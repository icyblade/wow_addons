local FontStrings={}
local FontFile
local SM = LibStub:GetLibrary("LibSharedMedia-3.0")

SM:Register("font", "ABF", [[Interface\AddOns\Spy\Fonts\ABF.ttf]])

function Spy:AddFontString(string)
	local Font, Height, Flags

	FontStrings[#FontStrings+1] = string

	if not FontFile and Spy.db.profile.Font then
		FontFile = SM:Fetch("font", Spy.db.profile.Font)
	end

	if FontFile then
		Font, Height, Flags = string:GetFont()
		if Font ~= FontFile then
			string:SetFont(FontFile, Height, Flags)
		end
	end
end

function Spy:SetFont(fontname)
	local Height, Flags

	Spy.db.profile.Font = fontname
	FontFile = SM:Fetch("font",fontname)

	for _, v in pairs(FontStrings) do
		_, Height, Flags = v:GetFont()
		v:SetFont(FontFile, Height, Flags)
	end
end
