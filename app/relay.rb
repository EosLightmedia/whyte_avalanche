class Relay < AVDevice
  ip_address '10.0.155.40'
  port 80
  protocol "HTTP-GET"
  
  def commands
    {
      pulse: "GET /state.xml?relay1State=2&pulseTime1=0.05 HTTP/1.1\nAuthorization: Basic bm9uZTp3ZWJyZWxheQ==\r\n\r\n",
      off:   "GET /state.xml?relay1State=0 HTTP/1.1\r\nAuthorization: Basic bm9uZTp3ZWJyZWxheQ==\r\n\r\n"
    }
  end
end
