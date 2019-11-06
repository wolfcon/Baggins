local _G = _G
local Baggins = _G.Baggins
local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")
local LBU = LibStub("LibBagUtils-1.0")
local iui = LibStub("LibItemUpgradeInfo-1.0")

local next, pairs, ipairs, tonumber, select, strmatch, wipe, type, time =
      _G.next, _G.pairs, _G.ipairs, _G.tonumber, _G.select, _G.strmatch, _G.wipe, _G.type, _G.time
local min, max, ceil, floor, mod  =
      _G.min, _G.max, _G.ceil, _G.floor, _G.mod
local tinsert, tremove, tsort =
      _G.tinsert, _G.tremove, _G.table.sort

local GetItemCount, GetItemInfo, GetItemQualityColor, BankButtonIDToInvSlotID =
      _G.GetItemCount, _G.GetItemInfo, _G.GetItemQualityColor, _G.BankButtonIDToInvSlotID
local GetContainerItemInfo, GetContainerItemLink, GetContainerNumFreeSlots, GetContainerItemCooldown =
      _G.GetContainerItemInfo, _G.GetContainerItemLink, _G.GetContainerNumFreeSlots, _G.GetContainerItemCooldown
local IsModifiedClick, InRepairMode, C_PetJournal, C_NewItems =
      _G.IsModifiedClick, _G.InRepairMode, _G.C_PetJournal, _G.C_NewItems

local function new() return {} end
local function del(t) wipe(t) end
local rdel = del


function Baggins:GetSlotInfo(item)
	local bag, slot = item:match("^(-?%d+):(%d+)$")
	local bagType = Baggins:IsSpecialBag(bag)
	local itemID
	local cacheditem = Baggins:GetCachedItem(item)
	if cacheditem then
		itemID = tonumber(cacheditem:match("^(%d+)"))
	end
	return bag, slot, itemID, bagType
end

-------------------------
-- Update Bag Contents --
-------------------------
local scheduled_refresh = false

function Baggins:ScheduleRefresh()
	if not scheduled_refresh then
		scheduled_refresh = self:ScheduleForNextFrame('Baggins_RefreshBags')
	end
end

function Baggins:Baggins_RefreshBags()
	if self.dirtyBags then
		--self:Debug('Updating bags')
		self:ReallyUpdateBags()
	end
	for bagid,bagframe in pairs(self.bagframes) do
		for secid,sectionframe in pairs(bagframe.sections) do
			if sectionframe.used and sectionframe.dirty then
				--self:Debug('Updating section #%d-%d', bagid, secid)
				self:ReallyLayoutSection(sectionframe)
			end
		end

		if bagframe.dirty then
			self:ReallyUpdateBagFrameSize(bagid)
		end
	end
	if self.dirtyBagLayout then
		self:ReallyLayoutBagFrames()
	end

	scheduled_refresh = nil
end

function Baggins:UpdateBags()
	self.dirtyBags = true
	self:ScheduleRefresh()
end

local othersections = {}

local function CheckSection(bagframe, secid)
	for i = 1,secid do
		if not bagframe.sections[i] then
			bagframe.sections[i] = Baggins:CreateSectionFrame(bagframe,i)
			if i == 1 then
				bagframe.sections[i]:SetPoint("TOPLEFT",bagframe,"TOPLEFT",10,-36)
			else
				bagframe.sections[i]:SetPoint("TOPLEFT",bagframe.sections[i-1],"BOTTOMLEFT",0,1)
			end
		end
	end
end

function Baggins:CategoryMatchAdded(category, slot, isbank)
	local p = self.db.profile
	for bagid, bag in pairs(p.bags) do
		local bagframe = self.bagframes[bagid]
		if bagframe then
			for sectionid, section in pairs(bag.sections) do
				for catid, catname in pairs(section.cats) do
					if catname == category and (not bag.isBank == not isbank) then
						CheckSection(bagframe, sectionid)
						local secframe = bagframe.sections[sectionid]
						secframe.slots[slot] = ( secframe.slots[slot] or 0 ) + 1
						local layout = secframe.layout
						local bagnum, slotnum, itemid, bagtype = Baggins:GetSlotInfo(slot)
						if not itemid then
							itemid = (bagtype or "")
						end
						local found

						--check for an existing stack to add the slot to
						for k, entry in ipairs(layout) do
							if type(entry) == "table" then
								if entry.itemid == itemid and entry.slots[slot] then
									found = true
								elseif entry.itemid == itemid then
									if self:IsCompressed(itemid) then
										if not entry.slots[slot] then
											entry.slots[slot] = true
											entry.slotcount = entry.slotcount + 1
										end
										found = true
									end
								else
									if entry.slots[slot] then
										entry.slots[slot] = nil
										entry.slotcount = entry.slotcount - 1
										if entry.slotcount == 0 then
											del(entry.slots)
											del(entry)
											layout[k] = slot
										end
									end
								end
							end
						end
						if not found then
							local newentry = new()
							newentry.slots = new()
							newentry.slots[slot] = true
							newentry.slotcount = 1
							newentry.itemid = itemid
							tinsert(layout, newentry)
							secframe.needssorting = true
						end
					end
				end
			end
		end
	end
end

function Baggins:CategoryMatchRemoved(category, slot, isbank)
	local p = self.db.profile
	for bagid, bag in pairs(p.bags) do
	local bagframe = self.bagframes[bagid]
		if bagframe then
			for sectionid, section in pairs(bag.sections) do
				for catid, catname in pairs(section.cats) do
					if catname == category and (not bag.isBank == not isbank) then
						CheckSection(bagframe, sectionid)
						local secframe = bagframe.sections[sectionid]
						secframe.slots[slot] = ( secframe.slots[slot] or 1 ) - 1
						if secframe.slots[slot] == 0 then
							secframe.slots[slot] = false
						end

						local layout = secframe.layout

						--remove the slot from any stacks that contain it
						for k, entry in ipairs(layout) do
							if type(entry) == "table" then
								if entry.slots[slot] then
									entry.slots[slot] = nil
									entry.slotcount = entry.slotcount - 1
								end
								if entry.slotcount == 0 then
									del(entry.slots)
									del(entry)
									layout[k] = slot
								end
							end
						end

					end
				end
			end
		end
	end
end

function Baggins:SlotMoved(category, slot, isbank)
	local p = self.db.profile
	for bagid, bag in pairs(p.bags) do
		local bagframe = self.bagframes[bagid]
		if bagframe then
			for sectionid, section in pairs(bag.sections) do
				for catid, catname in pairs(section.cats) do
					if catname == category and (not bag.isBank == not isbank) then
						CheckSection(bagframe, sectionid)
						local secframe = bagframe.sections[sectionid]
						secframe.needssorting = true
						local layout = secframe.layout
						local bagnum, slotnum, itemid, bagtype = Baggins:GetSlotInfo(slot)
						if not itemid then
							itemid = (bagtype or "")
						end

						--remove the slot from any stacks that contain it
						for k, entry in ipairs(layout) do
							if type(entry) == "table" then
								if entry.slots[slot] then
									entry.slots[slot] = nil
									entry.slotcount = entry.slotcount - 1
								end
								if entry.slotcount == 0 then
									del(entry.slots)
									del(entry)
									layout[k] = slot
								end
							end
						end
						local found
						--check for an existing stack to add the slot to
						for k, entry in ipairs(layout) do
							if type(entry) == "table" then
								if entry.itemid == itemid then
									if self:IsCompressed(itemid) then
										if not entry.slots[slot] then
											entry.slots[slot] = true
											entry.slotcount = entry.slotcount + 1
										end
										found = true
									end
								else
									if entry.slots[slot] then
										entry.slots[slot] = nil
										entry.slotcount = entry.slotcount - 1
										if entry.slotcount == 0 then
											del(entry.slots)
											del(entry)
											layout[k] = slot
										end
									end
								end
							end
						end
						if not found then
							local newentry = new()
							newentry.slots = new()
							newentry.slots[slot] = true
							newentry.slotcount = 1
							newentry.itemid = itemid
							tinsert(layout, newentry)
							secframe.needssorting = true
						end

					end
				end
			end
		end
	end
end

function Baggins:ForceSectionReLayout(bagid)
	local bagframe = self.bagframes[bagid]
	if bagframe then
		for secid, secframe in pairs(bagframe.sections) do
			if secframe then
				for k, v in pairs(secframe.slots) do
					if v == false then
						secframe.slots[k] = nil
					end
				end
				secframe.needssorting = true
			end
		end
	end
end

function Baggins:ClearSectionCaches()
	for bagid, bag in ipairs(self.db.profile.bags) do
		local bagframe = self.bagframes[bagid]
		if bagframe then
			for secid, secframe in pairs(bagframe.sections) do
				if secframe then
					local layout = secframe.layout
					for k, v in pairs(layout) do
						if type(v) == "table" then
							del(v.slots)
							del(v)
						end
						layout[k] = nil
					end
					for k, v in pairs(secframe.slots) do
						secframe.slots[k] = nil
					end
				end
			end
		end
	end
end

function Baggins:RebuildSectionLayouts()
	for bagid, bag in ipairs(self.db.profile.bags) do
		local bagframe = self.bagframes[bagid]
		if bagframe then
			for secid, secframe in pairs(bagframe.sections) do
				if secframe then
					local layout = secframe.layout
					for k, v in pairs(layout) do
						if type(v) == "table" then
							del(v.slots)
							del(v)
						end
						layout[k] = nil
					end
					for slot, refcount in pairs(secframe.slots) do
						local bagnum, slotnum, itemid, bagtype = Baggins:GetSlotInfo(slot)
						if not itemid then
							itemid = (bagtype or "")
						end
						local found
						--check for an existing stack to add the slot to
						for k, entry in ipairs(layout) do
							if entry then
								if entry.itemid == itemid then
									if self:IsCompressed(itemid) then
										if not entry.slots[slot] then
											entry.slots[slot] = true
											entry.slotcount = entry.slotcount + 1
										end
										found = true
									end
								else
									if entry.slots[slot] then
										entry.slots[slot] = nil
										entry.slotcount = entry.slotcount - 1
										if entry.slotcount == 0 then
											del(entry.slots)
											del(entry)
											layout[k] = slot
										end
									end
								end
							end
						end
						if not found then
							local newentry = new()
							newentry.slots = new()
							newentry.slots[slot] = true
							newentry.slotcount = 1
							newentry.itemid = itemid
							tinsert(layout, newentry)
							secframe.needssorting = true
						end
					end
					secframe.needssorting = true
				end
			end
		end
	end
end


function Baggins:ReallyUpdateBags()
	local p = self.db.profile
	local isVisible = false
	BagginsMoneyFrame:Hide()
	BagginsBankControlFrame:Hide()
	for bagid, bag in pairs(p.bags) do
		if self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
			isVisible = true
		end
	end
	if not isVisible then return end
	for bagid, bag in pairs(p.bags) do
		if ( not bag.isBank ) or self.bankIsOpen then
			if self.bagframes[bagid] then
				self:SetBagTitle(bagid,bag.name)
				if self.currentSkin then
					self.currentSkin:SetBankVisual(self.bagframes[bagid], bag.isBank)
				end
				for k, v in pairs(self.bagframes[bagid].sections) do
					v.used = nil
					v:Hide()
					for i, itemframe in pairs(v.items) do
						itemframe:Hide()
					end
				end
				for sectionid, section in pairs(bag.sections) do
					if (self.bagframes[bagid]:IsVisible() or p.hideemptybags) then
						self:UpdateSection(bagid,sectionid,section.name) --,Baggins:FinishSection())
					end
				end
				self:UpdateBagFrameSize(bagid)
			end
		end
	end

	self:UpdateLayout()
	self.dirtyBags = nil
end

function Baggins:UpdateSection(bagid, secid,title) --, contents)
	local bagframe = self.bagframes[bagid]
	if not bagframe then return end
	local i
	for i = 1,secid do
		if not bagframe.sections[i] then
			bagframe.sections[i] = self:CreateSectionFrame(bagframe,i)
			if i == 1 then
				bagframe.sections[i]:SetPoint("TOPLEFT",bagframe,"TOPLEFT",10,-36)
			else
				bagframe.sections[i]:SetPoint("TOPLEFT",bagframe.sections[i-1],"BOTTOMLEFT",0,1)
			end
		end
	end
	self:UpdateSectionContents(bagframe.sections[secid],title) --,contents)
	self:UpdateBagFrameSize(bagid)
end

-----------------
-- Bag Updates --
-----------------

local firstbagupdate = true

local bagupdatebucket = {}
local lastbag,lastbagfree=-1,-1

function Baggins:BAG_UPDATE(_, ...)
	self:OnBagUpdate(...)
end

function Baggins:OnBagUpdate(bagid)
	--ignore bags -4 ( currency ); -3 is reagent bank
	if bagid <= -2 then return end
	bagupdatebucket[bagid] = true
	if self:IsWhateverOpen() then
		self:ScheduleTimer("RunBagUpdates",0.1)
		lastbagfree=-1
	else
		-- Update panel text.
		-- Optimization mostly for hunters - their bags change for every damn arrow they fire:
		local free=GetContainerNumFreeSlots(bagid)
		if lastbag==bagid and lastbagfree==free then
			-- nada!
		else
			lastbag=bagid
			lastbagfree=free
			self:UpdateText()
		end
	end
end

function Baggins:RunBagUpdates()
	if firstbagupdate then
		firstbagupdate = false
		self:SaveItemCounts()
		self:ForceFullUpdate()
	end
	if not next(bagupdatebucket) then
		return
	end
	self:UpdateText()

	local itemschanged
	for bag in pairs(bagupdatebucket) do
		itemschanged = Baggins:CheckSlotsChanged(bag) or itemschanged
		bagupdatebucket[bag] = nil
	end

	if itemschanged then
		self:UpdateBags()
	else
		self:UpdateItemButtons()
	end

	if(self:IsWhateverOpen()) then
		Baggins:FireSignal("Baggins_BagsUpdatedWhileOpen");
	end
end

-----------------------------
-- Update Section Contents --
-----------------------------
function Baggins:UpdateSectionContents(sectionframe,title)
	local p = self.db.profile

	sectionframe.used = true
	if sectionframe.needssorting or self.db.profile.alwaysresort then
		local layout = sectionframe.layout
		local size = #layout
		if size > 0 then
			for i = size, 1, -1 do
				if type(layout[i]) == "string" then
					tremove(layout, i)
				end
			end
		end

		self:SortItemList(layout, p.sort)
		sectionframe.needssorting = false
	end
	sectionframe:Show()

	self:LayoutSection(sectionframe, title)
end


local function baseComp(a, b)
	local p = Baggins.db.profile
	if type(a) == "table" then
		for k, v in pairs(a.slots) do
			if v then
				a = k
				break
			end
		end
	end
	if type(b) == "table" then
		for k, v in pairs(b.slots) do
			if v then
				b = k
				break
			end
		end
	end
	-- getting a or b as nil here shouldn't happen. but it happens.
	local baga, slota = strmatch(a or "", "^(-?%d+):(%d+)$")
	local bagb, slotb = strmatch(b or "", "^(-?%d+):(%d+)$")
	baga=tonumber(baga)
	slota=tonumber(slota)
	bagb=tonumber(bagb)
	slotb=tonumber(slotb)
	local linka = baga and slota and GetContainerItemLink(baga, slota)
	local linkb = bagb and slotb and GetContainerItemLink(bagb, slotb)
	--if both are empty slots compare based on bag type
	if not linka and not linkb then
		local bagtypea = Baggins:IsSpecialBag(baga)
		local bagtypeb = Baggins:IsSpecialBag(bagb)
		if not bagtypea then
			return false
		end
		if not bagtypeb then
			return true
		end
		return bagtypea < bagtypeb
	end
	if not linka then
		return false
	end
	if not linkb then
		return true
	end

	if p.sortnewfirst and baga>=0 and baga<=NUM_BAG_SLOTS then
		local newa, newb = Baggins:IsNew(linka), Baggins:IsNew(linkb)
		if newa and not newb then
			return true
		end
		if newb and not newa then
			return false
		end
	end

	return nil,linka,linkb,baga,slota,bagb,slotb
end

local function getBattlePetInfoFromLink(link)
	local speciesID, level, quality, maxHealth, power, speed, petid, name = link:match("battlepet:(%d+):(%d+):([-%d]+):(%d+):(%d+):(%d+):([x%d]+)|h%[([%a%s]+)")
	return tonumber(speciesID), tonumber(level), tonumber(quality), tonumber(maxHealth), tonumber(power), tonumber(speed), tonumber(petid), name
end

local function getCompInfo(link)
  if link:match("keystone:") then
    return GetItemInfo(158923)
  elseif link:match("battlepet:") then
    local speciesID, level, quality, maxHealth, power, speed, petid, name = getBattlePetInfoFromLink(link)
    local petType = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
    local subtype = _G["BATTLE_PET_NAME_" .. petType]
    return name, nil, quality, level, nil, L["Battle Pets"], subtype
  else
    return GetItemInfo(link)
  end
end

local function NameComp(a, b)
	local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
	if res~=nil then return res end

	local namea = getCompInfo(linka)
	local nameb = getCompInfo(linkb)

	if namea ~= nameb then
		return (namea  or "?") < (nameb or "?")
	end

	local counta = select(2, GetContainerItemInfo(baga, slota))
	local countb = select(2, GetContainerItemInfo(bagb, slotb))
	return (counta  or 0) > (countb or 0)
end
local function QualityComp(a, b)
	local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
	if res~=nil then return res end

	local namea, _, quala = getCompInfo(linka)
	local nameb, _, qualb = getCompInfo(linkb)

	if quala~=qualb then
		return (quala  or 0) > (qualb  or 0)
	end

	if namea ~= nameb then
		return (namea  or "?") < (nameb or "?")
	end

	local counta = select(2, GetContainerItemInfo(baga, slota))
	local countb = select(2, GetContainerItemInfo(bagb, slotb))
	return (counta  or 0) > (countb  or 0)
end
local function TypeComp(a, b)
	local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
	if res~=nil then return res end

	local namea, _, quala, _, _, typea, subtypea, _, equiploca = getCompInfo(linka)
	local nameb, _, qualb, _, _, typeb, subtypeb, _, equiplocb = getCompInfo(linkb)

	if typea ~= typeb then
		return (typea or "?") < (typeb or "?")
	end

	if (equiploca and equiplocs[equiploca]) and (equiplocb and equiplocs[equiplocb]) then
		if equiplocs[equiploca] ~= equiplocs[equiplocb] then
			return equiplocs[equiploca] < equiplocs[equiplocb]
		end
	end

	if quala~=qualb then
		return (quala or 0)  > (qualb or 0)
	end

	if namea ~= nameb then
		return (namea or "?")  < (nameb or "?")
	end

	local counta = select(2, GetContainerItemInfo(baga, slota))
	local countb = select(2, GetContainerItemInfo(bagb, slotb))
	return (counta or 0)  > (countb or 0)
end
local function SlotComp(a, b)
	local p = Baggins.db.profile
	if type(a) == "table" then
		a, b = (next(a.slots)), (next(b.slots))
	end
	local baga, slota = a:match("^(-?%d+):(%d+)$")
	local bagb, slotb = b:match("^(-?%d+):(%d+)$")
	if baga == bagb then
		slota = tonumber(slota)
		slotb = tonumber(slotb)
		return slota < slotb
	else
		return baga < bagb
	end
end
local function IlvlComp(a, b)
	local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
	if res~=nil then return res end

	local namea, _, quala = getCompInfo(linka)
	local nameb, _, qualb = getCompInfo(linkb)
	local ilvla = iui:GetUpgradedItemLevel(linka)
	local ilvlb = iui:GetUpgradedItemLevel(linkb)
	if ilvla~=ilvlb then
		return (ilvla or 0) > (ilvlb or 0)
	end

	if quala~=qualb then
		return (quala or 0) > (qualb or 0)
	end

	if namea ~= nameb then
		return (namea or "?")  < (nameb or "?")
	end

	local counta = select(2, GetContainerItemInfo(baga, slota))
	local countb = select(2, GetContainerItemInfo(bagb, slotb))
	return (counta  or 0) > (countb or 0)
end

function Baggins:SortItemList(itemlist, sorttype)
	local func
	if sorttype == "name" then
		func = NameComp
	elseif sorttype == "quality" then
		func = QualityComp
	elseif sorttype == "type" then
		func = TypeComp
	elseif sorttype == "slot" then
		func = SlotComp
	elseif sorttype == "ilvl" then
		func = IlvlComp
	else
		return
	end
	tsort(itemlist, func)
end


----------------------
-- ItemButton Funcs --
----------------------
function Baggins:UpdateItemButtons()
	for bagid, bag in ipairs(self.bagframes) do
		for sectionid, section in ipairs(bag.sections) do
			for buttonid, button in ipairs(section.items) do
				if button:IsVisible() then
					self:UpdateItemButton(bag,button,button:GetParent():GetID(),button:GetID())
				end
			end
		end
	end
end

function Baggins:UpdateItemButtonLocks()
	for bagid, bag in ipairs(self.bagframes) do
		for sectionid, section in ipairs(bag.sections) do
			for buttonid, button in ipairs(section.items) do
				if button:IsVisible() then
					local locked = select(3, GetContainerItemInfo(button:GetParent():GetID(), button:GetID()))
					SetItemButtonDesaturated(button, locked, 0.5, 0.5, 0.5)
				end
			end
		end
	end
end

function Baggins:UpdateItemButtonCooldowns()
	for bagid, bag in ipairs(self.bagframes) do
		for sectionid, section in ipairs(bag.sections) do
			for buttonid, button in ipairs(section.items) do
				if button:IsVisible() then
					local container = button:GetParent():GetID()
					local slot = button:GetID()
					local texture = GetContainerItemInfo(container, slot)
					if ( texture ) then
						self:UpdateItemButtonCooldown(container, button)
						button.hasItem = 1
					else
						_G[button:GetName().."Cooldown"]:Hide()
						button.hasItem = nil
					end
				end
			end
		end
	end
end

function Baggins:SetItemButtonCount(button, count, realcount)
	if not button then
		return
	end
	if not count then
		count = 0
	end
	local counttext = _G[button:GetName().."Count"]
	if button.countoverride then
		button.count = realcount
	else
		button.count = count
	end
	if type(count) == "string" then
		counttext:ClearAllPoints()
		counttext:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-5,2)
		counttext:SetText(count)
		counttext:Show()
	elseif ( count > 1 or (button.isBag and count > 0) ) then
		if ( count > 999 ) then
			count = (floor(count/100)/10).."k"
			counttext:ClearAllPoints()
			counttext:SetPoint("BOTTOM",button,"BOTTOM",0,2)
		else
			counttext:ClearAllPoints()
			counttext:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-5,2)
		end
		counttext:SetText(count)
		counttext:Show()
	else
		counttext:Hide()
	end
end

function Baggins:IsNew(itemid)
	local itemcounts = self.itemcounts
	itemid = tonumber(itemid) or tonumber(itemid:match("item:(%d+)"))
	if not itemid then
		return nil
	end
	local savedcount = itemcounts[itemid]
	if not savedcount then
		return 1	-- completely new
	else
		local count = GetItemCount(itemid)
		if count ~= savedcount.count
			and (self.db.profile.newitemduration > 0 and time() - savedcount.ts < self.db.profile.newitemduration) then
			return 2	-- more of an existing
		else
			return nil	-- not new
		end
	end
end

function Baggins:UpdateItemButton(bagframe,button,bag,slot)
	local p = self.db.profile
	if not C_NewItems.IsNewItem(bag, slot) then
		local newItemTexture = _G[button:GetName().."NewItemTexture"]
		if newItemTexture then
			newItemTexture:Hide()
		end
	end
	local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot)
	local link = GetContainerItemLink(bag, slot)
	local itemid
	if link then
		local qual = select(3, GetItemInfo(link))
		quality = qual or quality
		itemid = tonumber(link:match("item:(%d+)"))
	end
	button:SetID(slot)
	-- quest item glow introduced in 3.3 (with silly logic)
	-- local isQuestItem, questId, isActive = GetContainerItemQuestInfo(bag, slot)
	-- local questTexture = (questId and not isActive) and TEXTURE_ITEM_QUEST_BANG or (questId or isQuestItem) and TEXTURE_ITEM_QUEST_BORDER
	-- if p.highlightquestitems and texture and questTexture then
	-- 	button.glow:SetTexture(questTexture)
	-- 	button.glow:SetVertexColor(1,1,1)
	-- 	button.glow:SetAlpha(1)
	-- 	button.glow:Show()
	-- else
	if p.qualitycolor and texture and quality >= p.qualitycolormin then
		local r, g, b = GetItemQualityColor(quality)
		button.glow:SetTexture("Interface\\Addons\\Baggins\\Textures\\Glow")
		button.glow:SetVertexColor(r,g,b)
		button.glow:SetAlpha(p.qualitycolorintensity)
		button.glow:Show()
	else
		button.glow:Hide()
	end
	local text = button.newtext
	if p.highlightnew and itemid and not LBU:IsBank(bag) then
		local isNew = self:IsNew(itemid)
		if isNew == 1 then
			text:SetText(L["*New*"])
			text:Show()
		elseif isNew == 2 then
			text:SetText("*+++*")
			text:Show()
		else
			text:Hide()
		end
	else
		text:Hide()
	end

	if not bagframe.bagparents[bag] then
		bagframe.bagparents[bag] = CreateFrame("Frame",nil,bagframe)
		bagframe.bagparents[bag]:SetID(bag)
	end
	button:SetParent(bagframe.bagparents[bag])
	if texture then
		SetItemButtonTexture(button, texture)
	elseif self.currentSkin and self.currentSkin.EmptySlotTexture then
		SetItemButtonTexture(button, self.currentSkin.EmptySlotTexture)
	else
		SetItemButtonTexture(button, nil)
	end
	if button.countoverride then
		local count
		if not itemid then
			local bagtype, itemFamily = Baggins:IsSpecialBag(bag)
			bagtype = bagtype or ""
			count = bagtype..LBU:CountSlots(LBU:IsBank(bag) and "BANK" or "BAGS", itemFamily)
		else
			count = GetItemCount(itemid)
			if LBU:IsBank(bag) then
				count = GetItemCount(itemid,true) - count
			end
			if IsEquippedItem(itemid) then
				count = count - 1
			end
		end
		self:SetItemButtonCount(button, count, itemCount)
	else
		self:SetItemButtonCount(button, itemCount)
	end
	SetItemButtonDesaturated(button, locked, 0.5, 0.5, 0.5)

	if ( texture ) then
		self:UpdateItemButtonCooldown(bag, button)
		button.hasItem = 1
	else
		_G[button:GetName().."Cooldown"]:Hide()
		button.hasItem = nil
	end
	if button.tainted then
		button.icon:SetAlpha(0.3)
	else
		button.icon:SetAlpha(1)
	end

	button.readable = readable
	--local normalTexture = getglobal(name.."Item"..j.."NormalTexture")
	--if ( quality and quality ~= -1) then
	--	local color = getglobal("ITEM_QUALITY".. quality .."_COLOR")
	--	normalTexture:SetVertexColor(color.r, color.g, color.b)
	--else
	--	normalTexture:SetVertexColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
	--end
	--[[
	if button:GetParent():GetID() == -1 then
		if ( not GameTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(button:GetID(),button.isBag)) ) then
			if ( self.isBag ) then
				GameTooltip:SetText(self.tooltipText);
			end
		end
		CursorUpdate();
		return
	end

	local showSell = nil;
	local hasCooldown, repairCost = GameTooltip:SetBagItem(button:GetParent():GetID(), button:GetID());
	if ( InRepairMode() and (repairCost and repairCost > 0) ) then
		GameTooltip:AddLine(REPAIR_COST, "", 1, 1, 1);
		SetTooltipMoney(GameTooltip, repairCost);
		GameTooltip:Show();
	elseif ( MerchantFrame:IsShown() and MerchantFrame.selectedTab == 1 and not button.locked ) then
		showSell = 1;
	end

	if ( IsModifiedClick("DRESSUP") and button.hasItem ) then
		ShowInspectCursor();
	elseif ( showSell ) then
		ShowContainerSellCursor(button:GetParent():GetID(),button:GetID());
	elseif ( button.readable ) then
		ShowInspectCursor();
	else
		ResetCursor();
	end]]

	self:FireSignal("Baggins_ItemButtonUpdated", bagframe, button, bag, slot)
end

function Baggins:UpdateItemButtonCooldown(container, button)
	local cooldown = _G[button:GetName().."Cooldown"]
	local start, duration, enable = GetContainerItemCooldown(container, button:GetID())

	-- CooldownFrame_SetTimer has been renamed to CooldownFrame_Set in 7.0
	-- We'll check for the new name and use it if it's available. This lets the patch
	-- work with both 6.2 and 7.0.
	local setTimer = nil
	if (CooldownFrame_Set ~= nil) then
		setTimer = CooldownFrame_Set
	else
		setTimer = CooldownFrame_SetTimer
	end
	setTimer(cooldown, start, duration, enable)

	if ( duration > 0 and enable == 0 ) then
		SetItemButtonTextureVertexColor(button, 0.4, 0.4, 0.4)
	end
end