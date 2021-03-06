module JellyfishDemo
  class Engine < ::Rails::Engine
    isolate_namespace JellyfishDemo

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    # Initializer to combine this engines static assets with the static assets of the hosting site.
    initializer 'static assets' do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

    initializer 'jellyfish_demo.load_default_settings', before: :load_config_initializers do
      begin
        if ::Setting.table_exists?
          Dir[File.expand_path '../../../app/models/jellyfish_demo/setting/*.rb', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        # ignored
        nil
      end
    end

    initializer 'jellyfish_demo.load_product_types', before: :load_config_initializers do
      begin
        if ::ProductType.table_exists?
          Dir[File.expand_path '../../../app/models/jellyfish_demo/product_type/*.rb', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        # ignored
        nil
      end
    end

    initializer 'jellyfish_demo.load_registered_providers', before: :load_config_initializers do
      begin
        if ::RegisteredProvider.table_exists?
          Dir[File.expand_path '../../../app/models/jellyfish_demo/registered_provider/*', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        # ignored
        nil
      end
    end

    initializer 'jellyfish_demo.register_extension', after: :finisher_hook do |_app|
      Jellyfish::Extension.register 'jellyfish-demo' do
        requires_jellyfish '>= 4.0.0'

        load_scripts 'extensions/demo/components/forms/fields.config.js',
          'extensions/demo/resources/demo-data.factory.js',
          'extensions/demo/states/services/details/demo/server/server.state.js',
          'extensions/demo/states/services/details/demo/sql/sql.state.js'

        mount_extension JellyfishDemo::Engine, at: :demo
      end
    end
  end
end
