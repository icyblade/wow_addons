--[[
	itemFrame.lua
		A guild bank item slot container
--]]

local ItemFrame = Bagnon:NewClass('GuildItemFrame', 'Frame', Bagnon.ItemFrame)
ItemFrame.Button = Bagnon.GuildItemSlot
ItemFrame.TransposeLayout = true

function ItemFrame:RegisterEvents()
	self:UnregisterEvents()
	self:RegisterMessage(self:GetFrameID() .. '_PLAYER_CHANGED', 'OnShow')
	self:RegisterMessage('UPDATE_ALL', 'RequestLayout')
	
	self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED', 'ForAll', 'Update')
	self:RegisterEvent('GUILDBANK_ITEM_LOCK_CHANGED', 'ForAll', 'UpdateLocked')

	if self:IsCached() then
		self:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'ForAll', 'Update')
		self:RegisterMessage('GUILDBANK_TAB_CHANGED', 'ForAll', 'Update')
	end
end

function ItemFrame:IsShowing(bag)
	return bag == GetCurrentGuildBankTab()
end

function ItemFrame:NumSlots()
	return 98
end