module SpyderVideosHelper
  include SessionsHelper
  def publish_video(video)
    url = APP_CONFIG['vod_root'] + "/api/v1/videos"
    res = HTTParty.post(url,
            :body => { :name => video.translate_name,
                       :column_ids => video.category.split(",").map { |s| s.to_s }.uniq,
                       :video_src => "http://" + video.qiniu_url,
                       :video_cover => "http://" + video.qiniu_thumb_url,
                       :status => 1.to_s
                     }.to_json,
            :headers => { 'Content-Type' => 'application/json', 'token' => video.user.token } )

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

  def fit_user(video)
    #18000000006 车展
    if ["交通事故video"].include? video.author
      user = dummy_login("18000000001")
    elsif ["Shmee150"].include? video.author
      user = dummy_login("18000000007")
    elsif ["IIHS"].include? video.author
      user = dummy_login("18000000008")
    elsif ["PDriveTV"].include? video.author
      user = dummy_login("18000000009")
    elsif ["AutoTopNL"].include? video.author
      user = dummy_login("18000000010")
    elsif ["AutoCentrum.pl"].include? video.author
      user = dummy_login("18000000011")
    elsif ["The Fast Lane Car"].include? video.author
      user = dummy_login("18000000012")
    elsif ["carwow"].include? video.author
      user = dummy_login("18000000013")
    elsif ["Car TV"].include? video.author
      user = dummy_login("18000000014")
    elsif ["CHEEKY CARS7"].include? video.author
      user = dummy_login("18000000015")
    elsif ["FORMULA 1"].include? video.author
      user = dummy_login("18000000016")
    elsif ["Autogefühl"].include? video.author
      user = dummy_login("18000000017")
    elsif ["夢想街57號"].include? video.author
      user = dummy_login("18000000018")
    elsif ["AutoMoHo"].include? video.author
      user = dummy_login("18000000019")
    elsif ["YOUCAR"].include? video.author
      user = dummy_login("18000000020")
    elsif ["buycartv"].include? video.author
      user = dummy_login("18000000021")
    elsif ["Popular Videos"].include? video.author
      user = dummy_login("18000000022")
    elsif ["CAR TV"].include? video.author
      user = dummy_login("18000000023")
    elsif ["Ausfahrt.tv", "Autowizja.pl"].include? video.author
      user = dummy_login("18000000024")
    elsif ["U-CAR 汽車網站"].include? video.author
      user = dummy_login("18000000025")
    elsif ["車水馬龍網"].include? video.author
      user = dummy_login("18000000026")
    elsif ["小七車觀點"].include? video.author
      user = dummy_login("18000000027")
    elsif ["Wheels"].include? video.author
      user = dummy_login("18000000028")
    elsif ["Cars & Technology"].include? video.author
      user = dummy_login("18000000029")
    elsif ["Top Gear"].include? video.author
      user = dummy_login("18000000030")
    elsif ["TheTFJJ", "Supercars on the streets", "PBSupercarPhotography", ].include? video.author
      user = dummy_login("18000000031")
    elsif ["DragTimes", "PRonTheRoad"].include? video.author
      user = dummy_login("18000000032")
    elsif ["Kelley Blue Book"].include? video.author
      user = dummy_login("18000000033")
    elsif ["AutoGuide.com"].include? video.author
      user = dummy_login("18000000034")
    elsif ["Zapaak World"].include? video.author
      user = dummy_login("18000000035")
    elsif ["Autoblog"].include? video.author
      user = dummy_login("18000000036")
    elsif ["FIA", "F1BOARD", "FIA World Rally Championship", "FIA Formula E Championship"].include? video.author
      user = dummy_login("18000000037")
    elsif ["DDS TV 2", "ricarmobil1", "Exposed: UK Dash Cams", "Road Cams Videos"].include? video.author
      user = dummy_login("18000000038")
    elsif ["小明不背锅"].include? video.author
      user = dummy_login("18000000039")
    elsif ["天下有车"].include? video.author
      user = dummy_login("18000000040")
    elsif ["SuperCarTube"].include? video.author
      user = dummy_login("18000000041")
    elsif (["38号车评"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000501")
    elsif (["初晓敏", "车若初见", "车上说车闻"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000502")
    elsif (["胖哥试车", "胖哥长测", "胖哥选车"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000503")
    elsif (["逗斗车"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000504")
    elsif (["玩车TV"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000505")
    elsif (["超级试驾"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000506")
    elsif (["踢车帮"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000507")
    elsif (["驾驭"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000508")
    elsif (["JS Family"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000509")
    elsif (["爽爽"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000510")
    elsif (["老司机出品"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000511")
    elsif (["新车评", "Y车评", "ASK YYP", "颜宇鹏"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000512")
    elsif (["汽车之家"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000513")
    elsif (["萝卜报告", "震震有词"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000514")
    elsif (["百车短评"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000515")
    elsif (["车比得"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000516")
    elsif (["丈母娘唠车"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000517")
    elsif (["吴佩"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000518")
    elsif (["海阔试车"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000519")
    elsif (["集车"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000520")
    elsif (["韩路"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000521")
    elsif (["大拆车"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000522")
    elsif (["麦浪说车"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000523")
    elsif (["从夏观底盘"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000524")
    elsif (["小吱","吱道","吱吱吱", "堂主撩车"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000525")
    elsif (["四万说车"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000526")
    elsif (["工匠派"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000527")
    elsif (["上车走吧"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000528")
    elsif (["出发吧远洋"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000529")
    elsif (["寻美之旅"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000530")
    elsif (["涡轮时间"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000531")
    elsif (["夏东"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000532")
    elsif (["破车评"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000533")
    elsif (["寻车记"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000534")
    elsif (["旭子头条"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000535")
    elsif (["闫闯说车",].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000536")
    elsif (["车商大爆料"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000537")
    elsif (["五号频道"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000538")
    elsif (["王思聪点评"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000539")
    elsif (["涓子"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000540")
    elsif (["老车评测"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000541")
    elsif ["66车讯"].include? video.author
      user = dummy_login("18000000542")
    elsif (["真知卓见"].map {|x| video.name.include? x}).include? true
      user = dummy_login("18000000543")
    elsif ["JZCarReview"].include? video.author
      user = dummy_login("18000000544")
    elsif ["Car 汽车社区"].include? video.author
      user = dummy_login("18000000002")
    elsif ["第一汽车试驾评测网 No.1 Car"].include? video.author
      user = dummy_login("18000000003")
    elsif ["车瘾CARDDICTION"].include? video.author
      user = dummy_login("18000000004")
    elsif ["章鱼快报"].include? video.author
      user = dummy_login("18000000005")
    elsif ["The Grand Tour"].include? video.author
      user = dummy_login("18000000545")
    elsif ["超级说明书"].include? video.author
      user = dummy_login("18000000546")
    else
      if current_user.nil?
        user = dummy_login("18018559077")
      else
        user = current_user
      end
    end
  end

end
