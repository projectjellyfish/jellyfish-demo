module JellyfishDemo
  module ProductType
    class Widget < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Demo Widget', '95244eb2-3286-43ec-915b-e8aedfd23bd2', provider_type: 'JellyfishDemo::Provider::Demo', active: 'false')
          ].each do |s|
            create! s.merge!(type: 'JellyfishDemo::ProductType::Widget')
          end
        end
      end

      def description
        'Demo Widget'
      end

      def tags
        %w(widget)
      end

      def product_questions
        [
        ]
      end

      def product_class
        'JellyfishDemo::Product::Widget'.constantize
      end
    end
  end
end
