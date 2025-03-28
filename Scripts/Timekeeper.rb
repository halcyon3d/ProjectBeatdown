# encoding: utf-8

module Timekeeper
  def self.sample_rate
    return 1000
  end
  
  def self.bpm
    return 120
  end

  def self.bps
    return bpm / 60
  end

  def self.get_audio_pos_in_seconds
    return Audio.bgm_pos.to_f / sample_rate
  end

  def self.get_current_time
    return Graphics.frame_count.to_f / 60
  end
  
  def self.get_current_beat
    return get_current_time * bps
  end

  def self.get_current_beat_synced
    return get_audio_pos_in_seconds * bps
  end

  def self.get_av_ratio
    return get_audio_pos_in_seconds / get_current_time
  end
end