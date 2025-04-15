# encoding: utf-8

class Window_Skill_Wheel < Window_Selectable_Wheel

  def initialize
    super(:KEYW, fret_width, line_height * 2)
    @actor = nil
    @stype_id = 0
    @data = []
  end

  def update_tone
    self.tone.set(255,255,0)
  end

  def get_item_icon(i)
    if @data[i]
      return @data[i].icon_index
    else
      return 0
    end
  end
  
  def current_item_name
    if item
      return item.name
    else
      return ""
    end
  end

  def current_item_desc
    if item
      return item.description
    else
      return ""
    end
  end

  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    self.oy = 0
  end

  def stype_id=(stype_id)
    return if @stype_id == stype_id
    @stype_id = stype_id
    refresh
    self.oy = 0
  end

  def current_item_enabled?
    enable?(@data[index])
  end

  def include?(item)
    item && item.stype_id == @stype_id
  end

  def enable?(item)
    @actor && @actor.usable?(item)
  end

  def make_item_list
    @data = @actor ? @actor.skills.select {|skill| include?(skill) } : []
  end

  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end
