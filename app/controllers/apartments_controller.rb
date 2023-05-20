class ApartmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :apartment_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_parameters

  def index
    render json: Apartment.all, status: :ok
  end

  def show
    apartment = find_apartment
    render json: apartment, status: :ok
  end

  def update
    apartment = find_apartment
    apartment.update!(apartment_params)
    render json: apartment, status: :ok
  end

  def create
    apartment = Apartment.create!(apartment_params)
    render json: apartment, status: :created
  end

  def destroy
    apartment = find_apartment
    apartment.destroy
    head :no_content
  end

  private

  def find_apartment
    Apartment.find(params[:id])
  end

  def apartment_params
    params.permit(:number)
  end

  def invalid_parameters(invalid)
    render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

  def apartment_not_found
    render json: {error: "Apartment not found"}, status: :not_found
  end
end
