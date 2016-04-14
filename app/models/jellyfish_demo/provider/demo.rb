module JellyfishDemo
  module Provider
    class Demo < ::Provider
      def s3_client
        @s3_client ||= begin
          Fog::Storage.new credentials
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
  end
end
