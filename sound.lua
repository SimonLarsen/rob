current_song = 0
music_volume = 0.75
sfx_volume = 0.85
mute = false

function playSound(snd)
	if snd == "door" then
		TEsound.play(sndDoor,"sfx")
	elseif snd == "alarm" then
		TEsound.play(sndAlarm,"sfx")
	end
end

function updateSound()
	TEsound.cleanup()
end

function updateVolume()
	TEsound.volume("music",music_volume)
	TEsound.volume("sfx",sfx_volume)
end

function nextSong()
	current_song = current_song + 1
	if current_song > #SONG_LIST then current_song = 1 end
	TEsound.stop("music",false)
	TEsound.play("res/music/"..SONG_LIST[current_song],"music",music_volume,1,nextSong)
	return SONG_LIST[current_song]
end

function toggleMute()
	if mute == true then
		mute = false
		updateVolume()
	else
		mute = true
		TEsound.volume("music",0)
		TEsound.volume("sfx",0)
	end
end

SONG_LIST = {
	"blues.ogg"
}
