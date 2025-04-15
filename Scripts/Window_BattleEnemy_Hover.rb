# encoding: utf-8

class Window_BattleEnemy_Hover < Window_Base
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    self.windowskin = Bitmap.new(128, 128)
    @index = 0
    refresh
    self.visible = false
  end

  def update
    super
    return unless active

    refresh
    handle_input
    if enemy
      enemy.sprite_effect_type = :whiten
    end
  end

  def handle_input
    return unless active

    if Input.trigger?(:LEFT)
      @index -= 1
      @index %= item_max
      Audio.se_play("Audio/SE/ui_choose.wav", 70)
    elsif Input.trigger?(:RIGHT)
      @index += 1
      @index %= item_max
      Audio.se_play("Audio/SE/ui_choose.wav", 70)
    end
  end

  def refresh
    make_item_list
    create_contents
  end

  def enemy; @data[@index]; end

  def item_max
    $game_troop.alive_members.size
  end

  def make_item_list
    @data = $game_troop.alive_members
    @data.sort! { |a,b| a.screen_x <=> b.screen_x }
  end
end
