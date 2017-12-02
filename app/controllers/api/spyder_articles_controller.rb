class Api::SpyderArticlesController < Api::BaseController
  include SpydersHelper
  # include SpyderVideosHelper
  # before_action :authenticate_user!

  def articles
    spyder = Spyder.find(params[:spyder_id])
    articles = spyder.spyder_articles.order(updated_at: :desc).select(:id, :title, :url, :author, :summary)
    keyword = spyder.keyword
    # videos = videos.where(state: state) if (state && !state.empty?)
    # videos = videos.where("lower(name) like ? ", "%#{name.downcase}%") if (name && !name.empty?)
    # videos = videos.where("lower(author) like ? ", "%#{author.downcase}%") if (author && !author.empty?)
    page_articles = Kaminari.paginate_array(articles).page(1).per(40)

    render json: {code: 0, message: articles.length > 0 ? '获取成功' : '暂无数据', data: {articles_count: articles.length, articles: page_articles, keyword: keyword}}
  end

end
