module JellyfishDemo
  module Service
    class Server < ::Service::Compute
      def actions
        actions = super.merge :terminate
        actions
      end

      def deprovision
        handle_errors do
          update_status(::Service.defined_enums['status']['terminated'], 'terminated')
        end
      end

      def provision
        storage = nil
        handle_errors do
          # TODO: generate service outputs
          # details = {
          #     :allocated_storage => self.product.answers.find { |x| x.name == 'allocated_storage' }.value,
          #     :key => "id-#{SecureRandom.hex(10)}"
          # }
          # save db outputs from product details
          # save_outputs(details, [['Storage', :allocated_storage], [ 'instance_id', :key ]], ValueTypes::TYPES[:string]) if defined? details
          # update status of service to running
          update_status(::Service.defined_enums['status']['running'], 'running')
        end
      end

      private

      def update_status(status, status_msg)
        self.status = status
        self.status_msg = status_msg
        self.save
      end

      def save_outputs(source, outputs_to_save, output_value_type)
        outputs_to_save.each do |output_name, source_key|
          next unless defined? source[source_key]
          service = get_output(output_name) || self.service_outputs.new(name: output_name)
          service.update_attributes(value: source[source_key], value_type: output_value_type) unless service.nil?
          service.save
        end
      end

      def get_output(name)
        self.service_outputs.where(name: name).first
      end

      def handle_errors
        yield
      rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
        raise e, 'Request failed, check for valid credentials and proper permissions.', e.backtrace
      end

      def client
        @client ||= begin
          self.provider.client
        end
      end
    end
  end
end
