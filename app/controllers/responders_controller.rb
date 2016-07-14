class RespondersController < ApplicationController
  before_action :find_responder, only: [:show, :update, :edit, :destroy]

  def index
    @responders = Responder.all
    if params[:show] == 'capacity'
      render json: Responder.available_responders
    else
      render json: { responders: @responders }
    end
  end

  def edit
    
  end

  def new
    @responder = Responder.new
  end

  def create
    @responder = Responder.new(create_responder_params)
    if @responder.save
      render status: :created, json: { responder: @responder }
    else
      render status: :unprocessable_entity, json: { message: @responder.errors }
    end
  end

  def update
    if @responder.update(update_responder_params)
      render json: { responder: @responder }
    else
      render json: @responder.errors, status: :unprocessable_entity
    end        
  end

  def destroy
    @responder.destroy
    head :no_content
  end

  def show
    render json:  { responder: @responder }
  end

  private

  def create_responder_params
    params.require(:responder).permit(:name, :type, :capacity)
  end

  def update_responder_params
    params.require(:responder).permit(:on_duty)
  end

  def find_responder
    @responder = Responder.where(name: params[:name]).first!
  end
end
