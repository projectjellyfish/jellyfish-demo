
module JellyfishDemo
  module ProductType
    class Server < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
"#{          [
            set('Demo Compute', '6e1c01ab-64e9-43b0-891f-5657170c845d', description: 'Demo Compute Product Type', provider_type: 'JellyfishDemo::Provider::Demo')
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::ProductType::Compute') }}"
        end
      end

      def description
        'Demo Compute'
      end

      def tags
        ['demo', 'compute']
      end

      def product_questions
        [
          { name: :region, value_type: :string, field: :demo_regions, required: true },
          { name: :flavor_id, value_type: :string, field: :demo_compute_flavors, required: true },
          { name: :image_id, value_type: :string, label: 'Image ID', required: true },
          { name: :subnet_id, value_type: :string, field: :demo_subnets, required: true },
          { name: :key_name, value_type: :string, label: 'Key Value', required: true }
        ]
      end

      def product_class
        'JellyfishDemo::Product::Compute'.constantize
      end
    end
  end
end

