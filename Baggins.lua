local _G = _G

_G.Baggins = LibStub("AceAddon-3.0"):NewAddon("Baggins", "AceEvent-3.0", "AceHook-3.0", "AceBucket-3.0", "AceTimer-3.0", "AceConsole-3.0")

local Baggins = _G.Baggins
local pt = LibStub("LibPeriodicTable-3.1", true)
local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")
local LBU = LibStub("LibBagUtils-1.0")
local qt = LibStub('LibQTip-1.0')
local dbIcon = LibStub("LibDBIcon-1.0")
local console = LibStub("AceConsole-3.0")
local gratuity = LibStub("LibGratuity-3.0")
local iui = LibStub("LibItemUpgradeInfo-1.0")

local next, unpack, pairs, ipairs, tonumber, select, strmatch, wipe, type, time, print =
      _G.next, _G.unpack, _G.pairs, _G.ipairs, _G.tonumber, _G.select, _G.strmatch, _G.wipe, _G.type, _G.time, _G.print
local min, max, ceil, floor, mod  =
      _G.min, _G.max, _G.ceil, _G.floor, _G.mod
local tinsert, tremove, tsort, tconcat =
      _G.tinsert, _G.tremove, _G.table.sort, _G.table.concat
local format =
      _G.string.format
local band =
      _G.bit.band

local GetItemCount, GetItemInfo, GetInventoryItemLink, GetItemQualityColor, GetItemFamily, BankButtonIDToInvSlotID, GetNumBankSlots =
      _G.GetItemCount, _G.GetItemInfo, _G.GetInventoryItemLink, _G.GetItemQualityColor, _G.GetItemFamily, _G.BankButtonIDToInvSlotID, _G.GetNumBankSlots
local GetContainerItemInfo, GetContainerItemLink, GetContainerNumFreeSlots, GetContainerItemCooldown =
      _G.GetContainerItemInfo, _G.GetContainerItemLink, _G.GetContainerNumFreeSlots, _G.GetContainerItemCooldown
local C_Item, ItemLocation, InCombatLockdown, IsModifiedClick, GetDetailedItemLevelInfo, GetContainerItemID, InRepairMode, KeyRingButtonIDToInvSlotID, C_PetJournal, C_NewItems, PlaySound =
      _G.C_Item, _G.ItemLocation, _G.InCombatLockdown, _G.IsModifiedClick, _G.GetDetailedItemLevelInfo, _G.GetContainerItemID, _G.InRepairMode, _G.KeyRingButtonIDToInvSlotID, _G.C_PetJournal, _G.C_NewItems, _G.PlaySound

-- GLOBALS: UIParent, GameTooltip, BankFrame, CloseBankFrame, TEXTURE_ITEM_QUEST_BANG, TEXTURE_ITEM_QUEST_BORDER, REAGENTBANK_CONTAINER, REPAIR_COST, SOUNDKIT
-- GLOBALS: CoinPickupFrame, ShowInspectCursor, this, CooldownFrame_Set, MerchantFrame, SetTooltipMoney, BagginsCategoryAddDropdown, error, CooldownFrame_SetTimer, StaticPopup_Show
-- GLOBALS: BagginsCopperIcon, BagginsCopperText, BagginsSilverIcon, BagginsSilverText, BagginsGoldIcon, BagginsGoldText, BagginsMoneyFrame, GetMoney, IsEquippedItem
-- GLOBALS: GetAddOnInfo, GetAddOnMetadata, GetNumAddOns, LoadAddOn, CursorUpdate, ResetCursor, ShowContainerSellCursor, UseContainerItem, SetItemButtonDesaturated, SetItemButtonTexture, SetItemButtonTextureVertexColor
-- GLOBALS: GetCursorInfo, CreateFrame, GetCursorPosition, ClearCursor, GetScreenWidth, GetScreenHeight, GetMouseButtonClicked, IsControlKeyDown, IsAltKeyDown, IsShiftKeyDown
-- GLOBALS: GameFontNormalLarge, GameFontNormal, Baggins_ItemMenuFrame, BagginsBankControlFrame, makeMenu, BagginsBagPlacement, CloseDropDownMenus, ToggleDropDownMenu
-- GLOBALS: EasyMenu, MainMenuBarBackpackButton, BackpackButton_OnClick, UIDropDownMenu_AddButton, OpenCoinPickupFrame, UIDropDownMenu_Refresh, BattlePetToolTip_Show, DropDownList1, DropDownList2

-- Bank tab locals, for auto reagent deposit
local BankFrame_ShowPanel = BankFrame_ShowPanel
local BANK_TAB = BANK_PANELS[1].name

Baggins.hasIcon = "Interface\\Icons\\INV_Jewelry_Ring_03"
Baggins.cannotDetachTooltip = true
Baggins.clickableTooltip = true
Baggins.independentProfile = true
Baggins.hideWithoutStandby = true

-- number of item buttons that should be kept in the pool, so that none need to be created in combat
Baggins.minSpareItemButtons = 10

_G.BINDING_HEADER_BAGGINS = L["Baggins"]
_G.BINDING_NAME_BAGGINS_TOGGLEALL = L["Toggle All Bags"]

local equiplocs = {
	INVTYPE_AMMO = 0,
	INVTYPE_HEAD = 1,
	INVTYPE_NECK = 2,
	INVTYPE_SHOULDER = 3,
	INVTYPE_BODY = 4,
	INVTYPE_CHEST = 5,
	INVTYPE_ROBE = 5,
	INVTYPE_WAIST = 6,
	INVTYPE_LEGS = 7,
	INVTYPE_FEET = 8,
	INVTYPE_WRIST = 9,
	INVTYPE_HAND = 10,
	INVTYPE_FINGER = 11,
	INVTYPE_TRINKET = 13,
	INVTYPE_CLOAK = 15,
	INVTYPE_WEAPON = 16,
	INVTYPE_SHIELD = 17,
	INVTYPE_2HWEAPON = 16,
	INVTYPE_WEAPONMAINHAND = 16,
	INVTYPE_WEAPONOFFHAND = 17,
	INVTYPE_HOLDABLE = 17,
	INVTYPE_RANGED = 18,
	INVTYPE_THROWN = 18,
	INVTYPE_RANGEDRIGHT = 18,
	INVTYPE_RELIC = 18,
	INVTYPE_TABARD = 19,
	INVTYPE_BAG = 20,
}
local currentbag
local currentsection
local currentcategory

Baggins.itemcounts = {}

local timers = {}
function Baggins:ScheduleNamedTimer(name, callback, delay, arg)
	local alreadyScheduled = timers[name]
	if alreadyScheduled and self:TimeLeft(alreadyScheduled) then
		self:CancelTimer(alreadyScheduled, true)
	end

	timers[name] = self:ScheduleTimer(callback, delay, arg)
end
function Baggins:CancelNamedTimer(name)
	local timer = timers[name]
	if timer then
		timers[name] = nil
		self:CancelTimer(timer, true)
	end
end
local nextFrameTimers = {}
local timerFrame = CreateFrame('Frame')
timerFrame:SetScript("OnUpdate", function(self)
	while next(nextFrameTimers) do
		local func = next(nextFrameTimers)
		local args = nextFrameTimers[func]
		if type(args) == 'table' then
			Baggins[func](Baggins, unpack(args))
			wipe(args)
		else
			Baggins[func](Baggins)
		end
		nextFrameTimers[func] = nil
	end
	self:Hide()
end)
function Baggins:ScheduleForNextFrame(callback, arg, ...)
	nextFrameTimers[callback] = arg and { arg, ... } or true
	timerFrame:Show()
end

-- internal signalling minilibrary

local signals = {}

function Baggins:RegisterSignal(name, handler, arg1)		-- Example: RegisterSignal("MySignal", self.SomeHandler, self)
	if not arg1 then error("want arg1 noob!") end
	if not signals[name] then
		signals[name] = {}
	end
	signals[name][handler]=arg1;
end

function Baggins:FireSignal(name, ...)		-- Example: FireSignal("MySignal", 1, 2, 3);
	if signals[name] then
		for handler,arg1 in pairs(signals[name]) do
			handler(arg1, ...);
		end
	end
end

local function PT3ModuleSet(info, value)
	local name = info[#info]
	Baggins.db.global.pt3mods[name] = value
	if value then
		LoadAddOn(name)
	end
end

local function PT3ModuleGet(info)
	local name = info[#info]
	return Baggins.db.global.pt3mods[name]
end

local tooltip

local ldbDropDownFrame = CreateFrame("Frame", "Baggins_DropDownFrame", UIParent, "UIDropDownMenuTemplate")

local ldbDropDownMenu
local spacer = { text = "", disabled = true, notCheckable = true, notClickable = true}
local function initDropdownMenu()
	ldbDropDownMenu = {
		{
			text = L["Force Full Refresh"],
			tooltipText = L["Forces a Full Refresh of item sorting"],
			func = function()
					Baggins:ForceFullRefresh()
					Baggins:UpdateBags()
				end,
			notCheckable = true,
		},
		spacer,
		{
			text = L["Hide Default Bank"],
			tooltipText = L["Hide the default bank window."],
			checked = Baggins.db.profile.hidedefaultbank,
			keepShownOnClick = true,
			func = function()
					Baggins.db.profile.hidedefaultbank = not Baggins.db.profile.hidedefaultbank
				end,
		},
		{
			text = L["Override Default Bags"],
			tooltipText = L["Baggins will open instead of the default bags"],
			checked = Baggins.db.profile.overridedefaultbags,
			keepShownOnClick = true,
			func = function()
					Baggins.db.profile.overridedefaultbags = not Baggins.db.profile.overridedefaultbags
					Baggins:UpdateBagHooks()
				end,
		},
		spacer,
		{
			text = L["Config Window"],
			func = function() Baggins:OpenConfig() end,
			notCheckable = true,
		},
		{
			text = L["Bag/Category Config"],
			func = function() Baggins:OpenEditConfig() end,
			notCheckable = true,
		},
	}
end

local function updateMenu()
	if not ldbDropDownMenu then
		initDropdownMenu()
		return
	end
	ldbDropDownMenu[3].checked = Baggins.db.profile.hidedefaultbank
	ldbDropDownMenu[4].checked = Baggins.db.profile.overridedefaultbags
end

local ldbdata = {
	type = "data source",
	icon = "Interface\\Icons\\INV_Jewelry_Ring_03",
	OnClick = function(self, message)
			if message == "RightButton" then
				tooltip:Hide()
				updateMenu()
				EasyMenu(ldbDropDownMenu, ldbDropDownFrame, "cursor", 0, 0, "MENU")
				-- Baggins:OpenConfig()
			else
				Baggins:OnClick()
			end
		end,
	label = "Baggins",
	text = "",
	OnEnter = function(self)
			tooltip = qt:Acquire('BagginsTooltip', 1)
			tooltip:SetHeaderFont(GameFontNormalLarge)
			tooltip:SetScript("OnHide", function(self)
					qt:Release(self)
				end)
			Baggins:UpdateTooltip(true)
			self.tooltip = tooltip
			tooltip:SmartAnchorTo(self)
			tooltip:SetAutoHideDelay(0.2, self)
			tooltip:Show()
		end,
}
Baggins.obj = LibStub("LibDataBroker-1.1"):NewDataObject("Baggins", ldbdata)

do
	local buttonCount = 0
	local buttonPool = {}

	local function createItemButton()
		local frame = CreateFrame("Button","BagginsPooledItemButton"..buttonCount,nil,"ContainerFrameItemButtonTemplate")
                frame.GetItemContextMatchResult = nil
		buttonCount = buttonCount + 1
		if InCombatLockdown() then
			print("Baggins: WARNING: item-frame will be tainted")
			Baggins:RegisterEvent("PLAYER_REGEN_ENABLED")
			frame.tainted = true
		end
		return frame
	end

	function Baggins:RepopulateButtonPool(num)
		if InCombatLockdown() then
			Baggins:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		end
		while #buttonPool < num do
			local frame = createItemButton()
			tinsert(buttonPool, frame)
		end
	end

	local usedButtons = 0
	function Baggins:GetItemButton()
		usedButtons = usedButtons + 1
		self.db.char.lastNumItemButtons = usedButtons
		local frame
		if next(buttonPool) then
			frame = tremove(buttonPool, 1)
		else
			frame = createItemButton()
		end
		self:ScheduleTimer("RepopulateButtonPool", 0, Baggins.minSpareItemButtons)
		return frame
	end

	function Baggins:ReleaseItemButton(button)
		button.glow:Hide()
		button.newtext:Hide()
		tinsert(buttonPool, button)
	end
end

function Baggins:PLAYER_REGEN_ENABLED()
	for _,bagframe in ipairs(Baggins.bagframes) do
		for _,section in ipairs(bagframe.sections) do
			for i,item in ipairs(section.items) do
				if item.tainted then
					local tainted = section.items[i]
					tainted:Hide()
					section.items[i] = self:CreateItemButton()
				end
			end
		end
	end
	self:ForceFullUpdate()
	self:RepopulateButtonPool(Baggins.minSpareItemButtons)
end

function Baggins:OnInitialize()
	self.bagframes = {}
	self.colors = {
		black = {r=0,g=0,b=0,hex="|cff000000"},
		white = {r=1,g=1,b=1,hex="|cffffffff"},
		blue = {r=0,g=0.5,b=1,hex="|cff007fff"},
		purple = {r=1,g=0.4,b=1,hex="|cffff66ff"},
	}

	self:InitOptions()
	local buttonsToPool = (self.db.char.lastNumItemButtons or 90) + Baggins.minSpareItemButtons -- create a few spare buttons
	self:RepopulateButtonPool(buttonsToPool)
	self:InitBagCategoryOptions()
	self:RegisterChatCommand("baggins", "OpenConfig")
	self.OnMenuRequest = self.opts

	dbIcon:Register("Baggins", ldbdata, self.db.profile.minimap)

	self.ptsetsdirty = true

	local PT3Modules
	if pt then
		for i = 1, GetNumAddOns() do
			local metadata = GetAddOnMetadata(i, "X-PeriodicTable-3.1-Module")
			if metadata then
				local name, _, _, enabled = GetAddOnInfo(i)
				if enabled then
					PT3Modules = PT3Modules or {}
				  PT3Modules[name] = true
				end
		  end
		end
	end

	if PT3Modules then
		self.opts.args.PT3LOD = {
				name = L["PT3 LoD Modules"],
				type = "group",
				desc = L["Choose PT3 LoD Modules to load at startup, Will load immediately when checked"],
				order = 135,
				args = {

				},
			}
		local order = 1
		for name in pairs(PT3Modules) do
			self.opts.args.PT3LOD.args[name] = {
				name = name,
				type = "toggle",
				order = order,
				desc = L["Load %s at Startup"]:format(name),
				arg = name,
				get = PT3ModuleGet,
				set = PT3ModuleSet,
			}
			order = order + 1
		end
	end

	-- self:RegisterChatCommand({ "/baggins" }, self.opts, "BAGGINS")

end

function Baggins:IsActive()
	return true
end

function Baggins:OnEnable()
	--self:SetBagUpdateSpeed();
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN", "UpdateItemButtonCooldowns")
	self:RegisterEvent("ITEM_LOCK_CHANGED", "UpdateItemButtonLocks")
	self:RegisterEvent("QUEST_ACCEPTED", "UpdateItemButtons")
	self:RegisterEvent("UNIT_QUEST_LOG_CHANGED", "UpdateItemButtons")
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", "OnBankChanged")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED", "OnBankSlotPurchased")
	self:RegisterEvent("BANKFRAME_CLOSED", "OnBankClosed")
	self:RegisterEvent("BANKFRAME_OPENED", "OnBankOpened")
	self:RegisterEvent("PLAYER_MONEY", "UpdateMoneyFrame")
	self:RegisterEvent('AUCTION_HOUSE_SHOW', "AuctionHouse")
	self:RegisterEvent('AUCTION_HOUSE_CLOSED', "CloseAllBags")

	-- Patch 8.0.1 Added
	-- self:RegisterEvent('SCRAPPING_MACHINE_SHOW', "OpenAllBags")
	-- self:RegisterEvent('SCRAPPING_MACHINE_CLOSE', "CloseAllBags")
	self:RegisterBucketEvent('ADDON_LOADED', 5,'OnAddonLoaded')

	self:RegisterSignal('CategoryMatchAdded', self.CategoryMatchAdded, self)
	self:RegisterSignal('CategoryMatchRemoved', self.CategoryMatchRemoved, self)
	self:RegisterSignal('SlotMoved', self.SlotMoved, self)

	self:ScheduleRepeatingTimer("RunBagUpdates", 20)
	self:ScheduleRepeatingTimer("RunItemCountUpdates", 60)

	self:UpdateBagHooks()
	self:UpdateBackpackHook()
	self:RawHook("CloseSpecialWindows", true)
	self:RawHookScript(BankFrame,"OnEvent","BankFrame_OnEvent")

	-- hook blizzard PLAYERBANKSLOTS_CHANGED function to filter inactive table
	-- this is required to prevent a nil error when working with a tab that the
	-- default UI is not currently showing
	self:RawHook("BankFrameItemButton_Update", true)

	--force an update of all bags on first opening
	self.doInitialUpdate = true
	self.doInitialBankUpdate = true
	self:ResortSections()
	self:UpdateText()
	--self:SetDebugging(true)

	if pt then
		for name, load in pairs(self.db.global.pt3mods) do
			if GetAddOnMetadata(name, "X-PeriodicTable-3.1-Module") then
				if load then
					LoadAddOn(name)
				end
			else
				self.db.global.pt3mods[name] = nil
			end
		end
	end

	if self.db.profile.hideduplicates == true then
		self.db.profile.hideduplicates = "global"
	end
	self:CreateMoneyFrame()
	self:UpdateMoneyFrame()
	self:CreateBankControlFrame()
	self:UpdateBankControlFrame()
	local skin = self:GetSkin(self.db.profile.skin)
	if not skin then -- if skin doesn't exist anymore, reset to default
		console:Print("|cFFFF0000Baggins|r "..L["Skin '%s' not found, resetting to default"]:format(self.db.profile.skin))
		self.db.profile.skin = "default"
	end
	self:EnableSkin(self.db.profile.skin)
	self:OnProfileEnable()
	self:RunBagUpdates()
end

function Baggins:FixInit()
    self:ForceFullUpdate()
    self:RebuildSectionLayouts()
    self:UpdateBags()
end

function Baggins:Baggins_CategoriesChanged()
	self:UpdateBags()
	self.doInitialBankUpdate = true
end

function Baggins:BankFrame_OnEvent(...)
	if not self:IsActive() or not self.db.profile.hidedefaultbank then
		self.hooks[BankFrame].OnEvent(...)
	end
end

function Baggins:UpdateBagHooks()
	if self.db.profile.overridedefaultbags then
		self:RawHook("OpenAllBags", "ToggleAllBags", true)
		self:RawHook("ToggleAllBags", true)
		self:RawHook("CloseAllBags", true)
	else
		self:UnhookBagHooks()
	end
end

function Baggins:UnhookBagHooks()
	if self:IsHooked("OpenAllBags") then
		self:Unhook("OpenAllBags")
	end
	if self:IsHooked("ToggleAllBags") then
		self:Unhook("ToggleAllBags")
	end
	if self:IsHooked("CloseAllBags") then
		self:Unhook("CloseAllBags")
	end
end

function Baggins:UpdateBackpackHook()
	if self.db.profile.overridebackpack then
		self:RawHookScript(MainMenuBarBackpackButton, "OnClick", "MainMenuBarBackpackButtonOnClick")
	else
		self:UnhookBackpack()
	end
end

function Baggins:UnhookBackpack()
	if self:IsHooked(MainMenuBarBackpackButton, "OnClick") then
		self:Unhook(MainMenuBarBackpackButton, "OnClick")
	end
end

function Baggins:OnDisable()
	self:CloseAllBags()
end

local INVSLOT_LAST_EQUIPPED, CONTAINER_BAG_OFFSET, NUM_BAG_SLOTS =
      INVSLOT_LAST_EQUIPPED, CONTAINER_BAG_OFFSET, NUM_BAG_SLOTS

function Baggins:SaveItemCounts()
	local itemcounts = self.itemcounts
	wipe(itemcounts)
	for bag,slot,link in LBU:Iterate("BAGS") do	-- includes keyring
		if link then
			local id = tonumber(link:match("item:(%d+)"))
			if id and not itemcounts[id] then
				itemcounts[id] = { count = GetItemCount(id), ts = time() }
			end
		end
	end

	for slot = 0, INVSLOT_LAST_EQUIPPED do	-- 0--19
		local link = GetInventoryItemLink("player",slot)
		if link then
			local id = tonumber(link:match("item:(%d+)"))
			if id and not itemcounts[id] then
				itemcounts[id] = { count = GetItemCount(id), ts = time() }
			end
		end
	end
	for slot = 1+CONTAINER_BAG_OFFSET, NUM_BAG_SLOTS+CONTAINER_BAG_OFFSET do  -- 20--23
		local link = GetInventoryItemLink("player",slot)
		if link then
			local id = tonumber(link:match("item:(%d+)"))
			if id and not itemcounts[id] then
				itemcounts[id] = { count = GetItemCount(id), ts = time() }
			end
		end
	end
end

function Baggins:RunItemCountUpdates()
	if self.db.profile.newitemduration > 0 then
		Baggins:ForceFullUpdate()
	end
end

function Baggins:IsCompressed(itemID)
	local p = self.db.profile
	if self.tempcompressnone then
		return false
	end
	--slot sorting will break compression horribly
	if p.sort == "slot" then
		return false
	end
	if p.compressall then
		return true
	end
	--string id's here are empty slots
	if type(itemID) == "string" and p.compressempty then
		return true
	end

	if type(itemID) == "number" then
		local itemFamily = GetItemFamily(itemID)
		local _, _, _, _, _, _, _, itemStackCount, itemEquipLoc = GetItemInfo(itemID)
		if itemFamily then	-- likes to be nil during login
			if p.compressshards and band(itemFamily,4)~=0 and itemEquipLoc~="INVTYPE_BAG" then
				return true
			end
			if p.compressammo and band(itemFamily,3)~=0 and itemEquipLoc~="INVTYPE_BAG" then
				return true
			end
		end
		if p.compressstackable and itemStackCount and itemStackCount>1 then
			return true
		end
	end
end

function Baggins:OnAddonLoaded(name)
	if not pt and name then return end
	local module
	if type(name) == "string" then
		module = GetAddOnMetadata(name, "X-PeriodicTable-3.1-Module")
	else
		for k in pairs(name) do
			module = module or GetAddOnMetadata(k, "X-PeriodicTable-3.1-Module")
		end
	end
	if module then
		self.ptsetsdirty = true
	end
end

function Baggins:OnBankClosed()
	-- don't remove the test, it prevents infinite recursion loop on CloseBankFrame()
	if self.bankIsOpen then
		self.bankIsOpen = nil
		self:CloseAllBags()
	end
end

function Baggins:OnBankOpened()
	if self.doInitialBankUpdate then
		self.doInitialBankUpdate = nil
		Baggins:ForceFullBankUpdate()
	end
	self.bankIsOpen = true
	self:OpenAllBags()
end

function Baggins:OnBankChanged()
	self:OnBagUpdate(-1)
end

function Baggins:OnBankSlotPurchased()
	self:UpdateBankControlFrame()
	self:ForceFullBankUpdate()
	self:UpdateBags()
end

---------------------
-- Fubar Plugin    --
---------------------
function Baggins:UpdateText()
	self:OnTextUpdate()
end

function Baggins:SetText(text)
	ldbdata.text = text
end

function Baggins:OnClick()
	if IsShiftKeyDown() then
		self:SaveItemCounts()
		self:ForceFullUpdate()
	elseif IsControlKeyDown() and self.db.profile.layout == 'manual' then
		self.db.profile.lock = not self.db.profile.lock
	else
		self:ToggleAllBags()
	end
end

function Baggins:UpdateTooltip(force)
	if not tooltip then return end
	if not tooltip:IsShown() and not force then return end
	ldbdata:OnTooltipUpdate()
end

local function openBag(self, line)
	Baggins:ToggleBag(line)
end

function ldbdata:OnTooltipUpdate()
	tooltip:Clear()
	local title = tooltip:AddHeader()
	tooltip:SetCell(title, 1, "Baggins", tooltip:GetHeaderFont(), "LEFT")
	tooltip:AddLine()
	for bagid, bag in ipairs(Baggins.db.profile.bags) do
		if not bag.isBank or (bag.isBank and self.bankIsOpen) then
			local color
			if bag.isBank then
				color = Baggins.colors.blue
			else
				color = Baggins.colors.white
			end
			local name = bag.name
			if Baggins.bagframes[bagid] and Baggins.bagframes[bagid]:IsVisible() then
				name = "* "..name
			end
			local line = tooltip:AddLine(name)
			tooltip:SetLineScript(line, "OnMouseUp", openBag, line - 2)
		end
	end
end



function Baggins:BuildCountString(empty, total, color)
	local p = self.db.profile
	color = color or ""
	local div = "|r/"
	if p.showtotal then
		if p.showused and p.showempty then
			return format("%s%i%s%s%i%s%s%i", color, total-empty, div, color, empty, div, color, total)
		elseif p.showused then
			return format("%s%i%s%s%i", color, total-empty, div, color, total)
		elseif p.showempty then
			return format("%s%i%s%s%i", color, empty, div, color, total)
		end
		return format("%s%i", color, total)
	end

	if p.showused and p.showempty then
		return format("%s%i%s%s%i", color, total-empty, div, color, empty)
	elseif p.showused then
		return format("%s%i", color, total-empty)
	elseif p.showempty then
		return format("%s%i", color, empty)
	end
	return ""
end


local texts={}
function Baggins:OnTextUpdate()
	local p = self.db.profile
	local color

	if p.combinecounts then
		local normalempty,normaltotal = LBU:CountSlots("BAGS", 0)
		local itemFamilies
		if p.showspecialcount then
			itemFamilies = 2047-256-4-2-1   -- all except keyring, ammo, quiver, soul
		else
			itemFamilies = 0
		end
		if p.showammocount then
			itemFamilies = itemFamilies +1 +2
		end
		if p.showsoulcount then
			itemFamilies = itemFamilies +4
		end

		local empty, total = LBU:CountSlots("BAGS", itemFamilies)
		empty=empty+normalempty
		total=total+normaltotal

		local fullness = 1 - (empty/total)
		local r, g
		r = min(1,fullness * 2)
		g = min(1,(1-fullness) *2)
		color = ("|cFF%2X%2X00"):format(r*255,g*255)

		self:SetText(self:BuildCountString(empty,total,color))
		return
	end

	-- separate normal/ammo/soul/special counts

	local n=0	-- count of strings in texts{}

	local normalempty, normaltotal = LBU:CountSlots("BAGS", 0)

	local fullness = 1 - (normalempty/normaltotal)
	local r, g
	r = min(1,fullness * 2)
	g = min(1,(1-fullness) *2)
	color = ("|cFF%2X%2X00"):format(r*255,g*255)

	n=n+1
	texts[n] = self:BuildCountString(normalempty,normaltotal,color)

	if self.db.profile.showsoulcount then
		local soulempty, soultotal = LBU:CountSlots("BAGS", 4)
		if soultotal>0 then
			color = self.colors.purple.hex
			n=n+1
			texts[n] = self:BuildCountString(soulempty,soultotal,color)
		end
	end

	if self.db.profile.showammocount then
		local ammoempty, ammototal = LBU:CountSlots("BAGS", 1+2)
		if ammototal>0 then
			color = self.colors.white.hex
			n=n+1
			texts[n] = self:BuildCountString(ammoempty,ammototal,color)
		end
	end

	if self.db.profile.showspecialcount then
		local specialempty, specialtotal = LBU:CountSlots("BAGS", 2047-256-4-2-1)
		if specialtotal>0 then
			color = self.colors.blue.hex
			n=n+1
			texts[n] = self:BuildCountString(specialempty,specialtotal,color)
		end
	end

	if n==1 then
		self:SetText(texts[1])
	else
		self:SetText(tconcat(texts, " ", 1, n))
	end
end

---------------------
-- Add/Remove/Move --
---------------------
function Baggins:NewBag(bagname)
	local bags = self.db.profile.bags
	tinsert(bags, { name=bagname, openWithAll=true, sections={}})
	if not self.bagframes[#bags] then
		self:CreateBagFrame(#bags)
	end
	currentbag = #bags
	self:ResortSections()
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
	self:BuildMoneyBagOptions()
	self:BuildBankControlsBagOptions()
end

function Baggins:MoveBag(bagid, down)
	local bags = self.db.profile.bags
	local other
	if down then
		other = bagid + 1
	else
		other = bagid - 1
	end

	if bags[bagid] and bags[other] then
		bags[bagid], bags[other] = bags[other], bags[bagid]
	end
	self:ResortSections()
	self:ForceFullRefresh()
	self:BuildMoneyBagOptions()
	self:BuildBankControlsBagOptions()
end

function Baggins:MoveSection(bagid, sectionid, down)
	local other
	if down then
		other = sectionid + 1
	else
		other = sectionid - 1
	end
	if self.db.profile.bags[bagid] then
		local sections = self.db.profile.bags[bagid].sections
		if sections[sectionid] and sections[other] then
			sections[sectionid], sections[other] = sections[other], sections[sectionid]
		end
	end
    self:ResortSections()
	self:ForceFullRefresh()
end

function Baggins:MoveRule(categoryid, ruleid, down)
	local other
	if down then
		other = ruleid + 1
	else
		other = ruleid - 1
	end
	local rules = self.db.profile.categories[categoryid]
	if rules then
		if rules[ruleid] and rules[other] then
			rules[ruleid], rules[other] = rules[other], rules[ruleid]
		end
	end
end

function Baggins:RemoveBag(bagid)
	self:CloseBag(bagid)
	tremove(self.db.profile.bags, bagid)
	self:ResetCatInUse()
	self:ResortSections()
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
	local numbags, numbagframes = #self.db.profile.bags, #self.bagframes
	for i = numbags+1, numbagframes do
		if self.bagframes[i] then
			self.bagframes[i]:Hide()
		end
	end
	self:BuildMoneyBagOptions()
	self:BuildBankControlsBagOptions()
end

function Baggins:NewSection(bagid,sectionname)
	tinsert(self.db.profile.bags[bagid].sections, { name=sectionname, cats = {} })
	currentsection = #self.db.profile.bags[bagid].sections
	self:ResortSections()
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
end

function Baggins:NewCategory(catname)
	if not self.db.profile.categories[catname] then
		self.db.profile.categories[catname] = { name=catname }
		currentcategory = catname
		--tablet:Refresh("BagginsEditCategories")
		self:RebuildCategoryOptions()
	end
end

function Baggins:RemoveSection(bagid, sectionid)
	tremove(self.db.profile.bags[bagid].sections, sectionid)
	self:ResetCatInUse()
	self:ResortSections()
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
end

function Baggins:RemoveRule(catid, ruleid)
	tremove(self.db.profile.categories[catid], ruleid)
	--tablet:Refresh("BagginsEditCategories")
	Baggins:OnRuleChanged()
end

function Baggins:AddCategory(bagid,sectionid,category)
	tinsert(self.db.profile.bags[bagid].sections[sectionid].cats,category)
	self:ResetCatInUse(category)
	self:ForceFullRefresh()
	self:UpdateBags()
	self:UpdateLayout()
end

do
	local catinuse = { [true] = {}, [false] = {}}
	function Baggins:ResetCatInUse(catname)
		if catname then
			catinuse[true][catname] = nil
			catinuse[false][catname] = nil
		else
			for k in pairs(catinuse[true]) do
				catinuse[true][k] = nil
			end
			for k in pairs(catinuse[false]) do
				catinuse[false][k] = nil
			end
		end
	end

	function Baggins:CategoryInUse(catname, isbank)
		if not catname then return end
		if isbank == nil or catinuse[isbank][catname] == nil then
			for bid, bag in ipairs(self.db.profile.bags) do
				if isbank==nil or (not bag.isBank == not isbank) then
					for sid, section in ipairs(bag.sections) do
						for cid, cat in ipairs(section.cats) do
							if cat == catname then
								if isbank ~= nil then
									catinuse[isbank][catname] = true
								end
								return true
							end
						end
					end
				end
			end
			if isbank ~= nil then
				catinuse[isbank][catname] = false
			end
			return false
		else
			return catinuse[isbank][catname]
		end
	end
end

function Baggins:RemoveCategory(bagid,sectionid,catid)
	local p = self.db.profile
	if type(bagid) == "string" then
		--removing a category completely
		if not self:CategoryInUse(bagid) then
			p.categories[bagid] = nil
		end
		self:RebuildCategoryOptions()
	else
		--removing a category from a bag
		tremove(p.bags[bagid].sections[sectionid].cats,catid)
		self:ResetCatInUse()
		self:ForceFullRefresh()
		self:UpdateBags()
		self:UpdateLayout()
	end
end

---------------------
-- Bag Open/Close  --
---------------------
function Baggins:CloseBag(bagid)
	if self.bagframes[bagid] then
		self.bagframes[bagid]:Hide()
		if self.db.profile.hidedefaultbank and self.db.profile.bags[bagid].isBank then
			if self.bankIsOpen and not self:IsAnyBankOpen() then
				CloseBankFrame()
			end
		end
		self:UpdateLayout()
	end
	self:UpdateTooltip()

	if(not Baggins:IsWhateverOpen()) then
		--self:SetBagUpdateSpeed(false);	-- indicate bags closed
		self:FireSignal("Baggins_AllBagsClosed");
		-- reset temp no item compression
		if self.tempcompressnone then
			self.tempcompressnone = nil
			self:RebuildSectionLayouts()
		end
	end
end

function Baggins:CloseAllBags()
	for bagid, bag in ipairs(self.db.profile.bags) do
		Baggins:CloseBag(bagid)
	end
end

function Baggins:MainMenuBarBackpackButtonOnClick(button)
	if IsAltKeyDown() then
		BackpackButton_OnClick(button)
	else
		self:ToggleAllBags()
		button:SetChecked(false)
	end
end

function Baggins:ToggleBag(bagid)
	if not self.bagframes[bagid] then
		self:CreateBagFrame(bagid)
		self:OpenBag(bagid)
	elseif self.bagframes[bagid]:IsVisible() then
		self:CloseBag(bagid)
	else
		self:OpenBag(bagid)
	end
end

function Baggins:OpenBag(bagid,noupdate)
	--self:SetBagUpdateSpeed(true);	-- indicate bags open
	local p = self.db.profile
	if not self:IsActive() then
		return
	end
	if self.doInitialUpdate then
		Baggins:ForceFullUpdate()
		-- note: we use self.doInitialUpdate further down, and nil it there
	end

	if p.bags[bagid].isBank and not self.bankIsOpen then
		return
	end
	self:ForceSectionReLayout(bagid)
	if not self.bagframes[bagid] then
		self:CreateBagFrame(bagid)
	end
	self.bagframes[bagid]:Show()
	if not noupdate then

		self:RunBagUpdates()
		self:UpdateBags()
	end
	self:UpdateLayout()
	self:UpdateTooltip()

	-- reuse self.doInitialUpdate to only run once
	-- this fixes the duplicate stacks bug upon login
	if self.doInitialUpdate then
    -- this time we set to nil so this only runs the first time
    self.doInitialUpdate = nil
		-- rebuild layouts to fix duplicate stacks
    self:ScheduleForNextFrame('FixInit')
	end
end

-- "All Bags" in these 3 functions refers to bags that are set to openWithAll
function Baggins:OpenAllBags()
	local p = self.db.profile
	if not self:IsActive() then
		return
	end
	for bagid, bag in ipairs(p.bags) do
		if bag.openWithAll then
			Baggins:OpenBag(bagid,true)
		end
	end
	self:RunBagUpdates()
	self:UpdateBags()
	self:UpdateLayout()
end

function Baggins:AuctionHouse()
 	if self.db.profile.openatauction then
 		self:OpenAllBags()
 	end
end


function Baggins:ToggleAllBags(forceopen)
	local p = self.db.profile
	if (forceopen) then
		self:OpenAllBags()
	elseif (p.hideemptybags) then
		if self:IsAnyOpen() then
			self:CloseAllBags()
		else
			self:OpenAllBags()
		end
	else
		if self:IsAllOpen() then
			self:CloseAllBags()
		else
			self:OpenAllBags()
		end
	end
end

function Baggins:IsAllOpen()
	for bagid, bag in ipairs(self.db.profile.bags) do
		if bag.openWithAll and (not bag.isBank or self.bankIsOpen) then
			if not ( self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() ) then
				return false
			end
		end
	end
	return true
end

function Baggins:IsAnyOpen()
	for bagid, bag in ipairs(self.db.profile.bags) do
		if bag.openWithAll and (not bag.isBank or self.bankIsOpen) then
			if self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
				return true
			end
		end
	end
end

function Baggins:IsWhateverOpen()
	for bagid, bag in ipairs(self.db.profile.bags) do
		if self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
			return true
		end
	end
end

function Baggins:IsAnyBankOpen()
	for bagid, bag in ipairs(self.db.profile.bags) do
		if bag.isBank and self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
			return true
		end
	end
end

function Baggins:IsEmpty(bagid)
	local count = 0
	if self.bagframes[bagid] then
		for i, v in ipairs(self.bagframes[bagid].sections) do
			count = count + v.itemcount or 0
		end
	end
	return count == 0
end

function Baggins:OpenBackpack()
	self:OpenAllBags()
end

function Baggins:CloseBackpack()
	self:CloseAllBags()
end

function Baggins:ToggleBackpack()
	if self:IsAnyOpen() then
		self:CloseAllBags()
	else
		self:OpenAllBags()
	end
end

function Baggins:CloseSpecialWindows()
    if self:IsAnyOpen() then
		self:CloseAllBags()
		return true
	end
	return self.hooks.CloseSpecialWindows()
end

function Baggins:BankFrameItemButton_Update(button)
	if button ~= nil then
		return self.hooks.BankFrameItemButton_Update(button)
	end
end
