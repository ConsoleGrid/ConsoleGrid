class Api::V2::BaseApiController < ApplicationController
  respond_to :json

  rescue_from Exception, :with => :exception_error_response
  # This needs to be after the `rescue_from Exception` because that handler
  # would overwrite this one
  rescue_from Exceptions::APIError, :with => :api_error_response

  before_filter :set_cors_headers

  def error_response(message)
    render :json => { :error => message}
  end

  def api_error_response(api_exception)
    error_response "API Error: #{api_exception.message}"
  end

  def exception_error_response(exception)
    error_response exception.message
  end

  def set_cors_headers
    # When reading online it was recommended to not set Allow-Credentials to
    # true if you are using a wildcard Allow-Origin. Since I want to support
    # user-specific features via the API I need to restrict the Allow-Origin
    # value to just the site that originally made the request
    return unless request.headers["HTTP_ORIGIN"]
    headers['Access-Control-Allow-Origin'] = request.headers["HTTP_ORIGIN"]
    headers['Access-Control-Allow-Credentials'] = 'true'
  end
end
