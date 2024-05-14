if not zanncModMain.Config.Enabled then return end

local dataconfigs = {
    --Max of like 6, before it starts breaking
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

ModUtil.Path.Context.Wrap("CreateUpgradeChoiceButton", function ( screen )
    -- local purchaseButton = ShallowCopyTable( screen.PurchaseButton )
	-- local highlight = ShallowCopyTable( screen.Highlight )

    local data = { }
    local active = false

    ModUtil.Path.Wrap("CreateScreenComponent", function ( base, args )
        if not active and args.Group == "Combat_Menu" then
            active = true
            local local_hades = ModUtil.Locals.Stacked( )

            data.upgrade = local_hades.upgradeData
            data.squash = 3/(3+dataconfigs.ExtraChoices)

            if args.Name == "BoonSlotBase" then
                local_hades.itemLocationY = local_hades.itemLocationY + 100 * (data.squash - 1)
                args.Y = local_hades.itemLocationY
                args.Scale = 1.0 * (data.squash ^ 0.4)
                screen.Highlight.Scale = args.Scale -- Can't find a good way to do this
            end
            -- if args.Name == "BlankObstacle" then
            --     local_hades.itemLocationY = local_hades.itemLocationY + 100 * (data.squash - 1)
            --     args.Y = local_hades.itemLocationY
            --     args.Scale = 1.0 * (data.squash ^ 0.4)
            -- end
        end
        local component = base( args ) 
		return component
    end)
    -- if purchaseButton.Group == "Combat_Menu" then -- hopefully to stop breaking the codex/arachne/echo etc
        -- if purchaseButton.Name == "BoonSlotBase" then
        --     screen.ButtonSpacingY = ScreenData.UpgradeChoice.ButtonSpacingY * (data.squash ^ (1/3)) -- Spacing between buttons automatically to scale - Lower 0.8 for more space
        --     -- ModUtil.Path.Wrap("CreateScreenComponent", function (base, args)
                
        --     -- end)

        --     -- screen.PurchaseButton.Y = itemLocationY -- dunno if i need this but will keep so location stops crying
        --     screen.PurchaseButton.Scale = 1.0 * (data.squash ^ (1/3)) -- Scaling the buttons, unsure how to get it to scale (specifically the X scaling) nicely like in hades 1 - increase 0.8 for harsher scaling
        --     screen.Highlight.Scale = screen.PurchaseButton.Scale -- same as purchaseButton scaling
        -- end
    -- end

    ModUtil.Path.Wrap("CreateTextBox", function( base, args )
        if args.OffsetY then
            args.OffsetY = args.OffsetY * data.squash
        end
        if args.OffsetX then
            args.OffsetX = args.OffsetX * (data.squash ^ (1/3))
        end
        if args.FontSize then args.FontSize = args.FontSize * (data.squash ^ (1/3)) end
        if data.upgrade and args.Text == data.upgrade.CustomRarityName then 
            ModUtil.Locals.Stacked( ).lineSpacing = 8*data.squash
        end
        return base( args )
    end)
end)

ModUtil.Path.Override("DestroyBoonLootButtons", function( screen, lootData )
	local components = screen.Components
	local toDestroy = {}
	for index = 1, GetTotalLootChoices() do -- indexing to new max limit
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