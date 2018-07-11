class ShowTimer
  attr_accessor :parent

  def initialize(parent)
    @parent = WeakRef.new(parent)
    App::Persistence['last_played'] 
    @timer_interval = 1
    App::Persistence['loop_interval'] = 1200
  end

  def start_timer
    @timer.invalidate if @timer
    @timer = NSTimer.scheduledTimerWithTimeInterval(@timer_interval, target: self, selector: :timer_fired, userInfo: nil, repeats: true)
    NSRunLoop.mainRunLoop.addTimer(@timer, forMode: NSDefaultRunLoopMode)
  end

  def timer_fired()
    current_time = Time.now
    current_minute = calendar.components(NSMinuteCalendarUnit, fromDate: current_time).minute

    now = current_time.strftime("%-H:%M")
    current_min = current_time.strftime("%M")
    current_hour = current_time.strftime("%-H")
    current_date = current_time.strftime("%Y-%m-%d")
    current_zone = current_time.strftime("%z")
    
    # next_show = App::Persistence['last_played'] + App::Persistence['loop_interval']

    NextShowHelper.set_next_show_time(current_hour, current_min, current_date, current_zone)
    is_show_time(current_min)
  end
  
  def is_show_time(current_min)
    if App::Persistence["power_status"]
      if App::Persistence['loop_status']
        if App::Persistence['show_times'].include? current_min 
          play_movie
        end
      end
    end
  end
  
  def play_movie
    mp "play movie #{@wait_60}"
    unless @wait_60
      NSLog "Looping show."
      @parent.play_show
      App::Persistence['last_played'] = Time.now
      NSThread.detachNewThreadSelector('wait_60', toTarget:self, withObject: nil)
    else
      mp 'already triggered once. Waiting for a minute'
    end
  end
  
  def wait_60
    @wait_60 = true
    App.run_after(60){    
      @wait_60 = false
    }
  end
  

  def stop_timer
    @timer.cancel if @timer
  end
  
  def seconds_to_time(seconds)
    [ seconds.to_i / 60 % 60, seconds.to_i % 60].map { |t| t.to_s.rjust(2,'0') }.join(':')
  end

  def calendar
    @calendar ||= NSCalendar.currentCalendar
  end
end
