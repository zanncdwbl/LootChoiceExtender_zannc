ModUtil.RegisterMod("zanncModMain")

local dataconfigs = {
    MaxChoices = 5,
    ButtonSpacingY = 160,

    PurchaseButton = {
		Name = "BoonSlotBase",
		Group = "Combat_Menu",
        ScaleY = 0.7
	},

    Highlight = {
		Name = "BlankObstacle",
		Group = "Combat_Menu",
        ScaleY = 0.7
    },

    DescriptionText =
	{
		OffsetX = -420,
		OffsetY = -35,
		Width = 920,
		Justification = "Left",
		VerticalJustification = "Top",
		LineSpacingBottom = 2,
		LuaKey = "TooltipData",
		LuaValue = {},
		Format = "BaseFormat",
		UseDescription = true,
		VariableAutoFormat = "BoldFormatGraft",
		TextSymbolScale = 0.8,
		DataProperties =
		{
			OpacityWithOwner = true,
		},
	},

	StatLineLeft =
	{
		OffsetX = -420,
		Width = 420,
		Justification = "Left",
		VerticalJustification = "Top",
		LineSpacingBottom = 2,
		LuaKey = "TooltipData",
		LuaValue = {},
		Format = "BaseFormat",
		VariableAutoFormat = "BoldFormatGraft",
		TextSymbolScale = 0.8,
	},

	StatLineRight =
	{
		OffsetX = 0,
		Width = 485,
		Justification = "Left",
		VerticalJustification = "Top",
		LineSpacingBottom = 2,
		UseDescription = true,
		LuaKey = "TooltipData",
		LuaValue = {},
		Format = "BaseFormat",
		VariableAutoFormat = "BoldFormatGraft",
		TextSymbolScale = 0.8,
	}
}

OnAnyLoad { 
    function()
    ScreenData.UpgradeChoice.MaxChoices = dataconfigs.MaxChoices
    ScreenData.UpgradeChoice.ButtonSpacingY = dataconfigs.ButtonSpacingY
    ScreenData.UpgradeChoice.PurchaseButton = dataconfigs.PurchaseButton
    ScreenData.UpgradeChoice.Highlight = dataconfigs.Highlight
    ScreenData.UpgradeChoice.DescriptionText = dataconfigs.DescriptionText
    ScreenData.UpgradeChoice.StatLineLeft = dataconfigs.StatLineLeft
    ScreenData.UpgradeChoice.StatLineRight = dataconfigs.StatLineRight
end}

ModUtil.Path.Override("UpgradeChoiceData", function()
	return dataconfigs
end, zanncModMain)