module JellyfishDemo
  class Engine < ::Rails::Engine
    isolate_namespace JellyfishDemo

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

    # Initializer to combine this engines static assets with the static assets of the hosting site.
    initializer 'static assets' do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

    initializer 'jellyfish_demo.register_extension', :after => :finisher_hook do |app|
      Jellyfish::Extension.register 'jellyfish-demo' do
        requires_jellyfish '>= 4.0.0'

        # load_scripts 'extensions/aws/components/forms/fields.config.js',
        #              'extensions/aws/resources/aws-data.factory.js',
        #              'extensions/aws/states/services/details/aws/ec2/ec2.state.js'

        mount_extension JellyfishDemo::Engine, at: :demo
      end
    end

  end
end
