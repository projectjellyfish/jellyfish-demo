module JellyfishDemo
  module ProductType
    class Server < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Demo Server', '398cbd70-0013-4222-b460-fdbd09656991', description: 'Demo Server Product Type',
            provider_type: 'JellyfishDemo::Provider::Demo')
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::ProductType::Server') }
        end
      end

      def description
        'Demo Server'
      end

      def tags
        ['server']
      end

      def product_questions

        flavor_options = [
          {label: "Burstable Performance Instance - t2.nano", value: "t2.nano"},
          {label: "Burstable Performance Instance - t2.micro", value: "t2.micro"},
          {label: "Burstable Performance Instance - t2.small", value: "t2.small"},
          {label: "Burstable Performance Instance - t2.medium", value: "t2.medium"},
          {label: "Burstable Performance Instance - t2.large", value: "t2.large"},
          {label: "Fixed Performance Instance - m4.large", value: "m4.large"},
          {label: "Fixed Performance Instance - m4.2xlarge", value: "m4.2xlarge"},
          {label: "Fixed Performance Instance - m4.4xlarge", value: "m4.4xlarge"}
        ]

        [
          { name: :region, value_type: :string, field: :demo_regions, required: true },
          { name: :flavor_id, value_type: :string, field: :flavor_options, label: 'Instance Type', required: true },
          { name: :image_id, value_type: :string, label: 'Image ID', required: true },
          { name: :subnet_id, value_type: :string, field: :demo_subnets, required: true },
          { name: :key_name, value_type: :string, label: 'Key Value', required: true }
        ]
      end

      def product_class
        'JellyfishDemo::Product::Server'.constantize
      end
    end
  end
end
