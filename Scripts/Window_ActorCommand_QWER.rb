# encoding: utf-8
#==============================================================================
# ** Window_ActorCommand
#------------------------------------------------------------------------------
#  This window is for selecting an actor's action on the battle screen.
#==============================================================================

class Window_ActorCommand_QWER < Window_Command_QWER
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    self.openness = 0
    deactivate
    @actor = nil
  end

  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    add_attack_command
    add_skill_commands
    add_guard_command
    add_item_command
  end
  #--------------------------------------------------------------------------
  # * Add Attack Command to List
  #--------------------------------------------------------------------------
  def add_attack_command
    add_command(Vocab::attack, :attack, @actor.attack_usable?)
  end
  #--------------------------------------------------------------------------
  # * Add Skill Command to List
  #--------------------------------------------------------------------------
  def add_skill_commands
    @actor.added_skill_types.sort.each do |stype_id|
      name = $data_system.skill_types[stype_id]
      add_command(name, :skill, true, stype_id)
    end
  end
  #--------------------------------------------------------------------------
  # * Add Guard Command to List
  #--------------------------------------------------------------------------
  def add_guard_command
    add_command(Vocab::guard, :guard, @actor.guard_usable?)
  end
  #--------------------------------------------------------------------------
  # * Add Item Command to List
  #--------------------------------------------------------------------------
  def add_item_command
    add_command(Vocab::item, :item)
  end
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def setup(actor)
    @actor = actor
    clear_command_list
    make_command_list
    refresh
    activate
    open
  end
end
