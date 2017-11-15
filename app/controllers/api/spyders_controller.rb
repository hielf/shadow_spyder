class Api::SpydersController < Api::BaseController
  include SpydersHelper
  include SpyderVideosHelper

  def search
    # Spyder.where(active: false).each do |s|
    #   s.spyder_videos.destroy_all
    # end
    root = 'https://www.youtube.com'
    # key = "renal function"
    # openid = "og7qVxKXBQqtPAePsFSQGXqHWETk"

    key = params[:keyword]
    openid = params[:open_id]

    spyder = Spyder.create!(site: root, begin_time: Time.now, open_id: openid)
    url = root +"/results?q=#{key}&hl=en-US"
    url = URI.encode(url)
    spyder.update!(keyword: key)
    spyder.get_youtube_video_info(url,key,spyder)
    spyder.update!(end_time: Time.now, active: false)

    videos = spyder.spyder_videos
    # page_videos = Kaminari.paginate_array(videos).page(page).per(per)
    url = "http://wendao.easybird.cn" + "/wechat_reports/search_result"
    res = HTTParty.post(url,
            :body => { :open_id => spyder.open_id,
                       :key_word => spyder.keyword,
                       :count => videos.length
                     }.to_json,
            :headers => { 'Content-Type' => 'application/json' } )

    # data = JSON.parse(res.body)

    render json: {code: 0, message: videos.length > 0 ? '获取成功' : '暂无数据', data: {videos_count: videos.length}}
  end

end
