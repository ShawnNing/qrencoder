module QREncoder
  class SVG
    attr_reader :canvas,
      :background,
      :points,
      :width,
      :height

    ##
    # Takes an optional hash of options. See QRCode#png for details.
    def initialize(qrcode, options={})
      @points = qrcode.points
      @background = options[:transparent] ? 0 : 1
      
      @height = qrcode.height
      @width = qrcode.width

    end

    def to_s2(sz)
      str = "<?xml version='1.0' encoding='utf-8'?>"
      str = str + "<svg version='1.1' baseProfile='full' width='#{sz}' height='#{sz}' viewBox='0 0 #{width} #{height}' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:ev='http://www.w3.org/2001/xml-events'>"
      str = str + "<defs><rect id='b' width='1' height='1' /></defs>"
      str = str + "<g fill='black'>"
      
      points.each do |pt|
        str = str + "<use x='#{pt[0]}' y='#{pt[1]}' xlink:href='#b' />"
      end
      
      str = str + "</g></svg>"
      return str
    end

    def to_s(sz)
      svg_str = "<?xml version='1.0' encoding='utf-8'?>"
      svg_str = svg_str + "<svg version='1.1' baseProfile='full' width='#{sz}' height='#{sz}' viewBox='0 0 #{width} #{height}' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:ev='http://www.w3.org/2001/xml-events'>"
      svg_str = svg_str + "<g stroke='black'>"
      
      lx = 0
      ly = 0
      n = 1
      str = ""
      compress = true
      points.each do |pt|
        x = pt[0]
        y = pt[1]

        if str == "" then
          str = "<path d='M#{x},#{y}"
          lx = x
          ly = y
          n = 1
        else
          if y != ly then
            if compress then
              str = str + "h#{n}M#{x},#{y}"
            else
              str = str + "h#{n}' />" + "\n" + "<path d='M#{x},#{y}"
            end
            
            lx = x
            ly = y
            n = 1
          else
            if x == lx+n then
              n = n+1
            else
              str = str + "h#{n}m#{x-lx-n},0"
              lx = x
              ly = y
              n = 1
            end
          end
        end
      end
      str = str + "h#{n}' />"

      svg_str = svg_str + str + "</g></svg>"
      return svg_str
    end

  end
end
