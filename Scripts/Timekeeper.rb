# encoding: utf-8

module Timekeeper
  $offset = 0

  def self.update_offset
    $offset = Graphics.frame_count
  end

  def self.bpm
    return 138
  end

  def self.bps
    return bpm / 60
  end

  def self.get_current_time
    return (Graphics.frame_count-$offset).to_f / 60
  end
  
  def self.get_current_beat
    return get_current_time * bps + 1
  end

  # def self.get_current_beat_synced
  #   return get_audio_pos_in_seconds * bps
  # end

  # def self.get_av_ratio
  #   return get_audio_pos_in_seconds / get_current_time
  # end

  # def self.sample_rate
  #   return 1000
  # end

  # def self.get_audio_pos_in_seconds
  #   return Audio.bgm_pos.to_f / sample_rate
  # end
end

module Audio
  class << self
    alias cp_bgm_play bgm_play unless $@

    def bgm_play(*args)
      cp_bgm_play(*args)
      Timekeeper.update_offset
    end
  end
end