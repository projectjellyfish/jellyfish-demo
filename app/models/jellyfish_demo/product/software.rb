module JellyfishDemo
  module Product
    class Software < ::Product
      def order_questions
        [
          { name: :master_username, value_type: :string, label: 'Admin Username', required: true },
          { name: :master_password, value_type: :string, field: :password, label: 'Admin Password', required: true }
        ]
      end

      def service_class
        'JellyfishDemo::Service::Software'.constantize
      end
    end
  end
end
