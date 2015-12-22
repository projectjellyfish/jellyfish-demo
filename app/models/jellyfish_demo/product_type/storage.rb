
module JellyfishDemo
  module ProductType
    class Storage < ::ProductType
      def self.load_product_types
        return unless super
        transaction do
          [
            set('Demo Storage', 'ec795ba0-b090-4f63-bdd6-13c7063d999d', description: 'Demo Storage Product Type')
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::ProductType::Storage', provider_type: 'JellyfishDemo::Provider::Demo') }
        end
      end
    end

    def description
      'Demo Server'
    end

    def tags
      ['demo', 'storage']
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

