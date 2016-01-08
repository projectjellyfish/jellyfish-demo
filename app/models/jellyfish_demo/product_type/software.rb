module JellyfishDemo
  module ProductType
    class Software < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Demo Software', '6e1c01ab-64e9-43b0-891f-5657170c845d', description: 'Demo Software Product Type', provider_type: 'JellyfishDemo::Provider::Demo')
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::ProductType::Software') }
        end
      end

      def description
        'Demo Software'
      end

      def tags
        ['software']
      end

      def product_questions
        language_options = [
          { label: 'Python', value: 'Python' },
          { label: 'NodeJS', value: 'NodeJS' },
          { label: 'Ruby', value: 'Ruby' },
          { label: 'PHP', value: 'PHP' }
        ]

        database_options = [
          { label: 'MySQL', value: 'mysql' },
          { label: 'PostgreSQL', value: 'postgresql' },
          { label: 'MongoDB', value: 'mongodb' },
          { label: 'Cassandra', value: 'cassandra' }
        ]

        server_options = [
          { label: 'Burstable Performance Instance - t2.nano', value: 't2.nano' },
          { label: 'Burstable Performance Instance - t2.micro', value: 't2.micro' },
          { label: 'Burstable Performance Instance - t2.small', value: 't2.small' },
          { label: 'Burstable Performance Instance - t2.medium', value: 't2.medium' },
          { label: 'Burstable Performance Instance - t2.large', value: 't2.large' },
          { label: 'Fixed Performance Instance - m4.large', value: 'm4.large' },
          { label: 'Fixed Performance Instance - m4.2xlarge', value: 'm4.2xlarge' },
          { label: 'Fixed Performance Instance - m4.4xlarge', value: 'm4.4xlarge' }
        ]

        [
          { name: :region, value_type: :string, field: :demo_regions, required: true },
          { name: :flavor_id, value_type: :string, field: server_options, label: 'Instance Type', required: true },
          { name: :database, value_type: :string, field: database_options, label: 'Database', required: true },
          { name: :language, value_type: :string, field: language_options, label: 'Language', required: true },
          { name: :image_id, value_type: :string, label: 'Image ID', required: true },
          { name: :subnet_id, value_type: :string, field: :demo_subnets, required: true },
          { name: :key_name, value_type: :string, label: 'Key Value', required: true }
        ]
      end

      def product_class
        'JellyfishDemo::Product::Software'.constantize
      end
    end
  end
end
