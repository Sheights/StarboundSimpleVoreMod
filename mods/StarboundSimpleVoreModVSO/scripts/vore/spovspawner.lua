--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

--storage.myvehicle = nil;

statepart = "part";	--where is this exactly?
--statewhennear = { "off" }		--Get this from the config file.
--statewhenaway = { "ghost" }

laststate = nil;
--lastnear = nil;
--animator.setAnimationState( statepart, randomPick( statewhennear ) );

--"empty"

sentinit = nil
initialplacepos = {0,0}

respawntimer = -1;
loadedparams = nil;
delaysmashing = nil;

--Utilities for item building
function spovSpawnerPick( list )
	local listlen = #list;
	if listlen > 0 then
		return list[ 1 + (math.floor( math.random() * listlen ) % listlen) ]
	end
	return nil;
end

function spovSpawnerMakeColorReplaceDirectiveString( colmap )
	local R = "replace=";
	for k,v in pairs( colmap ) do
		R = R..k.."="..v..";"
	end
	return R;
end

function spovSpawnerSetDirectives( dirstring )
	animator.setGlobalTag( "directives", "?"..dirstring )
end

function spovSpawnerStorageSetIfNotNil( defaults )
	if storage.vso ~= nil then
	
	else
		storage.vso = {}
	end
	for k,v in pairs( defaults ) do
		if storage.vso[k] ~= nil then
			--Dont overwrite.
		else
			storage.vso[k] = v;
		end
	end
end

--1 is lightest, 4 is darkest
spovSpawnerDefaultPrimaryColorOptions = {
	{ "a7d485",  "5fab55",  "338033",  "18521a" }	--dino green
	,{ "838383",  "555555",  "383838",  "151515" }
	,{ "b5b5b5",  "808080",  "555555",  "303030" }
	,{ "e6e6e6",  "b6b6b6",  "7b7b7b",  "373737" }
	,{ "f4988c",  "d93a3a",  "932625",  "601119" }
	,{ "ffd495",  "ea9931",  "af4e00",  "6e2900" }
	,{ "ffffa7",  "e2c344",  "a46e06",  "642f00" }
	,{  "b2e89d",  "51bd3b",  "247824",  "144216" }
	,{  "96cbe7",  "5588d4",  "344495",  "1a1c51" }
	,{  "d29ce7",  "a451c4",  "6a2284",  "320c40" }
	,{  "eab3db",  "d35eae",  "97276d",  "59163f" }
	,{  "ccae7c",  "a47844",  "754c23",  "472b13" }
}

--This is used to load / check the SPOV spawner configuration and return it
function spovSpawnerLoadConfig()

	--RETAIN MEMORY (if you have it otherwise this is a generic VSO and doesnt need memory)
	
	--WHOA hold up. the scriptStorage ONLY APPLIES if we DONT already have a storage in the vso!
	--IE only applies on CREATE of this object
	--
	local havevsostorage = (storage.vso ~= nil);	--true if we have storage
	--sb.logInfo( "Do we have storage: "..tostring( havevsostorage ) )
	
	local gotscriptstore = config.getParameter("scriptStorage")
	if gotscriptstore ~= nil then
	
		local hasany = false;
		for k,v in pairs( gotscriptstore ) do
			hasany = true;
			break;
		end
		
		if hasany then
		
			--Is this required to use storage? Probably is.
			if object.uniqueId() then
				storage.uniqueId = object.uniqueId()
			else
				if storage.uniqueId ~= nil then
					--Interesting...
				else
					--sb.logInfo("GENERATING UNIQUE ID" );
					storage.uniqueId = storage.uniqueId or sb.makeUuid()	--Hm!
				end
				--sb.logInfo("ASSIGNING UNIQUE ID" );
				object.setUniqueId( storage.uniqueId )
			end
			
			local excludelist = { myvehicle=0, uniqueId=0 }
			
			if havevsostorage then
				--gotscriptstore.vso = storage.vso;
				--EXCLUDE:
				--	"uniqueId", "myvehicle", "vso"
				for k,v in pairs( gotscriptstore ) do
					if k ~= "vso" then
						if excludelist[k] ~= nil then
						
						else
							storage[ k ] = v;
						end
					end
					--storage.vso[k] = v;
					--sb.logInfo( k.." = "..tostring( v ) )
				end
			else
				for k,v in pairs( gotscriptstore ) do
					if excludelist[k] ~= nil then
					
					else
						storage[ k ] = v;
					end
					--storage.vso[k] = v;
					--sb.logInfo( k.." = "..tostring( v ) )
				end
			end
			
			--storage.vso = {};
			--for k,v in pairs( gotscriptstore ) do
			--	storage[ k ] = v;
			--	--storage.vso[k] = v;
			--	--sb.logInfo( k.." = "..tostring( v ) )
			--end
			
		end
	end

	local params = config.getParameter("spov")	--Not quite right...
	
	if not params then
		sb.logInfo( tostring(entity.id()).." SPOV spawner at %s is missing configuration!", object.position() )
	else
	
		if params.types == nil then
			sb.logInfo( tostring(entity.id()).." SPOV spawner at %s is missing spawner.types!", object.position() )
		else
		
			if params.position == nil then
				sb.logInfo( tostring(entity.id()).." SPOV spawner at %s is missing spawner.position, using 0,0,0,0!", object.position() )
				params.position = { 0, 0, 0, 0 }
			end
					
			if #params.position < 4 then
				sb.logInfo( tostring(entity.id()).." SPOV spawner at %s position parameter wrong length [ xleft, yleft, xright, yright ]!", object.position() )
				params.position = { 0, 0, 0, 0 }
			end
			
			params.useThisTypeIndex = math.random( #params.types );
			
			if params.useThisTypeIndex >= #params.types then
				params.useThisTypeIndex = 0
			end
			
			params.useThisType = params.types[ params.useThisTypeIndex + 1 ];
		
		end
	end
	
	if params == nil then
		--sb.logInfo( "soft failure" );
		object.smash( false );	--SOFT failure
	end
	return params;
end

--You can get a offset position relative to the spawner direction. requires the params object and a {x,y} vector
function spovSpawnerOffsetPosition( params, posvec )

	local placepos = params.position;
	local facingsgn = object.direction();
	local retpos = { placepos[1], placepos[2] }
	if object.direction() < 0 then
		retpos[1] = facingsgn*(posvec[1] + placepos[1]) + object.position()[1]
		retpos[2] = (posvec[2] + placepos[2]) + object.position()[2]
	else
		retpos[1] = facingsgn*(posvec[1] + placepos[3]) + object.position()[1]
		retpos[2] = (posvec[2] + placepos[4]) + object.position()[2]
	end
	
	return retpos;
end

--Call this to initialize a spawner, given the loaded params object ( vso.spawnerLoadConfig )
function spovSpawnerInit( params )
	
	if params == nil then
		--sb.logInfo( "init failure" );
		object.smash( false );	--SOFT failure
		return nil;
	else
	
		script.setUpdateDelta( 0 )
		
		object.setInteractive( true );
		
		initialplacepos = spovSpawnerOffsetPosition( params, {0,0} );
		
		animator.setAnimationState( statepart, "off" )	--Invis when spawned
		
		if storage.myvehicle ~= nil then
		
			--THIS meta information MUST MATCH or else.
			local worldsvname = world.entityName( storage.myvehicle );	--MUST MATCH: any in list of params.useThisType / params.types ...
			local worldsvvel = world.entityVelocity( storage.myvehicle );	--MUST NOT BE NIL
			local worldsvtype = world.entityType( storage.myvehicle );	--MUST MATCH: "vehicle"
			
			--sb.logInfo( tostring(entity.id()).." SPOV Spawner 1 : "..tostring( worldsvname ).." "..tostring( worldsvvel ).." "..tostring( worldsvtype ).." "..tostring( storage.myvehicle ) )
				
			if worldsvtype == "vehicle" and worldsvvel ~= nil then
				
				if object.uniqueId() ~= nil then
				
					--world.entityExists()
					--sb.logInfo( tostring( world.entityUniqueId( storage.myvehicle ) ) );	Not vehicles.
					
					--PROBLEM: this "stored" ID may not persist... Hm.
					--So, this vehicle MUST be queried. (async)
					if world.entityExists( storage.myvehicle ) then
						--WAIT FOR IT...
						--sb.logInfo( tostring( entity.id() ).." SPOV spawner 2 HAS vehicle "..tostring( storage.myvehicle ).." uid:"..tostring( object.uniqueId() ) )
					else
						--sb.logInfo( tostring( entity.id() ).." SPOV spawner 2 had a vehicle but it is gone now "..tostring( storage.myvehicle ).." uid:"..tostring( object.uniqueId() ) )
						storage.myvehicle = nil;
					end			
					
				else
					if world.entityExists( storage.myvehicle ) then
						--sb.logInfo( tostring( entity.id() ).." SPOV spawner 2 not using storage but retained an ID."..tostring(storage.myvehicle) );
						--storage.myvehicle = nil;
					else
					
						--sb.logInfo( tostring( entity.id() ).." SPOV spawner 2 not using storage and has no ID."..tostring(storage.myvehicle) );
						storage.myvehicle = nil;
					end
				end
			else
			
				--sb.logInfo( tostring( entity.id() ).." SPOV spawner stored 2 ID is completely invalid "..tostring(storage.myvehicle) );
				storage.myvehicle = nil;
			end
		
			--object.uniqueId();
			--storage.uniqueId
			--world.entityUniqueId( EntityId entityId )
			--world.entityUniqueId( EntityId entityId )
			--world.findUniqueEntity( uid )
			
			--if object.uniqueId() then
			--	storage.uniqueId = object.uniqueId()
			--end
		end
		
		if storage.myvehicle == nil then
		
			--sb.logInfo( tostring( entity.id() ).." SPOV spawner 3 about to spawn, old id is "..tostring( storage.myvehicle ) );
				
			local vehicleParams = {
				ownerKey = entity.id(),
				startHealthFactor = 1.0,
				fromItem = true,
				initialFacing = object.direction()	--This will be 1 for right or -1 for left. 
			}	
			
			storage.myvehicle = world.spawnVehicle( params.useThisType, initialplacepos, vehicleParams )--, [Json overrides])
		
			--sb.logInfo( tostring( entity.id() ).." SPOV spawner 3 SPAWNINED a vehicle: "..tostring( storage.myvehicle ) );
		
			if storage.myvehicle == nil then
				sb.logInfo( "SPOV spawner 3 at %s failed to spawn %s", object.position(), params.useThisType )
			end
		end
		
		if storage.myvehicle ~= nil then
			world.sendEntityMessage( storage.myvehicle, "vsoCreatedFrom", entity.id(), initialplacepos, object.uniqueId() )	--It wont have the handler ready...
		end
		
		return storage.myvehicle;
	end
end

--Call this when the spawner is smashed. Give it the id of the spawned vehicle.
function spovSpawnerDie( spawnedone )

	--storage = {}	--Wipes out storage??? Hm...
	--sb.logInfo( "spovSpawnerDie" );
	--Hm... scriptStorage
	
	--Need to call "update item info" function if present... Hm... How to do that?
	--
	if _ENV['spovSpawnerItemGenerateCallback'] ~= nil then
		spovSpawnerItemGenerateCallback();
	end
	
	if _ENV['spovSpawnerEndCallback'] ~= nil then
		spovSpawnerEndCallback();
	end
	
	if spawnedone ~= nil then
		if world.entityExists( spawnedone ) then
			--This might be TOO MUCH (doesnt let use do a "final" or "deny" or things like that...)
			--	Hm.
			world.callScriptedEntity( spawnedone, "vehicle.destroy" )	--Works perfectly!
			return true;
		end
	end
	return false;
end

function spovSpawnerInteracted( spawnedone, args )
	--world.sendEntityMessage( spawnedone, "vsoPlayerInteracted", entity.id(), args["sourceId"] )
end

function spovSpawnerNPCInteracted( spawnedone, npcid )
	world.sendEntityMessage( spawnedone, "vsoNPCInteracted", entity.id(), npcid )
end

--Select a random element from a list
--[[
function randomPick( list )
	local dowhat = #list;
	if dowhat > 0 then
		dowhat = math.random( dowhat );
		if dowhat >= #list then
			dowhat = 0
		end
		return list[ dowhat + 1 ];
	end
	return nil;
end
]]--

function init( args )

	--sb.logInfo( tostring( entity.id() ).." SPOV Spawner init() "..tostring( storage.myvehicle ) )

	initialplacepos = { object.position()[1], object.position()[2] }

	loadedparams = spovSpawnerLoadConfig();
	
	if storage.myvehicle ~= nil then
		if world.entityExists( storage.myvehicle ) then
			--loadedparams
			--if params.types ~= nil then well. Pick one and STAY with that one forever once placed?
			if world.entityName( storage.myvehicle ) == loadedparams.useThisType then
				--sb.logInfo( "Remembered: "..tostring( world.entityName( storage.myvehicle ) ) );
				--Looks good enough! low probability of collision.
			else
				--sb.logInfo( "Id exists, but type is wrong: "..tostring( world.entityName( storage.myvehicle ) ) );
				storage.myvehicle = nil;
			end
		else
			storage.myvehicle = nil;
		end
	end

	--Is this important? No. (maybe? because it SETS stuff...)
	if _ENV['spovSpawnerItemGenerateCallback'] ~= nil then
		spovSpawnerItemGenerateCallback();
	end
	
	message.setHandler("vsoSpawnerSay",
		function(_, _, ownerKey, message)
			object.say( message );
		end)
		
	message.setHandler("vsoSpawnerDie",
		function(_, _, ownerKey, options)
			--options.
			--sb.logInfo( "spawner die message recieved " );
			if storage.myvehicle == ownerKey then
				if options ~= nil then
					if options.respawn ~= nil then
						respawntimer = options.respawn
					end
					if options.smash ~= nil then
						--sb.logInfo( "spawner die message recieved and smashing" );
						if options.permadeath == true then
							delaysmashing = { arg = true, time = 0, timemax = 0.5 }
						else
							delaysmashing = { arg = false, time = 0, timemax = 0.5 }
						end
					end
				end
			end
		end)
		
	--spovSpawnerInit( loadedparams );
	
	
	message.setHandler("vsoRelinkVehicleToSpawner",
		function(_, _, fromid, uidreq)
			--sb.logInfo( "Recieved relink "..tostring( fromid ).." "..tostring( uidreq ).." "..tostring( entity.id() ).." "..tostring( object.uniqueId() ) )
			if uidreq == object.uniqueId() then
				delaysmashing = nil;
				--sb.logInfo( "ID DOES match. "..tostring( storage.myvehicle ).." "..tostring( fromid ) );
				storage.myvehicle = fromid;	--_vsoSpawnOwnerUID
				sentinit = nil;
				--script.setUpdateDelta( 1 )
			else
				--sb.logInfo( "ID does not match. "..tostring( storage.myvehicle ) );
			end
		end)
	
	message.setHandler("vsoSpawnerAnimState",
		function(_, _, fromKey, state)
			if storage.myvehicle == fromKey then
				--sb.logInfo( "SET"..statepart.." "..state );
				animator.setAnimationState( statepart, state );
			end
		end)
		
	message.setHandler( "vsoStorageSaveDataKey",
		function(_, _, fromKey, key, data)
			--sb.logInfo( "vsoStorageSaveData "..tostring( fromKey ).." "..tostring( storage.myvehicle ) );
			if storage.myvehicle == fromKey then
				--sb.logInfo( "vsoStorageSaveData "..tostring( fromKey ).." "..tostring( storage.myvehicle ) );
				storage.vso[ key ] = data;
			end
		end )
		
	message.setHandler( "vsoStorageSaveData",
		function(_, _, fromKey, data)
			--sb.logInfo( "vsoStorageSaveData "..tostring( fromKey ).." "..tostring( storage.myvehicle ) );
			if storage.myvehicle == fromKey then
				--sb.logInfo( "vsoStorageSaveData "..tostring( fromKey ).." "..tostring( storage.myvehicle ) );
				storage.vso = data;
			end
		end )
		
	message.setHandler( "vsoStorageLoadData",
		function(_, _, fromKey)
			--sb.logInfo( "vsoStorageLoadData "..tostring( fromKey ).." "..tostring( storage.myvehicle ) );
			if storage.myvehicle == fromKey then
				--sb.logInfo( "vsoStorageLoadData: "..tostring( storage.vso ) );
				world.sendEntityMessage( storage.myvehicle, "vsoStorageLoadData", entity.id(), storage.vso )
			end
		end )
		
	script.setUpdateDelta( 1 )
	
	if _ENV['spovSpawnerInitCallback'] ~= nil then
		spovSpawnerInitCallback( storage.myvehicle );
	end
end

function update( dt )

	if delaysmashing ~= nil then
	
		--if delaysmashing
		delaysmashing.time = delaysmashing.time + dt;
		if delaysmashing.time > delaysmashing.timemax then
			object.smash( delaysmashing.arg );
			delaysmashing = nil;
		else
			script.setUpdateDelta( 1 )
		end
	else
		
		--So we defer a bit.
		if sentinit ~= nil then
		
			if respawntimer >= 0 then
				respawntimer = respawntimer - dt;
				if respawntimer < 0 then
					
					--Do a respawn...
					if world.entityExists( storage.myvehicle ) then
						--Hm! wait some more.
						respawntimer = 1;
					else
						
						sentinit = nil;
						
						paramobj = spovSpawnerLoadConfig();	--what??
						
						spovSpawnerInit( paramobj );
										
						script.setUpdateDelta( 1 )
						
						if _ENV['spovSpawnerInitCallback'] ~= nil then
							spovSpawnerInitCallback( storage.myvehicle );
						end
						
						respawntimer = -1;
					end
				end
			end
		
		else
		
			spovSpawnerInit( loadedparams );
			
			--world.sendEntityMessage( storage.myvehicle, "vsoCreatedFrom", entity.id(), initialplacepos, object.uniqueId() )	--It wont have the handler ready...
			sentinit = true;
			script.setUpdateDelta( 60 )
		end
	
	end

end

function die()
	spovSpawnerDie( storage.myvehicle );
end

function onInteraction(args)
	spovSpawnerInteracted( storage.myvehicle, args );
end

function onNpcPlay(npcId)
	spovSpawnerNPCInteracted( storage.myvehicle, npcId );
end
