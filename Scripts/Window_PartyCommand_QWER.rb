# encoding: utf-8

class Window_PartyCommand_QWER < Window_Command_QWER

  def initialize
    super
    self.openness = 0
    deactivate
  end
 
  def make_command_list
    add_command(Vocab::fight,  :fight)
    add_command(Vocab::escape, :escape, BattleManager.can_escape?)
  end

  def setup
    clear_command_list
    make_command_list
    refresh
    select(0)
    activate
    open
  end
end
