module JellyfishDemo
  module Provider
    class Demo < ::Provider
      def deprovision(service_id)
        service = ::Service.where(id: service_id).first
        service.delay.deprovision unless service.nil?

        # TODO: SHOULD THIS BE TURNED INTO A REUSABLE FUNCTION?
        # SUCCESS OR FAIL NOTIFICATION
        service.status = ::Service.defined_enums['status']['stopping']
        service.status_msg = 'stopping'
        service.save

        [ 'Service has been scheduled for deprovisioning.' ]
      end

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
