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
    openid = params[:openid]

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
                       :count => videos.length,
                       :spyder_id => spyder.id
                     }.to_json,
            :headers => { 'Content-Type' => 'application/json' } )

    # data = JSON.parse(res.body)

    render json: {code: 0, message: videos.length > 0 ? '获取成功' : '暂无数据', data: {videos_count: videos.length}}
  end

  def download_videos
    ids = JSON.parse(params[:ids])
    videos = SpyderVideo.where(id: ids)

    Parallel.map(videos, in_processes: 5) do |v|
      SpyderVideo.transaction do
        s1 = system("you-get -o #{APP_CONFIG['path_to_root']}/tmp/d_video -O #{v.id} '#{v.src}'") or false

        Rails.logger.warn "视频s1: #{v.translate_name} #{s1}" if s1 == false
        if s1
          filePath = Dir.glob("#{APP_CONFIG['path_to_root']}/tmp/d_video/#{v.id}.*").first
          s2 = system("ffmpegthumbnailer -i #{filePath} -o #{APP_CONFIG['path_to_root']}/tmp/d_video/thumb_#{v.id}.jpeg -s 640") or false
        end
        v.download if (s1 && s2)
      end
    end

  end

end
