if not zanncModMain.Config.Enabled then return end

local dataconfigs = {
    MaxChoices = 2
}

OnAnyLoad{ function()
	ScreenData.UpgradeChoice.MaxChoices = ScreenData.UpgradeChoice.MaxChoices + dataconfigs.MaxChoices
end}

ModUtil.Path.Override("GetTotalLootChoices", function( )
	return ScreenData.UpgradeChoice.MaxChoices
end, zanncModMain)

ModUtil.Path.Context.Wrap("CreateUpgradeChoiceButton", function ( screen, lootData, itemIndex, itemData )
    local purchaseButton = ShallowCopyTable( screen.PurchaseButton )
    local data = { }
    if purchaseButton.Name == "BoonSlotBase" and purchaseButton.Group == "Combat_Menu" then
        local locals = ModUtil.Locals.Stacked( )
        data.upgrade = locals.upgradeData

        local excess = math.max( 3, #locals.upgradeOptions )-3
        data.squashY = 3/(3+excess)
        
        local itemLocationY = (ScreenCenterY - 220) + screen.ButtonSpacingY * ( itemIndex - 1 )
        screen.ButtonSpacingY = screen.ButtonSpacingY * (data.squashY ^ (1/3))

        screen.PurchaseButton.Y = itemLocationY
        screen.PurchaseButton.Scale = 1.0 * (data.squashY ^ (1/3))
        screen.Highlight.Scale = screen.PurchaseButton.Scale
    end

    ModUtil.Path.Wrap("CreateTextBox", function( base, args )
        if args.FontSize then 
            args.FontSize = args.FontSize * (data.squashY ^ (1/3))
        end
        -- if data.upgrade and args.Text == data.upgrade.CustomRarityName then 
        --     ModUtil.Locals.Stacked( ).lineSpacing = 8*data.squashY
        -- end
        return base( args )
    end)
end)

ModUtil.Path.Override("DestroyBoonLootButtons", function( screen, lootData )
	local components = screen.Components
	local toDestroy = {}
	for index = 1, ScreenData.UpgradeChoice.MaxChoices + dataconfigs.MaxChoices do
		local destroyIndexes = {
		"PurchaseButton"..index,
		"PurchaseButton"..index.. "Lock",
		"PurchaseButton"..index.. "Highlight",
		"PurchaseButton"..index.. "Icon",
		"PurchaseButton"..index.. "ExchangeIcon",
		"PurchaseButton"..index.. "ExchangeIconFrame",
		"PurchaseButton"..index.. "QuestIcon",
		"PurchaseButton"..index.. "ElementIcon",
		"Backing"..index,
		"PurchaseButton"..index.. "Frame",
		"PurchaseButton"..index.. "Patch",
		}
		for i, indexName in pairs( destroyIndexes ) do
			if components[indexName] then
				table.insert(toDestroy, components[indexName].Id)
				components[indexName] = nil
			end
		end
	end
	Destroy({ Ids = toDestroy })
end, zanncModMain)  