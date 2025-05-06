local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace = cloneref(game:GetService("Workspace"))
local RunService = cloneref(game:GetService("RunService"))

local RenderBand = require(ReplicatedStorage.Shared.Utils.RenderBand)

type BandConfig = {
    Distance: number,
    Rate: number
}

type BandInstance = {
    Add: (self: any, instance: Model) -> (),
    Remove: (self: any, instance: Model) -> (),
    GetRenderData: (self: any, instance: Model) -> (boolean, number),
    Update: Signal,
    Render: Signal,
    Culled: Signal
}

type Callback = (instance: Model) -> ()
type UpdateCallback = (instance: Model, delta: number) -> ()

return {
    --[[
        Creates a new render band instance with optional custom distance-rate config.

        This wraps the internal .new() method of RenderBand, which sets up a per-frame LOD system.
        Exploiters may want to inject spoofed BandConfigs to manipulate update rates or visibility.

        @param config {BandConfig}? - Optional array of Distance/Rate rules.
        @return BandInstance
    ]]
    create = function(config: { BandConfig }?): BandInstance
        assert(config == nil or type(config) == "table", "Expected table or nil for config")
        return RenderBand.new(config)
    end,

    --[[
        Registers a model to be managed by RenderBand.

        This associates the instance with a per-frame update offset and starts emitting updates.

        @param self BandInstance
        @param instance Model
    ]]
    add = function(self: BandInstance, instance: Model)
        assert(typeof(instance) == "Instance" and instance:IsA("Model"), "Expected Model instance")
        self:Add(instance)
    end,

    --[[
        Removes a model from the render system.

        It will no longer be updated, rendered, or culled.

        @param self BandInstance
        @param instance Model
    ]]
    remove = function(self: BandInstance, instance: Model)
        assert(typeof(instance) == "Instance" and instance:IsA("Model"), "Expected Model instance")
        self:Remove(instance)
    end,

    --[[
        Returns whether the given instance is visible and how often it should update.

        This wraps GetRenderData(), which uses camera distance, modulo offsets, and LOD config
        to decide update eligibility. Exploiters may want to spoof distance or return values.

        @param self BandInstance
        @param instance Model
        @return boolean, number
    ]]
    get_render_data = function(self: BandInstance, instance: Model): (boolean, number)
        assert(typeof(instance) == "Instance" and instance:IsA("Model"), "Expected Model instance")
        return self:GetRenderData(instance)
    end,

    --[[
        Connects to the internal Update signal.

        Fires every heartbeat frame for any active instance within render distance and rate threshold.

        @param self BandInstance
        @param callback UpdateCallback
        @return RBXScriptConnection
    ]]
    on_update = function(self: BandInstance, callback: UpdateCallback): RBXScriptConnection
        assert(type(callback) == "function", "Expected function for callback")
        return self.Update:Connect(callback)
    end,

    --[[
        Connects to the internal Render signal.

        Fires the first time an instance becomes active/visible.

        @param self BandInstance
        @param callback Callback
        @return RBXScriptConnection
    ]]
    on_render = function(self: BandInstance, callback: Callback): RBXScriptConnection
        assert(type(callback) == "function", "Expected function for callback")
        return self.Render:Connect(callback)
    end,

    --[[
        Connects to the internal Culled signal.

        Fires when an instance becomes inactive or falls out of range.

        @param self BandInstance
        @param callback Callback
        @return RBXScriptConnection
    ]]
    on_cull = function(self: BandInstance, callback: Callback): RBXScriptConnection
        assert(type(callback) == "function", "Expected function for callback")
        return self.Culled:Connect(callback)
    end,

    --[[
        (Optional Exploit Suggestion)
        Hook RenderBand:GetRenderData to always return `true, 1`, forcing max update frequency.

        Can be used to bypass LOD throttling for ESP, silent updates, or auto-tracking.

        Example usage:
        hookfunction(RenderBand.GetRenderData, function(self, instance)
            return true, 1 -- always visible, update every frame
        end)
    ]]
}
