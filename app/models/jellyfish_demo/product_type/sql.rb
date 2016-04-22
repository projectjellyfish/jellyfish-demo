module JellyfishDemo
  module ProductType
    class SQL < ::ProductType
      def self.load_product_types
        return unless super

        transaction do
          [
            set('Demo SQL', '75b08da2-1f55-4b4e-84bc-b8c76a7d8f04', provider_type: 'JellyfishDemo::Provider::Demo', active: 'false')
          ].each do |s|
            create! s.merge!(type: 'JellyfishDemo::ProductType::SQL')
          end
        end
      end

      def description
        'Demo SQL'
      end

      def tags
        %w(database sql)
      end

      def product_questions
        [
          { name: :engine, value_type: :string, field: :engines, required: true },
          { name: :disk_size, value_type: :string, field: :text, label: 'Disk Size (GB)', required: true },
          { name: :backup, value_type: :string, field: :backups, label: 'Backup', required: true },
          { name: :environment, value_type: :string, field: :environments, required: true }
        ]
      end

      def product_class
        'JellyfishDemo::Product::SQL'.constantize
      end
    end
  end
end
