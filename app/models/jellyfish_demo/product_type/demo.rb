module JellyfishDemo
  module ProductType
    class Demo < ::ProductType
      def self.load_product_types
        return unless super
        transaction do
          [
            set('Demo Compute', '6e1c01ab-64e9-43b0-891f-5657170c845d', description: 'Demo Compute Product Type'),
            set('Demo Database', '398cbd70-0013-4222-b460-fdbd09656991', description: 'Demo Database Product Type'),

          ].each { |s| create! s.merge!(type: 'JellyfishDemo::ProductType::Demo', provider_type: 'JellyfishDemo::Provider::Demo') }
        end
      end
    end

    def description
    end

    def tags
      ['demo']
    end

    def product_questions
      [
      ]
    end

    def order_questions
      [
      ]
    end
  end
end

