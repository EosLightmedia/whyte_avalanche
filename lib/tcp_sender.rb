=begin
----------------
TCP Sender class
----------------

Purpose:

Connects and sends data to the client through TCP sockets. Connections can
optionally stay open after the data has been sent. The class is intelligent
enough to reconnect if the connection is lost due to time out, connection
interruption, or manual disconnection.

Example usage:

# Deprecated way:
socket = TCPSender.new
socket.init_with_host('10.10.10.1', 5050)
socket.send_request("slp")

# New way:
socket = TCPSender.new({host: '10.10.10.1', port: 5050})
socket.send_request("slp")

# Don't close the connection between requests:
socket = TCPSender.new({
  host: '10.10.10.1',
  port: 5050,
  stays_connected: true
})
socket.send_request("slp")
# The socket is not closed between these two commands
socket.send_request("wke")

# Connect immediately to the socket:
socket = TCPSender.new({
  host: '10.10.10.1',
  port: 5050,
  connect_immediately: true
})
# Socket is connected here instead of after the next line.
socket.send_request("slp")
=end

class TCPSender
  attr_accessor :client, :stays_connected

  # Change this to be what you want the connection timeout to be.
  CONNECT_ATTEMPT_TIMEOUT = 5

  # Initialize Method argument options:
  # args = {
  #   host: 'ip string',
  #   port: 5050,
  #   stays_connected: false, <- sending true will keep the connections open indefinitely
  #   connect_immediately: false <- sending true will make sure the socket is opened immediately
  # }
  def initialize(args = {})
    unless args.empty?
      @stays_connected = args[:stays_connected] || false
      @client = FastSocket.alloc.initWithHost(args[:host], andPort: args[:port].to_s)
      connect if args[:connect_immediately]
    end
    self
  end

  # Deprecated
  def init_with_host(host, port, stays_connected = false, connect_immediately = false)
    NSLog("WARNING! You're using init_with_host() to initialize the TCP Sender. This method has been deprecated. Please see class file for documentation on the new way to us it.")
    @stays_connected = stays_connected
    @client = FastSocket.alloc.initWithHost(host, andPort: port.to_s)
    connect if connect_immediately
  end

  def connect(timeout = CONNECT_ATTEMPT_TIMEOUT)
    unless @client.isConnected
      mp "Connecting to #{@client.host}:#{@client.port}"
      @client.connect(timeout)
      mp "Connected? #{@client.isConnected}"
    end
    @client.isConnected
  end

  def force_disconnect
    disconnect(true)
  end

  def disconnect(force = false)
    if @client.isConnected && (force == true || !@stays_connected)
      mp "Disconnecting from #{@client.host}:#{@client.port}"
      @client.close
      mp "Connected? #{@client.isConnected}"
    end
  end

  def send_request_clock(to_send)
    connect
    sent = @client.sendBytes(to_send, count: 18)
    disconnect
  end

  def send_request(to_send)
    mp "value: #{to_send} length: #{to_send.length}"
    data = to_send.dataUsingEncoding(NSUTF8StringEncoding)
    mp data.length
    mp NSString.alloc.initWithData(data, encoding:NSUTF8StringEncoding)
    if connect
      sent = @client.sendBytes(data.bytes, count: data.length)
      disconnect
      NSLog "Sent: #{sent}. Client: #{@client.isConnected}"
    else
      NSLog("WARNING! Client could not connect to #{@client.host}:#{@client.port} with a timeout of #{CONNECT_ATTEMPT_TIMEOUT} seconds.")
    end
  end
  
  def send_mic_request(to_send)
    mp "mic request: value: #{to_send} length: #{to_send.length}"
    data = to_send.dataUsingEncoding(NSUTF8StringEncoding)
    mp data.length
    mp NSString.alloc.initWithData(data, encoding:NSUTF8StringEncoding)
    if connect
    sent = @client.sendBytes(data.bytes, count: data.length)
    # App.run_after(0.25){
      # mp "app run after"
      rcv_bytes = Pointer.new(:char, 1024)
      @client.receiveBytes(rcv_bytes, limit: 1024)
      mp @client
      c = 0
      out = []
      11.upto(1023) do |i|
        c = rcv_bytes[i]
        out << c.chr unless c == 0
      end
    response = out.join.chomp
    mp response
    mp "response is #{response}"
    # disconnect
    # }
      mp "Sent: #{sent}. Client: #{@client.isConnected}"
    else
       mp "WARNING! Client could not connect to #{@client.host}:#{@client.port} with a timeout of #{CONNECT_ATTEMPT_TIMEOUT} seconds."
    end
  end
  
  def send_pjlink_request(to_send, expected_response=nil)
    data = to_send.dataUsingEncoding(NSUTF8StringEncoding)
    if connect
      sent = @client.sendBytes(data.bytes, count: data.length)
      App.run_after(0.4){
        rcv_bytes = Pointer.new(:char, 1024)
        @client.receiveBytes(rcv_bytes, limit: 1024)
        c = 0
        out = []
        11.upto(1023) do |i|
          c = rcv_bytes[i]
          out << c.chr unless c == 0
        end
        response = out.join.chomp
        mp response
        ControlCentre.shared.pj_benches.listener(to_send, response, @client.host)
        disconnect
      }
    else
      NSLog("WARNING! Client could not connect to #{@client.host}:#{@client.port} with a timeout of #{CONNECT_ATTEMPT_TIMEOUT} seconds.")
    end
  end

end
