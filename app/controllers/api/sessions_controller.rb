class Api::SessionsController < Api::BaseController
  before_action :authenticate_user!, only: [:destroy]
  def create
    mobile = params[:mobile]
    password = params[:password]
    url = APP_CONFIG['vod_root'] + "/api/v1/accounts/sign_in"
    res = HTTParty.post(url,
            :body => { :mobile => mobile,
                       :password => password
                     }.to_json,
            :headers => { 'Content-Type' => 'application/json' } )

    data = JSON.parse(res.body)
    if data['code'] == 0
      user = User.find_or_create_by(mobile: mobile)
      user.token = data['data']['token']
      user.nick_name = data['data']['nickname']
      user.save!
    end
    render json: data, status: 200
  end

  def destroy
    # token = request.headers["token"]
    # url = APP_CONFIG['vod_root'] + "/api/v1/accounts/sign_out"
    # res = HTTParty.post(url,
    #         :headers => { 'Content-Type' => 'application/json', 'token' => token } )
    #
    # data = JSON.parse(res.body)
    # if data['code'] == 0
    #   # current_user.token = nil
    #   current_user.save!
    # end
    data = {code: 0, message: "成功"}
    render json: data, status: 200
  end
end
