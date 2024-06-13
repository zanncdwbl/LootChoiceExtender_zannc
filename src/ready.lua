---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- zanncModMain = zanncModMain or {}
-- zanncModMain.Choices = zanncModMain.Choices or 3

-- game.ScreenData.UpgradeChoice.MaxChoices = zanncModMain.Choices + config.ExtraChoices
-- local choices = game.ScreenData.UpgradeChoice.MaxChoices

-- OnAnyLoad{ function()
--     game.ScreenData.UpgradeChoice.MaxChoices = choices
-- end }

modutil.mod.Path.Context.Wrap("CreateBoonLootButtons", function(base, args)
    return CreateBoonLootButtons_Context(base, args)
end)

modutil.mod.Path.Wrap("GetTotalLootChoices", function()
    return GetTotalLootChoices_wrap()
end)

modutil.mod.Path.Wrap("CalcNumLootChoices", function(base, args)
    return CalcNumLootChoices_Wrap(base, args)
end)

-- modutil.mod.Path.Wrap("CreateUpgradeChoiceButton", function(base, screen, lootData, itemIndex, itemData)
--     return CreateUpgradeChoiceButton_wrap(base, screen, lootData, itemIndex, itemData)
-- end)

modutil.mod.Path.Wrap("DestroyBoonLootButtons", function(screen, lootData)
    return DestroyBoonLootButtons_wrap(screen, lootData)
end)
