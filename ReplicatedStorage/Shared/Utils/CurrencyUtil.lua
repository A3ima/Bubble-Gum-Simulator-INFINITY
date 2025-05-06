local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Players = cloneref(game:GetService("Players"))

local CurrencyUtil = require(ReplicatedStorage.Shared.Utils.CurrencyUtil)

type Player = typeof(Players.LocalPlayer)

type MultKey =
  "Teams"
  | "TeamsEquipped"
  | "Gamepasses"
  | "ActivePotions"
  | "ActiveBuffs"

type CurrencyKey =
  "Coins"
  | "Gems"
  | "Shells"
  | "Bubbles"
  | "Pearls"
  | "Tickets"
  | "Season"
  | "DailyRewards"
  | "ChallengePass"
  | "Competitive"
  | string -- fallback for possible dynamic currencies

return {
  --[[
    Returns the list of systems that influence currency multipliers.

    These include inventory elements like gamepasses, teams, buffs, and potions.
    Exploiters may use this to forcibly trigger multiplier updates.

    @return keys: { MultKey } — List of update-relevant keys
  ]]
  get_multiplier_update_keys = function(): { MultKey }
    return CurrencyUtil.CurrencyMultUpdateKeys
  end,

  --[[
    Returns all known keys used for tracking player currency and reward state.

    Filters out volatile keys like "Points", adds known extras such as "Season".
    Can be used by exploiters to automate spoofing, reward bypassing, etc.

    @return keys: { CurrencyKey } — Full set of trackable currency-related keys
  ]]
  get_data_keys = function(): { CurrencyKey }
    return CurrencyUtil:GetDataKeys()
  end,

  --[[
    Returns the player’s current currency balance for a specific currency.

    Internally wraps ItemUtil:GetOwnedAmount with a descriptor table.
    Could be hooked to spoof currency visually or prevent deduction.

    @param player: Player — The target player instance
    @param currency: CurrencyKey — The currency name (e.g. "Coins", "Gems")
    @return balance: number — The current balance
  ]]
  get_balance = function(player: Player, currency: CurrencyKey): number
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Expected Player instance")
    assert(type(currency) == "string", "Expected string for currency key")
    return CurrencyUtil:GetBalance(player, currency)
  end
}
