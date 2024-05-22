---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

local file = rom.path.combine(rom.paths.Content, 'Game/Text/en/ShellText.en.sjson')

sjson.hook(file, function(data)
	return sjson_ShellText(data)
end)

modutil.mod.Path.Wrap("SetupMap", function(base)
	return wrap_SetupMap(base)
end)

OnAnyLoad{ function()
    game.ScreenData.UpgradeChoice.MaxChoices = GetBaseChoices() + config.ExtraChoices
end }

modutil.mod.Path.Override("GetTotalLootChoices", function( )
    return GetTotalLootChoices_override()
end)

modutil.mod.Path.Wrap("CreateUpgradeChoiceButton", function(screen, lootData, itemIndex, itemData)
	return CreateUpgradeChoiceButton_wrap(screen, lootData, itemIndex, itemData)
end)

modutil.mod.Path.Override("DestroyBoonLootButtons", function (screen, lootData)
    return DestroyBoonLootButtons_override(screen, lootData)
end)