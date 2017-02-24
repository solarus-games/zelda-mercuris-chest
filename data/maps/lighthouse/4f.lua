local map = ...

function map:on_started()
  local game = map:get_game()

  -- dynamic music channel volume changes

  sol.audio.set_music_channel_volume(0, 64)
  sol.audio.set_music_channel_volume(1, 64)
  sol.audio.set_music_channel_volume(2, 64)
  sol.audio.set_music_channel_volume(3, 64)
  sol.audio.set_music_channel_volume(4, 64)
  sol.audio.set_music_channel_volume(5, 64)
  sol.audio.set_music_channel_volume(6, 64)
  sol.audio.set_music_channel_volume(7, 64)
end
