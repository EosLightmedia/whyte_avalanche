class AVDevice
  attr_accessor :ip_address, :port, :protocol

  def metaclass
    class << self; self; end
  end

  def self.ip_address(address=nil)
    @ip_address ||= address
  end

  def self.port(port=nil)
    @port ||= port
  end
  
  def self.protocol(protocol=nil)
    @protocol ||= protocol
  end

  def initialize
    self.ip_address = self.class.ip_address
    self.port = self.class.port
    self.protocol = self.class.protocol
    if self.class.respond_to? 'username'
      self.username = self.class.username
    end
    create_command_methods
    super
  end

  def create_command_methods
    commands.each do |method, command|
      self.metaclass.send(:define_method, method) do
        mp "Sending #{command}"
        send_command(command)
      end
    end
  end

  def send_command(command)
    # TCP and UDP to go here.
    case self.protocol
    when "UDP"
      NSLog "sending UDP command now.. #{command} to #{self.ip_address} port #{self.port}"
      sock = UDPSender.new(self.ip_address, self.port.to_i)
      # sock.setup(self.ip_address, self.port.to_i)

      if NSThread.isMainThread
        sock.udp_send(command)
      else
        Dispatch::Queue.main.sync do
          sock.udp_send(command)
        end
      end
    
    when "TCP"
      NSLog "sending TCP command now.. #{command} to #{self.ip_address}"
      socket = TCPSender.new({host: self.ip_address, port: self.port.to_i})
      if NSThread.isMainThread
        socket.send_request(command)
      else
        Dispatch::Queue.main.sync do
          socket.send_request(command)
        end
      end

    when "TCP-MIC"
      mp "sending TCP-MIC command now.. #{command} to #{self.ip_address}"
      socket = TCPSender.new({host: self.ip_address, port: self.port.to_i, stays_connected: true})
      if NSThread.isMainThread
        socket.send_mic_request(command)
      else
        Dispatch::Queue.main.sync do
          socket.send_mic_request(command)
        end
      end

    when "HTTP"
      NSLog "sending HTTP command now.. #{command} to #{self.ip_address}:#{self.port}"
      mp "http://#{self.ip_address}:#{self.port}/exe.cgi?cmd=#{command}"

      if NSThread.isMainThread
        AFMotion::HTTP.get("http://#{self.ip_address}:#{self.port}/exe.cgi?cmd=#{command}") do |result|
          if result.success?
            NSLog "http get command #{command} succeded to send to #{self.ip_address}:#{self.port}"
          elsif result.failure?
            NSLog "http error: #{result.error.localizedDescription}"
          end
        end
      else
        Dispatch::Queue.main.sync do
          AFMotion::HTTP.get("http://#{self.ip_address}:#{self.port}/exe.cgi?cmd=#{command}") do |result|
            if result.success?
              NSLog "http get command #{command} succeded to send to #{self.ip_address}:#{self.port}"
            elsif result.failure?
              NSLog "http error: #{result.error.localizedDescription}"
            end
          end
        end
      end
      
    when "HTTP-GET" #Send Raw HTTP get request
      NSLog "Sending raw http get request now... #{command} to #{self.ip_address}"
      if NSThread.isMainThread
        AFMotion::HTTP.get(command) do |result|
          p result
        end
      else
        Dispatch::Queue.main.sync do
          AFMotion::HTTP.get(command) do |result|
            p result
          end
        end
      end
      
    when "HTTP-JSON" #for use with philips hue
      mp "sending HTTP command now.. #{command} to #{self.ip_address}:#{self.port}"
      AFMotion::JSON.put("http://#{self.ip_address}/api/1afcddd45eb9030c46fed3c5424ee7ef/groups/0/action", command) do |result|
        p result.body.to_s
      end
      
    end
    
  end
end
