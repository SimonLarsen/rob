SONG_LIST = {
	"bossa.ogg",
	"blues.ogg"
}

function playSound(snd)
	if snd == "door" then
		TEsound.play(sndDoor,"sfx")
	elseif snd == "alarm" then
		TEsound.play(sndAlarm,"sfx")
	end
end

current_song = 1
function updateSound()
	TEsound.cleanup()
end

function nextSong()
	current_song = current_song + 1
	if current_song > #SONG_LIST then current_song = 1 end
	TEsound.stop("music",false)
	TEsound.play("res/music/"..SONG_LIST[current_song],"music",1,1,nextSong)
	return SONG_LIST[current_song]
end
