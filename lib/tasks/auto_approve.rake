namespace :download_video do
  task :approve => :environment do
    include SpyderVideosHelper
    videos = SpyderVideo.preapproved.limit(5)

    videos.where("author in ('交通事故video', '小明不背锅', '66车讯', '车瘾CARDDICTION', '天下有车', 'JZCarReview')").each do |v|
      v.update!(translate_name: v.name)
      v.user = fit_user(v)
      break if !v.approve
    end

    videos.where("author in ('Car 汽车社区', '第一汽车试驾评测网 No.1 Car', '章鱼快报')").each do |v|
      SpyderVideo.transaction do
        case v.author
        #排除 第一汽车试驾评测网 No.1 Car 栏目
        when "Car 汽车社区"
          if ((["大拆车","初晓敏","车上说车闻","麦浪说车","ASK YYP","从夏观底盘","小吱","四万说车","工匠派","上车走吧","胖哥选车","出发吧远洋","寻美之旅","涡轮时间","夏东","破车评","寻车记","旭子头条","车若初见","车商大爆料","五号频道","王思聪点评","涓子","老车评测","震震有词","真知卓见","吱道","堂主撩车","超级说明书"].map {|x| v.name.include? x}).include? true) == false
            v.update!(translate_name: v.name)
            v.user = fit_user(v)
            break if !v.approve
          else
            v.dispose
          end
        when "第一汽车试驾评测网 No.1 Car"
          if ((["38号车评","胖哥长测","闫闯说车","逗斗车","玩车TV","超级试驾","踢车帮","驾驭","JS Family","爽爽砍车","老司机出品","新车评","Y车评","汽车之家","萝卜报告","百车短评","车比得","丈母娘唠车","吴佩","海阔试车","集车","韩路","吱道"].map {|x| v.name.include? x}).include? true) == false
            v.update!(translate_name: v.name)
            v.user = fit_user(v)
            break if !v.approve
          else
            v.dispose
          end
        when "章鱼快报"
          if ((["吱道"].map {|x| v.name.include? x}).include? true) == true
            v.update!(translate_name: v.name)
            v.user = fit_user(v)
            break if !v.approve
          else
            v.dispose
          end
        end
      end
    end
    #
    # videos.where(author: "交通事故video").each do |v|
    #   v.update!(translate_name: v.name)
    #   url =  "http://127.0.0.1/api/login"
    #   res = HTTParty.post(url,
    #           :body => { :mobile => "18000000001",
    #                      :password => "123456"
    #                    }.to_json,
    #           :headers => { 'Content-Type' => 'application/json' } )
    #
    #   data = JSON.parse(res.body)
    #   user = User.find_by(mobile: "18000000001")
    #
    #   v.user = user
    #   break if !v.approve
    # end
    #
    # videos.where(author: "小明不背锅").each do |v|
    #   v.update!(translate_name: v.name)
    #   url =  "http://127.0.0.1/api/login"
    #   res = HTTParty.post(url,
    #           :body => { :mobile => "18000000001",
    #                      :password => "123456"
    #                    }.to_json,
    #           :headers => { 'Content-Type' => 'application/json' } )
    #
    #   data = JSON.parse(res.body)
    #   user = User.find_by(mobile: "18000000001")
    #
    #   v.user = user
    #   break if !v.approve
    # end
    #
    # videos.where(author: "Car 汽车社区").each do |v|
    #   v.update!(translate_name: v.name)
    #   url =  "http://127.0.0.1/api/login"
    #   res = HTTParty.post(url,
    #           :body => { :mobile => "18000000002",
    #                      :password => "123456"
    #                    }.to_json,
    #           :headers => { 'Content-Type' => 'application/json' } )
    #
    #   data = JSON.parse(res.body)
    #   user = User.find_by(mobile: "18000000002")
    #
    #   v.user = user
    #   break if !v.approve
    # end
    #
    # videos.where(author: "66车讯").each do |v|
    #   v.update!(translate_name: v.name)
    #   url =  "http://127.0.0.1/api/login"
    #   res = HTTParty.post(url,
    #           :body => { :mobile => "18000000003",
    #                      :password => "123456"
    #                    }.to_json,
    #           :headers => { 'Content-Type' => 'application/json' } )
    #
    #   data = JSON.parse(res.body)
    #   user = User.find_by(mobile: "18000000003")
    #
    #   v.user = user
    #   break if !v.approve
    # end
    #
    # videos.where(author: "第一汽车试驾评测网 No.1 Car").each do |v|
    #   v.update!(translate_name: v.name)
    #   url =  "http://127.0.0.1/api/login"
    #   res = HTTParty.post(url,
    #           :body => { :mobile => "18000000003",
    #                      :password => "123456"
    #                    }.to_json,
    #           :headers => { 'Content-Type' => 'application/json' } )
    #
    #   data = JSON.parse(res.body)
    #   user = User.find_by(mobile: "18000000003")
    #
    #   v.user = user
    #   break if !v.approve
    # end
    #
    # videos.where(author: "车瘾CARDDICTION").each do |v|
    #   v.update!(translate_name: v.name)
    #   url =  "http://127.0.0.1/api/login"
    #   res = HTTParty.post(url,
    #           :body => { :mobile => "18000000004",
    #                      :password => "123456"
    #                    }.to_json,
    #           :headers => { 'Content-Type' => 'application/json' } )
    #
    #   data = JSON.parse(res.body)
    #   user = User.find_by(mobile: "18000000004")
    #
    #   v.user = user
    #   break if !v.approve
    # end
    #
    # videos.where(author: "天下有车").each do |v|
    #   v.update!(translate_name: v.name)
    #   url =  "http://127.0.0.1/api/login"
    #   res = HTTParty.post(url,
    #           :body => { :mobile => "18000000005",
    #                      :password => "123456"
    #                    }.to_json,
    #           :headers => { 'Content-Type' => 'application/json' } )
    #
    #   data = JSON.parse(res.body)
    #   user = User.find_by(mobile: "18000000005")
    #
    #   v.user = user
    #   break if !v.approve
    # end
    #
    # videos.where(author: "章鱼快报").each do |v|
    #   v.update!(translate_name: v.name)
    #   url =  "http://127.0.0.1/api/login"
    #   res = HTTParty.post(url,
    #           :body => { :mobile => "18000000005",
    #                      :password => "123456"
    #                    }.to_json,
    #           :headers => { 'Content-Type' => 'application/json' } )
    #
    #   data = JSON.parse(res.body)
    #   user = User.find_by(mobile: "18000000005")
    #
    #   v.user = user
    #   break if !v.approve
    # end
    #
    # videos.where("name like '%成都车展%'").each do |v|
    #   v.update!(translate_name: v.name)
    #   url =  "http://127.0.0.1/api/login"
    #   res = HTTParty.post(url,
    #           :body => { :mobile => "18000000006",
    #                      :password => "123456"
    #                    }.to_json,
    #           :headers => { 'Content-Type' => 'application/json' } )
    #
    #   data = JSON.parse(res.body)
    #   user = User.find_by(mobile: "18000000006")
    #
    #   v.user = user
    #   break if !v.approve
    # end
  end
end
