local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace = cloneref(game:GetService("Workspace"))

local Chunker = require(ReplicatedStorage.Shared.Utils.Chunker)

type Vector3 = Vector3
type ChunkCoord = Vector3
type ChunkValue = Instance | any
type ChunkerInstance = {
  Add: (self: any, position: Vector3, value: ChunkValue) -> (),
  Remove: (self: any, position: Vector3, value: ChunkValue) -> (),
  GetChunk: (self: any, coord: ChunkCoord) -> { ChunkValue }?,
  GetChunkFromPosition: (self: any, position: Vector3) -> { ChunkValue }?,
  IsLoaded: (self: any, coord: ChunkCoord) -> boolean,
  IsValueLoaded: (self: any, value: ChunkValue) -> boolean,
  Update: (self: any, position: Vector3) -> (),
  Loaded: any,
  Unloaded: any,
}

return {
  --[[
    Creates a new chunking controller with a given chunk size and render distance.

    @param size: number — the width of each chunk in studs
    @param distance: number — how many chunks around the player to render
    @return ChunkerInstance
  ]]
  create = function(size: number, distance: number?): ChunkerInstance
    assert(type(size) == "number", "Expected number for chunk size")
    if distance ~= nil then
      assert(type(distance) == "number", "Render distance must be a number")
    end
    return Chunker.new(size, distance)
  end,

  --[[
    Adds a value (instance or otherwise) to a chunk at a world position.

    @param self: ChunkerInstance
    @param position: Vector3
    @param value: ChunkValue
  ]]
  add = function(self: ChunkerInstance, position: Vector3, value: ChunkValue)
    assert(typeof(position) == "Vector3", "Expected Vector3 for position")
    self:Add(position, value)
  end,

  --[[
    Removes a value from a chunk at a world position.

    @param self: ChunkerInstance
    @param position: Vector3
    @param value: ChunkValue
  ]]
  remove = function(self: ChunkerInstance, position: Vector3, value: ChunkValue)
    assert(typeof(position) == "Vector3", "Expected Vector3 for position")
    self:Remove(position, value)
  end,

  --[[
    Returns the chunk table for a given coordinate.

    @param self: ChunkerInstance
