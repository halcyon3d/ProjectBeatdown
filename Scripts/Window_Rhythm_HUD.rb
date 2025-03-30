# encoding: utf-8

class Window_Rhythm_HUD < Window_Base
  $player_turn = true

  def initialize(viewport)
    super(edge_padding, 0, window_width, line_height*5)
    self.back_opacity = 96
   
    create_rhythm_lines
    create_action_command_window
    set_viewports(viewport)

    refresh
  end

  def set_viewports(viewport)
    self.viewport = viewport
    @line1.viewport = viewport
    @line2.viewport = viewport
    @line3.viewport = viewport
    @line4.viewport = viewport
    @command_window.viewport = viewport
  end

  def create_action_command_window
    @command_window = Window_QWER_Command.new(edge_padding, 0, window_width, line_height*5)
  end
  
  def create_rhythm_lines
    @line1 = Window_Rhythm_Line.new(3, :QQQQ, 1, 2, [1,2,3,5])
    @line2 = Window_Rhythm_Line.new(2, :WWWW, 3, 4, [2.25,5])
    @line3 = Window_Rhythm_Line.new(1, :EEEE, 5, 6, [3.25])
    @line4 = Window_Rhythm_Line.new(0, :RRRR, 7, 8, [3.5])
  end

  def self.command_window
    return @command_window
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

  def refresh
    contents.clear
    @line1.refresh ; @line2.refresh ; @line3.refresh ; @line4.refresh
    draw_text(32, 32, 2000, line_height, Timekeeper.get_current_beat.floor)
    @command_window.refresh
    draw_frets
  end

  def update
    refresh
  end

  def draw_frets
    contents.fill_rect(fret_width, 0, 2, contents_height, Color.new(255, 255, 255, 48))
    contents.fill_rect(fret_width * 2, 0, 2, contents_height, Color.new(255, 255, 255, 128))
    contents.fill_rect(fret_width * 3, 0, 2, contents_height, Color.new(255, 255, 255, 48))
  end
end