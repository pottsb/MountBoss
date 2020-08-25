local addonName, mb = ...

local frame = CreateFrame("FRAME", "MOUNTBOSSLISTENER_ACHIEVEMENTDATA")
local frame = CreateFrame("FRAME", "MOUNTBOSSLISTENER_MOUSEOVERUNIT")
MOUNTBOSSLISTENER_ACHIEVEMENTDATA:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
MOUNTBOSSLISTENER_MOUSEOVERUNIT:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

local MountBoss_AceComm = LibStub("AceAddon-3.0"):NewAddon("MountBoss", "AceComm-3.0")
local MountBoss_AceConfig = LibStub("AceConfig-3.0")
local MountBoss_AceIcon = LibStub("LibDBIcon-1.0")
local MountBoss_AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("MountBoss")

local GetComparisonStatistic = GetComparisonStatistic
local SetAchievementComparisonUnit = SetAchievementComparisonUnit

local function MountBossTooltip_SetDefaultAnchor(tooltip, parent)
   tooltip:SetOwner(parent, "ANCHOR_NONE")
   tooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y)
   tooltip.default = 1
end
MountBossTooltip_SetDefaultAnchor(GameTooltip, UIParent)

local function MountBossTooltip_AddTitle(tooltip)
   tooltip:AddLine(" ", 1, 1, 1)
   tooltip:AddLine(mb.const.TooltipPrefix, 1, 1, 1)
end

local function MountBossTooltip_AddLine(tooltip, line_content)
   tooltip:AddLine(line_content)
   tooltip:Show()
   
end

local function MountBossToolTip_Create(frame, title, line1, line2)
	GameTooltip:SetOwner(frame, "ANCHOR_BOTTOM")
	GameTooltip:SetText(title)
	GameTooltip:AddLine(line1)
	if line2 then GameTooltip:AddLine(line2) end 
	GameTooltip:Show()
end

local function MountBossDebug_DisplayData(debug_text)
   local backdrop = {
      bgFile = "Interface/BUTTONS/WHITE8X8",
      edgeFile = "Interface/GLUES/Common/Glue-Tooltip-Border",
      tile = true,
      edgeSize = 8,
      tileSize = 8,
      insets = {
         left = 5,
         right = 5,
         top = 5,
         bottom = 5,
      },
   }
   
   local f = CreateFrame("Frame", "MountBossDebug", UIParent)
   f:SetSize(150, 150)
   f:SetPoint("CENTER")
   f:SetFrameStrata("BACKGROUND")
   f:SetBackdrop(backdrop)
   f:SetBackdropColor(0, 0, 0)
   f.Close = CreateFrame("Button", "$parentClose", f)
   f.Close:SetSize(24, 24)
   f.Close:SetPoint("TOPRIGHT")
   f.Close:SetNormalTexture("Interface/Buttons/UI-Panel-MinimizeButton-Up")
   f.Close:SetPushedTexture("Interface/Buttons/UI-Panel-MinimizeButton-Down")
   f.Close:SetHighlightTexture("Interface/Buttons/UI-Panel-MinimizeButton-Highlight", "ADD")
   f.Close:SetScript("OnClick", function(self)
         self:GetParent():Hide()
   end)
   f.Select = CreateFrame("Button", "$parentSelect", f, "UIPanelButtonTemplate")
   f.Select:SetSize(85, 14)
   f.Select:SetPoint("RIGHT", f.Close, "LEFT")
   f.Select:SetText(L["GUI_DebugOutput_SelectAll"])
   f.Select:SetScript("OnClick", function(self)
         self:GetParent().Text:HighlightText()
         self:GetParent().Text:SetFocus()
   end)
   
   f.SF = CreateFrame("ScrollFrame", "$parent_DF", f, "UIPanelScrollFrameTemplate")
   f.SF:SetPoint("TOPLEFT", f, 12, -30)
   f.SF:SetPoint("BOTTOMRIGHT", f, -30, 10)
   f.Text = CreateFrame("EditBox", nil, f)
   f.Text:SetMultiLine(true)
   f.Text:SetSize(180, 170)
   f.Text:SetPoint("TOPLEFT", f.SF)
   f.Text:SetPoint("BOTTOMRIGHT", f.SF)
   f.Text:SetMaxLetters(99999)
   f.Text:SetFontObject(GameFontNormal)
   f.Text:SetAutoFocus(false)
   f.Text:SetScript("OnEscapePressed", function(self) self:ClearFocus() end) 
   f.SF:SetScrollChild(f.Text)
   f.Text:SetText(debug_text)
   f.Text:HighlightText()
   f.Text:SetScript("OnTextChanged", function(self, userinput) if userinput then f.Text:SetText(debug_text) f.Text:HighlightText() end end)
   
end

local function MountBossDebug_AppendData(input)
   if input == nil then input = "ERROR" end
   if mb.var.DebugText == "" then
      mb.var.DebugText = tostring(input)
   else
      mb.var.DebugText = mb.var.DebugText..","..tostring(input)
   end
end

local function MountBossDebug_OutputOMT() -- Dumps the player mount table into the debug string.
	MountBossDebug_AppendData("MB_OMTSTART")
	for var = 1,#mb.OwnedMountTable,1 do
		MountBossDebug_AppendData(mb.OwnedMountTable[var])
	end
	MountBossDebug_AppendData("MB_OMTEND")
end

function MountBoss_OutputModule(out, id, v1, v2, v3, v4)
   if out == "SAY" then
      MountBoss_OutputModule_Say(id, v1, v2, v3, v4)
   else
      MountBoss_OutputModule_Local(id, v1, v2, v3, v4)
   end
end

function MountBoss_OutputModule_Local(id, v1, v2, v3, v4)
   if id == "PM" then
      print(mb.const.LocalPrefix..L["OutputModuleLocalPM"](v1,v2,v3,v4))
   elseif id == "TM" then
	  print(mb.const.LocalPrefix..L["OutputModuleLocalTM"](v1,v2,v3,v4))
   elseif id == "SC" then  
      print(mb.const.LocalPrefix..L["OutputModuleLocalSC"](v1,v2))
   else
      if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Output Module confused.") end
   end
end

function MountBoss_OutputModule_Say(id, v1, v2, v3, v4)
   if id == "PM" then
      SendChatMessage(mb.const.SayPrefix..L["OutputModuleSayPM"](v1, v2, v3, v4))
   elseif id == "TM" then
	  SendChatMessage(mb.const.SayPrefix..L["OutputModuleSayTM"](v1,v2,v3))
   elseif id == "SC" then      
      SendChatMessage(mb.const.SayPrefix..L["OutputModuleSaySC"](v1,v2))
   else
      if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Output Module confused.") end
   end
end

local function CheckMountScore()
	if not mb.var.CalculateMountScoreComplete then 
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Calculating Mount Score") end
		CalculateScore()
	end
end

local function CheckMountTable()
	if not mb.var.BuildMountTableComplete then 
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Mount table empty. Filling table to get mount data.") end
		MountBoss_BuildMountTable()
	end
end

local function CheckMountData()
	if mb.var.BuildMountData == false then 
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Mount data empty. Gathering mount data.") end
		MountBoss_UpdateMountData()
	end

end

local function MountBossValidate_MouseOver()
   if UnitIsPlayer("mouseover") and mb.var.MouseOverToolTipTable[GetUnitName("mouseover", true)] ~= false and UnitFactionGroup("mouseover") == mb.var.PlayerFaction then
      return true
   else
      return false
   end
end

local function MountBossValidate_Target()
   if not UnitExists("target") then
      print(mb.const.LocalPrefix..L["Validation_TargetNoTarget"])
      return false
   elseif not UnitIsPlayer("target") then
      print(mb.const.LocalPrefix..L["Validation_TargetNPC"])
      return false
   elseif not UnitIsVisible("target") then
	  print(mb.const.LocalPrefix..GetUnitName("target")..L["Validation_TargetPhased"]"")
	  return false
   else
      return true
   end
end

local function PPSizeCalc(input)
    -- tested to be fair for gnomes.
   local player_mounts = tonumber(mb.var.MountsUOOC)
   local target_mounts = tonumber(input)
   if player_mounts > target_mounts then
      local diff = player_mounts - target_mounts
      local out = L["PPSizeCalc_MoreMounts"](diff)
      return out
   elseif target_mounts > player_mounts then
      local diff = target_mounts - player_mounts
      local out = L["PPSizeCalc_FewerMounts"](diff)
      return out
	elseif target_mounts == player_mounts then
		local out = L["PPSizeCalc_snap"](target_mounts) 
		return out
	else
	if MountBossDebug_Mode then print(mb.const.DebugPrefix.."mount int comparison failed :( ") end
	return ""
   end
end

function MountBoss_CreateMacros()
	--old icon "achievement_guildperk_mountup" 
	local macrosglobal, macroslocal = GetNumMacros() 
	if InCombatLockdown() then
		print(mb.const.LocalPrefix..L["Macro_ErrorCombat"])
	elseif macroslocal > 15 then
		print(mb.const.LocalPrefix..L["Macro_ErrorNoFreeSpace"])
	else
		if GetMacroIndexByName(L["Macro_Target"]) == 0 then local macroId = CreateMacro("Target MB", "Ability_mount_fireravengodmountpurple", L["Macro_TargetMacro"], 1) end
		if GetMacroIndexByName(L["Macro_Self"]) == 0 then local macroId = CreateMacro("Self MB", "Ability_mount_fireravengodmountpurple", L["Macro_SelfMacro"], 1) end
		if GetMacroIndexByName(L["Macro_Score"]) == 0 then local macroId = CreateMacro("Score MB", "Ability_mount_fireravengodmountpurple", L["Macro_ScoreMacro"], 1) end
		if GetMacroIndexByName(L["Macro_Toggle"]) == 0 then local macroId = CreateMacro("Toggle MB", "Ability_mount_fireravengodmountpurple", L["Macro_ToggleMacro"], 1) end
		print(mb.const.LocalPrefix..L["Macro_MacrosCreated"])
	end
end

local function GetUnitMounts(unit, callback)
	local unitname = GetUnitName(unit)
	if mb.var.ExternalMountsTotalTable[unitname] then
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Target is in mount table. No lookup has been performed.") end
			count = mb.var.ExternalMountsUOOCTable[unitname]
			callback(unit, count)
	else
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Target not in mount table. Looking up data.") end
		ClearAchievementComparisonUnit()
		SetAchievementComparisonUnit(unit)
		MOUNTBOSSLISTENER_ACHIEVEMENTDATA:SetScript("OnEvent", function(self)
			self:SetScript("OnEvent", nil)       
			local count = GetComparisonStatistic(339)
			if count == "--" then count = 0 end
			callback(unit, count)
   end)
	end
end

local function FindNextUnit(unittype, unitnum)
   unitnum = unitnum or 1
   if  unitnum == "41" then
      return "novalue"
   elseif GetUnitName(unittype..unitnum) == GetUnitName("player") then
      local NextUnit = unitnum + 1
      if UnitExists(unittype..NextUnit) then return FindNextUnit(unittype, NextUnit) end
   elseif UnitIsVisible(unittype..unitnum) then
      return unittype..unitnum      
   else
      if GetUnitName(unittype..unitnum) then 
		  print(mb.const.LocalPrefix..GetUnitName(unittype..unitnum)..L["Validation_TargetPhased"])
		  mb.var.GroupMountsOutofRange = mb.var.GroupMountsOutofRange + 1
	  end
      local NextUnit = unitnum + 1
      if UnitExists(unittype..NextUnit) then return FindNextUnit(unittype, NextUnit) end
   end
end

local function GetGroupMounts(unitType, callback)
   local results = {}
   local function OnUnitMountsReceived(unit, count)
      results[GetUnitName(unit, true)] = count
      mb.var.GroupMountsLoggedCount = mb.var.GroupMountsLoggedCount + 1
      local unitIndex = tonumber(string.match(unit, "(%d+)$"))
      local nextUnit  = unitType .. tostring(unitIndex + 1)
      local nextUnitIndex  = tostring(unitIndex + 1)
      local nextVisibleUnit = FindNextUnit(unitType,nextUnitIndex)
      if UnitExists(nextVisibleUnit) then
         GetUnitMounts(nextVisibleUnit, OnUnitMountsReceived)
      else
         callback(results)
      end
   end
   local firstUnit = FindNextUnit(unitType)
   if UnitExists(firstUnit) then
      GetUnitMounts(firstUnit, OnUnitMountsReceived)
   else
      callback(results)
   end
end

local function GetRaidMounts(callback)
   GetGroupMounts("raid", callback)
end

local function GetPartyMounts(callback)
   GetGroupMounts("party", callback)
end

local function OutputGroupMounts()
   if IsInRaid() then
	  local OwnedBy = 0
      mb.var.GroupMountsLoggedCount = 0
      mb.var.GroupMountsOutCount = 0
	  mb.var.GroupMountsOutofRange = 0
      GetRaidMounts(function(results)
            for member, count in pairs(results) do
				ExternalMountDataString = ""
				if mb.var.ExternalMountsTotalTable[member] then
					ExternalMountDataString = L["TargetMounts_TotalMounts"](member, mb.var.ExternalMountScoreTable[member], mb.var.ExternalPrestigeScoreTable[member], mb.var.ExternalMountsTotalTable[member])
				end
               print(mb.const.LocalPrefix..L["GroupMounts_DataOut"](member,count)..PPSizeCalc(count)..ExternalMountDataString)
               mb.var.GroupMountsOutCount = mb.var.GroupMountsOutCount + 1
			   if tonumber(count) >= tonumber(mb.var.MountsUOOC) then OwnedBy = OwnedBy + 1 end 
            end
			if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Logged count: "..mb.var.GroupMountsLoggedCount) end
			if mb.var.GroupMountsOutofRange == 0 then
			   print(mb.const.LocalPrefix..L["GroupMounts_GetDataSuccess"](mb.var.GroupMountsOutCount))
			else
			   print(mb.const.LocalPrefix..L["GroupMounts_GetDataIncomplete_Successful"](mb.var.GroupMountsOutCount))
			   print(mb.const.LocalPrefix..L["GroupMounts_GetDataIncomplete_Phased"](mb.var.GroupMountsOutofRange))
			end
			if OwnedBy == 0 and mb.var.GroupMountsOutofRange == 0 then print(mb.const.LocalPrefix..L["GroupMounts_MostMounts"]) end
            if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Group members(including yourself): "..GetNumGroupMembers()) end
      end)
   elseif IsInGroup() then
	  local OwnedBy = 0
      mb.var.GroupMountsLoggedCount = 0
      mb.var.GroupMountsOutCount = 0
	  mb.var.GroupMountsOutofRange = 0
      GetPartyMounts(function(results)
            for member, count in pairs(results) do
				ExternalMountDataString = ""
				if mb.var.ExternalMountsTotalTable[member] then
					ExternalMountDataString = L["TargetMounts_TotalMounts"](member, mb.var.ExternalMountScoreTable[member], mb.var.ExternalPrestigeScoreTable[member], mb.var.ExternalMountsTotalTable[member])
				end
               print(mb.const.LocalPrefix..member.." has "..count.." mounts. "..PPSizeCalc(count)..ExternalMountDataString)
               mb.var.GroupMountsOutCount = mb.var.GroupMountsOutCount + 1
			   if tonumber(count) >= tonumber(mb.var.MountsUOOC) then OwnedBy = OwnedBy + 1 end  
            end
			if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Logged count: "..mb.var.GroupMountsLoggedCount) end
			if mb.var.GroupMountsOutofRange == 0 then
			   print(mb.const.LocalPrefix..L["GroupMounts_GetDataSuccess"](mb.var.GroupMountsOutCount))
			else
			   print(mb.const.LocalPrefix..L["GroupMounts_GetDataIncomplete_Successful"](mb.var.GroupMountsOutCount))
			   print(mb.const.LocalPrefix..L["GroupMounts_GetDataIncomplete_Phased"](mb.var.GroupMountsOutofRange))
			end
			if OwnedBy == 0 and mb.var.GroupMountsOutofRange == 0 then print(mb.const.LocalPrefix..L["GroupMounts_MostMounts"]) end
            if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Group members(including yourself): "..GetNumGroupMembers()) end
      end)
   end
end

local function GroupMounts()
	if IsInGroup() then
		print(mb.const.LocalPrefix..L["GroupMounts_GettingData"])
		MountBoss_RequestGroupMountData()
		C_Timer.After(5, OutputGroupMounts)
	else
		print(mb.const.LocalPrefix..L["GroupMounts_NoGroup"])
	end
end

local function TargetMounts(output)
ClearAchievementComparisonUnit()
local function outputdata(output,target_name,target_mounts,ExternalMountDataString)
	if output == "SAY" then
		inInstance, instanceType = IsInInstance()
		if inInstance then
			MountBoss_OutputModule("SAY","TM", target_name, target_mounts, ExternalMountDataString)
		elseif mb.var.ExternalMountsTotalTable[target_name] then
			MountBoss_OutputModule("SAY","TM", target_name, target_mounts, ExternalMountDataString)
		else
			print(mb.const.LocalPrefix..L["TargetMounts_NotInInstanceError"])
		end
	else
		MountBoss_OutputModule("LOCAL","TM", target_name, target_mounts, PPSizeCalc(target_mounts), ExternalMountDataString)
	end
end

   if MountBossValidate_Target() then
		local ExternalMountDataString = ""
		local target_name = GetUnitName("target", true)
		if mb.var.ExternalMountsTotalTable[target_name] then
			if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Target is in mount table. No lookup has been performed.") end
			ExternalMountDataString = L["TargetMounts_TotalMounts"](target_name, mb.var.ExternalMountScoreTable[target_name], mb.var.ExternalPrestigeScoreTable[target_name], mb.var.ExternalMountsTotalTable[target_name])
			target_mounts = mb.var.ExternalMountsUOOCTable[target_name]
			outputdata(output,target_name,target_mounts,ExternalMountDataString)
		else
		  if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Target not in mount table. Looking up data.") end
		  local success = SetAchievementComparisonUnit("target")
		  local function eventHandler(self, event, ...)
			 local target_mounts = GetComparisonStatistic(339)
			 if target_mounts == "--" then target_mounts = 0 end
			 if mb.var.ExternalMountsTotalTable[target_name] then
				ExternalMountDataString = L["TargetMounts_TotalMounts"](target_name, mb.var.ExternalMountScoreTable[target_name], mb.var.ExternalPrestigeScoreTable[target_name], mb.var.ExternalMountsTotalTable[target_name])
			 end
			 outputdata(output,target_name,target_mounts,ExternalMountDataString)
		  end
		  MOUNTBOSSLISTENER_ACHIEVEMENTDATA:SetScript("OnEvent", eventHandler)
	   
	   end
	end
end

function MountBoss_BuildMountTable()
   mb.OwnedMountTable:clear()
   mb.var.BuildMountTableComplete = false
   mb.var.TotalMountCount = 0
   mb.var.AllianceMountCount = 0
   mb.var.HordeMountCount = 0
   local mount_id = 1
   while mount_id < mb.const.maximum_mount_id do
      local name,_,_,_,_,_,_,isFactionSpecific,faction,_,owned = C_MountJournal.GetMountInfoByID(mount_id)
      if name and owned then 
         mb.var.TotalMountCount = mb.var.TotalMountCount + 1
         mb.OwnedMountTable:push(mount_id)
		 if isFactionSpecific and faction == 1 then -- Alliance only mount
			mb.var.AllianceMountCount = mb.var.AllianceMountCount + 1
		 elseif isFactionSpecific and faction == 0 then -- Horde only mount
			mb.var.HordeMountCount = mb.var.HordeMountCount + 1
		 end
      end
      mount_id = mount_id + 1
   end
   mb.var.BuildMountTableComplete = true
end

local function CalculateScore()
	mb.var.CalculateMountScoreComplete = false
   if mb.var.BuildDebug then MountBossDebug_AppendData("MB_CSS") end
   local mount_count = #mb.OwnedMountTable
   local mount_score = 0
   local prestige_score = 0
   local x = 1
   local y = 1
   while mount_count > 0 do
         if mb.OwnedMountTable[x] == mb.const.master_mount_id[y] then
         mount_score = mount_score + mb.const.master_mount_score[y]
		 prestige_score = prestige_score + mb.const.master_prestige_score[y]
		 if mb.var.BuildDebug then MountBossDebug_AppendData("HIT. OMT: "..mb.OwnedMountTable[x].." MMID: "..mb.const.master_mount_id[y]) end
         x = x + 1
         mount_count = mount_count - 1
      elseif y == mb.const.maximum_mount_id then
         mount_count = mount_count - mb.const.maximum_mount_id
		 if mb.var.BuildDebug then MountBossDebug_AppendData("CALC SCORE MAX_MOUNT_ID_REACHED. OMT: "..mb.OwnedMountTable[x].." MMID: "..mb.const.master_mount_id[y]) end
         print(mb.const.DebugPrefix..L["Score_CalcError"])
      else
		 if mb.var.BuildDebug then MountBossDebug_AppendData("MISS. OMT: "..mb.OwnedMountTable[x].." MMID: "..mb.const.master_mount_id[y]) end
         y = y + 1
      end
   end
   avg_mount_score = math.floor(mount_score / #mb.OwnedMountTable)
   if mb.var.BuildDebug then MountBossDebug_AppendData("MB_CSE") end
   mb.var.CalculateMountScoreComplete = true
   return mount_score, prestige_score, avg_mount_score
end

function MountBoss_UpdateMountData()
	mb.var.MountsUOOC = GetStatistic(339)
	if mb.var.MountsUOOC == "--" then mb.var.MountsUOOC = 0 end
	MountBoss_BuildMountTable()
	mb.var.MountScore, mb.var.PrestigeScore, mb.var.AverageMountScore = CalculateScore()
	mb.var.AceCommDataOut = L["MountData_ACString"](mb.var.MountScore,mb.var.PrestigeScore,mb.var.MountsUOOC,mb.var.TotalMountCount)
	if mb.var.BuildMountTableComplete then
		print(mb.const.LocalPrefix..L["MountData_UpdateSuccess"])
		mb.var.BuildMountData = true
	else
		print(mb.const.DebugPrefix..L["MountData_UpdateFail"])
		mb.var.BuildMountData = false
	end
end

local function Mountboss_DrawMMI()
	MountBossMMIConfig = {
		type = "data source",
		icon = "Interface/ICONS/Ability_mount_fireravengodmountpurple",
		OnClick = function() MountBoss_InterpretMMIPush() end,
		OnEnter = function(self) 
			if not MountBossMMISavedVarTable.MMITTHidden then 
			MountBossToolTip_Create(self, L["MMI_Title"], L["MMI_MountData"](mb.var.MountScore,mb.var.PrestigeScore,mb.var.MountsUOOC,mb.var.TotalMountCount), L["MMI_HelpInfo"]) 
			end 
		end,
        OnLeave = function() GameTooltip:Hide() end,
	}
	MountBoss_AceIcon:Register("MountBossMMI", MountBossMMIConfig, MountBossMMISavedVarTable)
end

local function MountBoss_DisplayLoginInfo()
	print(mb.const.LocalPrefix..L["LoginInfo_Greeting"]) 
	local isShown = MountBoss_ButtonBox:IsShown()
	if not isShown then
		print(mb.const.LocalPrefix..L["LoginInfo_UIHidden"])
	end
	if MountBossMMISavedVarTable.hide then
		print(mb.const.LocalPrefix..L["LoginInfo_MMIHidden"])
	end
end

local function LocalizeBB()
   MountBoss_TitleLabel:SetText(L["GUI_CONF_TitleMain"])
   MountBoss_ScoreButton:SetText(L["GUI_ButtonBox_Button_Score"])
   MountBoss_MyMountsButton:SetText(L["GUI_ButtonBox_Button_MyMounts"])
   MountBoss_TargetMountButton:SetText(L["GUI_ButtonBox_Button_TargetMounts"])
   MountBoss_GroupMountButton:SetText(L["GUI_ButtonBox_Button_GroupMounts"])
end

function MountBoss_Init()
	if not MountBossMMISavedVarTable then MountBossMMISavedVarTable = {} end
	if MountBossMMISavedVarTable.hide == nil then MountBossMMISavedVarTable.hide = true end
	if MountBossMMISavedVarTable.MMITTHidden == nil then MountBossMMISavedVarTable.MMITTHidden = false end
	if MountBoss_BBHidden == nil then MountBoss_BBHidden = true end
	if MountBossDebug_Mode == nil then MountBossDebug_Mode = false end
	if MountBoss_BBHidden == true then MountBoss_ButtonBox:Hide() end
	mb.var.PlayerFaction = UnitFactionGroup("player")
	mb.var.PlayerName = GetUnitName("player")
	mb.var.MouseOverToolTipTable[GetUnitName("player", true)] = false
	MountBoss_AceConfig:RegisterOptionsTable("MountBoss", mb.OptionsUI)
	MountBoss_AceConfigDialog:AddToBlizOptions("MountBoss", L["GUI_CONF_TitleMain"])
	LocalizeBB()
	Mountboss_DrawMMI()
end

function MountBoss_AddonLoad(msg, v1, v2, ...)
	if v2 == "MountBoss" then
		print(mb.const.LocalPrefix..L["LoadInfo"](mb.const.versionumber))
		MountBoss_Init()
		C_Timer.After(5, CheckMountData)
		C_Timer.After(20, MountBoss_DisplayLoginInfo)
	end
	if v2 == "totalRP3" then
		mb.func.TRP3TTInit()
	end
end

function MountBoss_InterpretBBScorePush()
	CheckMountData()
	if IsShiftKeyDown() then
		MountBoss_OutputModule("SAY", "SC", mb.var.MountScore, mb.var.PrestigeScore, mb.var.AverageMountScore)
	elseif IsControlKeyDown() then
		MountBoss_UpdateMountData()
		MountBoss_OutputModule("LOCAL", "SC", mb.var.MountScore, mb.var.PrestigeScore, mb.var.AverageMountScore)
	else
		MountBoss_OutputModule("LOCAL", "SC", mb.var.MountScore, mb.var.PrestigeScore, mb.var.AverageMountScore)
	end
end

function MountBoss_InterpretBBMyMountsPush()
	CheckMountData()
	if IsShiftKeyDown() then
		MountBoss_OutputModule("SAY","PM", mb.var.MountsUOOC, mb.var.TotalMountCount, mb.var.AllianceMountCount, mb.var.HordeMountCount)
	elseif IsControlKeyDown() then
		MountBoss_UpdateMountData()
		MountBoss_OutputModule("LOCAL","PM", mb.var.MountsUOOC, mb.var.TotalMountCount, mb.var.AllianceMountCount, mb.var.HordeMountCount)
	else
		MountBoss_OutputModule("LOCAL","PM", mb.var.MountsUOOC, mb.var.TotalMountCount, mb.var.AllianceMountCount, mb.var.HordeMountCount)
	end
end

function MountBoss_InterpretBBTargetMountsPush()
	CheckMountData()
	if IsShiftKeyDown() then
		TargetMounts("SAY")
	elseif IsControlKeyDown() then
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."You pushed target mounts while holding control. This feature isn't currently used.") end
	else
		TargetMounts()
	end
end

function MountBoss_InterpretBBGroupMountsPush()
	CheckMountData()
	if IsShiftKeyDown() then
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."You pushed group mounts while holding shift. This feature isn't currently used.") end
	elseif IsControlKeyDown() then
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."You pushed group mounts while holding control. This feature isn't currently used.") end
	else
		GroupMounts()
	end
end

function MountBoss_InterpretMMIPush()
	if IsShiftKeyDown() then
		MountBoss_AceConfigDialog:Open("MountBoss")
	elseif IsControlKeyDown() then
		MountBoss_UpdateMountData()
	else
		MountBoss_BB_Toggle()
	end
end

function MountBossDebug_OutputStatus()
	print(mb.const.DebugPrefix.."Addon status ===========================")
	print(mb.const.DebugPrefix.."Version: "..mb.const.versionumber)
	print(mb.const.DebugPrefix.."Max Mount ID: "..mb.const.maximum_mount_id)
	print(mb.const.DebugPrefix.."UI Hidden: "..tostring(MountBoss_BBHidden))
	print(mb.const.DebugPrefix.."Debug Mode: "..tostring(MountBossDebug_Mode))
	print(mb.const.DebugPrefix.."Build Debug: "..tostring(mb.var.BuildDebug))
	print(mb.const.DebugPrefix.."Build Mount Data: "..tostring(mb.var.BuildMountData))
	print(mb.const.DebugPrefix.."Build Mount Table: "..tostring(mb.var.BuildMountTableComplete))
	print(mb.const.DebugPrefix.."Calculate Score: "..tostring(mb.var.CalculateMountScoreComplete))
	print(mb.const.DebugPrefix.."GM Logged: "..mb.var.GroupMountsLoggedCount)
	print(mb.const.DebugPrefix.."GM Out: "..mb.var.GroupMountsOutCount)
	print(mb.const.DebugPrefix.."GM OOR: "..mb.var.GroupMountsOutofRange)
	print(mb.const.DebugPrefix.."Mounts UOOC: "..mb.var.MountsUOOC)
	print(mb.const.DebugPrefix.."Mounts Total: "..mb.var.TotalMountCount)
	print(mb.const.DebugPrefix.."Mounts A: "..mb.var.AllianceMountCount)
	print(mb.const.DebugPrefix.."Mounts H: "..mb.var.HordeMountCount)
	print(mb.const.DebugPrefix.."MS: "..mb.var.MountScore)
	print(mb.const.DebugPrefix.."AMS: "..mb.var.AverageMountScore)
	print(mb.const.DebugPrefix.."Prestige: "..mb.var.PrestigeScore)
end

function MountBossDebug_GenerateDebug()
   mb.var.BuildDebug = true
   mb.var.DebugText = ""
   MountBossDebug_AppendData(mb.const.versionumber)
   MountBossDebug_AppendData(mb.const.maximum_mount_id)
   MountBossDebug_AppendData(UnitName("player"))
   MountBossDebug_AppendData(GetRealmName())
   MountBossDebug_AppendData(GetCurrentRegion())
   MountBossDebug_AppendData(mb.var.BuildMountData)
   MountBossDebug_AppendData(mb.var.BuildMountTableComplete)
   MountBossDebug_AppendData(mb.var.CalculateMountScoreComplete)
   MountBossDebug_AppendData(mb.var.MountsUOOC)
   MountBossDebug_AppendData(mb.var.TotalMountCount)
   MountBossDebug_AppendData(mb.var.AllianceMountCount)
   MountBossDebug_AppendData(mb.var.HordeMountCount)
   MountBossDebug_OutputOMT()
   CalculateScore()
   MountBossDebug_AppendData("score "..mb.var.MountScore)
   MountBossDebug_AppendData("avg score "..mb.var.AverageMountScore)
   MountBossDebug_AppendData("prestige "..mb.var.PrestigeScore)
   MountBossDebug_AppendData("MB_DEBUG_END")
   MountBossDebug_DisplayData(mb.var.DebugText)
   mb.var.BuildDebug = false
end

function MountBossDebug_Toggle()
	if MountBossDebug_Mode then
		MountBossDebug_Mode = false
		print(mb.const.DebugPrefix..L["DebugMode_Disable"])
	else
		MountBossDebug_Mode = true
		print(mb.const.DebugPrefix..L["DebugMode_Enable"])
	end
end

function MountBoss_LuaErr_Toggle()
	if GetCVar("scriptErrors") == "1" then
		SetCVar('scriptErrors', 0)
		print(mb.const.DebugPrefix..L["LuaErrors_Disable"])
	else
		SetCVar('scriptErrors', 1)
		print(mb.const.DebugPrefix..L["LuaErrors_Enable"])
	end
end

function MountBoss_BB_Toggle()
	local isShown = MountBoss_ButtonBox:IsShown()
	if isShown then
		MountBoss_BB_Hide()
		MountBoss_BBHidden = true
	else
		MountBoss_BB_Show()
		MountBoss_BBHidden = false
	end
end

function MountBoss_MMI_Toggle()
	if MountBossMMISavedVarTable.hide then
		MountBoss_AceIcon:Show("MountBossMMI")
		MountBossMMISavedVarTable.hide = false
	else
		MountBoss_AceIcon:Hide("MountBossMMI")
		MountBossMMISavedVarTable.hide = true
	end
end

function MountBoss_MMITT_Toggle()
	if MountBossMMISavedVarTable.MMITTHidden then
		MountBossMMISavedVarTable.MMITTHidden = false
	else
		MountBossMMISavedVarTable.MMITTHidden = true
	end
end

function MountBoss_BB_Show()
	MountBoss_ButtonBox:Show()
	MountBoss_BBHidden = false
end

function MountBoss_BB_Hide()
	MountBoss_ButtonBox:Hide()
	MountBoss_BBHidden = true
end

function MountBoss_BB_OnClose()
	MountBoss_BBHidden = true
end

function MountBoss_BB_OnShow()-- not used
end

function MountBoss_BB_OnLoad()-- not used
end

function MountBoss_BB_ScoreOnEnter(frame)
	MountBossToolTip_Create(frame, "MountScore", "Line one")
end

function MountBoss_BB_ScoreOnLeave()
	GameTooltip:Hide()
end

function MountBoss_BB_MyMountsOnEnter(frame)
	MountBossToolTip_Create(frame, "My Mounts", "Line one")
end

function MountBoss_BB_MyMountsOnLeave()
	GameTooltip:Hide()
end

function MountBoss_BB_TargetMountsOnEnter(frame)
	MountBossToolTip_Create(frame, "Target mounts", "Line one")
end

function MountBoss_BB_TargetMountsOnLeave()
GameTooltip:Hide()
end

function MountBoss_BB_GroupMountsOnEnter(frame)
	MountBossToolTip_Create(frame, "Warning this is an experimental feature.", "Please report any bugs to our Discord. '/mb help' for more info. ")
end

function MountBoss_BB_GroupMountsOnLeave()
	GameTooltip:Hide()
end

function MountBoss_RequestGroupMountData()
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."You are in a instance group.") end
		MountBoss_AceComm:SendCommMessage("MountBoss", "requestData", "INSTANCE_CHAT")
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."You are in a home group.") end
		MountBoss_AceComm:SendCommMessage("MountBoss", "requestData", "RAID")
	else
		if MountBossDebug_Mode then print(mb.const.DebugPrefix..L["GroupMounts_NoGroup"]) end
	end
end

function MountBoss_AceComm:OnCommReceived(prefix, message, distribution, sender) -- processes data requests
	if MountBossDebug_Mode then print(mb.const.DebugPrefix.."AceComm Request Recieve: "..prefix, message, distribution, sender) end
	if message == "requestData" then
		if distribution == "WHISPER" then
			MountBoss_AceComm:SendCommMessage("MountBossData", mb.var.AceCommDataOut, "WHISPER", sender)
		else
			MountBoss_AceComm:SendCommMessage("MountBossData", mb.var.AceCommDataOut, distribution)
		end
	else
		if MountBossDebug_Mode then print(mb.const.DebugPrefix.."Unknown message content.") end
	end
end

function MountBoss_AceComm:OnCommReceived_Data(prefix, message, distribution, sender) -- processes returned data
	if MountBossDebug_Mode then print(mb.const.DebugPrefix.."AceComm Data Recieve: "..prefix, message, distribution, sender) end
	if sender ~= mb.var.PlayerName then
	local TTDataIn, ExternalMountScore, ExternalPrestigeScore, ExternalMountsUOOC, ExternalTotalMounts = strsplit("#", message, 5)
	mb.var.MouseOverToolTipTable[sender] = TTDataIn
	mb.var.ExternalMountScoreTable[sender] = ExternalMountScore
	mb.var.ExternalPrestigeScoreTable[sender] = ExternalPrestigeScore
	mb.var.ExternalMountsUOOCTable[sender] = ExternalMountsUOOC
	mb.var.ExternalMountsTotalTable[sender] = ExternalTotalMounts
		if sender == GetUnitName("mouseover", true) then
			MountBossTooltip_AddTitle(GameTooltip)
			MountBossTooltip_AddLine(GameTooltip, TTDataIn)
		end
	end
end
MountBoss_AceComm:RegisterComm("MountBoss")
MountBoss_AceComm:RegisterComm("MountBossData", "OnCommReceived_Data")

local function eventHandler(self, event, ...) -- mouse over
    if MountBossValidate_MouseOver() then
	local UnitName = GetUnitName("mouseover", true)
		if mb.var.MouseOverToolTipTable[UnitName] then
			if MountBossDebug_Mode then print(mb.const.DebugPrefix.."We have data for "..UnitName.." in the table and it has been displayed.") end
			MountBossTooltip_AddTitle(GameTooltip)
			MountBossTooltip_AddLine(GameTooltip, mb.var.MouseOverToolTipTable[UnitName])
		elseif UnitRealmRelationship("mouseover") ~= 2 then
			if MountBossDebug_Mode then print(mb.const.DebugPrefix.."AceComm Send: No data for "..UnitName.." sending requestData") end
			MountBoss_AceComm:SendCommMessage("MountBoss", "requestData", "WHISPER", UnitName)
			mb.var.MouseOverToolTipTable[UnitName] = false
			mb.var.ExternalMountsTotalTable[UnitName] = false
		end
	end
end
MOUNTBOSSLISTENER_MOUSEOVERUNIT:SetScript("OnEvent", eventHandler)

local function MountBossCommands(msg)
   if msg == L["SmashCommand_Self"] then
		CheckMountData()
		MountBoss_OutputModule("LOCAL","PM", mb.var.MountsUOOC, mb.var.TotalMountCount, mb.var.AllianceMountCount, mb.var.HordeMountCount)
   elseif msg == L["SmashCommand_Target"] then
		CheckMountData()
		TargetMounts()
   elseif msg == L["SmashCommand_Macros"] then
		MountBoss_CreateMacros()
   elseif msg == L["SmashCommand_UIToggle"] then
		MountBoss_BB_Toggle()
	elseif msg == L["SmashCommand_UIShow"] then
		MountBoss_BB_Show()
	elseif msg == L["SmashCommand_UIHide"] then
		MountBoss_BB_Hide()
	elseif msg == L["SmashCommand_MinimapToggle"] then
		MountBoss_MMI_Toggle()
   elseif msg == L["SmashCommand_Score"] then
		MountBoss_OutputModule("LOCAL", "SC", mb.var.MountScore, mb.var.PrestigeScore, mb.var.AverageMountScore)
   elseif msg == L["SmashCommand_UpdateMountData"] then
		MountBoss_UpdateMountData()
   elseif msg == L["SmashCommand_OptionsUIShow"] then
		MountBoss_AceConfigDialog:Open("MountBoss")
   elseif msg == L["SmashCommand_DebugGenerate"] then
		MountBossDebug_GenerateDebug()
   elseif msg == L["SmashCommand_DebugToggle"] then
		MountBossDebug_Toggle()
	elseif msg == L["SmashCommand_DebugStatus"] then
		MountBossDebug_OutputStatus()
   elseif msg == L["SmashCommand_Help"] then
		 print(mb.const.LocalPrefix.."Help =======================================")
         print(mb.const.LocalPrefix.."Targets & group members must be in the same phase and in most cases close by.")
		 print(mb.const.LocalPrefix.."Hold control while pressing 'My Mount Score' or 'My Mounts' to force an update.")
		 print(mb.const.LocalPrefix.."Hold control while pressing the minimap icon will update mount data and shift will open the options UI.")
		 print(mb.const.LocalPrefix.."Mount score and prestige are calculated from all unlocked mounts on all characters and both factions.")
		 print(mb.const.LocalPrefix.."Prestige score is like mount score but is calculated only using the rarest and hardest to obtain mounts in the game.")
		 print(mb.const.LocalPrefix.."Mounts shown in other addon users tooltip are mounts usable on one character.")
		 print(mb.const.LocalPrefix.."For feedback and support please join https://discord.gg/GRSp8jb")
		 print(mb.const.LocalPrefix.."If you have problems please use '/mb debug' and post the data to the Discord.")
   else
   		print(mb.const.LocalPrefix.."Commands ==================================")
		print(mb.const.LocalPrefix.."I respond to /mountboss or /mb.")
		print(mb.const.LocalPrefix.."/mb toggle - Shows or hides the UI. '/mb show' and '/mb hide' also work.")
		print(mb.const.LocalPrefix.."/mb minimap - Shows or hides the minimap icon.")
		print(mb.const.LocalPrefix.."/mb self -- Displays your mounts.")
		print(mb.const.LocalPrefix.."/mb target -- Displays your current targets mounts.")
		print(mb.const.LocalPrefix.."/mb score -- Displays your mount score.")
		print(mb.const.LocalPrefix.."/mb update -- Forces your score and mount info to be updated.")
		print(mb.const.LocalPrefix.."/mb macros -- Creates handy dandy macros.")
		print(mb.const.LocalPrefix.."/mb options -- Opens the addon options window.")
		print(mb.const.LocalPrefix.."/mb help -- Shows helpful information and how to submit feedback.")	  
   end
end

SLASH_MOUNTBOSS1, SLASH_MOUNTBOSS2 = '/mb', '/mountboss'
SlashCmdList["MOUNTBOSS"] = MountBossCommands