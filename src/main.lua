---@module 'SGG_Modding-ENVY'
local envy = rom.mods['SGG_Modding-ENVY']

---@module 'SGG_Modding-ENVY-auto'
envy.auto(); _ENV = private

---@module 'SGG_Modding-ReLoad'
local reload = rom.mods['SGG_Modding-ReLoad']
local loader = reload.auto_multiple()

---@module 'SGG_Modding-Chalk'
local chalk = rom.mods["SGG_Modding-Chalk"]

---@module 'SGG_Modding-Hades2GameDef-Globals'
local game = rom.game

---@module 'SGG_Modding-SJSON'
local sjson = rom.mods['SGG_Modding-SJSON']

---@module 'SGG_Modding-ModUtil'
local modutil = rom.mods['SGG_Modding-ModUtil']

---@module 'config'
local config = chalk.auto_lua_toml()
public.config = config

local function on_ready_setup()
	-- what to do when we are ready, but not re-do on reload.
	
	if not config.enabled then return end
	
	local file = rom.path.combine(rom.paths.Content, 'Game/Text/en/ShellText.en.sjson')

	sjson.hook(file, function(...)
		return private.sjson_ShellText(...)
	end)
end

local function on_ready_final()
	-- what to do when we are ready, but not re-do on reload.

	if not config.enabled then return end
	
	modutil.mod.Path.Wrap("SetupMap", function(base, ...)
		return private.wrap_SetupMap(base, ...)
	end)
	
	game.OnControlPressed({'Gift', function(...)
		return private.trigger_Gift(...)
	end})
end

local function on_reload_setup()
	-- what to do when we are ready, but also again on every reload.
	-- only do things that are safe to run over and over.
	
	function private.sjson_ShellText(data)
		for _,v in ipairs(data.Texts) do
			if v.Id == 'MainMenuScreen_PlayGame' then
				v.DisplayName = 'Test ' .. _PLUGIN.guid
				break
			end
		end
	end

	function private.wrap_SetupMap(base)
		print('Map is loading, here we might load some packages.')
		return base()
	end

	function private.trigger_Gift()
		modutil.mod.Hades.PrintOverhead(config.message)
	end
end

loader.load('plugin is ready', on_ready_setup, on_reload_setup)

modutil.on_ready_final(function()
	loader.load('game is ready', on_ready_final)
end)









-- -- =======================================================================
-- -- Yeah I don't even know, but this works perfectly - sorry had to steal
-- -- =======================================================================

-- local baseChoices = GetTotalLootChoices()

-- -- Other mods should override this value
-- zanncModMain.Choices = baseChoices

-- zanncModMain.GetBaseChoices = function( )
-- 	return baseChoices
-- end

-- OnAnyLoad{ function()
-- 	ScreenData.UpgradeChoice.MaxChoices = zanncModMain.Choices + config.ExtraChoices
-- end}

-- modutil.Path.Override("GetTotalLootChoices", function( )
-- 	return ScreenData.UpgradeChoice.MaxChoices or zanncModMain.Choices
-- end, zanncModMain)

-- modutil.Path.Override("CalcNumLootChoices", function( )
-- 	local numChoices = ScreenData.UpgradeChoice.MaxChoices - GetNumMetaUpgrades("ReducedLootChoicesShrineUpgrade")
-- 	if (isGodLoot or treatAsGodLootByShops) and HasHeroTraitValue("RestrictBoonChoices") then
-- 		numChoices = numChoices - 1
-- 	end
-- 	return numChoices
-- end, zanncModMain)


-- --Absolutely unsure how to fix arache etc, they use the same name and group, but their choices dont go up, unless I want to increase their choices too
-- -- No reason to increase their choices at the moment.
-- modutil.Path.Context.Wrap("CreateUpgradeChoiceButton", function ( screen, lootData, itemIndex, itemData )
--     -- local purchaseButton = ShallowCopyTable( screen.PurchaseButton )
-- 	-- local highlight = ShallowCopyTable( screen.Highlight )

--     local data = { }
--     local active = false

--     modutil.Path.Wrap("CreateScreenComponent", function ( base, args )
--         if not active and args.Group == "Combat_Menu" then
--             active = true
--             local local_hades = modutil.Locals.Stacked( )

--             data.upgrade = local_hades.upgradeData
--             data.squash = 3/(3+config.ExtraChoices) -- I cannot do the previous excess method as it crashes when using rarity (I don't want to figure it out anymore)
--             -- I just want to be happy please
--             if args.Name == "BoonSlotBase" then
--                 screen.ButtonSpacingY = 256 * (data.squash ^ 0.9)
--                 local_hades.itemLocationY = local_hades.itemLocationY + 160 * (data.squash - 1)
--                 args.Y = local_hades.itemLocationY
--                 args.Scale = 1.0 * (data.squash ^ 0.7)
--                 screen.Highlight.Scale = args.Scale -- Can't find a good way to do this
--             end
--             -- Icons etc cause I can't find a good way to do this either
--             if data.upgrade.Icon ~= nil then
--                 local icon = screen.Icon
--                 icon.X = (screen.IconOffsetX + local_hades.itemLocationX + screen.ButtonOffsetX) * data.squash -- Doesn't even work lol
--                 icon.Scale = 0.6 * (data.squash ^ 0.7)

--                 screen.Frame.X = icon.X
--                 screen.Frame.Scale = screen.Icon.Scale
--             end
--             -- if args.Name == "BlankObstacle" then
--             --     local_hades.itemLocationY = local_hades.itemLocationY + 100 * (data.squash - 1)
--             --     args.Y = local_hades.itemLocationY
--             --     args.Scale = 1.0 * (data.squash ^ 0.4)
--             -- end
--         end
--         local component = base( args ) 
-- 		return component
--     end)

--     -- if purchaseButton.Group == "Combat_Menu" then -- hopefully to stop breaking the codex/arachne/echo etc
--         -- if purchaseButton.Name == "BoonSlotBase" then
--         --     screen.ButtonSpacingY = ScreenData.UpgradeChoice.ButtonSpacingY * (data.squash ^ (1/3)) -- Spacing between buttons automatically to scale - Lower 0.8 for more space
--         --     -- modutil.Path.Wrap("CreateScreenComponent", function (base, args)
                
--         --     -- end)

--         --     -- screen.PurchaseButton.Y = itemLocationY -- dunno if i need this but will keep so location stops crying
--         --     screen.PurchaseButton.Scale = 1.0 * (data.squash ^ (1/3)) -- Scaling the buttons, unsure how to get it to scale (specifically the X scaling) nicely like in hades 1 - increase 0.8 for harsher scaling
--         --     screen.Highlight.Scale = screen.PurchaseButton.Scale -- same as purchaseButton scaling
--         -- end
--     -- end

--     modutil.Path.Wrap("CreateTextBox", function( base, args )
--         if args.OffsetY then
--             args.OffsetY = args.OffsetY * data.squash
--         end
--         if args.OffsetX then
--             args.OffsetX = args.OffsetX * (data.squash ^ 0.6)
--         end
--         if args.FontSize then args.FontSize = args.FontSize * (data.squash ^ 0.5) end
--         if data.upgrade and args.Text == data.upgrade.CustomRarityName then 
--             modutil.Locals.Stacked( ).lineSpacing = 8*data.squash
--         end
--         return base( args )
--     end)
-- end)

-- modutil.Path.Override("DestroyBoonLootButtons", function( screen, lootData )
-- 	local components = screen.Components
-- 	local toDestroy = {}
-- 	for index = 1, GetTotalLootChoices() do -- indexing to new max limit
-- 		local destroyIndexes = {
-- 		"PurchaseButton"..index,
-- 		"PurchaseButton"..index.. "Lock",
-- 		"PurchaseButton"..index.. "Highlight",
-- 		"PurchaseButton"..index.. "Icon",
-- 		"PurchaseButton"..index.. "ExchangeIcon",
-- 		"PurchaseButton"..index.. "ExchangeIconFrame",
-- 		"PurchaseButton"..index.. "QuestIcon",
-- 		"PurchaseButton"..index.. "ElementIcon",
-- 		"Backing"..index,
-- 		"PurchaseButton"..index.. "Frame",
-- 		"PurchaseButton"..index.. "Patch",
-- 		}
-- 		for i, indexName in pairs( destroyIndexes ) do
-- 			if components[indexName] then
-- 				table.insert(toDestroy, components[indexName].Id)
-- 				components[indexName] = nil
-- 			end
-- 		end
-- 	end
-- 	Destroy({ Ids = toDestroy })
-- end, zanncModMain)  