module JellyfishDemo
  module RegisteredProvider
    class Demo < ::RegisteredProvider
      def self.load_registered_providers
        return unless super

        transaction do
          [
            set('Demo', '1072ddc9-e04f-4d43-929b-8866ce7e6d3a')
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::RegisteredProvider::Demo') }
        end
      end

      def provider_class
        'JellyfishDemo::Provider::Demo'.constantize
      end

      def description
        'Demo Services'
      end

      def tags
        ['demo']
      end

      def questions
        [
          { name: :access_id, value_type: :string, field: :text, label: 'Access ID', required: true },
          { name: :secret_key, value_type: :password, field: :password, label: 'Secret Key', required: :if_new },
          { name: :region, value_type: :string, field: :aws_regions, required: true }
        ]
      end
    end
  end
end
