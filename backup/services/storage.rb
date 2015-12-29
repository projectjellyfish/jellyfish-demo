module JellyfishDemo
  module Service
    class Storage < ::Service
    end
  end
end


"#{module JellyfishDemo
  module Service
    class Storage < ::Service::Storage
      def actions
        actions = super.merge :terminate
        actions
      end

      def deprovision
        handle_errors do
          # GET HANDLE OF SERVER INSTANCE TO BE DEPROVISIONED
          server_identifier = get_output('instance_id').value

          # UPDATE STATUS
          update_status(::Service.defined_enums['status']['terminated'], 'terminated')
        end
      end

      def provision
        server = nil

        handle_errors do
          # TODO: EACH ANSWER SHOULD BE AN OPTIONAL DETAIL IF THEY EXIST
          details = {
            flavor_id: self.product.answers.find { |x| x.name == 'flavor_id' }.value,
            subnet_id: self.product.answers.find { |x| x.name == 'subnet_id' }.value,
          }

          # SAVE SERVER PUBLIC IP AND INSTANCE
          save_outputs(server.attributes, [ [ 'instance_id', :id], [ 'public_ip_address', '162.204.107.17' ] ], ValueTypes::TYPES[:string]) if defined? server.attributes

          # SAVE PRODUCT DETAILS
          save_outputs(details, [ [ 'image_id', :image_id], [ 'flavor_id', :flavor_id ], ['subnet_id', :subnet_id ], ['security_group_ids', :security_group_ids] ], ValueTypes::TYPES[:string]) if defined? details

          # UPDATE STATUS
          update_status(::Service.defined_enums['status']['running'], 'running')
        end
      end

      def start

      end

      def stop

      end

      def terminate

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
          self.provider.ec2_client
        end
      end
    end
  end
end
}"
