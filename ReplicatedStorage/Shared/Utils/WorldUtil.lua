local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))

local WorldUtil = require(ReplicatedStorage.Shared.Utils.WorldUtil)

local CharacterUtil = require(ReplicatedStorage.Shared.Framework.Utilities.CharacterUtil)

type Player = typeof(Players.LocalPlayer)

return {
  --[[
    Returns the name of the world the player is currently in.

    Uses proximity to Spawn locations stored under Workspace.Worlds.
    Exploiters may spoof proximity or force world detection by manipulating character position.

    @param player: Player — The player whose world context should be evaluated
    @return world: string — The name of the closest world (default: "The Overworld")
  ]]
  get_player_world = function(player: Player): string
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Expected Player instance")
    return WorldUtil:GetPlayerWorld(player)
  end,

  --[[
    Observes changes to the player’s current world and calls a callback when changed.

    Internally checks proximity to all world spawn points every 0.5 seconds and on respawn.
    Exploiters may use this to listen for zone transitions or automate behavior per-world.

    @param player: Player — The player to monitor
    @param callback: (world: string) -> () — Called whenever the player’s world changes
    @return disconnect: () -> () — Disconnects the listener
  ]]
  on_player_world_changed = function(player: Player, callback: (string) -> ()): () -> ()
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Expected Player instance")
    assert(type(callback) == "function", "Expected function for callback")
    return WorldUtil:OnPlayerWorldChanged(player, callback)
  end,

  --[[
    Constructs a formatted path string to an island's portal spawn location.

    This can be used for teleport spoofing, positional logic, or UI targeting.

    @param worldName: string — The name of the world
    @param islandName: string — The name of the island
    @return path: string — The formatted path to the island portal spawn
  ]]
  to_island_location = function(worldName: string, islandName: string): string
    assert(type(worldName) == "string", "Expected string for worldName")
    assert(type(islandName) == "string", "Expected string for islandName")
    return WorldUtil:toIslandLocation(worldName, islandName)
  end
}
