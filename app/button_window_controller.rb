class ButtonWindowController < NSWindowController
  extend IB
  
  outlet :phidget_id_field, NSTextField
  outlet :analog_1_id_field, NSTextField
  outlet :analog_2_id_field, NSTextField

  
  def save_values(sender)
    
    App::Persistence['phidget_id'] =  @phidget_id_field.stringValue.to_i
    App::Persistence['analog_1_id'] = @analog_1_id_field.stringValue.to_i
    App::Persistence['analog_2_id'] = @analog_2_id_field.stringValue.to_i
  end
  
  def setup_window()
    p "background colour is: #{window.backgroundColor}"
    
    @phidget_id_field.setStringValue App::Persistence['phidget_id'].to_s
    @analog_1_id_field.setStringValue App::Persistence['analog_1_id'].to_s
    @analog_2_id_field.setStringValue App::Persistence['analog_2_id'].to_s
  
    setup_notifications
  end
  
  def setup_notifications
    
  end
  

end
