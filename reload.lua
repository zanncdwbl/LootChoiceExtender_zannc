---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

zanncModMain = zanncModMain or {}
zanncModMain.Choices = zanncModMain.Choices or 3

function GetTotalLootChoices_override()
    return game.ScreenData.UpgradeChoice.MaxChoices or zanncModMain.Choices
end

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
    local upgradeOptions = lootData.UpgradeOptions
    local excess = math.max(3, #upgradeOptions) - 3
    local squash = 3 / (3 + excess)

    if not isNPC(game.ActiveScreens.UpgradeChoice.SubjectName) then

        if #upgradeOptions <= 3 then
            game.ActiveScreens.UpgradeChoice.PurchaseButton.Name = "BoonSlotBase"
        else
            game.ActiveScreens.UpgradeChoice.PurchaseButton.Name = "BoonSlotBaseExtraOptions"
        end

        -- Text Scaling
        game.ActiveScreens.UpgradeChoice.TitleText.FontSize = 27 * (squash ^ (1/3))
        game.ActiveScreens.UpgradeChoice.TitleText.OffsetY = -60 * squash

        game.ActiveScreens.UpgradeChoice.RarityText.FontSize = 27 * (squash ^ (1/3))
        game.ActiveScreens.UpgradeChoice.RarityText.OffsetY = -60 * squash

        game.ActiveScreens.UpgradeChoice.DescriptionText.FontSize = 20 * (squash ^ (1/3))
        game.ActiveScreens.UpgradeChoice.DescriptionText.OffsetY = -35 * squash

        game.ActiveScreens.UpgradeChoice.QuestIconOffsetY = 65 * squash

        -- game.ScreenData.UpgradeChoice.IconOffsetY = 20
        -- game.ScreenData.UpgradeChoice.ExchangeIconOffsetX = game.ScreenData.UpgradeChoice.IconOffsetX - 100
        -- game.ScreenData.UpgradeChoice.ExchangeIconOffsetY = game.ScreenData.UpgradeChoice.IconOffsetY

        local component = base( screen, lootData, itemIndex, itemData )
        game.ActiveScreens.UpgradeChoice.ButtonSpacingY = 256 * squash

        -- Setting Scale for buttons
        local components = screen.Components
        local purchaseButtonKey = "PurchaseButton"..itemIndex
        
        SetScaleY({ Id = components[purchaseButtonKey].Id, Fraction = squash, Duration = 0 })

        SetScaleY({ Id = components[purchaseButtonKey.."Highlight"].Id, Fraction = squash, Duration = 0 })
        
        SetScaleX({ Id = components[purchaseButtonKey.."Icon"].Id, Fraction = (squash ^ (2/3)), Duration = 0 })
        SetScaleY({ Id = components[purchaseButtonKey.."Icon"].Id, Fraction = (squash ^ (2/3)), Duration = 0 })
        
        SetScaleX({ Id = components[purchaseButtonKey.."Frame"].Id, Fraction = (squash ^ (2/3)), Duration = 0 })
        SetScaleY({ Id = components[purchaseButtonKey.."Frame"].Id, Fraction = (squash ^ (2/3)), Duration = 0 })
        
        if (components[purchaseButtonKey.."ElementIcon"] ~= nil) then
            SetScaleX({ Id = components[purchaseButtonKey.."ElementIcon"].Id, Fraction = squash, Duration = 0 })
            SetScaleY({ Id = components[purchaseButtonKey.."ElementIcon"].Id, Fraction = squash, Duration = 0 })
        end
        
        if (components[purchaseButtonKey.."ExchangeSymbol"] ~= nil) then
            SetScaleX({ Id = components[purchaseButtonKey.."ExchangeSymbol"].Id, Fraction = squash, Duration = 0 })
            SetScaleY({ Id = components[purchaseButtonKey.."ExchangeSymbol"].Id, Fraction = squash, Duration = 0 })
        end

        if (components[purchaseButtonKey.."ExchangeIcon"] ~= nil) then
            SetScaleX({ Id = components[purchaseButtonKey.."ExchangeIcon"].Id, Fraction = (squash ^ (2/3)), Duration = 0 })
            SetScaleY({ Id = components[purchaseButtonKey.."ExchangeIcon"].Id, Fraction = (squash ^ (2/3)), Duration = 0 })
        end

        if (components[purchaseButtonKey.."ExchangeIconFrame"] ~= nil) then
            SetScaleX({ Id = components[purchaseButtonKey.."ExchangeIconFrame"].Id, Fraction = (squash ^ (2/3)), Duration = 0 })
            SetScaleY({ Id = components[purchaseButtonKey.."ExchangeIconFrame"].Id, Fraction = (squash ^ (2/3)), Duration = 0 })
        end

        if (components[purchaseButtonKey.."QuestIcon"] ~= nil) then
            SetScaleX({ Id = components[purchaseButtonKey.."QuestIcon"].Id, Fraction = (squash ^ (1/3)) , Duration = 0 })
            SetScaleY({ Id = components[purchaseButtonKey.."QuestIcon"].Id, Fraction = (squash ^ (1/3)), Duration = 0 })
            -- If I use ActiveScreens, then the first one doesn't move, others do
            -- components[purchaseButtonKey.."QuestIcon"] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu", X = game.itemLocationX + screen.QuestIconOffsetX * squash, Y = game.itemLocationY + screen.QuestIconOffsetY })
        end

        return component
    else
        -- For NPCs to not cry and crash the game
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