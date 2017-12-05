class Api::SpyderVideosController < Api::BaseController
  include SpydersHelper
  include SpyderVideosHelper
  # before_action :authenticate_user!

  def videos
    spyder = Spyder.find(params[:spyder_id])
    videos = spyder.spyder_videos.order(updated_at: :desc).select(:id, :name, :translate_name, :src, :author, :pv, :video_duration, :key_word, :state, :updated_at, :upload_time, :category_str)
    keyword = spyder.keyword
    # videos = videos.where(state: state) if (state && !state.empty?)
    # videos = videos.where("lower(name) like ? ", "%#{name.downcase}%") if (name && !name.empty?)
    # videos = videos.where("lower(author) like ? ", "%#{author.downcase}%") if (author && !author.empty?)
    page_videos = Kaminari.paginate_array(videos).page(1).per(40)

    render json: {code: 0, message: videos.length > 0 ? '获取成功' : '暂无数据', data: {videos_count: videos.length, videos: page_videos, keyword: keyword}}
  end

  def index
    # page = 1
    # per = 20
    # state = nil
    # name = nil
    # author = nil

    page = params[:page]
    per = params[:per]
    state = params[:state]
    name = params[:name]
    author = params[:author]

    # columns = get_columns
    # columns.uniq!
    # if state == "废弃"
    #   videos = SpyderVideo.where(state: "废弃").limit(500).order(updated_at: :desc).select(:id, :name, :translate_name, :src, :author, :pv, :video_duration, :key_word, :state, :updated_at, :upload_time, :category_str)
    # else
    #   videos = SpyderVideo.where.not(state: "废弃").limit(500).order(updated_at: :desc).select(:id, :name, :translate_name, :src, :author, :pv, :video_duration, :key_word, :state, :updated_at, :upload_time, :category_str)
    # end
    videos = SpyderVideo.order(updated_at: :desc).select(:id, :name, :translate_name, :src, :author, :pv, :video_duration, :key_word, :state, :updated_at, :upload_time, :category_str)

    videos = videos.where(state: state) if (state && !state.empty?)
    videos = videos.where("lower(name) like ? ", "%#{name.downcase}%") if (name && !name.empty?)
    videos = videos.where("lower(author) like ? ", "%#{author.downcase}%") if (author && !author.empty?)
    page_videos = Kaminari.paginate_array(videos).page(page).per(per)

    render json: {code: 0, message: videos.length > 0 ? '获取成功' : '暂无数据', data: {videos_count: videos.length, videos: page_videos}}
  end

  def remove
    key = params[:key]
    delete_video(key)
    render json: {code: 0, message: 'ok', data: {}}
  end

  def states
    # states = SpyderVideo.all.group(:state).select(:state)
    states = SpyderVideo::STATES
    data = states.map {|x| {:state => x}}
    render json: {code: 0, message: data.length > 0 ? '获取成功' : '暂无数据', data: {states: data}}
  end

  def columns
    columns = get_columns
    columns.uniq!
    render json: {code: 0, message: columns.length > 0 ? '获取成功' : '暂无数据', data: {columns: columns}}
  end

  def approved
    video = SpyderVideo.find_by(id: params[:id])
    if params[:translate_name]
      video.update!(translate_name: params[:translate_name])
      video.user = fit_user(video)
    else
      video.update!(translate_name: video.name)
      video.user = fit_user(video)
    end
    if video.approve
      render json: {code: 0, message: "成功", data: {}}, status: 200
    else
      render json: {code: 1, message: "只能审核 已匹配标签 状态的视频", data: {}}, status: 200
    end
  end

  def disposed
    video = SpyderVideo.find_by(id: params[:id])
    video.user = current_user
    if video.dispose
      render json: {code: 0, message: "成功", data: {}}, status: 200
    else
      render json: {code: 1, message: "当前状态无法废弃", data: {}}, status: 200
    end
  end

  def ready_to_download
    video = SpyderVideo.find_by(id: params[:id])
    video.user = current_user
    if video.download
      render json: {code: 0, message: "成功", data: {}}, status: 200
    else
      render json: {code: 1, message: "只能下载 已处理 状态的视频", data: {}}, status: 200
    end
  end

  def recovered
    video = SpyderVideo.find_by(id: params[:id])
    video.user = current_user
    if video.recover
      render json: {code: 0, message: "成功", data: {}}, status: 200
    else
      render json: {code: 1, message: "只能回收 废弃、已匹配标签、已下载 状态的视频", data: {}}, status: 200
    end
  end

  def qiniu_callback
    video = SpyderVideo.find_by(id: params[:id])
    if video
      true
    end
  end
end
