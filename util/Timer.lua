--- Simple Timer class, counts from a specific duration to 0 and finishes
--- not to be confused with `love.timer.sleep`
--- @class Timer
local Timer = Object:extend()
function Timer:__tostring() return "Timer" end

function Timer:new()
  self.duration       = 0     --- @type number
  self.loops          = 0     --- @type number
  self.startCallback  = nil   --- @type function
  self.updateCallback = nil   --- @type function
  self.finishCallback = nil   --- @type fun(timer: Timer)
  self.finished       = false --- @type boolean
  self.progress       = 0;    --- @type number
  self._deltaTime     = 0     --- @type number
  self.oneshot        = false ---@type boolean
  return self
end

--- Immediately stops the timer and calls finishCallback.
function Timer:stop()
  -- mark timer as finished
  self.finished = true
  self:runFinishCallback()
  self.loops = 0
  self.progress = 0;
  self._deltaTime = 0.0
  -- clear functions
  self.startCallback = nil
  self.updateCallback = nil
  self.finishCallback = nil
end

function Timer:runFinishCallback()
  if type(self.finishCallback) == "function" then
    self.finishCallback(self)
  end
end

function Timer:update(dt)
  if self.finished == true then return end
  self.progress = (self._deltaTime / self.duration);

  --print('wait time '..self.progress..' loops left '..self.loops .. ' duration ' .. self.duration)

  if self.progress >= 1 then
    if self.loops > 0 then
      self._deltaTime = 0.0
      self.progress = 0;
      self.loops = self.loops - 1
      --print(self.timerID .. " : " .. self.loops);
      self:runFinishCallback()
    elseif self.loops <= 0 and self.finished ~= true then
      --print("finished")
      self:stop()
      return
    end
    --#endregion
  end

  if self.progress <= 1 then
    self._deltaTime = self._deltaTime + dt
  end
end


--- Starts the timer
--- @param duration number    duration of the timer.
--- @param cfinish function   function to call after the timer ends.
--- @param loops number?      how many times should the timer loop before ending.
--- @param oneshot boolean?   if the timer should destroy on finish
function Timer:start(duration, cfinish, loops, oneshot)
  assert(duration, "Timer:start expects a duration!");
  self.finishCallback = cfinish
  self.duration = duration
  self.loops = loops or 0
  self.finished = false;
  self.progress = 0;
  self._deltaTime = 0;
  self.oneshot = oneshot or false;

  if not table.has(_G.GlobalTimers, self)then
    table.insert(_G.GlobalTimers, self)
  end
  return self;
end

--- Creates a new timer and starts it.
--- @param duration number    duration of the timer.
--- @param cfinish function   function to call after the timer ends.
--- @param loops number?      how many times should the timer loop before ending.
--- @param oneshot boolean?   if the timer should destroy on finish
function Timer.create(duration, cfinish, loops, oneshot)
  assert(duration, "Timer.create expects a duration!");
  local t = Timer()
  return t:start(duration, cfinish, loops, oneshot)
  --return t
end

return Timer