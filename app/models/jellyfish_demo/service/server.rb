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
        handle_errors do

          # generate mock provisioning details with faker
          details = {
              :domain => Faker::Internet.domain_name,
              :ip_address => Faker::Internet.public_ip_v4_address,
              :username => 'admin',
              :password => Faker::Internet.password(10)
          }

          # save db outputs from product details
          save_outputs(details, [[ 'Domain', :domain ],
                                 [ 'Public IP', :ip_address ],
                                 [ 'Username', :username ],
                                 [ 'Password', :password ]], ValueTypes::TYPES[:string])

          # update status of service to running
          update_status(::Service.defined_enums['status']['running'], 'running')
        end
      end

      private

      def update_status(status, status_msg)
        self.status = status
        self.status_msg = status_msg
        save
      end

      def save_outputs(source, outputs_to_save, output_value_type)
        outputs_to_save.each do |output_name, source_key|
          next unless defined? source[source_key]
          service = get_output(output_name) || service_outputs.new(name: output_name)
          service.update_attributes(value: source[source_key], value_type: output_value_type) unless service.nil?
          service.save
        end
      end

      def get_output(name)
        service_outputs.where(name: name).first
      end

      def handle_errors
        yield
      rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
        raise e, 'Request failed, check for valid credentials and proper permissions.', e.backtrace
      end

      def client
        @client ||= begin
          provider.client
        end
      end
    end
  end
end
