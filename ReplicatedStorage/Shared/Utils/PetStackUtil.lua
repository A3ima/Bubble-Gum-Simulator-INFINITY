local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local PetStackUtil = require(ReplicatedStorage.Shared.Utils.PetStackUtil)

type PetData = {
  Name: string,
  Shiny: boolean?,
  Mythic: boolean?,
  Locked: boolean?,
  XP: number,
  Enchants: any
}

type PlayerData = {
  Pets: { PetData },
  Settings: { [string]: any }
}

return {
  --[[
    Determines whether a pet can be merged into a stack.

    The pet must:
    - Be unlocked
    - Have 0 XP
    - Have no enchants
    - Not be a "Secret" rarity pet

    @param playerData: PlayerData
    @param unused: any (placeholder for compatibility)
    @param pet: PetData
    @return boolean
  ]]
  can_merge_pet = function(playerData: PlayerData, unused: any, pet: PetData): boolean
    assert(type(playerData) == "table", "Expected PlayerData table for first argument")
    assert(type(pet) == "table", "Expected PetData table for third argument")
    return PetStackUtil:CanMergePet(playerData, unused, pet)
  end,

  --[[
    Searches for a mergeable pet in the player's inventory
    that matches the given pet's Name, Shiny, and Mythic flags.

    Excludes the pet itself.

    @param playerData: PlayerData
    @param pet: PetData
    @return PetData?
  ]]
  find_merge_pet = function(playerData: PlayerData, pet: PetData): PetData?
    assert(type(playerData) == "table", "Expected PlayerData table for first argument")
    assert(type(pet) == "table", "Expected PetData table for second argument")
    return PetStackUtil:FindMergePet(playerData, pet)
  end,

  --[[
    Returns the minimum visual stack size for a given pet,
    based on rarity and player settings.

    @param playerData: PlayerData
    @param pet: PetData
    @return number
  ]]
  get_min_stack_size = function(playerData: PlayerData, pet: PetData): number
    assert(type(playerData) == "table", "Expected PlayerData table for first argument")
    assert(type(pet) == "table", "Expected PetData table for second argument")
    return PetStackUtil:GetMinStackSize(playerData, pet)
  end
}
