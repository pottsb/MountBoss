-- Thanks to ConineSpiritwolf author of https://www.curseforge.com/wow/addons/raider-io-total-rp-3-tooltips who let me use their code to display data in the TotalRP3 tooltip.

local _, mb = ...
local L = LibStub("AceLocale-3.0"):GetLocale("MountBoss")

local mbtttrp3 = CreateFrame("Frame")
mbtttrp3:RegisterEvent("PLAYER_LOGIN")

local MBTRP3Tooltips = select(2, ...)
MBTRP3Tooltips.CONFIG = {}

local function fixFontsTrp3RIO (dummy)
	local line = _G[strconcat(TRP3_CharacterTooltip:GetName(), "TextLeft", TRP3_CharacterTooltip:NumLines())]
	local font, _ , flag = line:GetFont()
	line:SetFont(font, 12, flag)
	local line2 = _G[strconcat(TRP3_CharacterTooltip:GetName(), "TextRight", TRP3_CharacterTooltip:NumLines())]
	local font2, _ , flag2 = line2:GetFont()
	line2:SetFont(font2, 12, flag2)
end

local function trp3mbrun()
	mbtttrp3:SetScript("OnEvent", function(self, event, arg1, arg2)
		if event == "PLAYER_LOGIN" then -- check if this is needed.
			if TRP3_CharacterTooltip ~= nil then			
				TRP3_CharacterTooltip:HookScript("OnShow", function(t)
				local enabletooltip = true
				if not TRP3_API.configuration.getValue(MBTRP3Tooltips.CONFIG.SHOW_MB_TOOLTIPS) then
					enabletooltip = false
				end
				if (TRP3_API.dashboard.isPlayerIC() and not TRP3_API.configuration.getValue(MBTRP3Tooltips.CONFIG.SHOW_MB_TOOLTIPS_IC)) then
					enabletooltip = false
				end
				if enabletooltip then
					local UnitName = GetUnitName("mouseover", true)
					if mb.var.MouseOverToolTipTable[UnitName] then
							TRP3_CharacterTooltip:AddDoubleLine(" ", " ")
							TRP3_CharacterTooltip:AddDoubleLine(L["MMI_Title"], " ")
							TRP3_CharacterTooltip:AddLine(mb.var.MouseOverToolTipTable[UnitName])
							fixFontsTrp3RIO()	
					end
				end
					TRP3_CharacterTooltip:Show()
					TRP3_CharacterTooltip:GetTop()
				end)
			end   
		end
	end)


	--TRP3 Config 

	MBTRP3Tooltips.CONFIG.SHOW_MB_TOOLTIPS = "MBTRP3Tooltips_hide_tooltips"
	MBTRP3Tooltips.CONFIG.SHOW_MB_TOOLTIPS_IC = "MBTRP3Tooltips_hide_tooltips_ic"
	TRP3_API.configuration.registerConfigKey(MBTRP3Tooltips.CONFIG.SHOW_MB_TOOLTIPS, true)
	TRP3_API.configuration.registerConfigKey(MBTRP3Tooltips.CONFIG.SHOW_MB_TOOLTIPS_IC, false)

	TRP3_API.configuration.registerConfigurationPage({
			id = "trp3_mbtooltips_config",
			menuText = L["GUI_CONF_TitleMain"],
			pageText = L["TRP3_SettingsTitle"],
			elements = {
				{
					inherit = "TRP3_ConfigCheck",
					title = L["TRP3_SettingsToggleShowTooltipTitle"],
					--help = L["TRP3_SettingsToggleShowTooltipHelp"],
					configKey = MBTRP3Tooltips.CONFIG.SHOW_MB_TOOLTIPS
				},
				{
					inherit = "TRP3_ConfigCheck",
					title = L["TRP3_SettingsToggleShowTooltipICTitle"],
					help = L["TRP3_SettingsToggleShowTooltipICHelp"],
					configKey = MBTRP3Tooltips.CONFIG.SHOW_MB_TOOLTIPS_IC,
					dependentOnOptions = { MBTRP3Tooltips.CONFIG.SHOW_MB_TOOLTIPS }
				}
			}
		
		})
end


mb.func.TRP3TTInit = function()
	TRP3_API.module.registerModule({
		name = L["TRP3_ModuleTitle"],
		description = L["TRP3_ModuleDesc"],
		version = 1.2,
		id = "trp3_mbtooltips",
		onStart = trp3mbrun,
		minVersion = 60,
	});
end