module JellyfishDemo
  module Service
    class Software < ::Service
      def operations
        actions = super.merge :terminate
        actions
      end

      def provision
        random_id = 1 + rand(99_999)
        random_ip = rand(255)

        {
          image_id: product.settings[:image_id],
          flavor_id: product.settings[:flavor_id],
          database: product.settings[:database],
          language: product.settings[:language],
          key_name: product.settings[:key_name],
          subnet_id: product.settings[:subnet_id],
          instance_id: random_id,
          public_ip_address: "192.178.0.#{random_ip}"
        }.each do |value, key|
          service_outputs.create name: key, value: value, value_type: 'string'
        end

        # SAVE PRODUCT DETAILS
        # service.update_attributes(details, [['image_id', :image_id], ['flavor_id', :flavor_id], ['database', :database],
        #                        ['language', :language], ['key_name', :key_name], ['subnet_id', :subnet_id],
        #                        ['instance_id', :instance_id], ['public_ip_address', :public_ip_address]],
        #              ValueTypes::TYPES[:string])

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
