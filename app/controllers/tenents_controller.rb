class TenentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :tenant_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_parameters
  wrap_parameters format: []
  def index
    render json: Tenant.all, status: :ok
  end

  def show
    tenant = find_tenant
    render json: tenant, status: :ok
  end

  def update
    tenant = find_tenant
    tenant.update!(tenant_params)
    render json: tenant, status: :ok
  end

  def create
    tenant = Tenant.create!(tenant_params)
    render json: tenant, status: :created
  end

  def destroy
    tenant = find_tenant
    tenant.destroy
    head :no_content
  end

  private

  def find_tenant
    Tenant.find(params[:id])
  end

  def tenant_params
    params.permit(:id, :name, :age)
  end

  def invalid_parameters(invalid)
    render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  def tenant_not_found
    render json: {error: "Tenant not found"}, status: :not_found
  end
end
