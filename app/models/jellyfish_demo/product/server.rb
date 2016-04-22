module JellyfishDemo
  module Product
    class Server < ::Product
      def order_questions
        [
        ]
      end

      def service_class
        'JellyfishDemo::Service::Server'.constantize
      end
    end
  end
end
