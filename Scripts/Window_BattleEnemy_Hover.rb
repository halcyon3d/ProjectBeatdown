# encoding: utf-8

class Window_BattleEnemy_Hover < Window_Selectable
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    @index = 0
    @active = true
    refresh
    self.visible = false
  end

  def update
    refresh
    handle_input
    if enemy
      enemy.sprite_effect_type = :whiten
    end
  end

  def refresh
    make_item_list
    create_contents
    draw_all_items
  end

  def item_max
    $game_troop.alive_members.size
  end

  def make_item_list
    @data = $game_troop.alive_members
    @data.sort! { |a,b| a.screen_x <=> b.screen_x }
  end

  def enemy; @data[index]; end

  def col_max; return item_max; end

  def handle_input
    if !@active
      return
    end

    if Input.trigger?(:LEFT)
      @index -= 1
      @index %= item_max
    elsif Input.trigger?(:RIGHT)
      @index += 1
      @index %= item_max
    end
  end
end
