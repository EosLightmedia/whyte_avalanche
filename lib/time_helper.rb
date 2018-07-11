class TimeHelper
  class << self
    
    def thirty_sixty(now)

      now.strftime "%I:%M"
      hour = now.strftime('%I')
      min = now.strftime("%M")
      if min.to_i > 31
        p 'above 31'
        p hour = (hour.to_i + 1).to_s
        result = "#{hour}:00"
     else
        result = "#{hour}:30"
     end
     NSLog "Initial next show is #{result}"
     parse_time result
    end
    
    def parse_time time
      # time = time.strftime("%I%M")
      string = time.tr(' :PAM','')
      # mp "new time #{string}"
      array = []
      string.chars.each {|e| array << e.to_i(16).chr}

      ones = array[3]
      tens = array[2]
      p hour_ones = array[1]
      if array[0] == "\x00"
        hour_tens = 0x2E #Blank character
      else
        hour_tens = array[0]
      end
      
      time_array = ["\x00","\x00","\x00",ones,tens,hour_ones,hour_tens,"\x30","\x00","\x00","\x00","\x00","\x00","\x00","\x00"]
      total = 0
      time_array.join.each_byte {|b| total += b
        }
      sum = total.chr
      
      data = Pointer.new('c', 18)
      data[0] = 0xFE
      data[1] = 0x00
      data[2] = 0x00
      data[3] = ones.chr
      data[4] = tens.chr
      data[5] = hour_ones.chr
      data[6] = hour_tens.chr
      data[7] = 0x30
      data[8] = 0x00
      data[9] = 0x00
      data[10] = 0x00
      data[11] = 0x00
      data[12] = 0x00
      data[13] = 0x00
      data[14] = 0x00
      data[15] = 0x00
      data[16] = 0x00
      data[17] = sum
      
      data

    end
    
    def send_blanks
      
      data = Pointer.new('c', 18)
      data[0] = 0xFE
      data[1] = 0x00
      data[2] = 0x00
      data[3] = 0x2E
      data[4] = 0x2E
      data[5] = 0x2E
      data[6] = 0x2E
      data[7] = 0x00
      data[8] = 0x00
      data[9] = 0x00
      data[10] = 0x00
      data[11] = 0x00
      data[12] = 0x00
      data[13] = 0x00
      data[14] = 0x00
      data[15] = 0x00
      data[16] = 0x00
      data[17] = 0x00
      
      data
      
    end
  
  
  
  end
end