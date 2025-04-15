# encoding: utf-8

class Window_Item_Wheel < Window_Selectable_Wheel

  def initialize
    super(:KEYE, fret_width * 2, line_height)
    @category = :none
    @data = []
  end
  
  def update_tone
    self.tone.set(0,255,0)
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

  def current_item_enabled?
    enable?(@data[index])
  end

  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end

  def enable?(item)
    $game_party.usable?(item)
  end

  def make_item_list
    @data = $game_party.all_items#.select {|item| include?(item) }
    @data.push(nil) if include?(nil)
  end

  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
end
