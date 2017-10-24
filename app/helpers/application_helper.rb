module ApplicationHelper
  def adjust_time(time)
    if (time.to_i / 60 * 60) == time.to_i
      return time
    else
      return Time.at(time.to_i / 60 * 60) + 1.minute
    end
  end

  def floor_time(time)
    if (time.to_i / 60 * 60) == time.to_i
      return time
    else
      return Time.at(time.to_i / 60 * 60)
    end
  end

end
