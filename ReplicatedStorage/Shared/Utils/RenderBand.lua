local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace = cloneref(game:GetService("Workspace"))
local RunService = cloneref(game:GetService("RunService"))

local RenderBand = require(ReplicatedStorage.Shared.Utils.RenderBand)

type BandInstance = {
  Add: (self: any, instance: Model) -> (),
  Remove: (self: any, instance: Model) -> (),
  GetRenderData: (self: any, instance: Model) -> (boolean, number),
  Update: any,
  Render: any,
  Culled: any
}

type BandConfig = {
  Distance: number,
  Rate: number
}

type Callback = (instance: Instance) -> ()

return {
  --[[
    Creates a new RenderBand controller with optional configuration.

    This controls LOD-style logic and throttled updates based on proximity.

    @param config: { BandConfig }? — Optional distance/rate overrides
    @return BandInstance
  ]]
  create = function(config: { BandConfig }?): BandInstance
    assert(config == nil or type(config) == "table", "Expected nil or table for config")
    return RenderBand.new(config)
  end,

  --[[
    Adds an instance to the render band system and initializes its update offset.

    @param self: BandInstance
    @param instance: Model
  ]]
  add = function(self: BandInstance, instance: Model)
    assert(typeof(instance) == "Instance" and instance:IsA("Model"), "Expected Model for instance")
    self:Add(instance)
  end,

  --[[
    Removes an instance from the render band system.

    @param self: BandInstance
    @param instance: Model
  ]]
  remove = function(self: BandInstance, instance: Model)
    assert(typeof(instance) == "Instance" and instance:IsA("Model"), "Expected Model for instance")
    self:Remove(instance)
  end,

  --[[
    Returns whether the instance is currently visible and how frequently it should update.

    Useful to decide when to throttle per-frame logic.

    @param self: BandInstance
    @param instance: Model
    @return isVisible: boolean, rate: number
  ]]
  get_render_data = function(self: BandInstance, instance: Model): (boolean, number)
    assert(typeof(instance) == "Instance" and instance:IsA("Model"), "Expected Model for instance")
    return self:GetRenderData(instance)
  end,

  --[[
    Hooks into the internal `Update` signal which fires on logical update frames.

    @param self: BandInstance
    @param callback: Callback — function(instance: Model, dt: number)
    @return RBXScriptConnection
  ]]
  on_update = function(self: BandInstance, callback: (Model, number) -> ())
    assert(type(callback) == "function", "Expected function for callback")
    return self.Update:Connect(callback)
  end,

  --[[
    Hooks into the internal `Render` signal which fires when an instance becomes active/visible.

    @param self: BandInstance
    @param callback: Callback
    @return RBXScriptConnection
  ]]
  on_render = function(self: BandInstance, callback: Callback)
    assert(type(callback) == "function", "Expected function for callback")
    return self.Render:Connect(callback)
  end,

  --[[
    Hooks into the internal `Culled` signal which fires when an instance becomes hidden.

    @param self: BandInstance
    @param callback: Callback
    @return RBXScriptConnection
  ]]
  on_cull = function(self: BandInstance, callback: Callback)
    assert(type(callback) == "function", "Expected function for callback")
    return self.Culled:Connect(callback)
  end
}
