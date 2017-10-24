namespace :get_data do
  task :fit_category => :environment do
    include SpydersHelper

    #fit keywords
    categories = []
    array = get_keywords

    array.each do |c|
     categories << [c[0], c[1].gsub("^", "").gsub("!", "").gsub("*", "")]
    end
    #add sizetype & car relation
    all_cars = CarCategory.available_depth_3
    all_cars.each do |car|
      begin
      categories << [categories.select{ |x| x.include? car.sizetype}.first[0], car.parent.name + car.fullname] if car.sizetype?
      categories << [categories.select{ |x| x.include? car.sizetype}.first[0], car.parent.translate_name + " " + car.translate_name] if car.sizetype?
      # if !categories.select{ |x| x[1] == car.fullname}.empty?
      #   categories << [categories.select{ |x| x.include? car.sizetype}.first[0], car.fullname] if car.sizetype?
      #   categories << [categories.select{ |x| x.include? car.sizetype}.first[0], car.translate_name] if car.sizetype?
      # end
      rescue Exception => exc
        next
      end
    end

    # all_brands = CarCategory.available_depth_1

    categories.uniq!

    spyder_videos = SpyderVideo.unapproved
    spyder_videos.each do |video|
      a = []
      b = []
      SpyderVideo.transaction do
        categories.each do |cat|
          if video.name.downcase.include? cat[1].downcase
            (a << cat[0] && b << cat[1]) if !a.include? cat[0]
          end
        end
        begin
          video.update!(category: a.join(","), category_str: b.join(",")) && video.pre_approve if !a.empty?
          video.dispose if video.category.empty?
        rescue Exception => exc
          next
        end
      end
      # sleep 0.1
    end

  end
end
