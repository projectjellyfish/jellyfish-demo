module JellyfishDemo
  module Service
    class Storage < ::Service
      def actions
        actions = super.merge :terminate
        actions
      end

      def provision
        server = nil

        handle_errors do
          # TODO: EACH ANSWER SHOULD BE AN OPTIONAL DETAIL IF THEY EXIST
          random_id = 1+rand(99999)
          random_ip = rand(999)

          details = {
            image_id: self.product.answers.find { |x| x.name == 'image_id' }.value,
            flavor_id: self.product.answers.find { |x| x.name == 'flavor_id' }.value,
            key_name: self.product.answers.find { |x| x.name == 'key_name' }.value,
            subnet_id: self.product.answers.find { |x| x.name == 'subnet_id' }.value,
            instance_id: random_id,
            public_ip_address: "192.178.0.#{random_ip}"
          }

          # SAVE PRODUCT DETAILS
          save_outputs(details, [ [ 'image_id', :image_id], [ 'flavor_id', :flavor_id ], [ 'key_name', :key_name ], ['subnet_id', :subnet_id ], [ 'instance_id', :instance_id], [ 'public_ip_address', :public_ip_address ]  ], ValueTypes::TYPES[:string]) if defined? details

          # UPDATE STATUS
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
    end
  end
end

