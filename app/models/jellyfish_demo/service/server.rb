module JellyfishDemo
  module Service
    class Server < ::Service
      def operations
        actions = super.merge :terminate
        actions
      end

      def provision
        random_id = rand(1..99_999)
        random_ip = rand(1..255)

        {
          image_id: product.settings[:image_id],
          flavor_id: product.settings[:flavor_id],
          engine: product.settings[:engine],
          instance_id: random_id,
          public_ip_address: "192.178.0.#{random_ip}"
        }.each do |value, key|
          service_outputs.create name: key, value: value, value_type: 'string'
        end

        # SAVE PRODUCT DETAILS
        #save_outputs(details, %i(image_id flavor_id engine instance_id public_ip_address), ValueTypes::TYPES[:string])

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
    end
  end
end
