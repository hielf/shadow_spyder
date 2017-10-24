class Api::BaseController < ApplicationController
  # disable the CSRF token
  protect_from_forgery with: :null_session

  # disable cookies (no set-cookies header in response)
  before_action :destroy_session
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token
  attr_accessor :current_user

  def api_error(opts = {})
    render nothing: true, status: opts[:status]
  end

  def destroy_session
    request.session_options[:skip] = true
  end

  private
    def authenticate_user!
      token = request.headers["token"]
      mobile = request.headers["mobile"]

      return unauthenticated! if mobile.blank?
      user = User.find_by(mobile: mobile)
      if user && (user.token == token)
        self.current_user = user
      else
        return unauthenticated!
      end
    end

    def unauthenticated!
      api_error(status: 401)
    end
end
