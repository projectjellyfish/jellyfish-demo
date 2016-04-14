module JellyfishDemo
  module Provider
    class Demo < ::Provider
      def client
        @s3_client ||= begin
          MockClient.new credentials
        end
      end

      private

      def credentials
        @credentials ||= begin
          {
            provider: 'AWS',
            aws_access_key_id: settings[:access_id],
            aws_secret_access_key: settings[:secret_key],
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
