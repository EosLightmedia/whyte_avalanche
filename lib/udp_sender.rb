class UDPSender

  def setup(ip, port)
    @port = port
    @ip = ip
  end

  def udp_send(to_send)
    payload = to_send
    socket = AsyncUdpSocket.alloc.initWithDelegate(self, delegateQueue:Dispatch::Queue.main.dispatch_object)
    socket.sendData(payload.dataUsingEncoding(NSUTF8StringEncoding), toHost:@ip, port:@port, withTimeout:-1, tag:0)
    # mp "message #{to_send} sent"
    true
  end
  
  class << self
    
    def udp_send_full(ip, port, to_send)
      payload = to_send
      socket = AsyncUdpSocket.alloc.initWithDelegate(self, delegateQueue:Dispatch::Queue.main.dispatch_object)
      socket.sendData(payload.dataUsingEncoding(NSUTF8StringEncoding), toHost:ip, port:port, withTimeout:-1, tag:0)
      # mp "message #{to_send} sent"
      true
    end
  end
  
end
