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
  Loaded: RBXScriptSignal,
  Unloaded: RBXScriptSignal
}

return {
  --[[
    Creates a new chunking controller with a given chunk size and render distance.

    Wraps Chunker.new() to initialize chunk tracking logic. Useful for
    spatial partitioning or LOD-style systems.

    @param size number — Width of each chunk in studs
    @param distance number? — Optional render distance (defaults to 1)
    @return ChunkerInstance — Initialized chunking controller
  ]]
  create = function(size: number, distance: number?): ChunkerInstance
    assert(type(size) == "number", "Expected number for chunk size")
    if distance ~= nil then
      assert(type(distance) == "number", "Render distance must be a number")
    end
    return Chunker.new(size, distance)
  end,

  --[[
    Adds a value to a chunk based on a world position.

    Automatically converts position to chunk coordinate using internal config.

    @param self ChunkerInstance — The chunk manager instance
    @param position Vector3 — World position
    @param value ChunkValue — The value to assign to the chunk
  ]]
  add = function(self: ChunkerInstance, position: Vector3, value: ChunkValue)
    assert(typeof(position) == "Vector3", "Expected Vector3 for position")
    self:Add(position, value)
  end,

  --[[
    Removes a value from the chunk at a given world position.

    @param self ChunkerInstance — The chunk manager instance
    @param position Vector3 — Position to remove from
    @param value ChunkValue — The value to remove
  ]]
  remove = function(self: ChunkerInstance, position: Vector3, value: ChunkValue)
    assert(typeof(position) == "Vector3", "Expected Vector3 for position")
    self:Remove(position, value)
  end,

  --[[
    Returns the raw chunk data table at a specific chunk coordinate.

    This is useful for direct inspection or manipulation.

    @param self ChunkerInstance
    @param coord ChunkCoord
    @return { ChunkValue }? — Chunk value list, or nil if empty
  ]]
  get_chunk = function(self: ChunkerInstance, coord: ChunkCoord): { ChunkValue }?
    assert(typeof(coord) == "Vector3", "Expected Vector3 for chunk coordinate")
    return self:GetChunk(coord)
  end,

  --[[
    Returns the chunk value table at a specific world position.

    Internally converts position to coordinate using the chunk size.

    @param self ChunkerInstance
    @param position Vector3
    @return { ChunkValue }? — Values in that chunk, or nil if none
  ]]
  get_chunk_from_position = function(self: ChunkerInstance, position: Vector3): { ChunkValue }?
    assert(typeof(position) == "Vector3", "Expected Vector3 for position")
    return self:GetChunkFromPosition(position)
  end,

  --[[
    Checks if a chunk at the given coordinate is currently rendered (active).

    @param self ChunkerInstance
    @param coord ChunkCoord
    @return boolean — Whether that chunk is loaded
  ]]
  is_loaded = function(self: ChunkerInstance, coord: ChunkCoord): boolean
    assert(typeof(coord) == "Vector3", "Expected Vector3 for chunk coordinate")
    return self:IsLoaded(coord)
  end,

  --[[
    Checks if a value is part of any currently loaded chunk.

    This performs a reverse lookup on loaded chunks.

    @param self ChunkerInstance
    @param value ChunkValue
    @return boolean — True if the value is in a visible/loaded chunk
  ]]
  is_value_loaded = function(self: ChunkerInstance, value: ChunkValue): boolean
    assert(value ~= nil, "Expected a valid chunk value")
    return self:IsValueLoaded(value)
  end,

  --[[
    Updates the chunk system with a new central position.

    All nearby chunks will be loaded or culled based on the render distance.
    This is typically called each frame using the camera or player position.

    @param self ChunkerInstance
    @param position Vector3
  ]]
  update = function(self: ChunkerInstance, position: Vector3)
    assert(typeof(position) == "Vector3", "Expected Vector3 for position")
    self:Update(position)
  end,

  --[[
    Returns the internal signal fired when a value is loaded into a chunk.

    Connect to this to detect when items or instances become visible.

    @param self ChunkerInstance
    @return RBXScriptSignal
  ]]
  on_loaded = function(self: ChunkerInstance): RBXScriptSignal
    return self.Loaded
  end,

  --[[
    Returns the internal signal fired when a value is removed from a chunk.

    Use this to track visibility culling or cleanup.

    @param self ChunkerInstance
    @return RBXScriptSignal
  ]]
  on_unloaded = function(self: ChunkerInstance): RBXScriptSignal
    return self.Unloaded
  end
}
