--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

defaultPrice = 3000

defaultDescription = "Summon a hungry little lizard with a long, sticky tongue!"

defaultIcon = "/vehicles/spov/PakkunLizard/PakkunLizardicon.png"

defaultFrame = "/vehicles/spov/PakkunLizard/PakkunLizard.png:idle.1"

defaultValues = {
	name = "Biting Lizard"
	, pills = {}
}

-------------------------------------------------------------------------------

function getRecolorDirectives()	--Get the current recolor directive string

	local allcolors = config.getParameter( "colorOptions" );
	if storage.vso.colorReplaceMap ~= nil then
		--No problem
	elseif allcolors ~= nil then
		local coli = 1 + ( (math.floor( math.random()*9999 )) % #allcolors )	--because lua. Make a new color map.
		storage.vso.colorReplaceMap = allcolors[ coli ];
		--Snap Dragon color
		if coli == 2 then
			storage.vso.name = "Snap Dragon";
		end
	end
	if storage.vso.colorReplaceMap ~= nil then
		return spovSpawnerMakeColorReplaceDirectiveString( storage.vso.colorReplaceMap );
	else
		return ""
	end
end

function getItemStatusString()	--Get the current item status message string
	--local R = tostring( storage.vso.name )
	local R = defaultDescription;
	--There aren't as many games with monster descriptions as I thought!
	--Also the second one is too long...
	--[[
	R = R..spovSpawnerPick({
		"\"It swallows the enemies by using its tongue, whether it's hungry or not.\"", --Legend of Mana
		"\"A monster with a tongue that stretches out. The villagers call it a sniper because it can catch farm crops with its tongue from afar.\"" --Merc Storia
	});
	]]--
	return R;
end

function getItemCurrentPrice()	--Get the current sell price for this item
	return defaultPrice
end

function buildIcon()	--Build a CUSTOM icon for this item

	local directivestring = getRecolorDirectives()
	spovSpawnerSetDirectives( directivestring );
	
	local R = { { image=defaultIcon.."?"..directivestring, position={0,0} } }

	return R;
end

function spovSpawnerItemGenerateCallback()	--THIS function is used to create the ITEM data when the object is broken. Very important. This is also a good way to test your storage.

	--this sets our storage defaults, very important if we want to track things or change colors.
	spovSpawnerStorageSetIfNotNil( defaultValues )
	
	local directivestring = getRecolorDirectives()	--Regenerate item configuration override
	spovSpawnerSetDirectives( directivestring );
	
	storage.vso.itemConfigOverride = {
		inventoryIcon = buildIcon()
		,largeImage = defaultFrame.."?"..directivestring
		,subtitle = storage.vso.name
		,price = getItemCurrentPrice()
		,description = getItemStatusString()
		,lowerleft = ""	--"Belly: "..tostring( math.floor( storage.vso.belly*100) / 100 )
		,itemTags = { "spovpillable" }	--This is required if you want to use pills
	}
end