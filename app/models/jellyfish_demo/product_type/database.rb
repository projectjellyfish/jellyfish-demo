
module JellyfishDemo
  module ProductType
    class Database < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Demo Database', '398cbd70-0013-4222-b460-fdbd09656991', description: 'Demo Database Product Type',
                provider_type: 'JellyfishDemo::Provider::Demo')
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::ProductType::Database') }
        end
      end

      def description
        'Demo Database'
      end

      def tags
        ['database']
      end

      def product_questions
        [
          { name: :region, value_type: :string, field: :demo_regions, required: true },
          { name: :flavor_id, value_type: :string, field: :demo_database_flavors, required: true },
          { name: :image_id, value_type: :string, label: 'Image ID', required: true },
          { name: :subnet_id, value_type: :string, field: :demo_subnets, required: true },
          { name: :key_name, value_type: :string, label: 'Key Value', required: true }
        ]
      end

      def product_class
        'JellyfishDemo::Product::Database'.constantize
      end
    end
  end
end

