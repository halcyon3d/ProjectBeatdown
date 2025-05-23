# encoding: utf-8

# Displays a single line in the HUD
class Window_Rhythm_Line < Window_Base
  def initialize(line, inputKey, symbol, symbol_pressed, note_buffer, offset=0)
    @note_buffer = note_buffer
    @inputKey = inputKey
    @symbol = symbol
    @symbol_pressed = symbol_pressed
    super(
      edge_padding - line_height / 2,
      line_height * (line + 0.5),
      Graphics.width - (edge_padding - line_height / 2),
      line_height)
    self.windowskin = Bitmap.new(128, 128)
    self.back_opacity = 0
    refresh
  end

  def window_width
    return Graphics.width - 2 * edge_padding
  end

  def fret_width
    return window_width / 4
  end

  def standard_padding
    return 0
  end

  def edge_padding
    return 64
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw
  end

  def update
    refresh
  end
  #--------------------------------------------------------------------------
  # * Open Window
  #--------------------------------------------------------------------------
  def open
    refresh
    super
  end

  def draw
      draw_string
      draw_symbol
      draw_note_buffer
  end

  def draw_string
    contents.fill_rect(0, line_height / 2, window_width + line_height / 2, 2, Color.new(255, 255, 255))
  end

  def draw_symbol
    if Input.press?(@inputKey)
      draw_icon(@symbol_pressed, 0, 0)
    else
      draw_icon(@symbol, 0, 0)
    end
  end

  def draw_note_buffer
    for note in @note_buffer
      draw_note(note)
    end
  end

  def draw_note(beat)
    draw_icon(@symbol, fret_width * ((beat - Timekeeper.get_current_beat) % 8), 0)
  end
end
