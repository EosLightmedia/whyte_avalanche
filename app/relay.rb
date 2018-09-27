class Relay < AVDevice
  ip_address '10.0.155.40'
  port 80
  protocol "HTTP"
  
  def commands
    {
      pulse: "/state.xml?relay1State=2&pulseTime1=0.05",
      off:   "/state.xml?relay1State=0"
    }
  end
end

#WITH PASSWORDS ENABLED - DONT WORK?
# pulse: "GET /state.xml?relay1State=2&pulseTime1=0.05 HTTP/1.1\r\nAuthorization: Basic bm9uZTp3ZWJzd2l0Y2g=\r\n\r\n",
# off:   "GET /state.xml?relay1State=0 HTTP/1.1\r\nAuthorization: Basic bm9uZTp3ZWJzd2l0Y2g=\r\n\r\n"
