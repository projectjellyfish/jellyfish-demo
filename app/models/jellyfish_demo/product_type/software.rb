
module JellyfishDemo
  module ProductType
    class Software < ::ProductType
      def self.load_product_types
        return unless super
        transaction do
          [
            set('Demo Software', 'a7944ce9-754e-43a6-a1a1-78d5488fd464', description: 'Demo Software Product Type', provider_type: 'JellyfishDemo::Provider::Demo')
          ].each { |s| create! s.merge!(type: 'JellyfishDemo::ProductType::Software') }
        end
      end

      def description
        'Demo Software'
      end

      def tags
        ['demo', 'software']
      end

      def product_questions
        [
          { name: :image_id, value_type: :string, label: 'AMI ID', required: true }
        ]
      end

      def service_class
        'JellyfishDemo::Service::Software'.constantize
      end
    end
  end
end

