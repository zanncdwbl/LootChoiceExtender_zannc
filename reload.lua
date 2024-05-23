---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

function sjson_ShellText(data)
	for _,v in ipairs(data.Texts) do
		if v.Id == 'MainMenuScreen_PlayGame' then
			v.DisplayName = 'Test ' .. _PLUGIN.guid
			break
		end
	end
end

-- function sjson_GUI(data)
--     for _, v in ipairs(data.Obstacles) do
--         if v.Name == 'BoonSlotBase' then
--             v.Thing.Points = {
--                 { X = -490, Y = 110 },
--                 { X = 600, Y = 110 },
--                 { X = 600, Y = -50 },
--                 { X = -490, Y = -50 }
--             }
--             for _, point in ipairs(v.Thing.Points) do
--                 print(point.X, point.Y)
--             end
--             break
--         end
--     end
--     return data
-- end

function GetTotalLootChoices_override()
    return game.ScreenData.UpgradeChoice.MaxChoices or zanncModMain.Choices
end

-- function GetBaseChoices()
--     local baseChoices = game.GetTotalLootChoices()
--     return baseChoices
-- end

-- NPCs that I won't scale down or change amount of options
local NPCsList = {
    "NPC_Arachne_01",
    "NPC_Narcissus_01",
    "NPC_Echo_01",
    "NPC_LordHades_01",
    "NPC_Medea_01",
    "NPC_Icarus_01",
    "NPC_Circe_01"
}

function isNPC(subjectName)
    for _, name in ipairs(NPCsList) do
        if subjectName == name then
            return true
        end
    end
    return false
end

function CreateUpgradeChoiceButton_wrap( base, screen, lootData, itemIndex, itemData )
    -- local data = { }
    local active = false
    
    local upgradeOptions = lootData.UpgradeOptions
    local excess = math.max(3, #upgradeOptions) - 3
    local squash = 3 / (3 + excess)

    if not isNPC(game.ActiveScreens.UpgradeChoice.SubjectName) then
        -- active = true
        -- game.ScreenData.UpgradeChoice.PurchaseButton.Scale = 1 * squash
        -- game.ScreenData.UpgradeChoice.Highlight.Scale = 1 * squash
        -- game.ScreenData.UpgradeChoice.UpgradeButtons.Scale = 0.2
        -- game.ActiveScreens.UpgradeChoice.QuestIconOffsetX = (-100 * squash) + 160
        -- game.ActiveScreens.UpgradeChoice.QuestIconOffsetY = (65 * squash) - 10

        
        local component = base( screen, lootData, itemIndex, itemData )
        game.ActiveScreens.UpgradeChoice.PurchaseButton.Name = "BoonSlotBaseExtraOptions"
        game.ActiveScreens.UpgradeChoice.ButtonSpacingY = 256 * squash
        
        -- ==================================================================================================================
        -- Doesn't work on either activescreen or screen data - fix later
        -- ==================================================================================================================
        -- Attempt to cap out the yaxis for location
        -- local maxValue = 300  
        -- local computedValue = 190 / (squash ^ (1/3))
        -- local limitedValue = math.min(computedValue, maxValue)

        -- local itemLocationY = (ScreenCenterY - (190 / limitedValue)) + game.ActiveScreens.UpgradeChoice.ButtonSpacingY * ( itemIndex - 1 )
        -- game.ScreenData.UpgradeChoice.itemLocationY = itemLocationY

        -- Setting Scale for buttons
        local components = screen.Components
        local purchaseButtonKey = "PurchaseButton"..itemIndex
        
        SetScaleY({ Id = components[purchaseButtonKey].Id, Fraction = squash, Duration = 0 })
        
        SetScaleY({ Id = components[purchaseButtonKey.."Highlight"].Id, Fraction = squash, Duration = 0 })
        
        SetScaleX({ Id = components[purchaseButtonKey.."Icon"].Id, Fraction = squash, Duration = 0 })
        SetScaleY({ Id = components[purchaseButtonKey.."Icon"].Id, Fraction = squash, Duration = 0 })
        
        SetScaleX({ Id = components[purchaseButtonKey.."Frame"].Id, Fraction = squash, Duration = 0 })
        SetScaleY({ Id = components[purchaseButtonKey.."Frame"].Id, Fraction = squash, Duration = 0 })
        
        if (components[purchaseButtonKey.."ElementIcon"] ~= nil) then
            SetScaleX({ Id = components[purchaseButtonKey.."ElementIcon"].Id, Fraction = squash, Duration = 0 })
            SetScaleY({ Id = components[purchaseButtonKey.."ElementIcon"].Id, Fraction = squash, Duration = 0 })
        end
        
        if (components[purchaseButtonKey.."ExchangeSymbol"] ~= nil) then
            SetScaleX({ Id = components[purchaseButtonKey.."ExchangeSymbol"].Id, Fraction = squash, Duration = 0 })
            SetScaleY({ Id = components[purchaseButtonKey.."ExchangeSymbol"].Id, Fraction = squash, Duration = 0 })
        end
        
        if (components[purchaseButtonKey.."QuestIcon"] ~= nil) then
            SetScaleX({ Id = components[purchaseButtonKey.."QuestIcon"].Id, Fraction = (squash ^ (1/3)) , Duration = 0 })
            SetScaleY({ Id = components[purchaseButtonKey.."QuestIcon"].Id, Fraction = (squash ^ (1/3)), Duration = 0 })
            -- If I use ActiveScreens, then the first one doesn't move, others do
            -- components[purchaseButtonKey.."QuestIcon"] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = game.itemLocationX + screen.QuestIconOffsetX * squash, Y = game.itemLocationY + screen.QuestIconOffsetY })
        end

        
        -- modutil.mod.Path.Wrap("CreateTextBox", function( base, args )
        --     if args.OffsetY then
        --         args.OffsetY = args.OffsetY * squash
        --     end
        --     if args.OffsetX then
        --         args.OffsetX = args.OffsetX * (squash ^ 0.6)
        --     end
        --     if args.FontSize then args.FontSize = args.FontSize * (squash ^ 0.5) end
        --     -- if upgrade and args.Text == upgrade.CustomRarityName then 
        --     --     modutil.Locals.Stacked( ).lineSpacing = 8*squash
        --     -- end
        --     return base( args )
        -- end)

        return component
    else
        -- active = false
        game.ActiveScreens.UpgradeChoice.PurchaseButton.Name = "BoonSlotBase"
        local component = base( screen, lootData, itemIndex, itemData )
        return component
    end
end

function DestroyBoonLootButtons_override( screen, lootData )
	local components = screen.Components
	local toDestroy = {}
	for index = 1, GetTotalLootChoices_override() do
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
end

--Absolutely unsure how to fix arache etc, they use the same name and group, but their choices dont go up, unless I want to increase their choices too
    -- No reason to increase their choices at the moment.
    -- modutil.mod.Path.Wrap("CreateUpgradeChoiceButton", function ( screen, lootData, itemIndex, itemData )
        -- local purchaseButton = ShallowCopyTable( screen.PurchaseButton )
        -- local highlight = ShallowCopyTable( screen.Highlight )

        -- local data = { }
        -- local active = false

        -- -- modutil.mod.Path.Wrap("CreateScreenComponent", function ( base, args )
        --     if not active and args.Group == "Combat_Menu" then
        --         active = true
        --         local local_hades = modutil.Locals.Stacked( )

        --         data.upgrade = local_hades.upgradeData
        --         data.squash = 3/(3+config.ExtraChoices) -- I cannot do the previous excess method as it crashes when using rarity (I don't want to figure it out anymore)
        --         -- I just want to be happy please
        --         if args.Name == "BoonSlotBase" then
        --             screen.ButtonSpacingY = 256 * (data.squash ^ 0.9)
        --             local_hades.itemLocationY = local_hades.itemLocationY + 160 * (data.squash - 1)
        --             args.Y = local_hades.itemLocationY
        --             args.Scale = 1.0 * (data.squash ^ 0.7)
        --             screen.Highlight.Scale = args.Scale -- Can't find a good way to do this
        --         end
        --         -- Icons etc cause I can't find a good way to do this either
        --         if data.upgrade.Icon ~= nil then
        --             local icon = screen.Icon
        --             icon.X = (screen.IconOffsetX + local_hades.itemLocationX + screen.ButtonOffsetX) * data.squash -- Doesn't even work lol
        --             icon.Scale = 0.6 * (data.squash ^ 0.7)

        --             screen.Frame.X = icon.X
        --             screen.Frame.Scale = screen.Icon.Scale
        --         end
        --         -- if args.Name == "BlankObstacle" then
        --         --     local_hades.itemLocationY = local_hades.itemLocationY + 100 * (data.squash - 1)
        --         --     args.Y = local_hades.itemLocationY
        --         --     args.Scale = 1.0 * (data.squash ^ 0.4)
        --         -- end
        --     end
        --     local component = base( args ) 
        --     return component
        -- end)

        -- if purchaseButton.Group == "Combat_Menu" then -- hopefully to stop breaking the codex/arachne/echo etc
            -- if purchaseButton.Name == "BoonSlotBase" then
            --     screen.ButtonSpacingY = ScreenData.UpgradeChoice.ButtonSpacingY * (data.squash ^ (1/3)) -- Spacing between buttons automatically to scale - Lower 0.8 for more space
            --     -- modutil.mod.Path.Wrap("CreateScreenComponent", function (base, args)
                    
            --     -- end)

            --     -- screen.PurchaseButton.Y = itemLocationY -- dunno if i need this but will keep so location stops crying
            --     screen.PurchaseButton.Scale = 1.0 * (data.squash ^ (1/3)) -- Scaling the buttons, unsure how to get it to scale (specifically the X scaling) nicely like in hades 1 - increase 0.8 for harsher scaling
            --     screen.Highlight.Scale = screen.PurchaseButton.Scale -- same as purchaseButton scaling
            -- end
        -- end

        -- modutil.mod.Path.Wrap("CreateTextBox", function( base, args )
        --     if args.OffsetY then
        --         args.OffsetY = args.OffsetY * data.squash
        --     end
        --     if args.OffsetX then
        --         args.OffsetX = args.OffsetX * (data.squash ^ 0.6)
        --     end
        --     if args.FontSize then args.FontSize = args.FontSize * (data.squash ^ 0.5) end
        --     if data.upgrade and args.Text == data.upgrade.CustomRarityName then 
        --         modutil.Locals.Stacked( ).lineSpacing = 8*data.squash
        --     end
        --     return base( args )
        -- end)
    -- end)