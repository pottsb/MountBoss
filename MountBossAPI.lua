local _, mb = ...
local L = LibStub("AceLocale-3.0"):GetLocale("MountBoss")
local MountBoss_AceConfigDialog = LibStub("AceConfigDialog-3.0")

MountBossAPI = {

	updateData = function()
	
	end,

	Version = function()
		return mb.const.versionumber
	end,

	createMacros = function()
	
	end,
}

MountBossAPI.UI = {

	ToggleBB = function()
	
	end,

	ToggleMMI = function()
	
	end,

	displayOptions = function()
		MountBoss_AceConfigDialog:Open("MountBoss")
	end,
}

MountBossAPI.GetDataPlayer = {

	player = function()
 
	end,
	
	targetMounts = function()

	end,
	
	groupMounts = function()

	end,
}

MountBossAPI.GetDataExternal = {

	requestDataCustom = function(channel)
		--if channel == nil then return "You must supply a channel."
	end,

	requestDataWhisper = function(recipient)
	
	end,
	
	lookupData = function() --return vars
	
	end,
	
	lookupString = function()
	
	end,
}

MountBossAPI.Out = {

	myMounts = function(out)
		out = out or "LOCAL"
	end,

	targetMounts = function(out)
		out = out or "LOCAL"
	
	end,
	
	groupMounts = function(out)
		out = out or "LOCAL"
	
	end,
}


