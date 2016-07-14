class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameters

  def page_not_found
    render file: "#{Rails.root}/public/404.json", status: :not_found
  end

  def unpermitted_parameters(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end
end