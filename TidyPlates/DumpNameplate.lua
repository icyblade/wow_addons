
--[[
	local function DumpNameplateInfo(plate)
		local ListChildren

		local function ListRegions(object, indent)
			local count = object:GetNumRegions()

			if count > 0 then print(indent, "Regions of ", object:GetName()) end

			for i = 1, count do
				local region = select(i,object:GetRegions())

				local name = region:GetName()
				local otype = region:GetObjectType()
				local extra = ""

				if otype == "FontString" then extra = region:GetText()
				elseif otype == "Texture" then extra = region:GetTexture()
				end

				print(indent, i, otype, name, extra)

			end
		end


		ListChildren = function(object, indent)

			local count = select('#',object:GetChildren())

			if count > 0 then print(indent, "Children of ", object:GetName()) end

			for i = 1, count do
				local child = select(i,object:GetChildren())
				local name = child:GetName()
				local otype = child:GetObjectType()
				local extra
				local sublevels = child:GetNumChildren()
				local subregions = child:GetNumRegions()

				if otype == "StatusBar" then extra = child:GetStatusBarTexture() 
				end

				print(indent, i, otype, name, extra, sublevels, subregions)
				ListRegions(child, indent.."  ")

				ListChildren(child, indent.."    ") 
			end
		end

		ListChildren(plate, "")

	end

	--]]