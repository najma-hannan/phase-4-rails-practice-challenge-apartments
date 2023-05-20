class LeasesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :lease_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_parameters
  wrap_parameters format: []


  def create
    lease = Lease.create!(lease_params)
    render json: lease, status: :created
  end

  def destroy
    lease = find_lease
    lease.destroy
    head :no_content
  end

  private

  def find_lease
    Lease.find(params[:id])
  end

  def lease_params
    params.permit(:rent, :tenant_id, :apartment_id)
  end

  def invalid_parameters(invalid)
    render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  def lease_not_found
    render json: {error: "Lease not found"}, status: :not_found
  end
end
