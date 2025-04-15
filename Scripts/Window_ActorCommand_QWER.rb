# encoding: utf-8

class Window_ActorCommand_QWER < Window_Command_QWER

  # intiialise
  def initialize
    super
    self.openness = 0
    deactivate
    @actor = nil
  end

  # reset
  def setup(actor)
    @actor = actor
    clear_command_list
    make_command_list
    refresh
    activate
    open
  end

  def make_command_list
    return unless @actor
    add_attack_command
    add_skill_commands
    add_item_command
    add_guard_command
  end

  def add_attack_command
    add_command(Vocab::attack, :attack, @actor.attack_usable?)
  end

  def add_skill_commands
    @actor.added_skill_types.sort.each do |stype_id|
      name = $data_system.skill_types[stype_id]
      add_command(name, :skill, true, stype_id)
    end
  end

  def add_guard_command
    add_command(Vocab::guard, :guard, @actor.guard_usable?)
  end

  def add_item_command
    add_command(Vocab::item, :item)
  end
end
