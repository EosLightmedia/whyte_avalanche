class WebPage
  attr_accessor :request, :params, :control_centre

  def initialize(request)
    @request = request
    @params = request.params
    @control_centre = ControlCentre.shared
    @css = '<link rel="stylesheet" href="css/sweetalert.css"> 
    <link rel="stylesheet" href="css/jquery.timepicker.css">
    <link rel="stylesheet" href="css/overlay.css">'
    @disable_scrolling = '<meta name="apple-mobile-web-app-capable"
      content="yes" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">'
    @scripts = '
		<script src="js/jquery1.11.2.js"></script>
		<script src="js/sweetalert.min.js"></script>
		<script src="js/jquery.timepicker.min.js"></script>
		<script src="js/app.js"></script>'  
  end

  class << self
    def html_from_file(path)
      data = ''
      file = File.open(path,'r')
      file.each_line do |line|
        data += line
      end
      data
    end
    
    def render(request)
      page = self.new(request)
      html = page.html
      page.params = nil
      page.request = nil
      page.control_centre = nil
      html
    end
  end
end
