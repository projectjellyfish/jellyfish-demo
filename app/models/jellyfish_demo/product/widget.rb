module JellyfishDemo
  module Product
    class Widget < ::Product
      def order_questions
        [
          { name: :environment, value_type: :string, field: :environments, required: true }
        ]
      end

      def service_class
        'JellyfishDemo::Service::Widget'.constantize
      end
    end
  end
end
