module JellyfishDemo
  class ProvidersController < JellyfishDemo::ApplicationController
    after_action :verify_authorized

    def deprovision
      authorize :demo
      render json: provider.deprovision(params[:service_id])
    end

    private

    def provider
      @provider ||= ::Provider.find params[:id]
    end
  end
end
