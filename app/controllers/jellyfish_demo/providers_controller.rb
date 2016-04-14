module JellyfishDemo
  class ProvidersController < JellyfishDemo::ApplicationController
    after_action :verify_authorized

    def ec2_flavors
      authorize :demo
      render json: provider.ec2_flavors
    end

    def rds_engines
      authorize :demo
      render json: provider.rds_engines
    end

    def rds_versions
      authorize :demo
      render json: provider.rds_versions(params[:engine])
    end

    def rds_flavors
      authorize :demo
      render json: provider.rds_flavors(params[:engine], params[:version])
    end

    def ec2_images
      authorize :demo
      render json: provider.ec2_images
    end

    def subnets
      authorize :demo
      render json: provider.subnets(params[:vpc_id])
    end

    def availability_zones
      authorize :demo
      render json: provider.availability_zones
    end

    def key_names
      authorize :demo
      render json: provider.key_names
    end

    def security_groups
      authorize :demo
      render json: provider.security_groups
    end

    def vpcs
      authorize :demo
      render json: provider.vpcs
    end

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
