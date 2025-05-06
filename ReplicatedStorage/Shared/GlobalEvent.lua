local GlobalEvent = require(game:GetService("ReplicatedStorage").Shared.GlobalEvent)
local Time = require(game:GetService("ReplicatedStorage").Shared.Framework.Utilities.Math.Time)
local Workspace = cloneref(game:GetService("Workspace"))

type EventName = "Lucky" | "Hatching"
type Callback = () -> ()

return {
  --[[
    Returns whether the specified event is currently active.

    @param name: EventName
    @return boolean
  ]]
  is_active = function(name: EventName): boolean
    assert(type(name) == "string", "Expected string for event name")
    return GlobalEvent:IsActive(name)
  end,

  --[[
    Returns the remaining time (in seconds) for an event.

    @param name: EventName
    @return number
  ]]
  get_remaining = function(name: EventName): number
    assert(type(name) == "string", "Expected string for event name")
    return GlobalEvent:GetRemainingTime(name)
  end,

  --[[
    Returns a list of currently active events.

    @return { string }
  ]]
  get_active = function(): { string }
    return GlobalEvent:GetActive()
  end,

  --[[
    Hooks the original function connected to GlobalEvent.Began
    and calls your callback when the specified event starts.

    @param name: EventName
    @param callback: Callback
  ]]
  on_start = function(name: EventName, callback: Callback)
    assert(type(name) == "string", "Expected string for event name")
    assert(type(callback) == "function", "Expected function for callback")

    for _, conn in ipairs(getconnections(GlobalEvent.Began)) do
      local original = conn.Function
      if typeof(original) == "function" and not isexecutorclosure(original) then
        hookfunction(original, function(fired)
          if fired == name then
            callback()
          end
          return original(fired)
        end)
      end
    end
  end,

  --[[
    Hooks the original function connected to GlobalEvent.Ended
    and calls your callback when the specified event ends.

    @param name: EventName
    @param callback: Callback
  ]]
  on_end = function(name: EventName, callback: Callback)
    assert(type(name) == "string", "Expected string for event name")
    assert(type(callback) == "function", "Expected function for callback")

    for _, conn in ipairs(getconnections(GlobalEvent.Ended)) do
      local original = conn.Function
      if typeof(original) == "function" and not isexecutorclosure(original) then
        hookfunction(original, function(fired)
          if fired == name then
            callback()
          end
          return original(fired)
        end)
      end
    end
  end,

  --[[
    Spoofs an active event by setting its end time manually.

    @param name: EventName
    @param duration: number (seconds from now)
  ]]
  spoof_event = function(name: EventName, duration: number)
    assert(type(name) == "string", "Expected string for event name")
    assert(type(duration) == "number", "Expected number for duration")
    Workspace:SetAttribute(name, Time.now() + duration)
  end
}
