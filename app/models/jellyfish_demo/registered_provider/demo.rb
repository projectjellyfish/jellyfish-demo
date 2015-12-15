module JellyfishDemo
  module RegisteredProvider
    class Demo < ::RegisteredProvider
      def self.load_registered_providers
        return unless super

        transaction do
          [
            set('Demo', '3c997248-e35e-408e-a577-3195dfa7f32e')
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::RegisteredProvider::Demo') }
        end
      end

      def provider_class
        'JellyfishDemo::Provider::Demo'.constantize
      end

      def description
        'Demo registered provider'
      end

      def tags
        ['demo']
      end

      def questions
        [{ name: :access_id, value_type: :string, field: :text, label: 'Access ID', required: true },
         { name: :secret_key, value_type: :password, field: :password, label: 'Secret Key', required: :if_new }]
      end
    end
  end
end
