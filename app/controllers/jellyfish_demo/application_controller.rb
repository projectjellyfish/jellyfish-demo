module JellyfishDemo
  class ApplicationController < ::ApplicationController
    rescue_from Fog::Compute::Demo::Error, with: :demo_error

    protected

    def demo_error(ex)
      message, type = ex.message.split(' => ').reverse
      render json: { type: type, error: message }, status: :bad_request
    end
  end
end
