# encoding: utf-8
class Window_QWER_Command < Window_Base

  def window_width
    return Graphics.width - 2 * edge_padding
  end

  def edge_padding
    return 64
  end

  def window_height
    return line_height * 4
  end

  def initialize(x,y,w,h)
    super(x,y,w,h)
    self.windowskin = Bitmap.new(128, 128)
  end

  def refresh
    contents.clear
    draw_text(0,line_height*4,80,line_height,"Attack")
  end
end