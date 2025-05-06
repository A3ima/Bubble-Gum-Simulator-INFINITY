local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Players = cloneref(game:GetService("Players"))

local CurrencyUtil = require(ReplicatedStorage.Shared.Utils.CurrencyUtil)

type Player = typeof(Players.LocalPlayer)

return {
  --[[
    Returns a list of systems that affect currency multiplier calculations.

    These include gamepasses, buffs, potions, and team bonuses.
    This data is used to determine when currency multipliers need updating.

    @return { string } — Keys that should trigger a recalculation
  ]]
  get_multiplier_update_keys = function(): { string }
    return CurrencyUtil.CurrencyMultUpdateKeys
  end,

  --[[
    Returns the full list of keys used to track player currency and reward systems.

    Excludes temporary stat keys like "Points", "Stars", and other score fields.
    Adds extra game-specific categories like "Season", "ChallengePass", etc.

    @return { string } — Cleaned list of currency-related data keys
  ]]
  get_data_keys = function(): { string }
    return CurrencyUtil:GetDataKeys()
  end,

  --[[
    Returns the player's current owned balance for a specific currency.

    Internally wraps ItemUtil:GetOwnedAmount with a currency-type descriptor.

    @param player Player — The player to query
    @param currency string — The currency name (e.g. "Coins", "Gems")
    @return number — Current balance for that currency
  ]]
  get_balance = function(player: Player, currency: string): number
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Expected Player instance")
    assert(type(currency) == "string", "Expected string for currency name")
    return CurrencyUtil:GetBalance(player, currency)
  end
}
