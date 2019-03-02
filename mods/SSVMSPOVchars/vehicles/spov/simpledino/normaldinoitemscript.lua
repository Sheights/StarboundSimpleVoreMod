--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo

function getRecolorDirectives()	--Get the current recolor directive string

	local allcolors = config.getParameter( "colorOptions", spovSpawnerDefaultPrimaryColorOptions );	--
	if storage.vso.colorReplaceMap ~= nil then
		--No problem
	else
		--local coli = 1 + ( (math.floor( math.random()*9999 )) % (#allcolors-1) )	--because lua. Make a new color map.
		local coli = 1 + ( (math.floor( math.random()*9999 )) % (#allcolors) )	--because lua. Make a new color map. ( 12%12 == 0.
		
		storage.vso.colorReplaceMap = allcolors[ coli ];
	end
	return spovSpawnerMakeColorReplaceDirectiveString( storage.vso.colorReplaceMap );
end

function getItemStatusString()	--Get the current item status message string
	local R = tostring(storage.vso.name).." is a "
	local belly = storage.vso.belly
	
	if belly > 50 then R = R.."fat"
	elseif belly > 20 then R = R.."happy"
	elseif belly > 0 then R = R.."hungry"
	else R = R.."starving"
	end
	
	R = R.." dinosaur"
	R = R..spovSpawnerPick( { "!", " and it likes to eat meat!", " who wants you for dinner!", " with a big appetite!", " and is ready for more~" } );
	R = R..spovSpawnerPick( { "", " Don't tease it...", " Try feeding it!", " Got any meat?" } );
	
	--Stats: Hm. Debugging purposes.
	--R = R.." V:"..tostring(storage.belly).." "..tostring(storage.burpsloaded).." "..tostring(storage.mood).." "..tostring(storage.feedstats.offered.floormeats)
	--R = R.." "..tostring( sb.printJson(storage.feedstats))
	--R = R.."\nBelly: "..tostring( math.floor( storage.vso.belly*100) / 100 )
	return R;
end

function getItemCurrentPrice()	--Get the current sell price for this item

	local belly = storage.vso.belly
	if belly > 50 then
		return 3000	--too fat
	elseif belly > 20 then
		return 5000	--just right
	elseif belly > 0 then
		return 500	--Unhealthy
	else
		return 20;	--You monster!
	end
end

function buildIcon()	--Build a CUSTOM icon for this item

	local directivestring = getRecolorDirectives()
	spovSpawnerSetDirectives( directivestring );
	
	local R = { { image="/vehicles/spov/simpledino/normaldinoicon.png?"..directivestring, position={0,0} } }
	
	--This is really cool. Now we need some good subicons to use to indicate SPOV status...
	local emote = "";
	if storage.vso.belly > 50 then
		emote = "surprised"	--too fat
	elseif storage.vso.belly > 20 then
		emote = ""	--just right
	elseif storage.vso.belly > 0 then
		emote = "confused" --Unhealthy
	else
		emote = "sad" --You monster!
	end
	
	if #emote > 0 then
		table.insert( R, { image="/animations/emotes/"..emote..".png:3", position={4,0} } )
	end
	
	return R;
end

function spovSpawnerItemGenerateCallback()	--THIS function is used to create the ITEM data when the object is broken. Very important. This is also a good way to test your storage.

	--this sets our storage defaults, very important if we want to track things or change colors.
	spovSpawnerStorageSetIfNotNil( {
		name = root.generateName( "/vehicles/spov/simpledino/normaldinonames.config:names", math.floor( math.random()*1073741824 ) )
		, belly = 30.0
		, burpsloaded = 0
		, pills = {}
		, feedstats = {
			eaten = {
				floormeats = 0
				, handmeats = 0
				, people = 0
			}
			,offered = {
				floormeats = 0
				, handmeats = 0
				, people = 0
			}
			,teased = {
				floormeats = 0
				, handmeats = 0
				, people = 0
			}
			,missed = {
				floormeats = 0
				, handmeats = 0
				, people = 0
			}
			,toured = {
				people = 0
			}
		}
	} );
	
	local directivestring = getRecolorDirectives()	--Regenerate item configuration override
	spovSpawnerSetDirectives( directivestring );
	
	--add tags HERE for pilling: spov	inventoryTags itemTags itemHasTag replaceTags
	
	storage.vso.itemConfigOverride = {
		inventoryIcon = buildIcon()
		,largeImage = "/vehicles/spov/simpledino/normaldino.png:idle.1?"..directivestring
		,subtitle = storage.vso.name
		,price = getItemCurrentPrice()
		,description = getItemStatusString()
		,lowerleft = "Belly: "..tostring( math.floor( storage.vso.belly*100) / 100 )
		,itemTags = { "spovpillable" }	--This is required if you want to use pills
	}
end