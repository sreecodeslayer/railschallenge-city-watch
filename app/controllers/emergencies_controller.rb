class EmergenciesController < ApplicationController
  before_action :find_emergency, only: [:show, :edit, :destroy]

  def index
    @emergency = Emergency.all
    render json: { emergencies: @emergencies, full_response: [Emergency.full_response.count, Emergency.count] }
  end

  def new
    @emergency = Emergency.new
  end

  def show
    render json: { emergency: @emergency }    
  end

  def edit
    
  end

  def create
    @emergency = Emergency.new(create_emergency_params)
    if @emergency.save
      render status: :created, json: { emergency: @emergency }
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end
  end

  def update
    @emergency = Emergency.where(code: params[:code]).first
    if @emergency.update(update_emergency_params)
      render :show, status: :ok, emergency: @emergency
    else
      render json: { message: @emergency.errors }, status: :unprocessable_entity
    end     
  end

  def destroy
    @emergency.destroy
    head :no_content
  end

  private

  def create_emergency_params
    params.require(:emergency).permit(:code, :police_severity, :fire_severity, :medical_severity)
  end

  def update_emergency_params
    params.require(:emergency).permit(:police_severity, :fire_severity, :medical_severity)
  end

  def find_emergency
    @emergency = Emergency.where(code: params[:code]).first!
  end
end
