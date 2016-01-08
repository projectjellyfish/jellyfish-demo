module JellyfishDemo
  module Product
    class Server < ::Product
      def order_questions
        [
          { name: :master_username, value_type: :string, label: 'Admin Username', required: true },
          { name: :master_password, value_type: :string, field: :password, label: 'Admin Password', required: true }
        ]
      end

      def service_class
        'JellyfishDemo::Service::Server'.constantize
      end
    end
  end
end
