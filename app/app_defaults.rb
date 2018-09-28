class AppDefaults
  
  class << self
    def load_defaults
      $center = NSNotificationCenter.defaultCenter
      App::Persistence['phidget_id']                        ||= 509583
      App::Persistence['phidget_ip']                        ||= "10.10.155.157"
      App::Persistence['port']                              ||= 80
      App::Persistence['analog_1_id']                       ||= -1
      App::Persistence['analog_2_id']                       ||= -1
      App::Persistence["path_to_audio"]                     ||= '~/track_1.mp3'
      App::Persistence["debug"]                             ||= false
      mp 'set defaults'
      mp App::Persistence.all
    end
    
    def reset_to_default
      App::Persistence.all.each do |e|
        App::Persistence[e[0]] = nil
      end
      load_defaults
      mp App::Persistence.all
    end
    
  end
end