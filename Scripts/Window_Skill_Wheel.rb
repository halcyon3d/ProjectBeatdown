# encoding: utf-8

class Window_Skill_Wheel < Window_Selectable_Wheel

  def initialize
    super(:KEYW, fret_width, line_height * 2)
    @category = :none
    @data = []
  end

  def get_item_icon(i)
    if @data[i]
      return @data[i].icon_index
    else
      return 0
    end
  end


  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Set Skill Type ID
  #--------------------------------------------------------------------------
  def stype_id=(stype_id)
    return if @stype_id == stype_id
    @stype_id = stype_id
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Get Skill
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Include in Skill List? 
  #--------------------------------------------------------------------------
  def include?(item)
    item && item.stype_id == @stype_id
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def enable?(item)
    @actor && @actor.usable?(item)
  end
  #--------------------------------------------------------------------------
  # * Create Skill List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = @actor ? @actor.skills.select {|skill| include?(skill) } : []
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index(@actor.last_skill.object) || 0)
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------

  #--------------------------------------------------------------------------
  # * Draw Skill Use Cost
  #--------------------------------------------------------------------------
  def draw_skill_cost(rect, skill)
    if @actor.skill_tp_cost(skill) > 0
      change_color(tp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_tp_cost(skill), 2)
    elsif @actor.skill_mp_cost(skill) > 0
      change_color(mp_cost_color, enable?(skill))
      draw_text(rect, @actor.skill_mp_cost(skill), 2)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end
