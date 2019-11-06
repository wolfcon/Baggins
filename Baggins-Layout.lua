local _G = _G
local Baggins = _G.Baggins

local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")
local LBU = LibStub("LibBagUtils-1.0")
local gratuity = LibStub("LibGratuity-3.0")


local next, pairs, ipairs, tonumber, select, wipe, type, print =
      _G.next, _G.pairs, _G.ipairs, _G.tonumber, _G.select, _G.wipe, _G.type, _G.print
local min, max, ceil, floor, mod  =
      _G.min, _G.max, _G.ceil, _G.floor, _G.mod
local tinsert, tremove, tsort =
      _G.tinsert, _G.tremove, _G.table.sort
local format =
      _G.string.format

local GetItemInfo, GetItemQualityColor, BankButtonIDToInvSlotID, GetNumBankSlots =
      _G.GetItemInfo, _G.GetItemQualityColor, _G.BankButtonIDToInvSlotID, _G.GetNumBankSlots
local GetContainerItemInfo, GetContainerItemLink =
      _G.GetContainerItemInfo, _G.GetContainerItemLink
local C_Item, ItemLocation, InCombatLockdown, IsModifiedClick, GetDetailedItemLevelInfo, GetContainerItemID, InRepairMode, KeyRingButtonIDToInvSlotID, PlaySound =
      _G.C_Item, _G.ItemLocation, _G.InCombatLockdown, _G.IsModifiedClick, _G.GetDetailedItemLevelInfo, _G.GetContainerItemID, _G.InRepairMode, _G.KeyRingButtonIDToInvSlotID, _G.PlaySound

------------------------
-- Section/Bag Layout --
------------------------

local catsorttable = {}

function Baggins:GetSectionSize(sectionframe, maxcols)
	local count
	local bagconf = self.db.profile.bags[sectionframe.bagid]
	if not bagconf then return 0,0 end
	local sectionconf = bagconf.sections[sectionframe.secid]
	if not sectionconf then return 0,0 end
	if sectionconf.hidden then
		count = 0
	else
		count = sectionframe.itemcount
	end
	maxcols = maxcols or count
	local columns = min(count, maxcols)
	local rows = ceil(count / maxcols)
	local width = columns * 39 - 2
	local height = rows * 39 - 2
	-- Flow requires we still get a height
	if maxcols < 1 then-- and not self.db.profile.flow_sections then
		height = 0
	end

	if self.db.profile.showsectiontitle then
		width = max(width, sectionframe.title:GetWidth())
		height = height + sectionframe.title:GetHeight()
	end

	return width, height, columns, rows
end


-- Flow layout
function Baggins:FlowSections(bagid)
	-- Bag references
	local bag = self.bagframes[bagid]
	local sections_conf = self.db.profile.bags[bagid].sections
	local skin = self.currentSkin
	-- Bag dimensions
	local width, height = 0, 0
	local xoff, yoff = skin.BagLeftPadding, -skin.BagTopPadding
	local max_cols = self.db.profile.columns
	-- Flow data
	local flow_x, flow_y, flow_anchor = 0, 0
	local flow_items, flow_sections, max_sections = 0, 0, 0
	local bagempty = true

	-- Like a river, man. LIKE A RIVER DO YOU HEAR ME
	for id, section in ipairs(self.bagframes[bagid].sections) do
		if section.used and section.itemcount > 0 then
			bagempty = false
			local available = max_cols - flow_items

			-- Give collapsed sections a virtual size to account for title length
			local x, y, section_items = self:GetSectionSize(section, max_cols)
			if not section_items then print('oops') return nil end
			local title_length = ceil(section.title:GetStringWidth()/39)
			if sections_conf[id] and sections_conf[id].hidden then
				section_items = title_length
			-- Account for long labels with one or two items
			else
				section_items = max(title_length, section_items)
			end
			flow_items = flow_items + section_items

			-- Add to last row
			if flow_anchor and available >= section_items then
				flow_sections = flow_sections + 1
				section:SetPoint("TOPLEFT", flow_anchor, "TOPLEFT", flow_x + 10, 0)
				flow_x = flow_x + x + 10
				flow_y = max(y, flow_y)

			else
				-- New row
				if flow_anchor then
					section:SetPoint("TOPLEFT", flow_anchor, "TOPLEFT", 0, -flow_y -5)
					y = y + 5
					max_sections = max(max_sections, flow_sections)
					height = height + flow_y + 5

				-- First row
				else
					section:SetPoint("TOPLEFT", bag, "TOPLEFT", xoff, yoff)
					--height = height + y
				end

				-- Frame/flow Data
				flow_anchor = section
				flow_items = section_items
				flow_sections = 0
				flow_x = x
				flow_y = y
			end

			width = max(x, width, flow_x)
		end
	end

	if (self.db.profile.hideemptybags and bagempty) then
		bag.isempty = true
	end

	-- Dimensions
	return width + skin.BagLeftPadding + skin.BagRightPadding, height + flow_y + skin.BagTopPadding + skin.BagBottomPadding
end

local areas = {}
function Baggins:OptimizeSectionLayout(bagid)
	local bagframe = self.bagframes[bagid]
	if not bagframe then
		return
	end
	local p = self.db.profile
	local s = self.currentSkin
	local titlefactor = p.showsectiontitle and 1 or 0
	local totalwidth, totalheight = 0, 0

	for k in pairs(areas) do areas[k] = nil end

	tinsert(areas, format('0:0:%d:3000', self.db.profile.columns * 39))

	--self:Debug("**** Laying out bag #%d ***", bagid)
	local bagempty = true

	for secid,sectionframe in ipairs(bagframe.sections) do
		local count = sectionframe.itemcount
		if sectionframe.used and (count > 0 or not p.hideemptysections) then
			bagempty = false
			local minwidth = self:GetSectionSize(sectionframe, 1)
			local minheight = select(2, self:GetSectionSize(sectionframe))

			--[[
			self:Debug("Section #%d, %d item(s), title width: %q, min width: %q, min height: %q",
				secid,	sectionframe.itemcount, sectionframe.title:GetWidth(), minwidth,
				minheight)
			--]]

			sectionframe.layout_waste = nil
			sectionframe.layout_columns = nil
			sectionframe.layout_area_index = nil

			for areaid,area in pairs(areas) do
				--self:Debug("  Area #%d: %s", areaid, area)

				local area_w,area_h = area:match('^%d+:%d+:(%d+):(%d+)$')
				area_w = tonumber(area_w)
				area_h = tonumber(area_h)

				if area_w >= minwidth and area_h >= minheight then
					local cols = floor(area_w / 39)
					local width, height = self:GetSectionSize(sectionframe, cols)
					--self:Debug("    %d columns", cols)

					if area_h >= height then
						local waste = (area_w * area_h) - (width * height)
						--self:Debug("    area waste: %d", waste)

						if not sectionframe.layout_waste or waste < sectionframe.layout_waste then
							sectionframe.layout_waste = waste
							sectionframe.layout_columns = cols
							sectionframe.layout_areaid = areaid
							--self:Debug("    -> best fit")
						else
							--self:Debug("    -> do not fit")
						end

					else
						--self:Debug("  -> too short")
					end
				else
					--self:Debug("  -> too small")
				end
			end
			local areaid = sectionframe.layout_areaid
			local area_x, area_y, area_w, area_h = tremove(areas, areaid):match('^(%d+):(%d+):(%d+):(%d+)$')
			area_x = tonumber(area_x)
			area_y = tonumber(area_y)
			area_w = tonumber(area_w)
			area_h = tonumber(area_h)
			local cols = sectionframe.layout_columns
			local width, height = self:GetSectionSize(sectionframe, cols)
			sectionframe:SetPoint('TOPLEFT', bagframe, 'TOPLEFT', s.BagLeftPadding + area_x, - (s.BagTopPadding + area_y) )
			sectionframe:SetWidth(width)
			sectionframe:SetHeight(height)

			totalwidth = max(totalwidth, area_x + width)
			totalheight = max(totalheight,area_y + height)
			--self:ReallyLayoutSection(sectionframe, cols)

			width = width + 10
			height = height + 10
			if area_w - width >= 39 then
				local area = format('%d:%d:%d:%d', area_x + width, area_y, area_w - width, height)
				--self:Debug("Created new area: %s", area)
				tinsert(areas, area)
			end
			if area_h - height >= 39 then
				local area = format('%d:%d:%d:%d', area_x, area_y + height, area_w, area_h - height)
				--self:Debug("Created new area: %s", area)
				tinsert(areas, area)
			end
		end
	end
	if (p.hideemptybags and bagempty) then
		bagframe.isempty = true
	end
	return s.BagLeftPadding + s.BagRightPadding + totalwidth, s.BagTopPadding + s.BagBottomPadding + totalheight
end

function Baggins:UpdateBagFrameSize(bagid)
	local bagframe = self.bagframes[bagid]
	if not bagframe then return end
	bagframe.dirty = true
	self:ScheduleRefresh()
end

function Baggins:ReallyUpdateBagFrameSize(bagid)
	local bagframe = self.bagframes[bagid]
	if not bagframe then return end
	local p = self.db.profile
	local s = self.currentSkin

	--self:Debug('Updating bag #%d', bagid)
	bagframe.isempty = false

	local hpadding = s.BagLeftPadding + s.BagRightPadding
	local width = s.BagLeftPadding + s.TitlePadding
	local height = s.BagTopPadding + s.BagBottomPadding

	if not p.shrinkbagtitle then
		width = width + bagframe.title:GetStringWidth()
 	end

	local layout = p.section_layout or "flow"
	if layout == 'optimize' then
		local swidth, sheight = Baggins:OptimizeSectionLayout(bagid)
		width = max(width, swidth)
		height = max(height, sheight)
	elseif layout == 'flow' then
		local x, y = self:FlowSections(bagid)
		width = max(x, width)
		height = max(y, height)
	else
		local lastsection
		local bagempty = true
		for id,section in ipairs(bagframe.sections) do
			if section.used and (not p.hideemptysections or section.itemcount > 0) then
				bagempty = false
				if not lastsection then
					section:SetPoint("TOPLEFT",bagframe,"TOPLEFT",s.BagLeftPadding,-s.BagTopPadding)
				else
					section:SetPoint("TOPLEFT",lastsection,"BOTTOMLEFT",0,-5)
					height = height + 5
				end
				lastsection = section
				--self:ReallyLayoutSection(section)
				width = max(width,section:GetWidth()+hpadding)
				height = height + section:GetHeight()
			end
		end
		if (p.hideemptybags and bagempty) then
			bagframe.isempty = true
		end
	end

	if p.moneybag == bagid then
		bagframe.isempty = false
		BagginsMoneyFrame:SetParent(bagframe)
		BagginsMoneyFrame:ClearAllPoints()
		BagginsMoneyFrame:SetPoint("BOTTOMLEFT",bagframe,"BOTTOMLEFT",8,6)
		BagginsMoneyFrame:Show()
		width = max(BagginsMoneyFrame:GetWidth() + 16, width)
		height = height + 30
	end

	if p.bankcontrolbag == bagid then
		bagframe.isempty = false
		BagginsBankControlFrame:SetParent(bagframe)
		BagginsBankControlFrame:ClearAllPoints()
		BagginsBankControlFrame:SetPoint("BOTTOMLEFT",bagframe,"BOTTOMLEFT",12,8)
		BagginsBankControlFrame:Show()
		width = max(BagginsBankControlFrame:GetWidth() + 16, width)
		height = height + BagginsBankControlFrame:GetHeight()
	end

	if not p.shrinkwidth then
		width = max(p.columns*39 + hpadding, width)
	end

	if bagframe:GetWidth() ~= width or bagframe:GetHeight() ~= height then
		bagframe:SetWidth(width)
		bagframe:SetHeight(height)
		self.dirtyBagLayout = true
	end

	bagframe.dirty = nil
end

local sectionSortTab = {}
local function sectionComp(a, b)
    local bags = Baggins.db.profile.bags

    local bagA, secA = floor(a/1000), mod(a,1000)
    local bagB, secB = floor(b/1000), mod(b,1000)

    local PriA = (bags[bagA].priority or 1) + (bags[bagA].sections[secA].priority or 1)
    local PriB = (bags[bagB].priority or 1) + (bags[bagB].sections[secB].priority or 1)

    if PriA == PriB then
        return a < b
    else
        return PriA > PriB
    end
end

function Baggins:ResortSections()
    self.sectionOrderDirty = true
end

function Baggins:IsSlotMine(mybagid, mysecid, slot, wasMine)
	local p = self.db.profile
	if not p.hideduplicates or p.hideduplicates == "disabled" then
		return true
	end

	local bag = p.bags[mybagid]
	if not bag then return false end
	local section = bag.sections[mysecid]
	if not section then return false end

    if section.allowdupes then
        return true
    end

	if type(slot) == 'table' then
		for k, v in pairs(slot) do
			if v then
				slot = k
				break
			end
		end
	end

	--if self.sectionOrderDirty then
        local i = 1

        local numbags = #p.bags

    	if p.hideduplicates == true or p.hideduplicates == "global" then
            for bagid = 1, numbags do
                local numsections = #p.bags[bagid].sections
                local bag = p.bags[bagid]
                if bag then
                    for secid = 1, numsections do
                        local section = bag.sections[secid]
                        if not section.allowdupes then
                            sectionSortTab[i] = bagid*1000 + secid
                            i = i + 1
                        end
                    end
                end
            end
    	elseif p.hideduplicates == "bag" then
    	    local numsections = #p.bags[mybagid].sections
    	    local bag = p.bags[mybagid]
    	    if bag then
                for secid = 1, numsections do
                    local section = bag.sections[secid]
                    if not section.allowdupes then
                        sectionSortTab[i] = mybagid*1000 + secid
                        i = i + 1
                    end
                end
            end
    	end

        while sectionSortTab[i] do
            sectionSortTab[i] = nil
            i = i + 1
        end
        self.sectionOrderDirty = nil
    --end

    tsort(sectionSortTab, sectionComp)

	for i, v in ipairs(sectionSortTab) do
	    local bagid, secid = floor(v/1000), mod(v,1000)
	    local section = self.bagframes[bagid].sections[secid]
		if section and ((not wasMine and section.slots[slot]) or (wasMine and section.slots[slot] == false)) then
			if mybagid == bagid and mysecid == secid then
				return true
			else
				return false
			end
		end
	end
end

function Baggins:LayoutSection(sectionframe, title, cols)
	sectionframe.dirty = true
	sectionframe.set_title = title
	sectionframe.set_columns = cols
	self:ScheduleRefresh()
end

function Baggins:ReallyLayoutSection(sectionframe, cols)
	local bagid, secid = sectionframe.bagid, sectionframe.secid
	local p = self.db.profile
	local bagconf = p.bags[sectionframe.bagid]
	if not bagconf then return end
	local sectionconf = bagconf.sections[sectionframe.secid]
	if not sectionconf then return end
	local totalwidth, totalheight = 1,1
	local s = self.currentSkin
	cols = cols or sectionframe.set_columns or p.columns

	if p.showsectiontitle then
		totalheight = totalheight + s.SectionTitleHeight
	end
	sectionframe.itemcount = 0
	if sectionconf.hidden then
		for itemnum, itemframe in ipairs(sectionframe.items) do
			itemframe:Hide()
		end
		for k, v in ipairs(sectionframe.layout) do
			sectionframe.itemcount = sectionframe.itemcount + 1
		end
	else
		local itemnum = 1
		local itemframeno = 1
		local BaseTop
		if p.showsectiontitle then
			BaseTop = (sectionframe.title:GetHeight() + 1)
		else
			BaseTop = 0
		end
		for k, v in pairs(sectionframe.items) do
			v:Hide()
		end
		for k, v in ipairs(sectionframe.layout) do
			if (type(v) == "string" and self:IsSlotMine(bagid, secid, v, true)) or (type(v) == "table" and self:IsSlotMine(bagid, secid, v.slots)) then
				if type(v) == "table" then
					sectionframe.items[itemframeno] = sectionframe.items[itemframeno] or self:CreateItemButton(sectionframe,itemframeno)
					local itemframe = sectionframe.items[itemframeno]
					itemframeno = itemframeno + 1
					itemframe:SetPoint("TOPLEFT",sectionframe,"TOPLEFT",((itemnum-1)%cols)*39,-(BaseTop+(floor((itemnum-1)/cols)*39)))
					local bag, slot, itemid = Baggins:GetSlotInfo(next(v.slots))
					if v.slotcount > 1 or ((p.compressall or p.compressempty) and not itemid) then
						itemframe.countoverride = true
					else
						itemframe.countoverride = nil
					end
					if not itemframe.slots then
						itemframe.slots = {}
					else
						wipe(itemframe.slots)
					end
					for slot in pairs(v.slots) do
						tinsert(itemframe.slots, slot)
					end
					self:UpdateItemButton(sectionframe:GetParent(),itemframe,tonumber(bag),tonumber(slot))

					itemframe:Show()
				end
				sectionframe.itemcount = sectionframe.itemcount + 1
				if itemnum == 1 then
					totalwidth = 39
					totalheight = totalheight+39
				elseif itemnum%cols == 1 then
					totalheight = totalheight+39
				else
					if itemnum <= cols then
						totalwidth = totalwidth+39
					end
				end
				itemnum = itemnum + 1
			end
		end
		-- cleaning up unused itembuttons
		for i = itemframeno,#sectionframe.items do
			local unusedframe = tremove(sectionframe.items, itemframeno)
			self:ReleaseItemButton(unusedframe)
		end
	end

	if p.showsectiontitle then
		local title = sectionframe.set_title
		if sectionconf.hidden then
			title = ("+ %s (%d)"):format(title, sectionframe.itemcount)
		else
			title = ("- %s"):format(title)
		end
		sectionframe.title:SetText(title)
		totalwidth = max(totalwidth,sectionframe.title:GetWidth())
	else
		sectionframe.title:SetText("")
	end

	if sectionframe.itemcount == 0 and p.hideemptysections then
		totalheight = 1
		sectionframe:Hide()
	end

	if sectionframe:GetWidth() ~= totalwidth or sectionframe:GetHeight() ~= totalheight then
		sectionframe:SetWidth(totalwidth)
		sectionframe:SetHeight(totalheight)
		self.bagframes[sectionframe.bagid].dirty = true
	end

	sectionframe.dirty = nil
end

---------------------
-- Frame Creation  --
---------------------
function Baggins:CreateBagPlacementFrame()
local f = CreateFrame("frame","BagginsBagPlacement",UIParent)

	f:SetWidth(130)
	f:SetHeight(300)
	f:SetPoint("CENTER",UIParent,"CENTER",0,0)
	f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	                                            edgeFile = false,
	                                            edgeSize = 0,
	                                            insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	f:SetBackdropColor(0.2,0.5,1,0.5)

	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetResizable(true)
	f:SetClampedToScreen(true)
	f:SetScript("OnMouseDown",function(this, button) if button == "RightButton" then this:Hide() else this:StartMoving() end end)
	f:SetScript("OnMouseUp", function(this) this:StopMovingOrSizing() self:SaveBagPlacement() end)

	f.t = CreateFrame("frame","BagginsBagPlacementTopMover",f)
	f.t:SetPoint("TOPLEFT",f,"TOPLEFT",0,0)
	f.t:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,0)
	f.t:SetHeight(20)
	f.t:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	                                            edgeFile = false,
	                                            edgeSize = 0,
	                                            insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	f.t:SetBackdropColor(0,0,1,1)
	f.t:EnableMouse(true)
	f.t:SetScript("OnMouseDown",function(this) this:GetParent():StartSizing("TOP") end)
	f.t:SetScript("OnMouseUp", function(this) this:GetParent():StopMovingOrSizing() self:SaveBagPlacement() end)

	f.b = CreateFrame("frame","BagginsBagPlacementTopMover",f)
	f.b:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0)
	f.b:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,0)
	f.b:SetHeight(20)
	f.b:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	                                            edgeFile = false,
	                                            edgeSize = 0,
	                                            insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	f.b:SetBackdropColor(0,0,1,1)
	f.b:EnableMouse(true)
	f.b:SetScript("OnMouseDown",function(this) this:GetParent():StartSizing("BOTTOM") end)
	f.b:SetScript("OnMouseUp", function(this) this:GetParent():StopMovingOrSizing() self:SaveBagPlacement() end)

	f.midtext = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	f.midtext:SetText(L["Drag to Move\nRight-Click to Close"])
	f.midtext:SetPoint("LEFT",f,"LEFT",0,0)
	f.midtext:SetPoint("RIGHT",f,"RIGHT",0,0)
	f.midtext:SetHeight(45)
	f.midtext:SetVertexColor(1, 1, 1)

	f.toptext = f.t:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	f.toptext:SetText(L["Drag to Size"])
	f.toptext:SetPoint("TOPLEFT",f,"TOPLEFT",0,-2)
	f.toptext:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,-2)
	f.toptext:SetHeight(15)
	f.toptext:SetVertexColor(1, 1, 1)

	f.bottext = f.b:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	f.bottext:SetText(L["Drag to Size"])
	f.bottext:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,2)
	f.bottext:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,2)
	f.bottext:SetHeight(15)
	f.bottext:SetVertexColor(1, 1, 1)
end

local function BagginsItemButton_OnEnter(button)
	if ( not button ) then
		button = this
	end

	local x
	x = button:GetRight()
	if ( x >= ( GetScreenWidth() / 2 ) ) then
		GameTooltip:SetOwner(button, "ANCHOR_LEFT")
	else
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	end

	-- Keyring specific code
	button:UpdateTooltip()

end

local KEYRING_CONTAINER = KEYRING_CONTAINER

local function showBattlePetTooltip(link)
	local speciesID, level, quality, maxHealth, power, speed = getBattlePetInfoFromLink(link)
	BattlePetToolTip_Show(speciesID, level, quality, maxHealth, power, speed)
end

local function BagginsItemButton_UpdateTooltip(button)
	if ( button:GetParent():GetID() == KEYRING_CONTAINER ) then
		GameTooltip:SetInventoryItem("player", KeyRingButtonIDToInvSlotID(button:GetID(),button.isBag))
		CursorUpdate(button)
		return
	end
	local hasItem, hasCooldown, repairCost
	if button:GetParent():GetID() == -1 then
		if ( not GameTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(button:GetID(),button.isBag)) ) then
			if ( button.isBag ) then
				GameTooltip:SetText(button.tooltipText);
			end
		end
		CursorUpdate(button);
		return
	end


	local showSell = nil;
	local itemlink = GetContainerItemLink(button:GetParent():GetID(), button:GetID())
	if itemlink and itemlink:match("battlepet:") then
		showBattlePetTooltip(itemlink)
		return
	end
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
	end
end

do
	local menu = {}

	local function includeItemInCategory(info, itemID)
		Baggins:IncludeItemInCategory(info.value, itemID)
	end

	local function excludeItemFromCategory(info, itemID)
		Baggins:ExcludeItemFromCategory(info.value, itemID)
	end

	local useButton = CreateFrame("Button", "BagginsUseItemButton", UIParent, "SecureActionButtonTemplate")
	useButton:SetAttribute("type", "item")
	useButton:SetAttribute("item", nil)
	useButton:Hide()

	local function reallyHideUseButton()
		useButton:ClearAllPoints()
		useButton:SetAttribute("item", nil)
		useButton:UnregisterAllEvents()
		useButton:Hide()
		Baggins:Unhook(_G["DropDownList1Button" .. useButton.owner], "OnHide")
		useButton.owner = nil
	end

	useButton:SetScript("OnEvent", function(self, event)
		UIDropDownMenu_Refresh(Baggins_ItemMenuFrame)
		if event == "PLAYER_REGEN_DISABLED" then
			self:Hide()
		elseif event == "PLAYER_REGEN_ENABLED" then
			if self.hideaftercombat then
				reallyHideUseButton()
				return
			end
			self:Show()
		end
	end)

	useButton:SetScript("OnEnter", function(self)
		local button = _G["DropDownList1Button" .. self.owner]
		button:GetScript("OnEnter")(button)
	end)

	useButton:SetScript("OnLeave", function(self)
		local button = _G["DropDownList1Button" .. self.owner]
		button:GetScript("OnLeave")(button)
	end)

	useButton:HookScript("OnClick", function(self)
		local button = _G["DropDownList1Button" .. self.owner]
		button:GetScript("OnClick")(button)
	end)

	local function hideUseButton()
		if InCombatLockdown() then
			useButton.hideaftercombat = true
			return
		end
		reallyHideUseButton()
	end

	local function showUseButton(bag, slot)
		useButton:SetAttribute("item", ("%d %d"):format(bag, slot))
		useButton:ClearAllPoints()
		local button = _G["DropDownList1Button" .. useButton.owner]
		useButton:SetAllPoints(button)
		useButton:SetFrameStrata(button:GetFrameStrata())
		useButton:SetFrameLevel(button:GetFrameLevel()+1)
		useButton:SetToplevel(true)
		useButton:RegisterEvent("PLAYER_REGEN_ENABLED")
		useButton:RegisterEvent("PLAYER_REGEN_DISABLED")
		useButton:Show()
		Baggins:SecureHookScript(button, "OnHide", hideUseButton)
	end

	local addCategoryIndex
	local excludeCategoryIndex
	-- some code to make the UIDropDownMenu scrollable
	local offset = 0
	local switchpage
	local function pageup(self)
		offset = max(offset - 1,0)
		switchpage(self)
	end
	local function pagedown(self)
		offset = min(offset + 1, #catsorttable)
		switchpage(self)
	end
	function switchpage(self)
		-- check if it's one of the category-menus
		if self.parentID ~= addCategoryIndex and self.parentID ~= excludeCategoryIndex then
			offset = 0
			return
		end
		if offset < 0 then
			offset = 0
		end
		local maxoffset = #catsorttable - 20
		if offset > maxoffset then
			offset = maxoffset
		end
		for x = 1,20 do
			local y = x + offset
			local newtext
			local button = _G[self:GetName() .. "Button" .. x]
			if x == 1 and offset > 0 then
				newtext = "..."
				button.func = pageup
				button.keepShownOnClick = true
			elseif x == 20 and y < #catsorttable then
				newtext = "..."
				button.func = pagedown
				button.keepShownOnClick = true
			else
				newtext = catsorttable[y] or ""
				button.func = menu[self.parentID].menuList[2].func
				button.keepShownOnClick = false
			end
			button:SetText(newtext)
			button.value = newtext
		end
		UIDropDownMenu_Refresh(Baggins_ItemMenuFrame)
	end

	function makeMenu(bag, slot)
		wipe(menu)
		if not LBU:IsBank(bag) then
			local use = {
				text = L["Use"],
				tooltipTitle = L["Use"],
				tooltipText = L["Use/equip the item rather than bank/sell it"],
				-- tooltipOnButton = true,
				notCheckable = true,
				disabled = InCombatLockdown(),
				func = function()
					if InCombatLockdown() then
						print("Baggins: Could not use item because you are in combat.")
					end
				end,
			}
			tinsert(menu, use)
			useButton.owner = #menu
		end

		local addToCatMenu = {
			text = L["Add To Category"],
			hasArrow = true,
			menuList = {},
			notCheckable = true,
		}
		tinsert(menu, addToCatMenu)
		addCategoryIndex = #menu

		local excludeFromCatMenu = {
			text = L["Exclude From Category"],
			hasArrow = true,
			notCheckable = true,
			menuList = {},
		}
		tinsert(menu, excludeFromCatMenu)
		excludeCategoryIndex = #menu

    local itemID
		local _, itemCount, _, itemQuality, _, _, itemLink = GetContainerItemInfo(bag, slot)
    if itemLink then
      itemID = C_Item.GetItemID(ItemLocation:CreateFromBagAndSlot(bag, slot))
    end
		local itemName, _, _, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc = GetItemInfo(itemLink)
		if not itemName then
			itemName, _, _, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc = GetItemInfo(itemID)
			itemLink = itemID
		end

		local itemInfo = {
			text = L["Item Info"],
			hasArrow = true,
			notCheckable = true,
			menuList = {
				{ text = L["ItemID: "]..itemID, notCheckable = true },
			},
		}

		if itemType then
			tinsert(itemInfo.menuList, { text = L["Item Type: "]..itemType, notCheckable = true })
			tinsert(itemInfo.menuList, { text = L["Item Subtype: "]..itemSubType, notCheckable = true })
		end
		tinsert(itemInfo.menuList, { text = L["Quality: "].._G["ITEM_QUALITY" .. itemQuality .. "_DESC"], notCheckable = true })
		if itemLevel and itemLevel > 1 then
			local effectiveItemLevel = GetDetailedItemLevelInfo(itemLink)
			if itemLevel ~= effectiveItemLevel then
				itemLevel = ("%d (%d)"):format(itemLevel, effectiveItemLevel)
			end
			tinsert(itemInfo.menuList, { text = L["Item Level: "]..itemLevel, notCheckable = true })
		end
		if itemMinLevel and itemMinLevel > 1 then
			tinsert(itemInfo.menuList, { text = L["Required Level: "]..itemMinLevel, notCheckable = true })
		end
		if itemStackCount and itemStackCount > 1 then
			tinsert(itemInfo.menuList, { text = L["Stack Size: "]..itemStackCount, notCheckable = true })
		end
		if itemEquipLoc and itemEquipLoc ~= "" then
			tinsert(itemInfo.menuList, { text = L["Equip Location: "]..(_G[itemEquipLoc] or itemEquipLoc), notCheckable = true })
		end
		-- tinsert(itemInfo.menuList, { text = ("Bag Location: %d %d"):format(bag, slot), notCheckable = true })

		tinsert(menu, itemInfo)
		local categories = Baggins.db.profile.categories
		while #catsorttable > 0 do
			tremove(catsorttable,#catsorttable)
		end
		for catid in pairs(categories) do
			tinsert(catsorttable,catid)
		end
		tsort(catsorttable)
		for i, name in ipairs(catsorttable) do
			if i == 20 and #catsorttable > 20 then
				addToCatMenu.menuList[i] = {
					text= " ...",
					notCheckable = true,
					func = pagedown,
					keepShownOnClick = true,
				}
				excludeFromCatMenu.menuList[i] = {
					text = "...",
					notCheckable = true,
					func = pagedown,
					keepShownOnClick = true,
				}
				break
			end
			addToCatMenu.menuList[i] = {
				text = name,
				notCheckable = true,
				func = includeItemInCategory,
				arg1 = itemID,
			}
			excludeFromCatMenu.menuList[i] = {
				text = name,
				notCheckable = true,
				func = excludeItemFromCategory,
				arg1 = itemID,
			}
		end
		DropDownList2:EnableMouseWheel(true)
		DropDownList2:SetScript("OnMouseWheel", function(self, delta)
			offset = offset - delta
			switchpage(self)
		end)
		return menu
	end

	local itemDropdownFrame = CreateFrame("Frame", "Baggins_ItemMenuFrame", UIParent, "UIDropDownMenuTemplate")

	local function BagginsItemButton_GetTargetBankTab(bag, slot)
		-- There's likely a better way then looking at the tooltip

		-- setup gratuity based on bag and slot
		if LBU:IsBank(bag) then
			gratuity:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
		else
			gratuity:SetBagItem(bag, slot)
		end

		return BANK_TAB
	end

	local function BagginsItemButton_OnClick(button)
		local bag = button:GetParent():GetID()
		local slot = button:GetID()
		UseContainerItem(bag, slot, nil, true)

		button:SetScript("OnClick",button.origOnClick)
		button.origOnClick = nil
	end


	local function BagginsItemButton_PreClick(button)
		if GetMouseButtonClicked() == "RightButton" and button.tainted then
			print("|cff00cc00Baggins: |cffffff00Right-clicking this button will not work until you leave combat|r")
		end
		for i, v in ipairs(button.slots) do
			local bag, slot = Baggins:GetSlotInfo(v)
			local locked =select(3, GetContainerItemInfo(bag, slot))
			if not locked then
				button:SetID(slot)
				local bagframe = button:GetParent():GetParent()
				if not bagframe.bagparents[bag] then
					bagframe.bagparents[bag] = CreateFrame("Frame",nil,bagframe)
					bagframe.bagparents[bag]:SetID(bag)
				end
				button:SetParent(bagframe.bagparents[bag])
				break
			end
		end
		if (IsControlKeyDown() or IsAltKeyDown()) and GetMouseButtonClicked() == "RightButton" then
			local bag = button:GetParent():GetID();
			local slot = button:GetID();
			local itemid = GetContainerItemID(bag, slot)
			if itemid then
				if DropDownList1:IsShown() then
					DropDownList1:Hide()
					return
				end
				makeMenu(bag, slot)
				EasyMenu(menu, itemDropdownFrame, "cursor", 0, 0, "MENU")
				-- make sure we restore the original scroll-wheel behavior for the DropdownList2-Frame
				-- when the item-dropdown is closed
				Baggins:SecureHookScript(DropDownList1, "OnHide", function(self)
					DropDownList2:EnableMouseWheel(false)
					DropDownList2:SetScript("OnMouseWheel", nil)
					Baggins:Unhook(DropDownList1, "OnHide")
				end)

				if not LBU:IsBank(bag) and not InCombatLockdown() then
					showUseButton(bag, slot)
				else
					hideUseButton()
				end
			end
		end
	end

	function Baggins:CreateItemButton(sectionframe,item)
		local frame = Baggins:GetItemButton()
		frame.glow = frame.glow or frame:CreateTexture(nil,"OVERLAY")
		frame.glow:SetTexture("Interface\\Addons\\Baggins\\Textures\\Glow")
		frame.glow:SetAlpha(0.3)
		frame.glow:SetAllPoints(frame)

		frame.newtext = frame.newtext or frame:CreateFontString(frame:GetName().."NewText","OVERLAY","GameFontNormal")
		frame.newtext:SetPoint("TOP",frame,"TOP",0,0)
		frame.newtext:SetHeight(13)
		frame.newtext:SetTextColor(0,1,0,1)
		frame.newtext:SetShadowColor(0,0,0,1)
		frame.newtext:SetShadowOffset(1,-1)
		frame.newtext:SetText("*New*")
		frame.newtext:Hide()

		frame:ClearAllPoints()
		local cooldown = _G[frame:GetName().."Cooldown"]
		cooldown:SetAllPoints(frame)
		cooldown:SetFrameLevel(10)
		frame:SetFrameStrata("HIGH")
		frame:SetScript("OnEnter",BagginsItemButton_OnEnter)
		frame:SetScript("PreClick",BagginsItemButton_PreClick)
		frame.UpdateTooltip = BagginsItemButton_UpdateTooltip
		if frame.BattlepayItemTexture then
			-- New blue glow introduced in 6.0. Purposely keeping this conditional - it smells like something that could change name or get removed in a future patch.
			frame.BattlepayItemTexture:Hide()
		end
		--frame:SetScript("OnUpdate",BagginsItemButton_OnUpdate)
		if self.currentSkin then
			self.currentSkin:SkinItem(frame)
		end
		frame:Show()
		return frame
	end
end

do
	local dropdown = CreateFrame("Frame", "BagginsCategoryAddDropdown")
	local info = { }

	local function Close()
		CloseDropDownMenus()
	end

	local function Click(dropdown, arg1, arg2)
		Baggins:IncludeItemInCategory(arg1, arg2)
		Baggins:UpdateBags()
	end

	local dd_categories, dd_id
	dropdown.initialize = function(self, level)

		-- Title
		wipe(info)
		info.text = L["Add To Category"]
		info.isTitle = true
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, 1)

		-- Categories
		for k, v in ipairs(dd_categories) do
			wipe(info)
			info.text = v
			info.arg1 = v
			info.arg2 = dd_id
			info.func = Click
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, 1)
		end

		-- Close
		wipe(info)
		info.text = "|cff777777"..L["Close"]
		info.func = Close
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, 1)
	end

	local function RecieveDrag(self)
		local section = self:GetParent()
		local categories = Baggins.db.profile.bags[section.bagid].sections[section.secid].cats
		local ctype, cid, clink = GetCursorInfo()
		if ctype ~= 'item' then return nil end
		if #categories == 1 then
			Click(nil, categories[1], cid)
		else
			dd_categories = categories
			dd_id = cid
			ToggleDropDownMenu(1, nil, BagginsCategoryAddDropdown, "UIParent", GetCursorPosition())
		end
		ClearCursor()
	end

	function Baggins:CreateSectionFrame(bagframe,secid)
		local frame = CreateFrame("Frame",bagframe:GetName().."Section"..secid,bagframe)

		frame.title = frame:CreateFontString(bagframe:GetName().."SectionTitle","OVERLAY","GameFontNormalSmall")
		frame.titleframe = CreateFrame("button",bagframe:GetName().."SectionTitleFrame",frame)
		frame.titleframe:SetAllPoints(frame.title)
		frame.titleframe:SetScript("OnClick", function(this) self:ToggleSection(this:GetParent()) end)
		frame.titleframe:SetScript("OnReceiveDrag", RecieveDrag)
		--[[
		frame.titleframe:SetScript("OnEnter", function(this) self:ShowSectionTooltip(this:GetParent()) end)
		frame.titleframe:SetScript("OnLeave", function(this) self:HideSectionTooltip(this:GetParent()) end)
		--]]
		frame:SetFrameStrata("HIGH")
		frame:Show()
		frame.items = {}
		frame.slots = {}
		frame.layout = {}
		frame.secid = secid
		frame.bagid = bagframe.bagid
		frame.itemcount = 0
		if self.currentSkin then
			self.currentSkin:SkinSection(frame)
		end

		return frame
	end
end

function Baggins:ToggleSection(sectionframe)
	local p = self.db.profile

	local bag = p.bags[sectionframe.bagid]
	if bag then
		local section = bag.sections[sectionframe.secid]
		if section then
			section.hidden = not section.hidden
			self:LayoutSection(sectionframe, section.name, p.columns)
			self:UpdateBagFrameSize(sectionframe.bagid)
		end
	end
end

function Baggins:CreateAllBags()
	for k, v in ipairs(self.db.profile.bags) do
		if not self.bagframes[k] then
			self:CreateBagFrame(k)
		end
	end
end

function Baggins:CreateBagFrame(bagid)
	if not bagid then return end
	local bagname = "BagginsBag"..bagid

	local frame = CreateFrame("Frame",bagname,UIParent)
	self.bagframes[bagid] = frame
	frame.bagid = bagid
	frame:SetToplevel(true)
	frame:SetWidth(100)
	frame:SetHeight(100)
	frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetScript("OnMouseDown",function(this,arg1)
		if arg1=="LeftButton" and not self:AreBagsLocked() then
			this:StartMoving()
		end
	end)
	frame:SetScript("OnMouseUp",function(this,arg1)
		if arg1=="LeftButton" then
			this:StopMovingOrSizing() self:SaveBagPosition(this.bagid)
		elseif arg1=="RightButton" then
			Baggins:DoBagMenu(frame);
		end
	end)
	frame:SetScript("OnShow",function() self:FireSignal("Baggins_BagOpened", frame); end)


	frame.closebutton = CreateFrame("Button",bagname.."CloseButton",frame,"UIPanelCloseButton")
	frame.closebutton:SetScript("OnClick", function(this)
		if IsShiftKeyDown() then
			self:CloseAllBags()
		else
  		    self:CloseBag(this:GetParent().bagid)
		end
	end)

	frame.compressbutton = CreateFrame("Button",bagname.."CompressButton",frame,nil);
	frame.compressbutton:Hide();
	frame.compressbutton:SetScript("OnClick", function()
		self:CompressBags(Baggins.db.profile.bags[frame.bagid].isBank);
	end)
	frame.compressbutton:SetScript("OnEnter", function(this)
		GameTooltip:SetOwner(this, 'ANCHOR_DEFAULT')
		GameTooltip:SetText(L["Compress bag contents"]);
		GameTooltip:Show();
	end)
	frame.compressbutton:SetScript("OnLeave", function(this)
		if(GameTooltip:IsOwned(this)) then
			GameTooltip:Hide();
		end
	end)
	frame.compressbutton:SetHeight(32);
	frame.compressbutton:SetWidth(32);
	frame.compressbutton:SetNormalTexture("Interface\\AddOns\\Baggins\\Textures\\compressbutton.tga");
	self:RegisterSignal("Baggins_CanCompress", function(self, bank, compressable)
			if Baggins.db.profile.bags[self.bagid] then
				if (not Baggins.db.profile.bags[self.bagid].isBank) == (not bank) then
					(compressable and self.compressbutton.Show or self.compressbutton.Hide)(self.compressbutton);
				end
			end
		end,
		frame
	);

	frame.title = frame:CreateFontString(bagname.."Title","OVERLAY","GameFontNormalLarge")
	frame.title:SetText("Baggins")
	frame:SetFrameStrata("HIGH")
	frame:SetClampedToScreen(true)
	frame:SetScale(self.db.profile.scale)
	frame.sections = {}
	frame.bagparents = {}

	if self.currentSkin then
		self.currentSkin:SkinBag(frame)
	end

	self:UpdateBagFrameSize(bagid)
	frame:Hide()
end

local function getsecond(_, value)
	return value
end

local function MoneyFrame_OnClick(button)
	local money = GetMoney()
	local multiplier
	if money < 100 then
		multiplier = 1
	elseif money < 10000 then
		multiplier = 100
	else
		multiplier = 10000
	end
	button.moneyType = "PLAYER"
	CoinPickupFrame:ClearAllPoints()
	OpenCoinPickupFrame(multiplier, money, button)
	button.hasPickup = 1

	CoinPickupFrame:ClearAllPoints()
	local frame = button

	if frame:GetCenter() < GetScreenWidth()/2 then
		if getsecond(frame:GetCenter()) < GetScreenHeight()/2 then
			CoinPickupFrame:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
		else
			CoinPickupFrame:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")
		end
	else
		if getsecond(frame:GetCenter()) < GetScreenHeight()/2 then
			CoinPickupFrame:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT")
		else
			CoinPickupFrame:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT")
		end
	end
end

function Baggins:CreateMoneyFrame()
	local frame = CreateFrame("Button","BagginsMoneyFrame",UIParent)
	frame:SetPoint("CENTER")
	frame:SetWidth(100)
	frame:SetHeight(18)
	frame:EnableMouse(true)
	frame:SetScript("OnClick",MoneyFrame_OnClick)
	local goldIcon = frame:CreateTexture("BagginsGoldIcon", "ARTWORK")
	goldIcon:SetWidth(16)
	goldIcon:SetHeight(16)
	goldIcon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
	goldIcon:SetTexCoord(0, 0.25, 0, 1)

	local silverIcon = frame:CreateTexture("BagginsSilverIcon", "ARTWORK")
	silverIcon:SetWidth(16)
	silverIcon:SetHeight(16)
	silverIcon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
	silverIcon:SetTexCoord(0.25, 0.5, 0, 1)

	local copperIcon = frame:CreateTexture("BagginsCopperIcon", "ARTWORK")
	copperIcon:SetWidth(16)
	copperIcon:SetHeight(16)
	copperIcon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
	copperIcon:SetTexCoord(0.5, 0.75, 0, 1)

	local goldText = frame:CreateFontString("BagginsGoldText", "OVERLAY")
	goldText:SetJustifyH("RIGHT")
	goldText:SetPoint("RIGHT", goldIcon, "LEFT", 0, 1)
	goldText:SetFontObject(GameFontNormal)

	local silverText = frame:CreateFontString("BagginsSilverText", "OVERLAY")
	silverText:SetJustifyH("RIGHT")
	silverText:SetPoint("RIGHT", silverIcon, "LEFT", 0, 1)
	silverText:SetFontObject(GameFontNormal)

	local copperText = frame:CreateFontString("BagginsCopperText", "OVERLAY")
	copperText:SetJustifyH("RIGHT")
	copperText:SetPoint("RIGHT", copperIcon, "LEFT", 0, 1)
	copperText:SetFontObject(GameFontNormal)

	copperIcon:SetPoint("RIGHT", frame, "RIGHT")
	silverIcon:SetPoint("RIGHT", copperText, "LEFT")
	goldIcon:SetPoint("RIGHT", silverText, "LEFT")
	frame:Hide()
end

function Baggins:UpdateMoneyFrame()

	local copper = GetMoney()
	local gold = floor(copper / 10000)
	local silver = mod(floor(copper / 100), 100)
	copper = mod(copper, 100)

	local width = 0

	if gold == 0 then
		BagginsGoldIcon:Hide()
		BagginsGoldText:Hide()
	else
		BagginsGoldIcon:Show()
		BagginsGoldText:Show()
		BagginsGoldText:SetWidth(0)
		BagginsGoldText:SetText(gold)
		width = width + BagginsGoldIcon:GetWidth() + BagginsGoldText:GetWidth()
	end
	if gold == 0 and silver == 0 then
		BagginsSilverIcon:Hide()
		BagginsSilverText:Hide()
	else
		BagginsSilverIcon:Show()
		BagginsSilverText:Show()
		BagginsSilverText:SetWidth(0)
		BagginsSilverText:SetText(silver)
		width = width + BagginsSilverIcon:GetWidth() + BagginsSilverText:GetWidth()
	end
	BagginsCopperIcon:Show()
	BagginsCopperText:Show()
	BagginsCopperText:SetWidth(0)
	BagginsCopperText:SetText(copper)
	width = width + BagginsCopperIcon:GetWidth() + BagginsCopperText:GetWidth()
	BagginsMoneyFrame:SetWidth(width)
end

function Baggins:CreateBankControlFrame()
	local frame = CreateFrame("Frame", "BagginsBankControlFrame", UIParent)
	frame:SetPoint("CENTER")
	frame:SetWidth(160)
	--frame:SetHeight((18 + 2) * 3)

	-- A button to allow purchase of bank slots
	-- Not super useful as you still require the default UI to place the bags,
	-- but can help as a reminder if a slot is not purchased with the default UI hidden.
	-- OnClick handler's are just like Blizzards default UI (see BankFrame.xml)
	frame.slotbuy = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.slotbuy:SetScript("OnClick", function(this)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		StaticPopup_Show("CONFIRM_BUY_BANK_SLOT");
	end)
	frame.slotbuy:SetWidth(160)
	frame.slotbuy:SetHeight(18)
	frame.slotbuy:SetText(L["Buy Bank Bag Slot"])
	frame.slotbuy:Hide()
end

function Baggins:UpdateBankControlFrame()
	local frame = BagginsBankControlFrame
	local numbuttons = 0
	local anchorframe = frame
	local anchorpoint = "TOPLEFT"
	local anchoryoffset = 0

	local _, full = GetNumBankSlots()
	if full then
		frame.slotbuy:Hide()
	else
		frame.slotbuy:SetPoint("TOPLEFT", anchorframe, anchorpoint, 0, anchoryoffset)
		frame.slotbuy:Show()

		numbuttons = numbuttons + 1
		anchorframe = frame.slotbuy
		anchorpoint = "BOTTOMLEFT"
		anchoryoffset = -2
	end

	frame:SetHeight((18 + 2) * numbuttons)
end

function Baggins:SetBagTitle(bagid,title)
	if self.bagframes[bagid] then
		self.bagframes[bagid].title:SetText(title)
		self:UpdateBagFrameSize(bagid)
	end
end

function Baggins:AreBagsLocked()
	return self.db.profile.lock or self.db.profile.layout == "auto"
end

function Baggins:UpdateLayout()
	if self.db.profile.layout == "auto" then
		self:LayoutBagFrames()
	else
		self:LoadBagPositions()
	end
end
