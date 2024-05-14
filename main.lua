if not zanncModMain.Config.Enabled then return end

local dataconfigs = {
    ExtraChoices = 2
}

-- =======================================================================
-- Yeah I don't even know, but this works perfectly - sorry had to steal
-- =======================================================================

local baseChoices = GetTotalLootChoices()

-- Other mods should override this value
zanncModMain.Choices = baseChoices

zanncModMain.GetBaseChoices = function( )
	return baseChoices
end

OnAnyLoad{ function()
	ScreenData.UpgradeChoice.MaxChoices = zanncModMain.Choices + dataconfigs.ExtraChoices
end}

ModUtil.Path.Override("GetTotalLootChoices", function( )
	return ScreenData.UpgradeChoice.MaxChoices or zanncModMain.Choices
end, zanncModMain)

ModUtil.Path.Override("CalcNumLootChoices", function( )
	local numChoices = ScreenData.UpgradeChoice.MaxChoices - GetNumMetaUpgrades("ReducedLootChoicesShrineUpgrade")
	if (isGodLoot or treatAsGodLootByShops) and HasHeroTraitValue("RestrictBoonChoices") then
		numChoices = numChoices - 1
	end
	return numChoices
end, zanncModMain)

ModUtil.Path.Context.Wrap("CreateUpgradeChoiceButton", function ( screen, lootData, itemIndex, itemData )
    local purchaseButton = ShallowCopyTable( screen.PurchaseButton )
    local data = { }
    if purchaseButton.Name == "BoonSlotBase" and purchaseButton.Group == "Combat_Menu" then -- hopefully to stop breaking the codex/arachne/echo etc
        local locals = ModUtil.Locals.Stacked( )
        data.upgrade = locals.upgradeData

        data.squash = 3/(3+dataconfigs.ExtraChoices)
    
        screen.ButtonSpacingY = ScreenData.UpgradeChoice.ButtonSpacingY * (data.squash ^ 1) -- Spacing between buttons automatically to scale - Lower 0.8 for more space
        -- ModUtil.Hades.PrintStack(screen.ButtonSpacingY)

        screen.PurchaseButton.Y = itemLocationY -- dunno if i need this but will keep so location stops crying
        screen.PurchaseButton.Scale = 1.0 * (data.squash ^ 0.8) -- Scaling the buttons, unsure how to get it to scale (specifically the X scaling) nicely like in hades 1 - increase 0.8 for harsher scaling
        screen.Highlight.Scale = screen.PurchaseButton.Scale -- same as purchaseButton scaling
    end

    ModUtil.Path.Wrap("CreateTextBox", function( base, args )
        if args.OffsetY and args.OffsetX then 
            args.OffsetY = args.OffsetY * (data.squash ^ 0.55)
            args.OffsetX = args.OffsetX * (data.squash ^ 0.6)
        end

        if args.FontSize then 
            args.FontSize = args.FontSize * (data.squash ^ 0.5)
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
	for index = 1, ScreenData.UpgradeChoice.MaxChoices + dataconfigs.ExtraChoices do -- indexing to new max limit
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