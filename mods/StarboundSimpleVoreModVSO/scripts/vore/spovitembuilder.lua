--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

require "/scripts/util.lua"

function build( directory, config, parameters, level, seed )

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
				
				--Some builtins cant be changed. ( like the title, and description, and objectImage )
				local knownfields = {
					description = "statusLabel"
					,descriptionLabel = "statusLabel"
					,statusLabel = "statusLabel"
					,subtitle ="subtitle"
					,lowerleft = "lowerLeftLabel"
				}
				
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
