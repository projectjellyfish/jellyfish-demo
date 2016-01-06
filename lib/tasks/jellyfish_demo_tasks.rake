# desc "Explaining what the task does"
# task :jellyfish_demo do
#   # Task goes here
# end

def sample_data(file)
  puts "-- Loading #{file.titlecase}"
  data = YAML.load_file(File.join [JellyfishDemo::Engine.root, 'db', 'data', 'sample', [file, 'yml'].join('.')])
  return data unless block_given?
  data.each { |d| yield d }
end

namespace :sample do
  desc 'Generates demo data'
  task demo: :environment do
    users = sample_data('staff').map do |data|
      alerts = data.delete 'alerts'
      puts "  #{data['first_name']} #{data['last_name']}"
      [data.delete('_assoc'), Staff.create(data).tap do |user|
        user.alerts.create(alerts) unless alerts.nil?
      end]
    end

    project_questions = sample_data('project_questions').map do |data|
      puts "  #{data['question']}"
      [data.delete('_assoc'), ProjectQuestion.create(data)]
    end

    projects = sample_data('projects').map do |data|
      approvals = data.delete 'approvals'
      alerts = data.delete 'alerts'
      answers = data.delete 'answers'
      puts "  #{data['name']}"
      [data.delete('_assoc'), Project.create(data).tap do |project|
        project.alerts.create(alerts) unless alerts.nil?
        unless approvals.nil?
          approvals = approvals.map do |approval|
            user = users.assoc(approval.delete 'staff').last
            approval.merge(staff: user)
          end
          project.approvals.create approvals
        end
        unless answers.nil?
          answers = answers.map do |answer|
            question = project_questions.assoc(answer.delete 'question').last
            answer.merge name: question['uuid'], value_type: 'string'
          end
          project.answers.create answers
        end
      end]
    end

    sample_data 'services' do |data|
      alerts = data.delete 'alerts'
      order = data.delete 'order'
      service_outputs = data.delete 'service_outputs'
      data['uuid'] = SecureRandom.uuid
      puts "  #{data['name']}"
      [data.delete('_assoc'), Service.create(data).tap do |service|
        service.alerts.create(alerts) unless alerts.nil?
        service.service_outputs.create(service_outputs) unless service_outputs.nil?
        staff = users.assoc(order.delete('staff')).last
        product = products.assoc(order.delete('product')).last
        project = projects.assoc(order.delete('project')).last
        order.merge! project: project,
                     product: product,
                     staff: staff,
                     setup_price: product.setup_price,
                     hourly_price: product.hourly_price,
                     monthly_price: product.monthly_price
        service.create_order order
      end]
    end

    groups = sample_data('groups').map do |data|
      group_staff = data.delete('group_staff') || []
      puts "  #{data['name']}"
      [data.delete('_assoc'), Group.create(data).tap do |group|
        next if group_staff.nil?
        group_staff.each do |staff|
          group.staff << users.assoc(staff).last
        end
      end]
    end

    roles = sample_data('roles').map do |data|
      puts "  #{data['name']}"
      [data.delete('_assoc'), Role.create(data)]
    end

    sample_data 'memberships' do |data|
      project = projects.assoc(data['project']).last
      group = groups.assoc(data['group']).last
      role = roles.assoc(data['role']).last
      Membership.create(project: project, group: group, role: role)
    end
  end
end