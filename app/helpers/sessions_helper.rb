module SessionsHelper
  def dummy_login(mobile)
    url =  "http://127.0.0.1/api/login"
    res = HTTParty.post(url,
            :body => { :mobile => mobile,
                       :password => "123456"
                     }.to_json,
            :headers => { 'Content-Type' => 'application/json' } )

    data = JSON.parse(res.body)
    user = User.find_by(mobile: mobile)
  end
end
