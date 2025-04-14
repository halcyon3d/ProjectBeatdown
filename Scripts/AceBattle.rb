# encoding: utf-8

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # public instance variables
  #--------------------------------------------------------------------------
  attr_accessor :enemy_window
  attr_accessor :info_viewport
  attr_accessor :spriteset
  attr_accessor :status_window
  attr_accessor :status_aid_window
  attr_accessor :subject
  
  #--------------------------------------------------------------------------
  # alias method: create_spriteset
  #--------------------------------------------------------------------------
  alias scene_battle_create_spriteset_abe create_spriteset
  def create_spriteset
    BattleManager.init_battle_type
    scene_battle_create_spriteset_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: update_basic
  #--------------------------------------------------------------------------
  alias scene_battle_update_basic_abe update_basic
  def update_basic
    scene_battle_update_basic_abe
    update_debug
  end
  
  #--------------------------------------------------------------------------
  # new method: update_debug
  #--------------------------------------------------------------------------
  def update_debug
    return unless $TEST || $BTEST
    debug_heal_party if Input.trigger?(:F5)
    debug_damage_party if Input.trigger?(:F6)
    debug_fill_tp if Input.trigger?(:F7)
    debug_kill_all if Input.trigger?(:F8)
  end
  
  #--------------------------------------------------------------------------
  # new method: debug_heal_party
  #--------------------------------------------------------------------------
  def debug_heal_party
    Sound.play_recovery
    for member in $game_party.battle_members
      member.recover_all
    end
    @status_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: debug_damage_party
  #--------------------------------------------------------------------------
  def debug_damage_party
    Sound.play_actor_damage
    for member in $game_party.alive_members
      member.hp = 1
      member.mp = 0
      member.tp = 0
    end
    @status_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: debug_fill_tp
  #--------------------------------------------------------------------------
  def debug_fill_tp
    Sound.play_recovery
    for member in $game_party.alive_members
      member.tp = member.max_tp
    end
    @status_window.refresh
  end
  
  #--------------------------------------------------------------------------
  # new method: debug_kill_all
  #--------------------------------------------------------------------------
  def debug_kill_all
    for enemy in $game_troop.alive_members
      enemy.hp = 0
      enemy.perform_collapse_effect
    end
    BattleManager.judge_win_loss
    @log_window.wait
    @log_window.wait_for_effect
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_all_windows
  #--------------------------------------------------------------------------
  alias scene_battle_create_all_windows_abe create_all_windows
  def create_all_windows
    scene_battle_create_all_windows_abe
    create_battle_status_aid_window
    set_help_window
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_info_viewport
  #--------------------------------------------------------------------------
  alias scene_battle_create_info_viewport_abe create_info_viewport
  def create_info_viewport
    scene_battle_create_info_viewport_abe
  end
  
  #--------------------------------------------------------------------------
  # new method: create_battle_status_aid_window
  #--------------------------------------------------------------------------
  def create_battle_status_aid_window
    @status_aid_window = Window_BattleStatusAid.new
    @status_aid_window.status_window = @status_window
    @status_aid_window.x = Graphics.width - @status_aid_window.width
    @status_aid_window.y = Graphics.height - @status_aid_window.height
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: create_help_window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_BattleHelp.new
    @help_window.hide
  end
  
  #--------------------------------------------------------------------------
  # new method: set_help_window
  #--------------------------------------------------------------------------
  def set_help_window
    @help_window.actor_window = @actor_window
    @help_window.enemy_window = @enemy_window
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_party_command_window
  #--------------------------------------------------------------------------
  alias scene_battle_create_party_command_window_abe create_party_command_window
  def create_party_command_window
    scene_battle_create_party_command_window_abe
    @party_command_window.set_handler(:dir6, method(:command_fight))
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_actor_command_window
  #--------------------------------------------------------------------------
  alias scene_battle_create_actor_command_window_abe create_actor_command_window
  def create_actor_command_window
    scene_battle_create_actor_command_window_abe
    @actor_command_window.set_handler(:dir4, method(:prior_command))
    @actor_command_window.set_handler(:dir6, method(:next_command))
  end
  
  #--------------------------------------------------------------------------
  # alias method: create_skill_window
  #--------------------------------------------------------------------------
  alias scene_battle_create_skill_window_abe create_skill_window
  def create_skill_window
    scene_battle_create_skill_window_abe
    @skill_window.height = @info_viewport.rect.height
    @skill_window.width = Graphics.width - @actor_command_window.width
    @skill_window.y = Graphics.height - @skill_window.height
  end
  
  #--------------------------------------------------------------------------
  # alias method: show_fast?
  #--------------------------------------------------------------------------
  alias scene_battle_show_fast_abe show_fast?
  def show_fast?
    return true if YEA::BATTLE::AUTO_FAST
    return scene_battle_show_fast_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: next_command
  #--------------------------------------------------------------------------
  alias scene_battle_next_command_abe next_command
  def next_command
    @status_window.show
    redraw_current_status
    @actor_command_window.show
    @status_aid_window.hide
    scene_battle_next_command_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: prior_command
  #--------------------------------------------------------------------------
  alias scene_battle_prior_command_abe prior_command
  def prior_command
    redraw_current_status
    scene_battle_prior_command_abe
  end
  
  #--------------------------------------------------------------------------
  # new method: redraw_current_status
  #--------------------------------------------------------------------------
  def redraw_current_status
    return if @status_window.index < 0
    @status_window.draw_item(@status_window.index)
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_attack
  #--------------------------------------------------------------------------
  alias scene_battle_command_attack_abe command_attack
  def command_attack
    $game_temp.battle_aid = $data_skills[BattleManager.actor.attack_skill_id]
    scene_battle_command_attack_abe
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_skill
  #--------------------------------------------------------------------------
  alias scene_battle_command_skill_abe command_skill
  def command_skill
    scene_battle_command_skill_abe
    @status_window.hide
    @actor_command_window.hide
    @status_aid_window.show
  end
  
  #--------------------------------------------------------------------------
  # alias method: command_item
  #--------------------------------------------------------------------------
  alias scene_battle_command_item_abe command_item
  def command_item
    scene_battle_command_item_abe
    @status_window.hide
    @actor_command_window.hide
    @status_aid_window.show
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: on_skill_ok
  #--------------------------------------------------------------------------
  def on_skill_ok
    @skill = @skill_window.item
    $game_temp.battle_aid = @skill
    BattleManager.actor.input.set_skill(@skill.id)
    BattleManager.actor.last_skill.object = @skill
    if @skill.for_friend?
      select_actor_selection
    else
      @skill_window.hide
      next_command
      $game_temp.battle_aid = nil
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_skill_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_skill_cancel_abe on_skill_cancel
  def on_skill_cancel
    scene_battle_on_skill_cancel_abe
    @status_window.show
    @actor_command_window.show
    @status_aid_window.hide
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: on_item_ok
  #--------------------------------------------------------------------------
  def on_item_ok
    @item = @item_window.item
    $game_temp.battle_aid = @item
    BattleManager.actor.input.set_item(@item.id)
    if @item.for_friend?
      select_actor_selection
    else
      @item_window.hide
      next_command
      $game_temp.battle_aid = nil
    end
    $game_party.last_item.object = @item
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_item_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_item_cancel_abe on_item_cancel
  def on_item_cancel
    scene_battle_on_item_cancel_abe
    @status_window.show
    @actor_command_window.show
    @status_aid_window.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: select_actor_selection
  #--------------------------------------------------------------------------
  alias scene_battle_select_actor_selection_abe select_actor_selection
  def select_actor_selection
    @status_aid_window.refresh
    scene_battle_select_actor_selection_abe
    @status_window.hide
    @skill_window.hide
    @item_window.hide
    @help_window.show
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_actor_ok
  #--------------------------------------------------------------------------
  alias scene_battle_on_actor_ok_abe on_actor_ok
  def on_actor_ok
    $game_temp.battle_aid = nil
    scene_battle_on_actor_ok_abe
    @status_window.show
    if $imported["YEA-BattleCommandList"] && !@confirm_command_window.nil?
      @actor_command_window.visible = !@confirm_command_window.visible
    else
      @actor_command_window.show
    end
    @status_aid_window.hide
  end
  
  #--------------------------------------------------------------------------
  # alias method: on_actor_cancel
  #--------------------------------------------------------------------------
  alias scene_battle_on_actor_cancel_abe on_actor_cancel
  def on_actor_cancel
    BattleManager.actor.input.clear
    @status_aid_window.refresh
    $game_temp.battle_aid = nil
    scene_battle_on_actor_cancel_abe
    case @actor_command_window.current_symbol
    when :skill
      @skill_window.show
    when :item
      @item_window.show
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: battle_start
  #--------------------------------------------------------------------------
  alias scene_battle_battle_start_abe battle_start
  def battle_start
    scene_battle_battle_start_abe
    return unless YEA::BATTLE::SKIP_PARTY_COMMAND
    @party_command_window.deactivate
    if BattleManager.input_start
      command_fight 
    else
      turn_start
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: turn_end
  #--------------------------------------------------------------------------
  def turn_end
    all_battle_members.each do |battler|
      battler.on_turn_end
      status_redraw_target(battler)
      @log_window.display_auto_affected_status(battler)
      @log_window.wait_and_clear
    end
    update_party_cooldowns if $imported["YEA-CommandParty"]
    BattleManager.turn_end
    process_event
    start_party_command_selection
    return if end_battle_conditions?
    return unless YEA::BATTLE::SKIP_PARTY_COMMAND
    if BattleManager.input_start
      @party_command_window.deactivate
      command_fight
    else
      @party_command_window.deactivate
      turn_start
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: end_battle_conditions?
  #--------------------------------------------------------------------------
  def end_battle_conditions?
    return true if $game_party.members.empty?
    return true if $game_party.all_dead?
    return true if $game_troop.all_dead?
    return true if BattleManager.aborting?
    return false
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: execute_action
  #--------------------------------------------------------------------------
  def execute_action
    @subject.sprite_effect_type = :whiten if YEA::BATTLE::FLASH_WHITE_EFFECT
    use_item
    @log_window.wait_and_clear
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: apply_item_effects
  #--------------------------------------------------------------------------
  def apply_item_effects(target, item)
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:prepare, item, @subject, target)
    end
    target.item_apply(@subject, item)
    status_redraw_target(@subject)
    status_redraw_target(target) unless target == @subject
    @log_window.display_action_results(target, item)
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:during, item, @subject, target)
    end
    perform_collapse_check(target)
  end
  
  #--------------------------------------------------------------------------
  # overwite method: invoke_counter_attack
  #--------------------------------------------------------------------------
  def invoke_counter_attack(target, item)
    @log_window.display_counter(target, item)
    attack_skill = $data_skills[target.attack_skill_id]
    @subject.item_apply(target, attack_skill)
    status_redraw_target(@subject)
    status_redraw_target(target) unless target == @subject
    @log_window.display_action_results(@subject, attack_skill)
    perform_collapse_check(target)
    perform_collapse_check(@subject)
  end
  
  #--------------------------------------------------------------------------
  # new method: perform_collapse_check
  #--------------------------------------------------------------------------
  def perform_collapse_check(target)
    return if YEA::BATTLE::MSG_ADDED_STATES
    target.perform_collapse_effect if target.can_collapse?
    @log_window.wait
    @log_window.wait_for_effect
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: show_attack_animation
  #--------------------------------------------------------------------------
  def show_attack_animation(targets)
    show_normal_animation(targets, @subject.atk_animation_id1, false)
    wait_for_animation
    show_normal_animation(targets, @subject.atk_animation_id2, true)
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: show_normal_animation
  #--------------------------------------------------------------------------
  def show_normal_animation(targets, animation_id, mirror = false)
    animation = $data_animations[animation_id]
    return if animation.nil?
    ani_check = false
    targets.each do |target|
      if ani_check && target.animation_id <= 0
        target.pseudo_ani_id = animation_id
      else
        target.animation_id = animation_id
      end
      target.animation_mirror = mirror
      ani_check = true if animation.to_screen?
    end
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: process_action_end
  #--------------------------------------------------------------------------
  def process_action_end
    @subject.on_action_end
    status_redraw_target(@subject)
    @log_window.display_auto_affected_status(@subject)
    @log_window.wait_and_clear
    @log_window.display_current_state(@subject)
    @log_window.wait_and_clear
    BattleManager.judge_win_loss
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: use_item
  #--------------------------------------------------------------------------
  def use_item
    item = @subject.current_action.item
    @log_window.display_use_item(@subject, item)
    @subject.use_item(item)
    status_redraw_target(@subject)
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:before, item, @subject, @subject)
    end
    process_casting_animation if $imported["YEA-CastAnimations"]
    targets = @subject.current_action.make_targets.compact rescue []
    show_animation(targets, item.animation_id) if show_all_animation?(item)
    targets.each {|target| 
      if $imported["YEA-TargetManager"]
        target = alive_random_target(target, item) if item.for_random?
      end
      item.repeats.times { invoke_item(target, item) } }
    if $imported["YEA-LunaticObjects"]
      lunatic_object_effect(:after, item, @subject, @subject)
    end
  end
  
  #--------------------------------------------------------------------------
  # alias method: invoke_item
  #--------------------------------------------------------------------------
  alias scene_battle_invoke_item_abe invoke_item
  def invoke_item(target, item)
    show_animation([target], item.animation_id) if separate_ani?(target, item)
    if target.dead? != item.for_dead_friend?
      @subject.last_target_index = target.index
      return
    end
    scene_battle_invoke_item_abe(target, item)
  end
  
  #--------------------------------------------------------------------------
  # new method: show_all_animation?
  #--------------------------------------------------------------------------
  def show_all_animation?(item)
    return true if item.one_animation
    return false if $data_animations[item.animation_id].nil?
    return false unless $data_animations[item.animation_id].to_screen?
    return true
  end
  
  #--------------------------------------------------------------------------
  # new method: separate_ani?
  #--------------------------------------------------------------------------
  def separate_ani?(target, item)
    return false if item.one_animation
    return false if $data_animations[item.animation_id].nil?
    return false if $data_animations[item.animation_id].to_screen?
    return target.dead? == item.for_dead_friend?
  end
  
  #--------------------------------------------------------------------------
  # new method: status_redraw_target
  #--------------------------------------------------------------------------
  def status_redraw_target(target)
    return unless target.actor?
    @status_window.draw_item($game_party.battle_members.index(target))
  end
  
  #--------------------------------------------------------------------------
  # alias method: start_party_command_selection
  #--------------------------------------------------------------------------
  alias start_party_command_selection_abe start_party_command_selection
  def start_party_command_selection
    @status_window.refresh unless scene_changing?
    start_party_command_selection_abe
  end
  
  #--------------------------------------------------------------------------
  # overwrite method: refresh_status
  #--------------------------------------------------------------------------
  def refresh_status; return; end
  
  #--------------------------------------------------------------------------
  # new method: refresh_autobattler_status_window
  #--------------------------------------------------------------------------
  def refresh_autobattler_status_window
    for member in $game_party.battle_members
      next unless member.auto_battle?
      @status_window.draw_item(member.index)
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: hide_extra_gauges
  #--------------------------------------------------------------------------
  def hide_extra_gauges
    # Made for compatibility
  end
  
  #--------------------------------------------------------------------------
  # new method: show_extra_gauges
  #--------------------------------------------------------------------------
  def show_extra_gauges
    # Made for compatibility
  end
  
end # Scene_Battle