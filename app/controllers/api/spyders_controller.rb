class Api::SpydersController < Api::BaseController
  include SpydersHelper
  include SpyderVideosHelper

  def get_youtube_videos
    root = 'https://www.youtube.com'
    # key = "renal function"
    key = params[:keyword]
    page = params[:page]
    per = params[:per]

    spyder = Spyder.create!(site: root, begin_time: Time.now)
    url = root +"/results?q=#{key}&hl=en-US"
    url = URI.encode(url)
    spyder.update!(keyword: key)
    spyder.get_youtube_video_info(url,key,spyder)
    spyder.update!(end_time: Time.now, active: false)

    videos = spyder.spyder_videos
    page_videos = Kaminari.paginate_array(videos).page(page).per(per)

    render json: {code: 0, message: videos.length > 0 ? '获取成功' : '暂无数据', data: {videos_count: videos.length, videos: page_videos}}
  end

end
