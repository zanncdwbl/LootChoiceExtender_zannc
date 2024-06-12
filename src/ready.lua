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

modutil.mod.Path.Override("GetTotalLootChoices", function()
    return GetTotalLootChoices_override()
end)

modutil.mod.Path.Wrap("CreateUpgradeChoiceButton", function(base, screen, lootData, itemIndex, itemData)
    return CreateUpgradeChoiceButton_wrap(base, screen, lootData, itemIndex, itemData)
end)

modutil.mod.Path.Override("DestroyBoonLootButtons", function(screen, lootData)
    return DestroyBoonLootButtons_override(screen, lootData)
end)
