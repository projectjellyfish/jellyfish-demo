module JellyfishDemo
  module ProductType
    class Server < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Demo Server', '11ca0e0e-617d-45f3-b10a-acf42d5e6ecc', provider_type: 'JellyfishDemo::Provider::Demo', active: 'false')
          ].each do |s|
            create! s.merge!(type: 'JellyfishDemo::ProductType::Server')
          end
        end
      end

      def description
        'Demo Server'
      end

      def tags
        %w(compute server)
      end

      def product_questions
        [
          { name: :cpus, value_type: :string, field: :cpus, required: true },
          { name: :memory, value_type: :string, field: :memory, required: true },
          { name: :disk_size, value_type: :string, field: :text, label: 'Disk Size (GB)', required: true },
          { name: :operating_system, value_type: :string, field: :operating_systems, required: true },
          { name: :environment, value_type: :string, field: :environments, required: true }
        ]
      end

      def order_questions
        [
        ]
      end

      def service_class
        'JellyfishDemo::Service::Server'.constantize
      end
    end
  end
end
