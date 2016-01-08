module JellyfishDemo
  module Service
    class Database < ::Service
      def operations
        actions = super.merge :terminate
        actions
      end

      def provision
        random_id = rand(1..99_999)
        random_ip = rand(1..255)

        {
          engine: product.settings[:engine],
          memory: product.settings[:memory],
          cpus: product.settings[:cpus],
          instance_id: random_id,
          public_ip_address: "192.178.0.#{random_ip}"
        }.each do |key, value|
          service_outputs.create name: key, value: value, value_type: 'string' unless value.nil?
        end

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
