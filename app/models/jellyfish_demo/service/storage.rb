module JellyfishDemo
  module Service
    class Storage < ::Service
      def actions
        actions = super.merge :terminate
        actions
      end

      def provision
        random_id = 1 + rand(99_999)
        random_ip = rand(999)

        details = {
          image_id: product.settings[:image_id],
          flavor_id: product.settings[:flavor_id],
          key_name: product.settings[:key_name],
          subnet_id: product.settings[:subnet_id],
          instance_id: random_id,
          public_ip_address: "192.178.0.#{random_ip}"
        }

        # SAVE PRODUCT DETAILS
        save_outputs(details, [['image_id', :image_id], ['flavor_id', :flavor_id], ['key_name', :key_name],
                               ['subnet_id', :subnet_id], ['instance_id', :instance_id], ['public_ip_address', :public_ip_address]],
          ValueTypes::TYPES[:string]) if defined? details

        # UPDATE STATUS
        update_status :running, 'running'
      end

      def deprovision
        update_status :terminated, 'terminated'
      end

      private

      def update_status(status, status_msg)
        update_attributes status: status, status_msg: status_msg
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
        service_outputs.find_by name: name
      end
    end
  end
end
