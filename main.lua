if not zanncModMain.Config.Enabled then return end

local dataconfigs = {
    MaxChoices = 2,
    ButtonSpacingY = 160,

    RarityText =
	{
		FontSize = 27,
		OffsetX = 340, OffsetY = -60,
		Width = 720,
		Color = color,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
		Justification = "Right",
		DataProperties =
		{
			OpacityWithOwner = true,
		},
	},

	TitleText =
	{
		FontSize = 27,
		OffsetX = -320, OffsetY = -60,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
		Justification = "Left",
		LuaKey = "TooltipData",
		LuaValue = {},
		DataProperties =
		{
			OpacityWithOwner = true,
		},
	},

    DescriptionText =
    {
		OffsetX = -320,
		OffsetY = -35,
		Width = 710,
		Justification = "Left",
		VerticalJustification = "Top",
		LineSpacingBottom = 5,
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
		OffsetX = -320,
		Width = 420,
		Justification = "Left",
		VerticalJustification = "Top",
		LineSpacingBottom = 5,
		LuaKey = "TooltipData",
		LuaValue = {},
		Format = "BaseFormat",
		VariableAutoFormat = "BoldFormatGraft",
		TextSymbolScale = 0.8,
	},

	StatLineRight =
	{
		OffsetX = 30,
		Width = 485,
		Justification = "Left",
		VerticalJustification = "Top",
		LineSpacingBottom = 5,
		UseDescription = true,
		LuaKey = "TooltipData",
		LuaValue = {},
		Format = "BaseFormat",
		VariableAutoFormat = "BoldFormatGraft",
		TextSymbolScale = 0.8,
	},

	FlavorText = 
	{	
		OffsetX = -320,
		OffsetY = 80,
		Width = 700,
		Color = Color.FlavorTextPurple,
		Font = "LatoItalic",
		FontSize = 18,
		ShadowBlur = 0, ShadowColor = {0, 0, 0, 1}, ShadowOffset = {0, 2},
		Justification = "Left",
	},
}

OnAnyLoad{ function()
	ScreenData.UpgradeChoice.MaxChoices = ScreenData.UpgradeChoice.MaxChoices + dataconfigs.MaxChoices
end}

ModUtil.Path.Override("GetTotalLootChoices", function( )
	return ScreenData.UpgradeChoice.MaxChoices
end, zanncModMain)

ModUtil.Path.Wrap("CreateUpgradeChoiceButton", function ( screen, lootData, itemIndex, itemData )
    
end)

-- ModUtil.Path.Wrap("CreateUpgradeChoiceButton", function()
--     return function(screen, lootData, itemIndex, itemData, argumentName)
--         local active = false
--         ModUtil.Path.Wrap("CreateScreenComponent", function(baseComponentFunc)
--             return function(args)
--                 if not active and args.Name == "BoonSlotBase" then
--                     active = true
--                     screen.MaxChoices = dataconfigs.MaxChoices
--                     screen.ButtonSpacingY = dataconfigs.ButtonSpacingY
--                     screen.RarityText = dataconfigs.RarityText
--                     screen.TitleText = dataconfigs.TitleText
--                     screen.DescriptionText = dataconfigs.DescriptionText
--                     screen.StatLineLeft = dataconfigs.StatLineLeft
--                     screen.StatLineRight = dataconfigs.StatLineRight
--                     screen.FlavorText = dataconfigs.FlavorText
--                 end
--                 local component = baseComponentFunc(args)
--                 return component
--             end
--         end)
--         return baseFunc(screen, lootData, itemIndex, itemData, argumentName)
--     end
-- end)

-- ModUtil.Path.Override("CreateUpgradeChoiceButton", function( screen, lootData, itemIndex, itemData  )
-- 	local components = screen.Components
-- 	local upgradeName = lootData.Name
-- 	local upgradeChoiceData = lootData
-- 	local itemLocationY = (ScreenCenterY - 240) + screen.ButtonSpacingY * ( itemIndex - 1 )
-- 	local itemLocationX = ScreenCenterX - 355
-- 	local blockedIndexes = screen.BlockedIndexes
-- 	local upgradeData = nil
-- 	local upgradeTitle = nil
-- 	local upgradeDescription = nil
-- 	local upgradeDescription2 = nil
-- 	local tooltipData = nil
-- 	upgradeData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = itemData.ItemName, Rarity = itemData.Rarity })
-- 	local traitNum = GetTraitCount(CurrentRun.Hero, { TraitData = upgradeData })
-- 	if HeroHasTrait(itemData.ItemName) and not TraitData[itemData.ItemName].Hidden then
-- 		upgradeTitle = "TraitLevel_Upgrade"
-- 		upgradeData.Title = upgradeData.Name
-- 	else
-- 		upgradeTitle = GetTraitTooltipTitle( TraitData[itemData.ItemName] )
-- 		upgradeData.Title = GetTraitTooltipTitle( TraitData[itemData.ItemName] )
-- 	end

-- 	if itemData.TraitToReplace ~= nil then
-- 		upgradeData.TraitToReplace = itemData.TraitToReplace
-- 		upgradeData.OldRarity = itemData.OldRarity
-- 		local existingNum = GetTraitCount( CurrentRun.Hero, { Name = upgradeData.TraitToReplace } )
-- 		local newNum = existingNum + GetTotalHeroTraitValue("ExchangeLevelBonus") 
-- 		tooltipData =  GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = itemData.ItemName, StackNum = newNum, RarityMultiplier = upgradeData.RarityMultiplier})
-- 		if newNum > 1 then
-- 			upgradeTitle = "TraitLevel_Exchange"
-- 			tooltipData.Title = GetTraitTooltipTitle( TraitData[upgradeData.Name])
-- 			tooltipData.Level = newNum
-- 		end
-- 		SetTraitTextData( tooltipData )
-- 	elseif lootData.StackOnly and upgradeData.Name ~= "FallbackGold" then
-- 		tooltipData = GetHeroTrait( upgradeData.Name )
-- 		local startingStackNum = tooltipData.StackNum or 1
-- 		tooltipData.OldLevel = startingStackNum
-- 		tooltipData.NewLevel = startingStackNum + lootData.StackNum
-- 		local stackTooltipData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = itemData.ItemName, StackNum = startingStackNum + lootData.StackNum, RarityMultiplier = tooltipData.RarityMultiplier})
-- 		SetTraitTextData( tooltipData, { ReplacementTraitData = stackTooltipData })
-- 		itemData.Rarity = tooltipData.Rarity
-- 	elseif itemData.Type == "TransformingTrait" then
-- 		local blessingData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = itemData.ItemName, Rarity = itemData.Rarity })
-- 		local curseData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = itemData.SecondaryItemName, Rarity = itemData.Rarity })
-- 		curseData.OnExpire = curseData.OnExpire or {}
-- 		curseData.OnExpire.TraitData = blessingData
		
-- 		curseData.TraitTitle = "ChaosCombo_"..curseData.Name.."_"..blessingData.Name
-- 		--blessingData.Title = "ChaosBlessingFormat"

-- 		SetTraitTextData( blessingData )
-- 		SetTraitTextData( curseData )

-- 		tooltipData = MergeTables( tooltipData, blessingData )
-- 		tooltipData = MergeTables( tooltipData, curseData )
-- 		tooltipData.Blessing = itemData.ItemName
-- 		tooltipData.Curse = itemData.SecondaryItemName

-- 		upgradeTitle = curseData.TraitTitle
-- 		upgradeDescription = curseData.Name
-- 		upgradeDescription2 = blessingData.Name
-- 		upgradeData = DeepCopyTable( curseData )
-- 		upgradeData.Icon = blessingData.Icon
-- 		upgradeData.ExtractData = upgradeData.ExtractData or {}
-- 		local extractedData = GetExtractData( blessingData )
-- 		for i, value in pairs(extractedData) do
-- 			local key = value.ExtractAs
-- 			if key then
-- 				upgradeData.ExtractData[key] = blessingData[key]
-- 			end
-- 		end
-- 	else
-- 		if upgradeData.PrePickSacrificeBoon then
-- 			upgradeData.SacrificedTraitName = GetRandomSacrificeTraitData().Name
-- 		end
-- 		tooltipData = upgradeData
-- 		SetTraitTextData( tooltipData )
-- 	end
-- 	if not upgradeDescription2 then
-- 		upgradeDescription = GetTraitTooltip( tooltipData , { Default = upgradeData.Title })
-- 	end

-- 	-- Setting button graphic based on boon type
-- 	local purchaseButtonKey = "PurchaseButton"..itemIndex

-- 	local overlayLayer = "Combat_Menu_Overlay_Backing"

-- 	local purchaseButton = ShallowCopyTable( screen.PurchaseButton )
-- 	purchaseButton.X = itemLocationX + screen.ButtonOffsetX
-- 	purchaseButton.Y = itemLocationY
--     purchaseButton.Scale = 0.7
-- 	--DebugPrint({ Text = "upgradeData.Rarity = "..upgradeData.Rarity })
-- 	local backingAnim = upgradeData.UpgradeChoiceBackingAnimation or screen.RarityBackingAnimations[upgradeData.Rarity]
-- 	if backingAnim ~= nil then
-- 		--DebugPrint({ Text = "backingAnim = "..backingAnim })
-- 		purchaseButton.Animation = backingAnim
-- 	end
-- 	components[purchaseButtonKey] = CreateScreenComponent( purchaseButton )
-- 	components[purchaseButtonKey].BackingAnim = backingAnim
	
-- 	if itemData.SlotEntranceAnimation ~= nil then
-- 		CreateAnimation({ Name = itemData.SlotEntranceAnimation, DestinationId = components[purchaseButtonKey].Id })
-- 	elseif upgradeData.Rarity == "Legendary" or upgradeData.Rarity == "Duo" then
-- 		if TraitData[upgradeData.Name].IsDuoBoon then
-- 			CreateAnimation({ Name = "BoonEntranceDuo", DestinationId = components[purchaseButtonKey].Id })
-- 		else
-- 			CreateAnimation({ Name = "BoonEntranceLegendary", DestinationId = components[purchaseButtonKey].Id }) 
-- 		end
-- 	end
-- 	if Contains( blockedIndexes, itemIndex ) then
-- 		itemData.Blocked = true
-- 		overlayLayer = "Combat_Menu"
-- 		AddInteractBlock( components[purchaseButtonKey], "TraitLocked" )
-- 		ModifyTextBox({ Id = components[purchaseButtonKey].Id, BlockTooltip = true })
-- 		thread( TraitLockedPresentation, { Screen = screen, Components = components, HighlightKey = purchaseButtonKey.."Highlight", Id = purchaseButtonKey, OffsetX = itemLocationX + screen.ButtonOffsetX + 15, OffsetY = screen.IconOffsetY + itemLocationY + 55, TooltipOffsetX = screen.TooltipOffsetX } )
-- 	end

-- 	local highlight = ShallowCopyTable( screen.Highlight )
-- 	highlight.X = purchaseButton.X
-- 	highlight.Y = purchaseButton.Y
--     highlight.Scale = purchaseButton.Scale
-- 	components[purchaseButtonKey.."Highlight"] = CreateScreenComponent( highlight )

-- 	if upgradeData.Icon ~= nil then
-- 		local icon = screen.Icon
-- 		icon.X = screen.IconOffsetX + itemLocationX + screen.ButtonOffsetX
-- 		icon.Y = screen.IconOffsetY + itemLocationY
-- 		icon.Animation = upgradeData.Icon
-- 		components[purchaseButtonKey.."Icon"] = CreateScreenComponent( icon )
-- 	end

-- 	if upgradeData.TraitToReplace ~= nil then

-- 		screen.TraitToReplaceName = upgradeData.TraitToReplace

-- 		local exchangeSymbol = screen.ExchangeSymbol
-- 		components[purchaseButtonKey.."ExchangeSymbol"] = CreateScreenComponent( exchangeSymbol )
-- 		Attach({ Id = components[purchaseButtonKey.."ExchangeSymbol"].Id, DestinationId = components[purchaseButtonKey].Id, OffsetX = exchangeSymbol.OffsetX, OffsetY = exchangeSymbol.OffsetY })
		
-- 		components[purchaseButtonKey.."ExchangeIcon"] = CreateScreenComponent({ Name = "BlankObstacle", Group = overlayLayer, Scale = screen.Icon.Scale * screen.ExchangeIconScale })
-- 		Attach({ Id = components[purchaseButtonKey.."ExchangeIcon"].Id, DestinationId = components[purchaseButtonKey].Id, OffsetX = screen.ExchangeIconOffsetX, OffsetY = screen.ExchangeIconOffsetY })
-- 		SetAnimation({ DestinationId = components[purchaseButtonKey.."ExchangeIcon"].Id, Name = TraitData[upgradeData.TraitToReplace].Icon })

-- 		components[purchaseButtonKey.."ExchangeIconFrame"] = CreateScreenComponent({ Name = "BlankObstacle", Group = overlayLayer, Scale = screen.Icon.Scale * screen.ExchangeIconScale })		
-- 		Attach({ Id = components[purchaseButtonKey.."ExchangeIconFrame"].Id, DestinationId = components[purchaseButtonKey].Id, OffsetX = screen.ExchangeIconOffsetX, OffsetY = screen.ExchangeIconOffsetY })
-- 		SetAnimation({ DestinationId = components[purchaseButtonKey.."ExchangeIconFrame"].Id, Name = "BoonIcon_Frame_".. itemData.OldRarity })

-- 		Flash({ Id = components[purchaseButtonKey.."ExchangeIcon"].Id, Speed = screen.ExchangeFlashSpeed, MinFraction = screen.ExchangeFlashMinFraction, MaxFraction = screen.ExchangeFlashMaxFraction, Color = screen.ExchangeFlashColor })
-- 		Flash({ Id = components[purchaseButtonKey.."ExchangeIconFrame"].Id, Speed = screen.ExchangeFlashSpeed, MinFraction = screen.ExchangeFlashMinFraction, MaxFraction = screen.ExchangeFlashMaxFraction, Color = screen.ExchangeFlashColor })
-- 		-- Flash({ Id = components[purchaseButtonKey.."ExchangeSymbol"].Id, Speed = screen.ExchangeFlashSpeed, MinFraction = screen.ExchangeFlashMinFraction, MaxFraction = screen.ExchangeFlashMaxFraction, Color = screen.ExchangeFlashColor })

-- 		-- Hidden description for tooltip
-- 		CreateTextBox({ Id = components[purchaseButtonKey].Id,
-- 			Text = "WillReplace",
-- 			Color = Color.Transparent,
-- 			LuaKey = "PurchaseTraitData",
-- 			LuaValue = upgradeData,
-- 		})

-- 	end

-- 	local frame = screen.Frame
-- 	frame.X = screen.IconOffsetX + itemLocationX + screen.ButtonOffsetX
-- 	frame.Y = screen.IconOffsetY + itemLocationY
--     -- frame.scale = purchaseButton.Scale
-- 	frame.Animation = GetTraitFrame( upgradeData )
-- 	components[purchaseButtonKey.."Frame"] = CreateScreenComponent( frame )

-- 	-- Button data setup
-- 	local button = components[purchaseButtonKey]
-- 	button.OnPressedFunctionName = "HandleUpgradeChoiceSelection"
-- 	button.OnMouseOverFunctionName = "MouseOverBoonButton"
-- 	button.OnMouseOffFunctionName = "MouseOffBoonButton"
-- 	button.Data = upgradeData
-- 	button.Screen = screen
-- 	button.UpgradeName = upgradeName
-- 	button.Type = itemData.Type
-- 	button.LootData = lootData
-- 	button.LootColor = upgradeChoiceData.LootColor
-- 	button.BoonGetColor = upgradeChoiceData.BoonGetColor
-- 	button.Highlight = components[purchaseButtonKey.."Highlight"]
	
-- 	AttachLua({ Id = components[purchaseButtonKey].Id, Table = components[purchaseButtonKey] })
-- 	components[components[purchaseButtonKey].Id] = purchaseButtonKey
-- 	-- Creates upgrade slot text
-- 	SetInteractProperty({ DestinationId = components[purchaseButtonKey].Id, Property = "TooltipOffsetX", Value = screen.TooltipOffsetX })
-- 	local selectionString = "UpgradeChoiceMenu_PermanentItem"
-- 	local selectionStringColor = Color.Black

-- 		local traitData = TraitData[itemData.ItemName]
-- 		if traitData.Slot ~= nil then
-- 			selectionString = "UpgradeChoiceMenu_"..traitData.Slot
-- 		end

-- 	local textOffset = -70 - screen.ButtonOffsetX
-- 	local exchangeIconOffset = 0
-- 	local lineSpacing = 8
-- 	local rarity = itemData.Rarity
-- 	if not rarity then
-- 		rarity = "Common"
-- 	end
-- 	local text = "Boon_"..rarity
-- 	local overlayLayer = ""
-- 	if upgradeData.CustomRarityName then
-- 		text = upgradeData.CustomRarityName
-- 	end
-- 	local color = Color["BoonPatch" .. rarity]
-- 	if upgradeData.CustomRarityColor then
-- 		color = upgradeData.CustomRarityColor
-- 	end

-- 	local rarityText = ShallowCopyTable( screen.RarityText )
--     rarityText.Scale = 0.8
-- 	rarityText.Id = button.Id
-- 	rarityText.Text = text
-- 	rarityText.Color = color
-- 	CreateTextBox( rarityText )

-- 	local titleText = ShallowCopyTable( screen.TitleText )
--     titleText.Scale = rarityText.Scale
-- 	titleText.Id = button.Id
-- 	titleText.Text = upgradeTitle
-- 	titleText.Color = color
-- 	titleText.LuaValue = tooltipData
-- 	CreateTextBox( titleText )

-- 	local descriptionText = ShallowCopyTable( screen.DescriptionText )
--     descriptionText.Scale = rarityText.Scale
-- 	descriptionText.Id = button.Id
-- 	descriptionText.Text = upgradeDescription
-- 	descriptionText.LuaValue = tooltipData
-- 	CreateTextBoxWithFormat( descriptionText )

-- 	if upgradeDescription2 then
-- 		local descriptionText2 = ShallowCopyTable( screen.DescriptionText )
--         descriptionText2.Scale = rarityText.Scale
-- 		descriptionText2.Id = button.Id
-- 		descriptionText2.Text = upgradeDescription2
-- 		descriptionText2.LuaValue = tooltipData
-- 		descriptionText2.OffsetY = offsetY
-- 		descriptionText2.AppendToId = descriptionText.Id
-- 		CreateTextBoxWithFormat( descriptionText2 )
-- 	end

-- 	if traitData.StatLines ~= nil then
-- 		local appendToId = nil
-- 		if #traitData.StatLines <= 1 then
-- 			appendToId = descriptionText.Id
-- 		end
-- 		for lineNum, statLine in ipairs( traitData.StatLines ) do
-- 			if statLine ~= "" then

-- 				local offsetY = (lineNum - 1) * screen.LineHeight
-- 				if upgradeData.ExtraDescriptionLine then
-- 					offsetY = offsetY + screen.LineHeight
-- 				end

-- 				local statLineLeft = ShallowCopyTable( screen.StatLineLeft )
--                 statLineLeft.Scale = rarityText.Scale
-- 				statLineLeft.Id = button.Id
-- 				statLineLeft.Text = statLine
-- 				statLineLeft.OffsetY = offsetY
-- 				statLineLeft.AppendToId = appendToId
-- 				statLineLeft.LuaValue = tooltipData
-- 				CreateTextBoxWithFormat( statLineLeft )

-- 				local statLineRight = ShallowCopyTable( screen.StatLineRight )
--                 statLineRight.Scale = rarityText.Scale
-- 				statLineRight.Id = button.Id
-- 				statLineRight.Text = statLine
-- 				statLineRight.OffsetY = offsetY
-- 				statLineRight.AppendToId = appendToId
-- 				statLineRight.LuaValue = tooltipData
-- 				CreateTextBoxWithFormat( statLineRight )

-- 			end
-- 		end
-- 	end

-- 	if traitData.FlavorText ~= nil then
-- 		local flavorText = ShallowCopyTable( screen.FlavorText )
--         flavorText.Scale = rarityText.Scale
-- 		flavorText.Id = button.Id
-- 		flavorText.Text = traitData.FlavorText
-- 		CreateTextBox( flavorText )
-- 	end

-- 	local needsQuestIcon = false
-- 	if not GameState.TraitsTaken[upgradeData.Name] and HasActiveQuestForName( upgradeData.Name ) then
-- 		needsQuestIcon = true
-- 	elseif itemData.ItemName ~= nil and not GameState.TraitsTaken[itemData.ItemName] and HasActiveQuestForName( itemData.ItemName ) then
-- 		needsQuestIcon = true
-- 	end

-- 	if needsQuestIcon then
-- 		components[purchaseButtonKey.."QuestIcon"] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = itemLocationX + screen.QuestIconOffsetX, Y = itemLocationY + screen.QuestIconOffsetY })
-- 		SetAnimation({ DestinationId = components[purchaseButtonKey.."QuestIcon"].Id, Name = "QuestItemFound" })
-- 		-- Silent toolip
-- 		CreateTextBox({ Id = components[purchaseButtonKey].Id, TextSymbolScale = 0, Text = "TraitQuestItem", Color = Color.Transparent, LuaKey = "TooltipData", LuaValue = tooltipData, })
-- 	end

-- 	if not IsEmpty( upgradeData.Elements ) then
-- 		local elementName = GetFirstValue( upgradeData.Elements )
-- 		local elementIcon = screen.ElementIcon
-- 		elementIcon.Name = TraitElementData[elementName].Icon
-- 		elementIcon.X = itemLocationX + elementIcon.XShift
-- 		elementIcon.Y = itemLocationY + elementIcon.YShift
-- 		components[purchaseButtonKey.."ElementIcon"] = CreateScreenComponent( elementIcon )
-- 		if not GameState.Flags.SeenElementalIcons then
-- 			SetAlpha({ Id = components[purchaseButtonKey.."ElementIcon"].Id, Fraction = 0, Duration = 0 })
-- 		end
-- 	end
-- 	return components[purchaseButtonKey]
-- end, zanncModMain)

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