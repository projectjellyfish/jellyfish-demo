namespace :setup do
  desc 'Sets up simple dataset'
  task demo: :environment do
    def sample_data(file)
      puts "-- Loading #{file.titlecase}"
      data = YAML.load_file(File.join([File.dirname(File.dirname(__FILE__)), 'assets', 'sample', [file, 'yml'].join('.')]))
      return data unless block_given?
      data.each { |d| yield d }
    end

    # Add Provider from demo registered provider loaded by Rails
    provider_data = {
      'type' => 'JellyfishDemo::Provider::Demo',
      'registered_provider' => RegisteredProvider.where(name: 'Demo').first,
      'name' => 'Demo Provider',
      'description' => 'Demo Services',
      'active' => true,
      'tag_list' => ['demo']
    }
    providers = [['demo', Provider.create(provider_data)]]

    # Add Organizations
    sample_data('demo_organizations').map do |data|
      alerts = data.delete 'alerts'
      puts "  #{data['name']}"
      [data.delete('_assoc'), Organization.create(data).tap do |org|
        org.alerts.create(alerts) unless alerts.nil?
      end]
    end

    # Add Staff
    staff = sample_data('demo_staff').map do |data|
      alerts = data.delete 'alerts'
      puts "  #{data['first_name']} #{data['last_name']}"
      if Staff.where(email: data['email']).exists?
        [data.delete('_assoc'), Staff.where(email: data['email']).first]
      else
        [data.delete('_assoc'), Staff.create(data).tap do |user|
          user.alerts.create(alerts) unless alerts.nil?
        end]
      end
    end

    # Add Product Categories
    sample_data('demo_product_categories').map do |data|
      puts "  #{data['name']}"
      [data.delete('_assoc'), ProductCategory.create(data)]
    end

    # Add Products
    products = sample_data('demo_products').map do |data|
      answers = data.delete 'answers'
      # product types are hardcoded to demo compute in sample db data
      product_type = ProductType.find_by uuid: data.delete('product_type')
      provider = providers.assoc(data.delete 'provider').last
      data.merge! product_type: product_type, provider: provider
      puts "  #{data['name']}"
      [data.delete('_assoc'), Product.create(data).tap do |product|
        product.answers.create(answers) unless answers.nil?
      end]
    end

    # Add Project Questions
    project_questions = sample_data('demo_project_questions').map do |data|
      puts "  #{data['question']}"
      [data.delete('_assoc'), ProjectQuestion.create(data)]
    end

    # Add Projects
    projects = sample_data('demo_projects').map do |data|
      approvals = data.delete 'approvals'
      alerts = data.delete 'alerts'
      answers = data.delete 'answers'
      puts "  #{data['name']}"
      [data.delete('_assoc'), Project.create(data).tap do |project|
        project.alerts.create(alerts) unless alerts.nil?
        unless approvals.nil?
          approvals = approvals.map do |approval|
            user = staff.assoc(approval.delete('staff')).last
            approval.merge(staff: user)
          end
          project.approvals.create approvals
        end
        unless answers.nil?
          answers = answers.map do |answer|
            question = project_questions.assoc(answer.delete('question')).last
            answer.merge name: question['uuid'], value_type: 'string'
          end
          project.answers.create answers
        end
      end]
    end

    # Add Order and Services
    services = sample_data('demo_services') do |data|
      @setup_price = 0
      @hourly_price = 0
      @monthly_price = 0
      order_staff = staff.assoc(data.delete('staff')).last
      order_project = projects.assoc(data.delete('project')).last
      order_products = data.delete 'products'
      # Create services from products
      services = order_products.map do |order_product|
        product = products.assoc(order_product.delete('product')).last
        service_outputs = order_product.delete('service_outputs')
        order_product['uuid'] = SecureRandom.uuid
        [order_product.delete('_assoc'), Service.create(order_product).tap do |service|
          puts "  #{service['name']}"
          service.service_outputs.create(service_outputs) unless service_outputs.nil?
          service.product_id = product.id
          @setup_price += product.setup_price
          @hourly_price += product.hourly_price
          @monthly_price += product.monthly_price
        end]
      end
      # Create Order
      order_params = {
        staff: order_staff,
        project: order_project,
        setup_price: @setup_price,
        hourly_price: @hourly_price,
        monthly_price: @monthly_price,
        status: Order.statuses['completed']
      }
      order = Order.create(order_params)
      # Save created Services with Order ID
      services.map do |service|
        service.last.order_id = order.id
        service.last.save
      end
    end

    # Add wizard questions
    sample_data 'demo_wizard_questions' do |data|
      answers = data.delete 'answers'
      puts "  #{data['text']}"
      [data.delete('_assoc'), WizardQuestion.create(data).tap { |q| q.wizard_answers.create answers }]
    end
  end
end
