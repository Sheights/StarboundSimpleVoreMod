
require "/scripts/util.lua"

function build( directory, config, parameters, level, seed )

	if parameters.scriptStorage ~= nil then
	
		config.scriptStorage = parameters.scriptStorage;	--Undocumented, scriptStorage requies use of "retainObjectParametersInItem" : true  and you must make a UUID for the object.
		
		--Specialized parameters do:storage.vso.itemConfigOverride
		if parameters.scriptStorage.vso ~= nil then
			if parameters.scriptStorage.vso.itemConfigOverride ~= nil then
				config = sb.jsonMerge( config, parameters.scriptStorage.vso.itemConfigOverride );
				
				--Okay have to MANUALLY override these. Since we use the vso tooltip, should be easy:
				config.tooltipFields = config.tooltipFields or {}
				
				--Some builtins cant be changed. ( like the title, and description, and objectImage )
				local knownfields = {
					description = "primaryLabel"
					,descriptionLabel = "primaryLabel"
					,primaryLabel = "primaryLabel"
					,subtitle ="subtitle"
				}
				
				for k,v in pairs( knownfields ) do
					if parameters.scriptStorage.vso.itemConfigOverride[ k ] ~= nil then
						config.tooltipFields[ knownfields[ k ] ] = parameters.scriptStorage.vso.itemConfigOverride[ k ]
						config.tooltipFields[ k ] = parameters.scriptStorage.vso.itemConfigOverride[ k ]
						--sb.logInfo( "changed "..k.." to "..knownfields[ k ] );
					end
				end
				
			end
		end
	end
	
	return config, parameters
end
