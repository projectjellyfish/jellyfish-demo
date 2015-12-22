
module JellyfishDemo
  module ProductType
    class Application < ::ProductType
      def self.load_product_types
        return unless super
        transaction do
          [
            set('Demo Application', 'a7944ce9-754e-43a6-a1a1-78d5488fd464', description: 'Demo Application Product Type', )
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::ProductType::Application', provider_type: 'JellyfishDemo::Provider::Demo') }
        end
      end
    end

    def description
      'Demo Application'
    end

    def tags
      ['demo', 'application']
    end

    def product_questions
      [
        { name: :flavor_id, value_type: :string, field: :demo_server_flavors, required: true },
        { name: :subnet_id, value_type: :string, field: :demo_subnets, required: true },
        { name: :security_group_id, value_type: :string, field: :demo_security_groups, required: true },
        { name: :key_name, value_type: :string, field: :demo_key_names, required: true }
      ]
    end

    def order_questions
      [
        { name: :master_username, value_type: :string, field: :demo_server_admin_username, required: true },
        { name: :master_password, value_type: :string, field: :demo_server_admin_password, required: true }
      ]
    end
  end
end

