class AppDelegate
  
  attr_reader :relay
  
  def applicationDidFinishLaunching(notification)
    @relay = Relay.new
    AppDefaults.load_defaults
    buildMenu
    buildWindow
    setup_notifications
    setup_phidget
    process_sensor(notification)
  end

  def buildWindow
    @button_window_controller = ButtonWindowController.alloc.initWithWindowNibName('ButtonWindow')
    @button_window_controller.setup_window
  end
  
  def setup_notifications
		#$center = NSNotificationCenter.defaultCenter 
    #Add the observer for processing sensor or analog inputs
    $center.addObserver(self, selector: "process_sensor:", name: 'sensor_notification_from_phidget', object: nil )
    #Add the observer for processing when a phidget gets added
		$center.addObserver(self, selector: "process_attach:", name: 'attach_notification_from_phidget', object: nil )
    #$center.addObserver(self, selector: "process_detach:", name: 'detach_notification_from_phidget', object: nil )
    #Add the observer for handling errors
		$center.addObserver(self, selector: "handle_error:", name: 'error_notification_from_phidget', object: nil ) 
  end
  
  def setup_phidget
    @analog_1 = PhidgetAnalogController.new
    @analog_1.createAnalog(App::Persistence['analog_1_id'])
    @phi = Phidget888Controller.new
    @phi.createInterfaceKit(App::Persistence['phidget_id'])
  end
  
  #Do something with the sensor notification
	def process_sensor(notification)
		value = notification.userInfo
    mp "sensor value is #{value}__serial is #{value['serial']}_____________"
    if value["value"] >=5
      mp "motion sensed - triggering lights"
      avalancheTrigger
    end   
	end
  
  def avalancheTrigger
    mp 'Avalanching'
    @phi.setOutput(2, toState: 1)
    @phi.setOutput(5, toState: 1)
    sleep(3)
    @phi.setOutput(2, toState: 0)
    @phi.setOutput(5, toState: 0)
    sleep(10)
    relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
    #sleep(10)
    #relay1pulse
  end
  
  def relay1pulse
    mp 'pulsing'
    relay.pulse
    #The http line to be sent:
    # "GET /state.xml?relay1State=2&pulseTime1=0.05 HTTP/1.1\nAuthorization: Basic bm9uZTp3ZWJyZWxheQ==\r\n\r\n"
  end
  
  #Handle Errors. Or not.
	def handle_error(notification)
		value = notification.userInfo
    mp "ERROR is #{value}_______________"
	end
  
  def setup_analog(analog)
    4.times { |i|
      mp i
      analog.setOutputEnabled(i, enableOutput: 1)
      analog.setVoltage(i, toVoltage: 0)
    }    
  end
  
	#this is called when the phidget 'attaches' to the system (available for talking to)
  def process_attach(notification)
		value = notification.userInfo
    NSLog "Phidget #{value["serial"]} attached (in AppDelegate)"
    App::Persistence["phidget_id"] = value["serial"]
    mp "Phidget #{value["serial"]} attached!"
    # sleep(1) #wait for the phidget to get ready to accept calls. May not need this.
    @phidget_attached = true #this is useful so you dont' write to a phidget which isn't there
    setup_analog(@analog_1)
	end  
  
	def process_detach(notification)
		value = notification.userInfo
    NSLog "Phidget detached"
    mp "Phidget detached!!!"
    # Slack.alert("Phidget Encoder", "Phidget Encoder Detached!", "danger")    
    @phidget_attached = false #this is usefull so you dont' write to a phidget which isn't there
  end
  
end
