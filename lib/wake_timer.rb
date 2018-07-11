class WakeTimer
  attr_accessor :parent

  def initialize(parent)
    setup_formatter
    format_times
    @parent = WeakRef.new(parent)
  end

  def start_timer
    stop_timer
    @timer = EM.add_periodic_timer 60.0 do
      NSLog "Timer activated time = #{NSDate.date}"
      update(NSDate.date)
    end
  end
  
  def scheduler_active=(boolean)
    mp "Scheduler #{boolean}"
    App::Persistence["scheduler_status"] = boolean
  end

  def update(current_time)
    format_times
    now = "#{current_time.hour}:#{current_time.min}"
    mp "update, current time: #{now}, off time: #{@off_time}, on time: #{@on_time}, Scheduler is #{App::Persistence["scheduler_status"]}"
    
    if App::Persistence["scheduler_status"]
      if now == @on_time 
        NSLog 'waking system' 
        ControlCentre.shared.pick_command("#power_on")
      elsif now == @off_time
        NSLog 'sleeping system'
        ControlCentre.shared.pick_command("#power_off")
      else
        mp "Schedule is running but it's not time"
      end
    end

  end

  def stop_timer
    @timer.cancel if @timer
  end
  
  def setup_formatter
    @date_formatter = NSDateFormatter.alloc.init
    @date_formatter.setDateFormat("hh:mma")
  end
  
  def format_times
    mp on_time = @date_formatter.dateFromString(App::Persistence["on_time"])
    mp off_time = @date_formatter.dateFromString(App::Persistence["off_time"])
    mp @on_time = "#{on_time.hour}:#{on_time.min}"
    mp @off_time = "#{off_time.hour}:#{off_time.min}"
  end

  def calendar
    @calendar ||= NSCalendar.currentCalendar
  end
  
end
