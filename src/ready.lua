---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

zanncModMain = zanncModMain or {}
zanncModMain.Choices = zanncModMain.Choices or 3

game.ScreenData.UpgradeChoice.MaxChoices = zanncModMain.Choices + config.ExtraChoices
local choices = game.ScreenData.UpgradeChoice.MaxChoices

OnAnyLoad{ function()
    print("Max Choices Set To: " .. choices)
    game.ScreenData.UpgradeChoice.MaxChoices = choices
end }

modutil.mod.Path.Override("GetTotalLootChoices", function( )
    return GetTotalLootChoices_override()
end)

modutil.mod.Path.Wrap("CreateUpgradeChoiceButton", function(base, screen, lootData, itemIndex, itemData)
	return CreateUpgradeChoiceButton_wrap(base, screen, lootData, itemIndex, itemData)
end)

modutil.mod.Path.Override("DestroyBoonLootButtons", function (screen, lootData)
    return DestroyBoonLootButtons_override(screen, lootData)
end)

-- Scaling button **hitbox** based on config option
local excess = math.max(3, choices) - 3
local squash = 3 / (3 + excess)

local filegui = rom.path.combine(rom.paths.Content, 'Game/Obstacles/GUI.sjson')

local order = {
    'Name',
    'InheritFrom',
    'DisplayInEditor',
    'Thing'
}

local newdata = sjson.to_object({
    Name = "BoonSlotBaseExtraOptions",
    InheritFrom = "BaseInteractableButton",
    DisplayInEditor = false,
    Thing = {
        TimeModifierFraction = 0.0,
        EditorOutlineDrawBounds = false,
        Graphic = "BoonSlotBase",
        Interact =
        {
        HighlightOnAnimation = "null",
        HighlightOffAnimation = "null",
        },
        Points = {
            { X = -490, Y = 110 * squash },
            { X = 600, Y = 110 * squash },
            { X = 600, Y = -110 * squash },
            { X = -490, Y = -110 * squash },
        }
    },
}, order)

sjson.hook(filegui, function(data)
    print("Hook fired")
    table.insert(data.Obstacles, newdata)
    -- print(sjson.encode(data))
    print("Hook Done")
end)