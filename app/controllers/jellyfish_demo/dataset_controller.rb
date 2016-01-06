module JellyfishDemo
  class DatasetController < JellyfishDemo::ApplicationController
    def self.load_generic_dataset
      reset_db

      providers = generic_data('providers').map do |data|
        reg_provider = ActiveRecord::Base::RegisteredProvider.find_by uuid: data.delete('registered_provider')
        data.merge! registered_provider: reg_provider
        puts "  #{data['name']}"
        [data.delete('_assoc'), ActiveRecord::Base::Provider.create(data)]
      end

      users = generic_data('staff').map do |data|
        alerts = data.delete 'alerts'
        puts "  #{data['first_name']} #{data['last_name']}"
        [data.delete('_assoc'), ActiveRecord::Base::Staff.create(data).tap do |user|
          user.alerts.create(alerts) unless alerts.nil?
        end]
      end

      categories = generic_data('product_categories').map do |data|
        puts "  #{data['name']}"
        [data.delete('_assoc'), ActiveRecord::Base::ProductCategory.create(data)]
      end

      products = generic_data('products').map do |data|
        answers = data.delete 'answers'
        product_type = ActiveRecord::Base::ProductType.find_by uuid: data.delete('product_type')
        provider = providers.assoc(data.delete 'provider').last
        data.merge! product_type: product_type, provider: provider
        puts "  #{data['name']}"
        [data.delete('_assoc'), ActiveRecord::Base::Product.create(data).tap do |product|
          product.answers.create(answers) unless answers.nil?
        end]
      end

      project_questions = generic_data('project_questions').map do |data|
        puts "  #{data['question']}"
        [data.delete('_assoc'), ActiveRecord::Base::ProjectQuestion.create(data)]
      end

      projects = generic_data('projects').map do |data|
        approvals = data.delete 'approvals'
        alerts = data.delete 'alerts'
        answers = data.delete 'answers'
        puts "  #{data['name']}"
        [data.delete('_assoc'), ActiveRecord::Base::Project.create(data).tap do |project|
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

      services = generic_data('services') do |data|
        alerts = data.delete 'alerts'
        order = data.delete 'order'
        service_outputs = data.delete 'service_outputs'
        data['uuid'] = SecureRandom.uuid
        puts "  #{data['name']}"
        [data.delete('_assoc'), ActiveRecord::Base::Service.create(data).tap do |service|
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

      groups = generic_data('groups').map do |data|
        group_staff = data.delete('group_staff') || []
        puts "  #{data['name']}"
        [data.delete('_assoc'), ActiveRecord::Base::Group.create(data).tap do |group|
          next if group_staff.nil?
          group_staff.each do |staff|
            group.staff << users.assoc(staff).last
          end
        end]
      end

      roles = generic_data('roles').map do |data|
        puts "  #{data['name']}"
        [data.delete('_assoc'), ActiveRecord::Base::Role.create(data)]
      end

      generic_data 'memberships' do |data|
        project = projects.assoc(data['project']).last
        group = groups.assoc(data['group']).last
        role = roles.assoc(data['role']).last
        ActiveRecord::Base::Membership.create(project: project, group: group, role: role)
      end
    end

    private

    def self.reset_db
      ActiveRecord::Base::Answer.destroy_all
      ActiveRecord::Base::Alert.destroy_all
      ActiveRecord::Base::Group.destroy_all
      ActiveRecord::Base::Membership.destroy_all
      ActiveRecord::Base::Provider.destroy_all
      ActiveRecord::Base::Product.destroy_all
      ActiveRecord::Base::ProductType.destroy_all
      ActiveRecord::Base::ProductCategory.destroy_all
      ActiveRecord::Base::ProjectQuestion.destroy_all
      ActiveRecord::Base::Project.destroy_all
      ActiveRecord::Base::Service.destroy_all
      ActiveRecord::Base::Order.destroy_all
      ActiveRecord::Base::Staff.delete_all
      ActiveRecord::Base::Staff.delete_all
      ActiveRecord::Base::Role.destroy_all
    end

    def self.generic_data(file)
      puts "-- Loading #{file.titlecase}"
      data = YAML.load_file(File.join [JellyfishDemo::Engine.root, 'db', 'data', 'datasets', 'generic', [file, 'yml'].join('.')])
      return data unless block_given?
      data.each { |d| yield d }
    end
  end
end

