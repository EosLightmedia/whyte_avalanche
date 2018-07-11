class NextShowHelper
  class << self
    def set_next_show_time(current_hour, current_min, current_date, current_zone)
      if App::Persistence["power_status"]
        if App::Persistence['loop_status']
          if current_min.to_i >= 40
            App::Persistence["next_showtime"] = "#{current_date} #{current_hour.to_i + 1}:00:00 #{current_zone}"
          elsif current_min.to_i >= 20
            App::Persistence["next_showtime"] = "#{current_date} #{current_hour}:40:00  #{current_zone}"
          else
            App::Persistence["next_showtime"] = "#{current_date} #{current_hour}:20:00  #{current_zone}"
          end
        else
          App::Persistence["next_showtime"] = nil
          
        end
      end
    end
  end
  
end