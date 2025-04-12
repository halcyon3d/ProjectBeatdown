# encoding: utf-8

class Window_Rhythm_HUD < Window_Base
  $player_turn = true
  $select_action = true

  def initialize(viewport)
    super(edge_padding, 0, window_width, line_height*5)
    self.back_opacity = 96
   
    create_rhythm_lines
    set_viewports(viewport)
    @handler = {}

    refresh
  end

  def refresh
    contents.clear
    draw_text(32, 32, 2000, line_height, Timekeeper.get_current_beat.floor)
    @line1.refresh ; @line2.refresh ; @line3.refresh ; @line4.refresh
    draw_frets
    @command_window.clear
  end

  def update
    refresh
    if $select_action
      @command_window.refresh
      handle_input_buttons
      return  
    end
  end

  def handle_input_buttons
    if Input.press?(:LETTER_Q)
      $select_action = false
      call_handler(:attack)
    end
  end

  def set_handler(symbol, method)
    @handler[symbol] = method
  end

  def call_handler(symbol)
    @handler[symbol].call
  end

  def draw_frets
    contents.fill_rect(fret_width, 0, 2, contents_height, Color.new(255, 255, 255, 48))
    contents.fill_rect(fret_width * 2, 0, 2, contents_height, Color.new(255, 255, 255, 128))
    contents.fill_rect(fret_width * 3, 0, 2, contents_height, Color.new(255, 255, 255, 48))
  end

  def set_viewports(viewport)
    self.viewport = viewport
    @line1.viewport = viewport
    @line2.viewport = viewport
    @line3.viewport = viewport
    @line4.viewport = viewport
  end

  def create_rhythm_lines
    @line1 = Window_Rhythm_Line.new(3, :QQQQ, 1, 2,[])#[1,2,3,5])
    @line2 = Window_Rhythm_Line.new(2, :WWWW, 3, 4,[])# [2.25,5])
    @line3 = Window_Rhythm_Line.new(1, :EEEE, 5, 6,[])# [3.25])
    @line4 = Window_Rhythm_Line.new(0, :RRRR, 7, 8,[])# [3.5])
  end
end