# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app_deployment_target = '10.9'
  app.name = 'Whyte Avalanche'
  app.icon = 'eos_purple'
  app.version = '1.0'
  app.identifier = 'com.eoslightmedia.EosAvalanche'
  
  app.embedded_frameworks += ['/Library/Frameworks/Phidget22.framework', '/Library/Frameworks/Phidget21.framework']
  app.bridgesupport_files << 'resources/phidget21.bridgesupport' 
  app.vendor_project('./vendor/phidget21', :static)
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  
  #app.files += Dir.glob(File.join(app.project_dir, 'lib/**/*.rb'))
   
  app.pods do
    pod 'CocoaAsyncSocket'
    pod 'FastSocket'
    pod 'SocketRocket'
  end

  #app.info_plist['CFBundleIconName'] = 'AppIcon'
  
  app.release do
    app.codesign_certificate = MotionProvisioning.certificate(
      type: :distribution,
      platform: :mac)
  end
end
