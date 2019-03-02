--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

require "/scripts/util.lua"

function build( directory, config, parameters, level, seed )

	--[[
	sb.logInfo( "item build: config " );
	
	for k,v in pairs( config ) do
		sb.logInfo( k .. " "..tostring( v ) )
	end
	
	sb.logInfo( "item build: parameters " );
	
	for k,v in pairs( parameters ) do
		sb.logInfo( k .. " "..tostring( v ) )
	end
	]]--

	if parameters.scriptStorage ~= nil then
	
		config.scriptStorage = parameters.scriptStorage;	--Undocumented, scriptStorage requies use of "retainObjectParametersInItem" : true  and you must make a UUID for the object.
		
		local paramstore = parameters.scriptStorage;
		
		--config.scriptStorage = 
		
		--for k,v in pairs( paramstore ) do
		--	sb.logInfo( k .. " " .. tostring( v ) )
		--end
		
		--Specialized parameters do:storage.vso.itemConfigOverride
		if paramstore.vso ~= nil then
			if paramstore.vso.itemConfigOverride ~= nil then
				
				--config = sb.jsonMerge( config, paramstore.vso.itemConfigOverride );	--BAD practice
				
				--Okay have to MANUALLY override these. Since we use the vso tooltip, should be easy:
				config.tooltipFields = config.tooltipFields or {}
				
				--Hey this works for wiping OUT an image. So that's good. (strange)
				config.tooltipFields.objectImage = ""
				--config.tooltipFields.description = "";	--does NOT work...
				--config.tooltipFields.descriptionLabel = "";	--does NOT work...
				--config.descriptionLabel = "";	--does NOT work...
				
				--config.tooltipFields.descriptionLabel.color = {0,0,0,0};	--HACK to hide description does not work???
				
				--sb.logInfo( sb.printJson( config ) );
				--{"colorOptions":[{"a7d485":"a7d485","5fab55":"5fab55","338033":"338033","18521a":"18521a"},{"a7d485":"838383","5fab55":"555555","338033":"383838","18521a":"151515"},{"a7d485":"b5b5b5","5fab55":"808080","338033":"555555","18521a":"303030"},{"a7d485":"e6e6e6","5fab55":"b6b6b6","338033":"7b7b7b","18521a":"373737"},{"a7d485":"f4988c","5fab55":"d93a3a","338033":"932625","18521a":"601119"},{"a7d485":"ffd495","5fab55":"ea9931","338033":"af4e00","18521a":"6e2900"},{"a7d485":"ffffa7","5fab55":"e2c344","338033":"a46e06","18521a":"642f00"},{"a7d485":"b2e89d","5fab55":"51bd3b","338033":"247824","18521a":"144216"},{"a7d485":"96cbe7","5fab55":"5588d4","338033":"344495","18521a":"1a1c51"},{"a7d485":"d29ce7","5fab55":"a451c4","338033":"6a2284","18521a":"320c40"},{"a7d485":"eab3db","5fab55":"d35eae","338033":"97276d","18521a":"59163f"},{"a7d485":"ccae7c","5fab55":"a47844","338033":"754c23","18521a":"472b13"}],"objectName":"spovspawnernormaldino","itemName":"spovspawnernormaldino","description":"Summon a hungry dinosaur, it likes to eat meat! Don't tease it...","animationPosition":[0,21],"isContainer":false,"tooltipSubtitle":"SPOV Summoner","isWired":false,"orientations":[{"imagePosition":[-25.5,0],"flipImages":true,"spaces":[[-2,0],[-1,0],[0,0],[1,0],[2,0],[3,0],[4,0],[-2,1],[-1,1],[0,1],[1,1],[2,1],[3,1],[4,1],[-2,2],[-1,2],[0,2],[1,2],[2,2],[3,2],[4,2],[-2,3],[-1,3],[0,3],[1,3],[2,3],[3,3],[4,3]],"image":"/vehicles/spov/simpledino/normaldino.png:silhouette","direction":"left","spaceScan":0.1,"anchors":["bottom"]},{"imagePosition":[-25.5,0],"spaces":[[-5,0],[-4,0],[-3,0],[-2,0],[-1,0],[0,0],[1,0],[-5,1],[-4,1],[-3,1],[-2,1],[-1,1],[0,1],[1,1],[-5,2],[-4,2],[-3,2],[-2,2],[-1,2],[0,2],[1,2],[-5,3],[-4,3],[-3,3],[-2,3],[-1,3],[0,3],[1,3]],"image":"/vehicles/spov/simpledino/normaldino.png:silhouette","direction":"right","spaceScan":0.1,"anchors":["bottom"]}],"price":500,"health":5,"inventoryIcon":"/vehicles/spov/simpledino/normaldinoicon.png","rarity":"Rare","shortdescription":"SPOV Normal Dino","scriptStorage":{"myvehicle":9504,"vso":{"pills":{},"burpsloaded":0,"health":100,"_vsoSpawnOwner":9502,"belly":30,"name":"Bigjaw","colorReplaceMap":{"a7d485":"b2e89d","5fab55":"51bd3b","338033":"247824","18521a":"144216"},"_vsoSpawnOwnerName":"spovspawnernormaldino","itemConfigOverride":{"itemTags":["spovpillable"],"largeImage":"/vehicles/spov/simpledino/normaldino.png:idle.1?replace=5fab55=51bd3b;18521a=144216;a7d485=b2e89d;338033=247824;","inventoryIcon":[{"image":"/vehicles/spov/simpledino/normaldinoicon.png?replace=5fab55=51bd3b;18521a=144216;a7d485=b2e89d;338033=247824;","position":[0,0]}],"lowerleft":"Belly: 30.0","description":"Bigjaw is a happy dinosaur and it likes to eat meat! Don't tease it...","subtitle":"Bigjaw","price":5000},"feedstats":{"missed":{"people":0,"floormeats":0,"handmeats":0},"toured":{"people":0},"offered":{"people":0,"floormeats":0,"handmeats":0},"eaten":{"people":0,"floormeats":0,"handmeats":0},"teased":{"people":0,"floormeats":0,"handmeats":0}}}},"race":"generic","interactive":false,"animationCustom":{},"retainObjectParametersInItem":true,"colonyTags":["vore"],"npcToy":{"preciseStandPositionRight":[2,0],"preciseStandPositionLeft":[-2,0],"influence":["approach","leave"],"maxNpcs":1,"defaultReactions":{"leave":[[1,"smile"],[1,"annoyed"],[1,"laugh"]],"approach":[[1,"laugh"]]}},"scannable":false,"animation":"spovspawner.animation","tooltipFields":{"objectImage":""},"animationParts":{"bg":"/vehicles/spov/simpledino/normaldino.png:silhouette"},"builder":"/scripts/vore/spovitembuilder.lua","allowScanning":false,"printable":false,"tooltipKind":"vso","spov":{"template":{},"pillsAdd":{"softdigest":{},"digest":{},"heal":{}},"position":[0,2.625,0,2.625],"types":["spovnormaldino"]},"inspectable":false,"category":"other","objectImage":"/vehicles/spov/simpledino/normaldino.png:idle.1"}

				--config.description = "";	--no luck.
				--config.tooltipKind = "vso";
				--config.tooltipFields.descriptionLabel = "x";	--does NOT work...
				
				--Some builtins cant be changed. ( like the title, and description, and objectImage )
				local knownfields = {
					description = "statusLabel"
					,descriptionLabel = "statusLabel"
					,statusLabel = "statusLabel"
					,subtitle ="subtitle"
					,lowerleft = "lowerLeftLabel"
				}
				--,itemTags = "itemTags"	--Replace item tags! nice? Maybe? Hm.
					
				--nameLabel countLabel rarityLabel statusLabel statusImage fuelAmount countLabel priceLabel icon objectImage slotCount slotCountLabel tooltipFields 
				--itemConfig shortdescription description ItemDescriptor .itemdescription
				
				for k,v in pairs( paramstore.vso.itemConfigOverride ) do
					if knownfields[ k ] ~= nil then
						local tmp = {};
						tmp[ knownfields[ k ] ] = paramstore.vso.itemConfigOverride[ k ];
						config.tooltipFields = sb.jsonMerge( config.tooltipFields, tmp );
					else
						local tmp = {};
						tmp[ k ] = paramstore.vso.itemConfigOverride[ k ];
						config = sb.jsonMerge( config, tmp );
					end
				end
				
				
				--itemTags <= replace item tags in config???
				
				--config.tooltipFields
				--config.itemdescription = {};	--means nothing.
				--config.tooltipOverride = {};	--means nothing.
				
				--config = sb.jsonMerge( config, { descriptionLabel={ visible=false } } );	--Nope. nada.
				--config.tooltipFields = sb.jsonMerge( config.tooltipFields, { descriptionLabel={ visible=false } } );	--Zilcho
				
				
				--for k,v in pairs( knownfields ) do
				--	if paramstore.vso.itemConfigOverride[ k ] ~= nil then
				--		config.tooltipFields[ knownfields[ k ] ] = paramstore.vso.itemConfigOverride[ k ]
				--		config.tooltipFields[ k ] = paramstore.vso.itemConfigOverride[ k ]
				--		--sb.logInfo( "changed "..k.." to "..knownfields[ k ] );
				--	end
				--end
				
				
				--config.tooltipFields.descriptionLabel = "X"	--Why doesnt THIS work???
				--config.tooltipFields.descriptionLabel = ""	--THIS doesnt work though. Still pulls in a different description.
				--config.tooltipFields.description = ""	--Hax. for sure. Auto populated description field?
				--config.tooltipFields = sb.jsonMerge( config.tooltipFields, { descriptionLabel={ value="", position={ 0, 0 } } } );
				--config.tooltipFields = sb.jsonMerge( config.tooltipFields, { description={ value="", position={ 0, 0 } } } );	--crashed it
				
				--config.tooltipFields.descriptionLabel.visible = false;	--??? crashola
				--config.descriptionLabel.visible = false;	--??? crashola
				
				--DOES NOTHING. dangit!!
				--config.tooltipFields = sb.jsonMerge( config.tooltipFields, { descriptionLabel = { visible=false } } );
				--sb.logInfo( tostring( config.tooltipFields.descriptionLabel ) );
				--sb.logInfo( tostring( config.tooltipFields ) );
				--sb.logInfo( tostring( config.tooltipFields.description ) );	--bogus.
				--sb.logInfo( tostring( config.description ) );	--bogus.
				--sb.logInfo( tostring( config.descriptionLabel ) );	--nil
				
				--config.tooltipFields.descriptionLabel = { visible=false };	--Did NOT crash it. Did nothing however.

				--widget.setVisible("descriptionLabel", true)
				
				--hack to remove object image...
				--paramstore.vso.itemConfigOverride.objectImage = { scale=0 }
				--config = sb.jsonMerge( config, { objectImage = { scale=10 } } );
				--
				--config.tooltipFields = sb.jsonMerge( config.tooltipFields, { objectImage = { scale=10 } } );
				--
				
				--name = itemConfig.config.rottedItem or root.assetJson("/items/rotting.config:rottedItem"),
				--
				
				--Refer to cockpit.lua
				--config.objectImage = sb.jsonMerge( config.objectImage, {} );
				--config.objectImage["scale"] = 10;
				
				--tooltipGui.explored.value, tooltipGui.explored.color = tooltip.exploredLabel.explored, tooltip.exploredLabelColor.explored
					
				--require "/interface/cockpit/cockpitview.lua"
				--if self.tooltipOverride then
				--	return self.tooltipOverride
				--end
				--return View:tooltip(screenPosition)
			else
				--sb.logInfo( "construct item with no override"..directory );
			end
		else
		
			--sb.logInfo( "construct item with no vso data "..directory );	--/objects/vore/spov/
			
			--HM! objectImage is already mapped right.
			config.tooltipFields = config.tooltipFields or {}
			if config.description ~= nil then
				config.tooltipFields.statusLabel = config.description;
			end
			
			if config.tooltipSubtitle ~= nil then
				config.tooltipFields.subtitle = config.tooltipSubtitle;
			end
			
			--What is config? is it just the OBJECT config? in that case...
			
			
		end
	else
	
		--Construct DEFAULT item please... from the item's configuration? this never happens oddly...
		--sb.logInfo( "construct default item "..directory );
		
		--config.tooltipFields = config.tooltipFields or {}
		--config.tooltipFields.statusLabel = "yahoo"
	
		--config = sb.jsonMerge( config, {} );
		--config.tooltipFields = config.tooltipFields or {}
		--config.tooltipFields.statusLabel = "yahoo"	--description
	end
	
	return config, parameters
end
