--- Tooling for managing game sounds and music.
--- @class Sound
local Sound = {
    --- Currently playing background music
    bgm = nil,
    --- List of currently playing sound effects
    sounds = {},
    --- Maximum number of sound effects that can be played at the same time
    maxSounds = 128,
    --- If true, sound will be update in love.update
    globalUpdate = true,
}

local _lastWasLooped = false

--- Updates the sound channels.
--- @param _ number
function Sound.update(_)
    Sound.forEachSfx(function(sound, i)
        if sound and not sound:isPlaying() then
            table.remove(Sound.sounds, i)
            --sound:release()
            sound = nil
        end
    end)
end

--- Plays a background music
--- @param filename string Path to the music file or audio source.
--- @param sourcetype? string Source type (e.g: "stream" or "static")
--- @param volume? number Volume (0-1)
--- @param force? boolean Play even if music is already playing
function Sound.playMusic(filename, sourcetype, volume, force)
    sourcetype = sourcetype or "stream"
    force = force or false
    if type(filename) == "string" then
        filename = love.audio.newSource(filename, sourcetype)
    end
    Sound.bgm = filename
    Sound.bgm:setVolume(volume or 1)
    if force or not Sound.bgm:isPlaying() then
        Sound.bgm:play()
    end
end

--- Plays a sound effect
--- @see Sound.playMusic
function Sound.playSfx(filename, sourcetype, volume)
    if #Sound.sounds >= Sound.maxSounds then return end
    if type(filename) == "string" then
        filename = love.audio.newSource(filename, sourcetype)
    end
    local sound = filename
    if sound then
        sound:setVolume(volume or 1)
        sound:stop()
        Sound.sounds[#Sound.sounds + 1] = sound
        sound:play()
    end
end

--[[
-- i was JOKING when i wrote this
--- Plays background music no matter what
--- @see Sound.playMusic
function Sound.playMusicAggresive(filename, sourcetype, volume)
    Sound.playMusic(filename, sourcetype, volume, true)
end]]

--- Plays background music if it's not already playing
--- @see Sound.playMusic
function Sound.playMusicPassive(filename, sourcetype, volume)
    if not Sound.isPlaying() then
        Sound.playMusic(filename, sourcetype, volume)
    end
end

--- Calls a function for each sound effect currently playing
--- @param func function
function Sound.forEachSfx(func)
    if type(func) ~= "function" then return end
    if #Sound.sounds == 0 then return end
    for i = 1, #Sound.sounds do
        func(Sound.sounds[i], i)
    end
end

--- Sets the looping state of the current music.
--- @see love.audio.setLooping
function Sound.setLooping(looping)
    if Sound.bgm then
        Sound.bgm:setLooping(looping)
        _lastWasLooped = looping == true
    end
end

--- Checks if the music is currently playing.
--- @see love.audio.isPlaying
function Sound.isPlaying()
    return Sound.bgm and Sound.bgm:isPlaying()
end

return Sound
