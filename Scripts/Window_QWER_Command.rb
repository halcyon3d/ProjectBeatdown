# encoding: utf-8
class Window_QWER_Command < Window_Base

  def window_width
    return Graphics.width - 2 * edge_padding
  end

  def edge_padding
    return 64
  end

  def fret_width
    return window_width / 4
  end

  def window_height
    return line_height * 4
  end

  def initialize(x,y,w,h)
    super(x,y,w,h)
    self.windowskin = Bitmap.new(128, 128)
  end

  def clear
    contents.clear
  end

  def refresh
    contents.clear
    draw_text(3*fret_width,0*line_height,120,line_height,"Rest")
    draw_text(2*fret_width,1*line_height,120,line_height,"Item")
    draw_text(1*fret_width,2*line_height,120,line_height,"Technique")
    draw_text(0*fret_width,3*line_height,120,line_height,"Solo")
  end
end