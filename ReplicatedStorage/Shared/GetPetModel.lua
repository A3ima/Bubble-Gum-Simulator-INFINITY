local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local GetPetModel = require(ReplicatedStorage.Shared.Utils.GetPetModel)
local Pets = cloneref(ReplicatedStorage.Assets.Pets)

type PetData = {
  Name: string,
  Shiny: boolean?,
  Mythic: boolean?
}

type PetModel = Model

return {
  --[[
    Retrieves the pet model (normal or shiny, mythic if applicable) from the game's asset structure.

    Falls back to `Doggy` model if the requested name doesn't exist under the appropriate folder.

    This directly forwards the internal logic from GetPetModel.

    @param data PetData — table containing Name, Shiny?, Mythic?
    @return PetModel
  ]]
  get_model = function(data: PetData): PetModel
    assert(type(data) == "table", "Expected PetData table")
    assert(type(data.Name) == "string", "Expected string for data.Name")
    if data.Shiny ~= nil then assert(type(data.Shiny) == "boolean", "Shiny must be boolean") end
    if data.Mythic ~= nil then assert(type(data.Mythic) == "boolean", "Mythic must be boolean") end

    return GetPetModel(data)
  end
}
