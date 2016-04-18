module JellyfishDemo
  module Provider
    class Demo < ::Provider
      def client
        @client ||= begin
          MockClient.new credentials
        end
      end

      private

      def credentials
        @credentials ||= begin
          {
            provider: 'Demo',
            access_key_id: settings[:access_id],
            secret_access_key: settings[:secret_key],
            region: settings[:region]
          }
        end
      end
    end
    class MockClient
      attr_accessor :credentials
      def initialize(credentials)
        @credentials = credentials
      end
    end
  end
end
