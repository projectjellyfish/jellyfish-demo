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
        ['storage']
      end

      def product_questions
        privacy_options = [
          { label: 'Private', value: 'private' },
          { label: 'Public', value: 'public' }
        ]

        flavor_options = [
          { label: 'High I/O Instance - i2.xlarge', value: 'i2.xlarge' },
          { label: 'High I/O Instance  - i2.2xlarge', value: 'i2.2xlarge' },
          { label: 'High I/O Instance - i2.4xlarge', value: 'i2.4xlarge' },
          { label: 'Dense Storage Instance - d2.xlarge', value: 'd2.xlarge' },
          { label: 'Dense Storage Instance - d2.2xlarge', value: 'd2.2xlarge' }
        ]

        [
          { name: :region, value_type: :string, field: :demo_regions, required: true },
          { name: :flavor_id, value_type: :string, field: flavor_options, required: true },
          { name: :disk_size, value_type: :string, label: 'Disk Size', required: true },
          { name: :privary, value_type: :string, field: privacy_options, required: true }
        ]
      end

      def product_class
        'JellyfishDemo::Product::Storage'.constantize
      end
    end
  end
end
