namespace :get_data do
  task :car_category => :environment do

    # car_category
    res = HTTParty.get 'http://api.jisuapi.com/car/brand?appkey=14d50de51a19f83e'
    json = JSON.parse(res.body)['result']

    json.each do |cat|
      CarCategory.create!(id: cat['id'], name: cat['name'], logo: cat['logo'],
                          initial: cat['initial'],
                          parent_id: cat['parentid'],
                          depth: cat['depth']) if !CarCategory.find_by(id: cat['id'])
    end

    # level 2 type
    brands = CarCategory.where(depth: 1, state: '使用')
    brands.each do |brand|
      res = HTTParty.get 'http://api.jisuapi.com/car/type?appkey=14d50de51a19f83e&parentid=' + brand.id.to_s
      json = JSON.parse(res.body)['result']
      if !json.empty?
        json.each do |j|
          if !j["list"].empty?
            j["list"].each do |type|
              if !CarCategory.find_by(id: type['id'])
                car = CarCategory.create!(id: type['id'], name: type['name'],
                                          logo: type['logo'],
                                          fullname: type['fullname'],
                                          keyword: type['fullname'],
                                          parent_id: brand.id,
                                          depth: type['depth'])
                res_2 = HTTParty.get 'http://api.jisuapi.com/car/car?appkey=14d50de51a19f83e&parentid=' + type['id'].to_s
                json_2 = JSON.parse(res_2.body)['result']
                car.update!(sizetype: json_2["list"].first["sizetype"]) if (car && !json_2["list"].nil?)
              end
            end
          end
        end
      end
    end

  end
end
