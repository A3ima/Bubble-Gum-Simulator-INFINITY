local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local GetPickupZones = require(ReplicatedStorage.Shared.Utils.GetPickupZones)

type BasePart = BasePart
type Folder = Folder
type PickupZoneRoot = BasePart | Folder

type PickupItem = {
  Visual: string,
  Item: {
    Type: string,
    Currency: string,
    Amount: number
  }
}

type PickupEntry = {
  Chance: number,
  Item: PickupItem
}

type PickupData = {
  Zone: any,
  Area: string,
  Pickups: { PickupEntry },
  Count: number?
}

type PickupZoneMap = {
  [PickupZoneRoot]: PickupData
}

return {
  --[[
    Returns all pickup zones registered under the "PickupZone" tag.

    Each entry includes:
    - The associated zone controller instance
    - The area it belongs to (from `GetAttribute("Area")`)
    - The configured list of item drops
    - Optional count control (from `GetAttribute("Count")`)

    This allows exploiters to:
    - Discover hidden pickup zones
    - Clone or spoof loot distribution by zone
    - Override or extend drop definitions based on area

    @return zones: PickupZoneMap — Mapping of zone roots to pickup zone definitions
  ]]
  get_all_zones = function(): PickupZoneMap
    return GetPickupZones()
  end
}
