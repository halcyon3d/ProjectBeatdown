# encoding: utf-8

class Window_Selectable_QWER < Window_Base

  attr_reader   :index                    # cursor position
  attr_reader   :help_window              # help window
  attr_accessor :cursor_fix               # fix cursor flag
  attr_accessor :cursor_all               # select all cursors flag

  def initialize
    super(edge_padding, line_height/2, window_width, line_height*4)

    self.windowskin = Cache.system("WindowBorderless")
    self.back_opacity = 0

    @index = 1000000
    @handler = {}
    @cursor_fix = false
    @cursor_all = false
    update_padding
    deactivate
  end

  def update
    super
    process_handling
  end

  def process_handling
    return unless open? && active

    return chooseindex(0)   if Input.trigger?(:KEYQ)
    return chooseindex(1)   if Input.trigger?(:KEYW)
    return chooseindex(2)   if Input.trigger?(:KEYE)
    return chooseindex(3)   if Input.trigger?(:KEYR)

    return process_cancel   if cancel_enabled?    && Input.trigger?(:B)
    
    # return process_pagedown if handle?(:pagedown) && Input.trigger?(:R)
    # return process_pageup   if handle?(:pageup)   && Input.trigger?(:L)
  end

  def chooseindex(index)
    select(index)
    if current_item_enabled?
      play_select_sound(index)
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end

  def play_select_sound(index)
    #Sound.play_ok
  end

  def item_rect(index)
    rect = Rect.new
    rect.width = fret_width
    rect.height = line_height
    rect.x = index * fret_width
    rect.y = (3 - index) * line_height
    rect
  end

  def item_rect_for_text(index)
    rect = item_rect(index)
    rect.x += line_height / 2
    rect
  end

  def item_rect_for_icon(index)
    rect = item_rect(index)
    rect.x -= line_height / 2
    rect.width = line_height
    rect
  end

  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Get Spacing for Items Arranged Side by Side
  #--------------------------------------------------------------------------
  def spacing
    return 32
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    return 0
  end
  #--------------------------------------------------------------------------
  # * Get Item Width
  #--------------------------------------------------------------------------
  def item_width
    (width - standard_padding * 2 + spacing) / col_max - spacing
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    line_height
  end
  #--------------------------------------------------------------------------
  # * Get Row Count
  #--------------------------------------------------------------------------
  def row_max
    [(item_max + col_max - 1) / col_max, 1].max
  end
  #--------------------------------------------------------------------------
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    [super - super % item_height, row_max * item_height].max
  end
  #--------------------------------------------------------------------------
  # * Update Padding
  #--------------------------------------------------------------------------
  def update_padding
    super
    update_padding_bottom
  end
  #--------------------------------------------------------------------------
  # * Update Bottom Padding
  #--------------------------------------------------------------------------
  def update_padding_bottom
    surplus = (height - standard_padding * 2) % item_height
    self.padding_bottom = padding + surplus
  end
  #--------------------------------------------------------------------------
  # * Set Height
  #--------------------------------------------------------------------------
  def height=(height)
    super
    update_padding
  end
  #--------------------------------------------------------------------------
  # * Change Active State
  #--------------------------------------------------------------------------
  def active=(active)
    super
    update_cursor
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Set Cursor Position
  #--------------------------------------------------------------------------
  def index=(index)
    @index = index
    update_cursor
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Select Item
  #--------------------------------------------------------------------------
  def select(index)
    self.index = index if index
  end
  #--------------------------------------------------------------------------
  # * Deselect Item
  #--------------------------------------------------------------------------
  def unselect
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # * Get Current Line
  #--------------------------------------------------------------------------
  def row
    index / col_max
  end
  #--------------------------------------------------------------------------
  # * Get Top Row
  #--------------------------------------------------------------------------
  def top_row
    oy / item_height
  end
  #--------------------------------------------------------------------------
  # * Set Top Row
  #--------------------------------------------------------------------------
  def top_row=(row)
    row = 0 if row < 0
    row = row_max - 1 if row > row_max - 1
    self.oy = row * item_height
  end
  #--------------------------------------------------------------------------
  # * Get Number of Rows Displayable on 1 Page
  #--------------------------------------------------------------------------
  def page_row_max
    (height - padding - padding_bottom) / item_height
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items Displayable on 1 Page
  #--------------------------------------------------------------------------
  def page_item_max
    page_row_max * col_max
  end
  #--------------------------------------------------------------------------
  # * Determine Horizontal Selection
  #--------------------------------------------------------------------------
  def horizontal?
    page_row_max == 1
  end
  #--------------------------------------------------------------------------
  # * Get Bottom Row
  #--------------------------------------------------------------------------
  def bottom_row
    top_row + page_row_max - 1
  end
  #--------------------------------------------------------------------------
  # * Set Bottom Row
  #--------------------------------------------------------------------------
  def bottom_row=(row)
    self.top_row = row - (page_row_max - 1)
  end


  #--------------------------------------------------------------------------
  # * Set Help Window
  #--------------------------------------------------------------------------
  def help_window=(help_window)
    @help_window = help_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Set Handler Corresponding to Operation
  #     method : Method set as a handler (Method object)
  #--------------------------------------------------------------------------
  def set_handler(symbol, method)
    @handler[symbol] = method
  end
  #--------------------------------------------------------------------------
  # * Check for Handler Existence
  #--------------------------------------------------------------------------
  def handle?(symbol)
    @handler.include?(symbol)
  end
  #--------------------------------------------------------------------------
  # * Call Handler
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    @handler[symbol].call if handle?(symbol)
  end
  #--------------------------------------------------------------------------
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  def cursor_movable?
    active && open? && !@cursor_fix && !@cursor_all && item_max > 0
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if index < item_max - col_max || (wrap && col_max == 1)
      select((index + col_max) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if index >= col_max || (wrap && col_max == 1)
      select((index - col_max + item_max) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
      select((index + 1) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if col_max >= 2 && (index > 0 || (wrap && horizontal?))
      select((index - 1 + item_max) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Down
  #--------------------------------------------------------------------------
  def cursor_pagedown
    if top_row + page_row_max < row_max
      self.top_row += page_row_max
      select([@index + page_item_max, item_max - 1].min)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Up
  #--------------------------------------------------------------------------
  def cursor_pageup
    if top_row > 0
      self.top_row -= page_row_max
      select([@index - page_item_max, 0].max)
    end
  end

  #--------------------------------------------------------------------------
  # * Get Activation State of OK Processing
  #--------------------------------------------------------------------------
  def ok_enabled?
    handle?(:ok)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Cancel Processing
  #--------------------------------------------------------------------------
  def cancel_enabled?
    handle?(:cancel)
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------

  #--------------------------------------------------------------------------
  # * Call OK Handler
  #--------------------------------------------------------------------------
  def call_ok_handler
    call_handler(:ok)
  end
  #--------------------------------------------------------------------------
  # * Processing When Cancel Button Is Pressed
  #--------------------------------------------------------------------------
  def process_cancel
    Sound.play_cancel
    Input.update
    deactivate
    call_cancel_handler
  end
  #--------------------------------------------------------------------------
  # * Call Cancel Handler
  #--------------------------------------------------------------------------
  def call_cancel_handler
    call_handler(:cancel)
  end
  #--------------------------------------------------------------------------
  # * Processing When L Button (Page Up) Is Pressed
  #--------------------------------------------------------------------------
  def process_pageup
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pageup)
  end
  #--------------------------------------------------------------------------
  # * Processing When R Button (Page Down) Is Pressed
  #--------------------------------------------------------------------------
  def process_pagedown
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:pagedown)
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    cursor_rect.empty
    # if @cursor_all
    #   cursor_rect.set(0, 0, contents.width, row_max * item_height)
    #   self.top_row = 0
    # elsif @index < 0
    #   cursor_rect.empty
    # else
    #   ensure_cursor_visible
    #   cursor_rect.set(item_rect(@index))
    # end
  end
  #--------------------------------------------------------------------------
  # * Scroll Cursor to Position Within Screen
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_row = row if row < top_row
    self.bottom_row = row if row > bottom_row
  end
  #--------------------------------------------------------------------------
  # * Call Help Window Update Method
  #--------------------------------------------------------------------------
  def call_update_help
    update_help if active && @help_window
  end
  #--------------------------------------------------------------------------
  # * Update Help Window
  #--------------------------------------------------------------------------
  def update_help
    @help_window.clear
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return true
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    item_max.times {|i| draw_item(i) }
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
  end
  #--------------------------------------------------------------------------
  # * Erase Item
  #--------------------------------------------------------------------------
  def clear_item(index)
    contents.clear_rect(item_rect(index))
  end
  #--------------------------------------------------------------------------
  # * Redraw Item
  #--------------------------------------------------------------------------
  def redraw_item(index)
    clear_item(index) if index >= 0
    draw_item(index)  if index >= 0
  end
  #--------------------------------------------------------------------------
  # * Redraw Selection Item
  #--------------------------------------------------------------------------
  def redraw_current_item
    redraw_item(@index)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
end
