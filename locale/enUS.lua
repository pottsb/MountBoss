local L = LibStub("AceLocale-3.0"):NewLocale("MountBoss", "enUS", true)
--L[""] = ""

-- Chat Prefixes
L["LocalDebugPrefix"] = "|cFF0000FAMB DEBUG:|r "
L["LocalPrefix"] = "|cFFA600FAMountBoss:|r "
L["SayPrefix"] = "MountBoss: "
L["TooltipPrefix"] = "|cFFA600FAMountBoss|r "

-- Config GUI - Listed in the order they show on screen.
L["GUI_CONF_TitleMain"] = "MountBoss" -- This is also the string listed in the addon list in interface settings and the ButtonBox Title.
L["GUI_CONF_Desc"] = "A simple way to compare your mount collection to others."
L["GUI_CONF_Author"] = "\n|cffffd100 Author: |r Bur @ Frostmane-EU"
L["GUI_CONF_VersionNum"] = function(versionumber)
	return "|cffffd100 Version: |r "..versionumber.." \n"
end
L["GUI_CONF_UITitleOptions"] = "|cffffd100 UI Options |r"
L["GUI_CONF_ToggleShowUI"] = "Show UI"
L["GUI_CONF_ToggleShowMMI"] = "Show Minimap Button"
L["GUI_CONF_ToggleMMITT"] = "Show Minimap Button Tooltip"
L["GUI_CONF_ToggleMMITTDesc"] = "|cffaaaaaa Click the minimap button to toggle UI, Shift click to open this options window and CTRL click to update mount data.  |r"
L["GUI_CONF_AddonTitleOptions"] = "\n |cffffd100 Addon Options |r"
L["GUI_CONF_ButtonUpdateMD"] = "Update Mount Data"
L["GUI_CONF_ButtonUpdateMDDesc"] = "Use this if your data is corrupt, incorrect or you gained a new mount. Please submit debug information if this doesn't fix incorrect data. \n"
L["GUI_CONF_ButtonCreateMacros"] = "Create Macros"
L["GUI_CONF_ButtonCreateMacrosDesc"] = "Creates handy dandy macros."
L["GUI_CONF_AddonTitleDebug"] = "\n |cffffd100 Debug Options |r"
L["GUI_CONF_ToggleDebugMode"] = "Debug Mode"
L["GUI_CONF_ToggleDebugmodeDesc"] = "|cffaaaaaa Shows debug information in chat so you know what's happening under the hood. |r"
L["GUI_CONF_ToggleLuaError"] = "Show Lua Errors"
L["GUI_CONF_ToggleLuaErrordDesc"] = "|cffaaaaaa This is system wide and will show errors from all addons. Addons such as Swatter and BugSack may hide lua errors with this enabled. |r \n"
L["GUI_CONF_ButtonGenerateDebug"] = "Generate Debug"
L["GUI_CONF_ButtonGenerateDebugDesc"] = "Please submit debug data and feedback to: https://discord.gg/GRSp8jb"

-- GUI - Debug Window
L["GUI_DebugOutput_SelectAll"] = "Select All"

-- GUI - ButtonBox
L["GUI_ButtonBox_Button_Score"] = "My Mount Score"
L["GUI_ButtonBox_Button_MyMounts"] = "My Mounts"
L["GUI_ButtonBox_Button_TargetMounts"] = "Target Mounts"
L["GUI_ButtonBox_Button_GroupMounts"] = "Group Mounts"

-- Local Output Modules
L["OutputModuleLocalPM"] = function(v1,v2,v3,v4)
	return "You have "..v1.." mounts usable on one character, "..v2.." mounts in total, |cFF0070FF"..v3.." Alliance|r mounts and |cFFF0000F"..v4.." Horde|r mounts. Hold shift for /s."
end
L["OutputModuleLocalTM"] = function(v1,v2,v3,v4)
	return v1.." has "..v2.." mounts usable on one character. "..v3..v4
end
L["OutputModuleLocalSC"] = function(v1,v2)
	return "Your mountscore is "..v1.." with a prestige score of "..v2..". Hold shift for /s."
end

-- Say Output Modules
L["OutputModuleSayPM"] = function(v1, v2, v3, v4)
	return "I have "..v1.." mounts usable on one character, "..v2.." mounts in total, "..v3.." Alliance mounts and "..v4.." Horde mounts."
end
L["OutputModuleSayTM"] = function(v1,v2,v3)
	return v1.." has "..v2.." mounts usable on one character. "..v3
end
L["OutputModuleSaySC"] = function(v1,v2)
	return "My mountscore is "..v1.." with a prestige score of "..v2.."."
end

-- Target Validation
L["Validation_TargetNoTarget"] = "Try clicking on someone first."
L["Validation_TargetNPC"] = "That doesn't seem to be a player."
L["Validation_TargetPhased"] = " is too far away or phased."

-- Mount Figure Comparison
L["PPSizeCalc_MoreMounts"] = function(diff)
	return "You have "..diff.." |cF00FF00Fmore|r mounts. "
end
L["PPSizeCalc_FewerMounts"] = function(diff)
	return "You have "..diff.." |c0FF0000Ffewer|r mounts. "
end
L["PPSizeCalc_snap"] = function(target_mounts) 
	return "|c00e6cc80You both have "..target_mounts.." mounts! SNAP! |r"
end

-- Macros
L["Macro_ErrorNoFreeSpace"] = "You don't have enough free character specific macro slots."
L["Macro_ErrorCombat"] = "Sorry I can't do that while you're in combat."
L["Macro_Target"] = "Target MB"
L["Macro_TargetMacro"] = "/mb target"
L["Macro_Self"] = "Self MB"
L["Macro_SelfMacro"] = "/mb self"
L["Macro_Score"] = "Score MB"
L["Macro_ScoreMacro"] = "/mb score"
L["Macro_Toggle"] = "Toggle MB"
L["Macro_ToggleMacro"] = "/mb toggle"
L["Macro_MacrosCreated"] = "Macros have been added to character specific macros."

-- Group Mounts
L["GroupMounts_GettingData"] = "Getting group mounts. This will take a moment please don't press the button again."
L["GroupMounts_DataOut"] = function(member,count)
	return member.." has "..count.." mounts. "
end
L["GroupMounts_GetDataSuccess"] = function(GroupMountsOutCount)
	return "Looks like we got mount data for all "..GroupMountsOutCount.." people."
end
L["GroupMounts_GetDataIncomplete_Successful"] = function(GroupMountsOutCount)
	return "Members who returned data: "..GroupMountsOutCount
end
L["GroupMounts_GetDataIncomplete_Phased"] = function(GroupMountsOutofRange)
	return "Members out of range: "..GroupMountsOutofRange
end
L["GroupMounts_MostMounts"] = "|cF00FF00FYou have the most mounts in the group!|r"
L["GroupMounts_NoGroup"] = "You are not in a group."

-- Target Mounts
L["TargetMounts_TotalMounts"] = function(target_name, mount_score, prestige_score, total_mounts)
	return target_name.." also has "..total_mounts.." mounts in total, a mountscore of "..mount_score.." and a prestige score of "..prestige_score.."."
end
L["TargetMounts_NotInInstanceError"] = "Target mounts in /s only works inside an instance."

-- Calculate Score
L["Score_CalcError"] = "It seems you have a mount that's not in our database. Are you using the latest version of MountBoss? If you are please submit debug data to our discord. See /help for more information."

-- Update Mount Data + tooltip
L["MountData_ACString"] = function(MountScore,PrestigeScore,MountsUOOC,TotalMountCount)
	return "MountScore:|cffffffff"..MountScore.."|r Prestige:|cffffffff"..PrestigeScore.."|r|nMounts UooC:|cffffffff"..MountsUOOC.."|r Mounts Total:|cffffffff"..TotalMountCount.."|r".."#"..MountScore.."#"..PrestigeScore.."#"..MountsUOOC.."#"..TotalMountCount
end
L["MountData_UpdateSuccess"] = "Your mount data has been updated."
L["MountData_UpdateFail"] = "Mount data update failed :("

-- Minimap Icon
L["MMI_Title"] = "|cFFA600FAMount Boss|r"
L["MMI_MountData"] = function(MountScore,PrestigeScore,MountsUOOC,TotalMountCount)
 return "MountScore:|cffffffff"..MountScore.."|r Prestige:|cffffffff"..PrestigeScore.."|r|nMounts UooC:|cffffffff"..MountsUOOC.."|r Mounts Total:|cffffffff"..TotalMountCount.."|r"
end
L["MMI_HelpInfo"] = "|cffaaaaaaLeft click to toggle UI. Hold Left click to drag.|nCTRL-click to update mount data. Shift-click to open options.|r"

-- Login Information
L["LoginInfo_Greeting"] = "Use '/mb' to list commands and '/mb help' for more information."
L["LoginInfo_UIHidden"] = "The MountBoss window is hidden. Use '/mb toggle' to show it."
L["LoginInfo_MMIHidden"] = "The minimap icon is hidden. Use '/mb minimap' to show it."

-- Addon Load Info
L["LoadInfo"] = function(versionnumber)
	return "Version: "..versionnumber
end

-- Toggle Debug
L["DebugMode_Enable"] = "Debug mode enabled."
L["DebugMode_Disable"] = "Debug mode disabled."

-- Toggle Lua Errors
L["LuaErrors_Enable"] = "Lua errors enabled."
L["LuaErrors_Disable"] = "Lua errors disabled."

--TRP3
L["TRP3_SettingsTitle"] = "MountBoss Tooltips"
L["TRP3_SettingsToggleShowTooltipTitle"] = "Show MountBoss Tooltips"
L["TRP3_SettingsToggleShowTooltipHelp"] = "If this is ticked, MountBoss info will be shown when you are IC (In Character)." -- not used
L["TRP3_SettingsToggleShowTooltipICTitle"] = "Show MountBoss Tooltips when IC"
L["TRP3_SettingsToggleShowTooltipICHelp"] = "If this is ticked, MountBoss info will be shown when you are IC (In Character)."
L["TRP3_ModuleTitle"] = "MountBoss Info Tooltips"
L["TRP3_ModuleDesc"] = "Adds MountBoss Information to Total RP3's tooltips."
L["TRP3_"] = ""

-- Slash Commands
L["SmashCommand_Self"] = "self"
L["SmashCommand_Target"] = "target"
L["SmashCommand_Macros"] = "macros"
L["SmashCommand_UIToggle"] = "toggle"
L["SmashCommand_UIShow"] = "show"
L["SmashCommand_UIHide"] = "hide"
L["SmashCommand_MinimapToggle"] = "minimap"
L["SmashCommand_Score"] = "score"
L["SmashCommand_UpdateMountData"] = "update"
L["SmashCommand_OptionsUIShow"] = "options"
L["SmashCommand_DebugGenerate"] = "debug"
L["SmashCommand_DebugToggle"] = "debugtoggle"
L["SmashCommand_DebugStatus"] = "debugstatus"
L["SmashCommand_Help"] = "help"
