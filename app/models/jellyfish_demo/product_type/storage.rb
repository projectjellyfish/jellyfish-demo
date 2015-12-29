
module JellyfishDemo
  module ProductType
    class Storage < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Demo Storage', 'ec795ba0-b090-4f63-bdd6-13c7063d999d', description: 'Demo Storage Product Type', provider_type: 'JellyfishDemo::Provider::Demo')
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::ProductType::Storage') }
        end
      end

      def description
        'Demo Storage'
      end

      def tags
        ['demo', 'storage']
      end

      def product_questions
        [
          { name: :region, value_type: :string, field: :demo_regions, required: true },
          { name: :flavor_id, value_type: :string, field: :demo_storage_flavors, required: true },
          { name: :image_id, value_type: :string, label: 'Image ID', required: true },
          { name: :subnet_id, value_type: :string, field: :demo_subnets, required: true },
          { name: :key_name, value_type: :string, label: 'Key Value', required: true }
        ]
      end

      def product_class
        'JellyfishDemo::Product::Storage'.constantize
      end
    end
  end
end

