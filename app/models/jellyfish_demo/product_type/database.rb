module JellyfishDemo
  module ProductType
    class Database < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Demo Database', '18be4e42-cbea-45bb-ac28-65c78d54c8e3', description: 'Demo Database Product Type',
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
        engine_options = [
          {label: 'MySQL', value: 'mysql'},
          {label: 'PostgreSQL', value: 'postgresql'},
          {label: 'MongoDB', value: 'mongodb'},
          {label: 'Cassandra', value: 'cassandra'},
        ]

        [
          { name: :region, value_type: :string, field: :demo_regions, required: true },
          { name: :cpus, value_type: :string, label: 'CPUs', required: true },
          { name: :memory, value_type: :string, label: 'Memory (GiB)', required: true },
          { name: :engine, value_type: :string, field: :select, options: engine_options, label: 'Engine', required: true }
        ]
      end

      def product_class
        'JellyfishDemo::Product::Database'.constantize
      end
    end
  end
end
