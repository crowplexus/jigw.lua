local Sound = {
	sourcesCached = {},  --- @type table<love.audio.Source>
	soundsPlaying = {},  --- @type table<love.audio.Source>
	music 				= nil, --- @class love.audio.Source
	masterVolume	= 1.0, --- @type number
	musicVolume		= 1.0, --- @type number
	soundVolume		= 1.0, --- @type number
	masterMute		= false,
}

function Sound.update(dt)
	local currentMV = love.audio.getVolume()
	local newestMV = Sound.masterMute and 0.0 or Sound.masterVolume
	if currentMV ~= newestMV then
		love.audio.setVolume(newestMV)
		-- TODO: ^ this, but with sound effects and music.
	end
	Sound.forEachSfx(function(sound,id)
		-- this might not be the best solution but hwere we have it ig
		if sound ~= nil then
			if not sound:isPlaying() then
				table.remove(Sound.soundsPlaying,id)
				sound:release()
				sound = nil
			end
		end
		--print("Sound Effects being played:"..#Sound.soundsPlaying)
	end)
end

--- Used for caching audio sources and releasing them later when finished.
--- @param file				string File path (with sound extension included at the end)
--- @param sourceType string Streaming or static source. ("static", stream")
function Sound.makeSource(file,sourceType)
	local src = love.audio.newSource(file,sourceType)
	table.insert(Sound.soundsPlaying,src)
	return src
end

--- Creates a background music stream and immediately plays it.
--- @param file				string File path (with sound extension included at the end)
--- @param sourceType string Streaming or static source. ("static", stream")
--- @param volume 		number Initial volume.
--- @param looped			boolean Sets whether the BGM should loop.
function Sound.playMusic(file,sourceType,volume,looped)
	local vol = (Sound.musicVolume) * (volume or 1.0)
	local bgm = love.audio.newSource(file,sourceType)
	bgm:setLooping(looped or false)
	bgm:setVolume(vol)
	bgm:play()
	-- replace this later ig?
	Sound.music = bgm
end

--- Creates a sound effect stream and immediately plays it.
--- @param file				string File path (with sound extension included at the end)
--- @param sourceType string Streaming or static source. ("static", stream")
--- @param volume 		number Initial volume.
function Sound.playSound(file,sourceType,volume)
	local vol = (Sound.soundVolume) * (volume or 1.0)
	local sfx = love.audio.newSource(file,sourceType)
	sfx:setVolume(vol)
	sfx:play()
	table.insert(Sound.soundsPlaying,sfx)
end

--- Stops the background music abruptly.
--- @param release			boolean Clears the audio completely from memory.
function Sound.stopMusic(release)
	if type(release) ~= "boolean" then release = true end
	if Sound.music and Sound.music.stop then
		Sound.music:stop()
	end
	if release == true then
		if Sound.music.release then Sound.music:release() end
		Sound.music = nil
	end
end

--- Stops every sound effect abruptly.
--- @param releaseAll		boolean Clears the sounds completely from memory.
function Sound.stopAll(releaseAll)
	if #Sound.soundsPlaying == 0 then return end
	for i=1,#Sound.soundsPlaying do
		local sfx = Sound.soundsPlaying[i]
		if sfx == nil then return end
		if sfx.stop then
			sfx:stop()
		end
		if releaseAll == true then
			if sfx.release then sfx:release() end
			table.remove(Sound.soundsPlaying,i)
			sfx = nil
		end
	end
end

function Sound.forEachSfx(func)
	if type(func) ~= "function" then return end
	if #Sound.soundsPlaying == 0 then return end
	for i=1,#Sound.soundsPlaying do
		local sfx = Sound.soundsPlaying[i]
		func(sfx,i)
	end
end

return Sound
