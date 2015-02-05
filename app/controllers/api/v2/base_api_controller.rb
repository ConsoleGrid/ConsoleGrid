class Api::V2::BaseApiController < ApplicationController
  respond_to :json

  rescue_from Exception, :with => :exception_error_response
  # This needs to be after the `rescue_from Exception` because that handler
  # would overwrite this one
  rescue_from Exceptions::APIError, :with => :api_error_response

  def error_response(message)
    render :json => { :error => message}
  end

  def api_error_response(api_exception)
    error_response "API Error: #{api_exception.message}"
  end

  def exception_error_response(exception)
    error_response exception.message
  end
end
