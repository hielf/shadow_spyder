class ErrorsController < ApplicationController
  # skip_before_action :authenticate_user!
  def error_404
    @requested_path = request.path
    respond_to do |format|
      format.html
      format.json { render json: {routing_error: @requested_path} }
      # format.js
      format.all  {render :text => "HTTP 404"}
    end
  end
end
