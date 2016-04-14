module JellyfishDemo
  class ProvidersController < JellyfishDemo::ApplicationController
    after_action :verify_authorized

    private

    def provider
      @provider ||= ::Provider.find params[:id]
    end
  end
end
