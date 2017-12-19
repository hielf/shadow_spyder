class Api::SpydersController < Api::BaseController
  include SpyderVideosHelper

  def search
    # Spyder.where(active: false).each do |s|
    #   s.spyder_videos.destroy_all
    # end
    root = 'https://www.youtube.com'
    root_2 = 'https://scholar.google.com'
    # key = "renal function"
    # openid = "og7qVxKXBQqtPAePsFSQGXqHWETk"

    key = params[:keyword]
    openid = params[:openid]

    spyder = Spyder.create!(site: root, begin_time: Time.now, open_id: openid)
    url = root +"/results?q=#{key}&hl=en-US"
    url = URI.encode(url)
    url_2 = root_2 +"/scholar?hl=zh-CN&as_sdt=0%2C5&q=#{key}&btnG="
    url_2 = URI.encode(url_2)
    spyder.update!(keyword: key)
    spyder.get_youtube_video_info(url,key,spyder)
    spyder.get_scholar(url_2,key,spyder)
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
    articles = spyder.spyder_articles
    # page_videos = Kaminari.paginate_array(videos).page(page).per(per)
    url = "http://wendao.easybird.cn" + "/wechat_reports/scholar_result"
    res = HTTParty.post(url,
            :body => { :open_id => spyder.open_id,
                       :key_word => spyder.keyword,
                       :count => articles.length,
                       :spyder_id => spyder.id
                     }.to_json,
            :headers => { 'Content-Type' => 'application/json' } )

    render json: {code: 0, message: videos.length > 0 ? '获取成功' : '暂无数据', data: {videos_count: videos.length}}
  end

  def download_videos
    # Rails.logger.warn "params: #{params}"
    # ids = JSON.parse(params[:ids])
    videos = SpyderVideo.where(id: params[:ids])

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

    videos = videos.downloaded

    Parallel.map(videos, in_processes: 5) do |video|
      SpyderVideo.transaction do
        if qiniu_upload(video)
          sleep 2
          if publish_video(video)
            s1 = system("rm -rf #{APP_CONFIG['path_to_root']}/tmp/d_video/#{video.id}.*") or false
            s2 = system("rm -rf #{APP_CONFIG['path_to_root']}/tmp/d_video/thumb_#{video.id}.jpeg") or false
            video.publish if (s1 && s2)
          end
        end
      end
    end

    videos = SpyderVideo.where(id: params[:ids])
    videos = videos.published

    if videos.count > 0
      spyder = videos.first.spyder
      url = "http://wendao.easybird.cn" + "/wechat_reports/video_download_result"
      res = HTTParty.post(url,
              :body => { :open_id => spyder.open_id,
                         :key_word => spyder.keyword,
                         :count => videos.length,
                         :spyder_id => spyder.id
                       }.to_json,
              :headers => { 'Content-Type' => 'application/json' } )

      render json: {code: 0, message: videos.length > 0 ? '获取成功' : '暂无数据', data: {videos_count: videos.length}}
    else
      render json: {code: 1, message: "no video"}
    end
  end

  def article_collect
    # Rails.logger.warn "params: #{params}"
    # ids = JSON.parse(params[:ids])
    articles = SpyderArticle.where(id: params[:ids])

    articles.each do |article|
      publish_article(article)
    end

    if articles.count > 0
      spyder = articles.first.spyder
      url = "http://wendao.easybird.cn" + "/wechat_reports/video_download_result"
      res = HTTParty.post(url,
              :body => { :open_id => spyder.open_id,
                         :key_word => spyder.keyword,
                         :count => articles.length,
                         :spyder_id => spyder.id
                       }.to_json,
              :headers => { 'Content-Type' => 'application/json' } )

      render json: {code: 0, message: articles.length > 0 ? '获取成功' : '暂无数据', data: {articles_count: articles.length}}
    else
      render json: {code: 1, message: "no video"}
    end
  end

end
