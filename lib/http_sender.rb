class HTTPSender
  attr_accessor :port, :domain, :log_http, :log_body

  def initialize(params)
    @port = params[:port] || 80
    @domain = params[:domain]
    @page = params[:page]
    @url = "http://#{@domain}/"
    mp @url
    @client = AFMotion::Client.build(@url)
  end

  def get(param_key, param_value)
    page_and_params = "#{@page}/#{param_key}=#{param_value}"
    mp "#{@url}#{page_and_params}" if @log_http
    @client.get(page_and_params) do |result|
      mp result.body if @log_body
    end
    nil
  end
  
  def simple_get(ip, port, to_send) #this is specific to cueserver and works
    AFMotion::HTTP.get("http://#{ip}:#{port}/exe.cgi?cmd=#{to_send}") do |result|
      p result.body.to_s
    end
  end
  
end


