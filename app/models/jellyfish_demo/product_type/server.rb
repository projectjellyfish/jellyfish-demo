module JellyfishDemo
  module ProductType
    class Server < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Demo Instance', '11ca0e0e-617d-45f3-b10a-acf42d5e6ecc', provider_type: 'JellyfishDemo::Provider::Demo', active: 'false')
          ].each do |s|
            create! s.merge!(type: 'JellyfishDemo::ProductType::Server')
          end
        end
      end

      def description
        'Demo Instance'
      end

      def tags
        %w(compute server)
      end

      def product_questions
        [
          { name: :allocated_storage, value_type: :string, field: :text, label: 'Allocated Storage', required: true },
          { name: :region, value_type: :string, field: :regions, required: true }
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
