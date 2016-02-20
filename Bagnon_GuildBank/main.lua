--[[
	main.lua
		Show and hide frame
--]]

local GuildBank = Bagnon:NewModule('GuildBank', 'AceEvent-3.0')

function GuildBank:OnEnable()
	self:RegisterEvent('GUILDBANKFRAME_CLOSED', 'OnClosed')
end

function GuildBank:OnOpen()
	Bagnon.Cache.AtGuild = true
	Bagnon:ShowFrame('guild')
	QueryGuildBankTab(GetCurrentGuildBankTab())
end

function GuildBank:OnClosed()
	Bagnon.Cache.AtGuild = nil
	Bagnon:HideFrame('guild')
end