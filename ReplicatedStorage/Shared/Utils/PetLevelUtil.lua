local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local PetLevelUtil = require(ReplicatedStorage.Shared.Utils.PetLevelUtil)

type PetData = {
  Name: string,
  XP: number
}

return {
  --[[
    Calculates the level a pet would be at based on raw XP.

    @param petName: string
    @param xp: number
    @return level: number
  ]]
  get_level_from_xp = function(petName: string, xp: number): number
    assert(type(petName) == "string", "Expected string for pet name")
    assert(type(xp) == "number", "Expected number for XP")
    return PetLevelUtil:GetLevelFromXP(petName, xp)
  end,

  --[[
    Returns the current level of a pet based on its XP field.

    @param pet: PetData
    @return level: number
  ]]
  get_level_from_pet = function(pet: PetData): number
    assert(type(pet) == "table" and type(pet.Name) == "string", "Expected valid PetData")
    return PetLevelUtil:GetLevelFromPet(pet)
  end,

  --[[
    Returns the total XP required to reach a specific level for a pet.

    @param petName: string
    @param level: number
    @return xp: number
  ]]
  get_total_xp_for_level = function(petName: string, level: number): number
    assert(type(petName) == "string", "Expected string for pet name")
    assert(type(level) == "number", "Expected number for level")
    return PetLevelUtil:GetTotalXPForLevel(petName, level)
  end,

  --[[
    Returns the XP needed to go from level n-1 to level n.

    @param petName: string
    @param level: number
    @return xp: number
  ]]
  get_marginal_xp_for_level = function(petName: string, level: number): number
    assert(type(petName) == "string", "Expected string for pet name")
    assert(type(level) == "number", "Expected number for level")
    return PetLevelUtil:GetMarginalXPForLevel(petName, level)
  end,

  --[[
    Returns how much XP a pet needs until it's fully maxed out.

    @param pet: PetData
    @return xpRemaining: number
  ]]
  get_xp_until_max = function(pet: PetData): number
    assert(type(pet) == "table" and type(pet.Name) == "string" and type(pet.XP) == "number", "Expected valid PetData")
    return PetLevelUtil:CalculateXPUntilMax(pet)
  end,

  --[[
    Calculates the XP and resulting level after applying XP to a pet.

    XP will be clamped to not exceed the maximum for the pet's rarity.

    @param pet: PetData
    @param gain: number
    @return finalXP: number, finalLevel: number
  ]]
  calculate_given_xp = function(pet: PetData, gain: number): (number, number)
    assert(type(pet) == "table" and type(pet.Name) == "string" and type(pet.XP) == "number", "Expected valid PetData")
    assert(type(gain) == "number", "Expected number for gain")
    return PetLevelUtil:CalculateGiveXP(pet, gain)
  end,

  --[[
    Returns the maximum level possible for the given pet.

    @param pet: PetData
    @return maxLevel: number
  ]]
  get_max_level = function(pet: PetData): number
    assert(type(pet) == "table" and type(pet.Name) == "string", "Expected valid PetData")
    return PetLevelUtil:GetMaxLevel(pet)
  end,

  --[[
    Returns whether the pet has reached its maximum level.

    @param pet: PetData
    @return boolean
  ]]
  is_max_level = function(pet: PetData): boolean
    assert(type(pet) == "table" and type(pet.Name) == "string", "Expected valid PetData")
    return PetLevelUtil:IsMaxLevel(pet)
  end
}
