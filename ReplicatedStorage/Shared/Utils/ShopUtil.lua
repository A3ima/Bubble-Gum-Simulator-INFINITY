local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local ShopUtil = require(ReplicatedStorage.Shared.Utils.ShopUtil)

type PlayerData = {
  UserId: number,
  Shops: { [string]: { Period: number } },
  MasteryUpgrades: { { Type: string, Buff: string } }
}

type ShopItem = {
  Visual: string,
  Item: {
    Type: string,
    Currency: string,
    Amount: number
  },
  Cost: {
    Type: string,
    Currency: string,
    Amount: number
  },
  Stock: number | NumberRange
}

return {
  --[[
    Returns the number of shop slots unlocked for a given mastery state.

    Considers the current mastery upgrade bonuses versus the global maximum.

    @param playerData: PlayerData — The player’s mastery data
    @param baseSlotCount: number — Base number of visible slots
    @return unlocked: number — Effective unlocked slots
  ]]
  get_unlocked_slots = function(playerData: PlayerData, baseSlotCount: number): number
    assert(type(playerData) == "table", "Expected PlayerData for playerData")
    assert(type(baseSlotCount) == "number", "Expected number for baseSlotCount")
    return ShopUtil:GetUnlockedSlots(playerData, baseSlotCount)
  end,

  --[[
    Returns the maximum number of free rerolls based on mastery upgrades.

    Useful for automating shop reroll spoof logic or reward optimizations.

    @param playerData: PlayerData — Mastery context
    @return rerolls: number — Maximum free reroll count
  ]]
  get_max_free_rerolls = function(playerData: PlayerData): number
    assert(type(playerData) == "table", "Expected PlayerData for playerData")
    return ShopUtil:GetMaxFreeRerolls(playerData)
  end,

  --[[
    Generates the current item list for a specific shop and player seed.

    Returns the item list, corresponding stock counts, and sale booleans.

    This can be used to spoof or preview upcoming shop states by manipulating period values.

    @param shopId: string — The shop identifier (e.g., "GemShop")
    @param playerData: PlayerData — The player and seed info
    @param saveData: PlayerData — Includes shop seed and upgrade state
    @return items: { ShopItem }, stock: { number }, discounts: { boolean }
  ]]
  get_items_data = function(
    shopId: string,
    playerData: PlayerData,
    saveData: PlayerData
  ): ({ ShopItem }, { number }, { boolean })
    assert(type(shopId) == "string", "Expected string for shopId")
    assert(type(playerData) == "table", "Expected PlayerData for playerData")
    assert(type(saveData) == "table", "Expected PlayerData for saveData")
    return ShopUtil:GetItemsData(shopId, playerData, saveData)
  end
}
