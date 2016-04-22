module JellyfishDemo
  module Product
    class SQL < ::Product
      def order_questions
        [
        ]
      end

      def service_class
        'JellyfishDemo::Service::SQL'.constantize
      end
    end
  end
end
