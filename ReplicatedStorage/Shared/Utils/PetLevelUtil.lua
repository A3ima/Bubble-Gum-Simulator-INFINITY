local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local PetLevelUtil = require(ReplicatedStorage.Shared.Utils.PetLevelUtil)

type PetData = {
  Name: string,
  XP: number
}

return {
  --[[
    Calculates the level a pet would reach given raw XP.

    Wraps PetLevelUtil:GetLevelFromXP, which uses rarity-specific XP scaling
    to determine the level corresponding to a specific XP amount.

    @param petName string — The name of the pet type (used for rarity lookup)
    @param xp number — The raw XP to evaluate
    @return level number — The resulting level
  ]]
  get_level_from_xp = function(petName: string, xp: number): number
    assert(type(petName) == "string", "Expected string for pet name")
    assert(type(xp) == "number", "Expected number for XP")
    return PetLevelUtil:GetLevelFromXP(petName, xp)
  end,

  --[[
    Returns the current level of a pet based on its XP field.

    This wraps PetLevelUtil:GetLevelFromPet, which handles XP-to-level
    mapping based on internal rarity and XP tables.

    @param pet PetData — A structured pet object with Name and XP
    @return level number — The pet’s current level
  ]]
  get_level_from_pet = function(pet: PetData): number
    assert(type(pet) == "table" and type(pet.Name) == "string", "Expected valid PetData")
    return PetLevelUtil:GetLevelFromPet(pet)
  end,

  --[[
    Returns the total XP required to reach a specific level.

    Internally uses GetTotalXPForLevel to calculate the full XP needed,
    based on the pet’s rarity and the input level.

    @param petName string — Name of the pet (used to get rarity)
    @param level number — Desired level to reach
    @return xp number — Total XP needed to reach that level
  ]]
  get_total_xp_for_level = function(petName: string, level: number): number
    assert(type(petName) == "string", "Expected string for pet name")
    assert(type(level) == "number", "Expected number for level")
    return PetLevelUtil:GetTotalXPForLevel(petName, level)
  end,

  --[[
    Returns the XP difference between level N-1 and level N.

    This wraps GetMarginalXPForLevel, which calculates the delta in XP
    needed to advance one level based on rarity curves.

    @param petName string — The name of the pet
    @param level number — The target level to evaluate
    @return xp number — Marginal XP needed from the prior level
  ]]
  get_marginal_xp_for_level = function(petName: string, level: number): number
    assert(type(petName) == "string", "Expected string for pet name")
    assert(type(level) == "number", "Expected number for level")
    return PetLevelUtil:GetMarginalXPForLevel(petName, level)
  end,

  --[[
    Calculates how much XP is left until the pet reaches max level.

    Internally checks the pet's rarity maximum XP and subtracts current XP.

    @param pet PetData — A structured pet with Name and XP
    @return xpRemaining number — Remaining XP to reach max
  ]]
  get_xp_until_max = function(pet: PetData): number
    assert(type(pet) == "table" and type(pet.Name) == "string" and type(pet.XP) == "number", "Expected valid PetData")
    return PetLevelUtil:CalculateXPUntilMax(pet)
  end,

  --[[
    Calculates the resulting XP and level after adding XP to a pet.

    This internally clamps the XP to avoid exceeding the maximum and
    recalculates the level after the gain is applied.

    @param pet PetData — Pet data before applying XP
    @param gain number — Amount of XP to add
    @return finalXP number — New total XP (clamped)
    @return finalLevel number — Updated level after gain
  ]]
  calculate_given_xp = function(pet: PetData, gain: number): (number, number)
    assert(type(pet) == "table" and type(pet.Name) == "string" and type(pet.XP) == "number", "Expected valid PetData")
    assert(type(gain) == "number", "Expected number for gain")
    return PetLevelUtil:CalculateGiveXP(pet, gain)
  end,

  --[[
    Returns the maximum level possible for the given pet.

    Uses internal rarity data to fetch the configured level cap.

    @param pet PetData — The pet to check
    @return maxLevel number — The pet's level ceiling
  ]]
  get_max_level = function(pet: PetData): number
    assert(type(pet) == "table" and type(pet.Name) == "string", "Expected valid PetData")
    return PetLevelUtil:GetMaxLevel(pet)
  end,

  --[[
    Checks if a pet has reached its maximum level.

    Uses GetLevelFromPet and GetMaxLevel to compare current state.

    @param pet PetData — The pet to check
    @return boolean — True if max level is reached
  ]]
  is_max_level = function(pet: PetData): boolean
    assert(type(pet) == "table" and type(pet.Name) == "string", "Expected valid PetData")
    return PetLevelUtil:IsMaxLevel(pet)
  end
}
