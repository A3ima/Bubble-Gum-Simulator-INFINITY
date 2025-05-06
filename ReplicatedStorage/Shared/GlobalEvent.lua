local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace = cloneref(game:GetService("Workspace"))

local GlobalEvent = require(ReplicatedStorage.Shared.GlobalEvent)
local Time = require(ReplicatedStorage.Shared.Framework.Utilities.Math.Time)

type EventName = "Lucky" | "Hatching"
type Callback = () -> ()

return {
  --[[
    Checks if a global event is currently active by consulting the game's internal time logic.

    This calls GlobalEvent:IsActive, which checks if the event's stored end time (via Workspace attribute)
    is still ahead of the current server time.

    @param name: EventName
    @return boolean
  ]]
  is_active = function(name: EventName): boolean
    assert(type(name) == "string", "Expected string for event name")
    return GlobalEvent:IsActive(name)
  end,

  --[[
    Returns the number of seconds remaining until the specified event ends.

    Internally uses GlobalEvent:GetRemainingTime, which compares the workspace attribute against Time.now().

    @param name: EventName
    @return number
  ]]
  get_remaining = function(name: EventName): number
    assert(type(name) == "string", "Expected string for event name")
    return GlobalEvent:GetRemainingTime(name)
  end,

  --[[
    Returns a list of all currently active events, as defined by internal Workspace state.

    Useful to scan which timed events are considered running.

    @return { string }
  ]]
  get_active = function(): { string }
    return GlobalEvent:GetActive()
  end,

  --[[
    Hooks into GlobalEvent.Began to execute a callback whenever a specific event starts.

    This uses getconnections + hookfunction to intercept the Signal firing without creating a new connection.

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
    Hooks into GlobalEvent.Ended to execute a callback whenever a specific event ends.

    This hijacks existing connections using hookfunction, instead of creating new listeners.

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
    Spoofs a global event by setting its end time to `duration` seconds from now.

    This modifies Workspace attributes directly and forces the event into an active state.

    @param name: EventName
    @param duration: number — how many seconds until expiration
  ]]
  spoof_event = function(name: EventName, duration: number)
    assert(type(name) == "string", "Expected string for event name")
    assert(type(duration) == "number", "Expected number for duration")
    Workspace:SetAttribute(name, Time.now() + duration)
  end,

  --[[
    Forces an event to immediately end by clearing its Workspace attribute.

    This is useful for prematurely terminating events client-side, or triggering on_end hooks.

    @param name: EventName
  ]]
  end_event_now = function(name: EventName)
    assert(type(name) == "string", "Expected string for event name")
    Workspace:SetAttribute(name, nil)
  end,

  --[[
    Returns the raw expiration timestamp set for a given event (if any), without computing remaining time.

    @param name: EventName
    @return number?
  ]]
  get_raw_expiry = function(name: EventName): number?
    assert(type(name) == "string", "Expected string for event name")
    return Workspace:GetAttribute(name)
  end
}
