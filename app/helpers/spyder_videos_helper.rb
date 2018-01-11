module SpyderVideosHelper
  include SessionsHelper
  def publish_video(video)
    url = APP_CONFIG['vod_root'] + "/videos"
    res = HTTParty.post(url, :body => { :user => video.spyder.open_id,
                             :name => video.name,
                             :video_src => "http://" + video.qiniu_url,
                             :video_cover => "http://" + video.qiniu_thumb_url,
                             :author => video.author,
                             :status => 1.to_s,
                             :secret => (Digest::MD5.hexdigest (video.name + 1.to_s))
                           }.to_json,
                         :headers => { 'Content-Type' => 'application/json' })


    data = JSON.parse(res.body)
    if data["code"] == 0
      true
    else
      false
    end
  end

  def qiniu_upload(video)
    bucket = APP_CONFIG['qiniu_bucket']
    key = nil
    put_policy = Qiniu::Auth::PutPolicy.new(
        bucket, # 存储空间
        key,    # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
        3600    # token 过期时间，默认为 3600 秒，即 1 小时
    )
    # 构建回调策略，这里上传文件到七牛后， 七牛将文件名和文件大小回调给业务服务器.
    # callback_url = 'http://your.domain.com/callback'
    # callback_body = "id=#{video.id}&filename=$(fname)&filesize=$(fsize)" # 魔法变量的使用请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#magicvar
    # put_policy.callback_url= callback_url
    # put_policy.callback_body= callback_body
    # 要上传文件的本地路径
    filePath = Dir.glob("#{APP_CONFIG['path_to_root']}/tmp/d_video/#{video.id}.*").first
    trans = false
    if (filePath.last(4) == ".flv" || filePath.last(4) == ".mkv")
      # 转码时使用的队列名称。
      pipeline = APP_CONFIG['qiniu_queue'] # 设定自己账号下的队列名称
      # 要进行的转码操作。
      # fops = "avthumb/mp4/ab/160k/ar/44100/acodec/libfaac/r/30/vb/2400k/vcodec/libx264/s/1280x720/autoscale/1/stripmeta/0"
      fops = "avthumb/mp4/ab/160k/ar/44100/acodec/libfaac/r/30/vb/5400k/vcodec/libx264/s/1920x1080/autoscale/1/strpmeta/0"
      job = APP_CONFIG['qiniu_job']

      put_policy.persistent_ops = fops
      put_policy.persistent_pipeline = pipeline
      trans = true
    end
    # 生成上传 Token
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    # 调用 upload_with_token_2 方法上传
    code, result, response_headers = Qiniu::Storage.upload_with_token_2(
         uptoken,
         filePath,
         key,
         nil, # 可以接受一个 Hash 作为自定义变量，请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#xvar
         bucket: bucket
    ) if filePath
    #打印上传返回的信息
    # puts code
    # puts result
    # 生成上传 Token
    put_policy2 = Qiniu::Auth::PutPolicy.new(
        bucket, # 存储空间
        key,    # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
        3600    # token 过期时间，默认为 3600 秒，即 1 小时
    )
    uptoken2 = Qiniu::Auth.generate_uptoken(put_policy2)
    # 要上传文件的本地路径
    filePath2 = Dir.glob("#{APP_CONFIG['path_to_root']}/tmp/d_video/thumb_#{video.id}.jpeg").first
    # 调用 upload_with_token_2 方法上传
    code2, result2, response_headers = Qiniu::Storage.upload_with_token_2(
         uptoken2,
         filePath2,
         key,
         nil, # 可以接受一个 Hash 作为自定义变量，请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#xvar
         bucket: bucket
    ) if filePath2
    if (code == 200 && code2 == 200)
      true if video.update!(file_hash: result["hash"], file_name: trans ? job + result["key"] : result["key"], qiniu_url: trans ? (APP_CONFIG['qiniu_cname'] + "/" + job +  result["key"]) : (APP_CONFIG['qiniu_cname'] + "/" + result["key"]), qiniu_thumb_url: APP_CONFIG['qiniu_cname'] + "/" + result2["key"])
    else
      false
    end
  end

  def delete_video(key)
    # 要删除的存储空间，并且这个资源名在存储空间中存在
    bucket = APP_CONFIG['qiniu_bucket']
    # key = 'lkIHcYRMEPGnd_b1qIHLXHrAb_Cp'
    # 删除资源
    code, result, response_headers = Qiniu::Storage.delete(
        bucket,     # 存储空间
        key         # 资源名
    )
    puts code
    puts result
    puts response_headers

  end

  def publish_article(article)
    url = APP_CONFIG['vod_root'] + "/articles"
    res = HTTParty.post(url, :body => { :user => article.spyder.open_id,
                             :title => article.title,
                             :url => article.url,
                             :summary => article.summary,
                             :author => article.author,
                             :status => 1.to_s,
                             :secret => (Digest::MD5.hexdigest (article.title + 1.to_s))
                           }.to_json,
                         :headers => { 'Content-Type' => 'application/json' })


    data = JSON.parse(res.body)
    if data["code"] == 0
      true
    else
      false
    end
  end

end
