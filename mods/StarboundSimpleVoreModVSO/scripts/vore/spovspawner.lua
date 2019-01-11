
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
				storage.uniqueId = storage.uniqueId or sb.makeUuid()	--Hm!
				object.setUniqueId( storage.uniqueId )
			end
			
			if havevsostorage then
				--gotscriptstore.vso = storage.vso;
				for k,v in pairs( gotscriptstore ) do
					if k ~= "vso" then
						storage[ k ] = v;
					end
					--storage.vso[k] = v;
					--sb.logInfo( k.." = "..tostring( v ) )
				end
			else
				for k,v in pairs( gotscriptstore ) do
					storage[ k ] = v;
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
		sb.logInfo( "SPOV spawner at %s is missing configuration!", object.position() )
	else
	
		if params.types == nil then
			sb.logInfo( "SPOV spawner at %s is missing spawner.types!", object.position() )
		else
		
			if params.position == nil then
				sb.logInfo( "SPOV spawner at %s is missing spawner.position, using 0,0,0,0!", object.position() )
				params.position = { 0, 0, 0, 0 }
			end
					
			if #params.position < 4 then
				sb.logInfo( "SPOV spawner at %s position parameter wrong length [ xleft, yleft, xright, yright ]!", object.position() )
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
		object.smash( false );	--SOFT failure
		return nil;
	else
	
		script.setUpdateDelta( 0 )
		
		object.setInteractive( true );
		
		local vehicleParams = {
			ownerKey = entity.id(),
			startHealthFactor = 1.0,
			fromItem = true,
			initialFacing = object.direction()
		}	
		
		local placepos = spovSpawnerOffsetPosition( params, {0,0} );
		
		local spawnedone = world.spawnVehicle( params.useThisType, placepos, vehicleParams )--, [Json overrides])
		
		if spawnedone == nil then
			sb.logInfo( "SPOV spawner at %s failed to spawn %s", object.position(), params.useThisType )
		else
			world.sendEntityMessage( spawnedone, "vsoCreatedFrom", entity.id(), placepos )
		end
		
		animator.setAnimationState("part", "off")	--Invis when spawned
		
		return spawnedone;
	end
end

--Call this when the spawner is smashed. Give it the id of the spawned vehicle.
function spovSpawnerDie( spawnedone )

	--storage = {}	--Wipes out storage??? Hm...
	--sb.logInfo( "spovSpawnerDie" );
	
	if spawnedone ~= nil then
		if world.entityExists( spawnedone ) then
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

function changeAnimState( setpart, towhat )
	if towhat ~= laststate then
		laststate = towhat;
		animator.setAnimationState( setpart, towhat );
	end
end

--Select a random element from a list
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

function init( args )

	params = spovSpawnerLoadConfig();
	
	myvehicle = spovSpawnerInit( params );
	
	statepart = "part";	--where is this exactly?
	--statewhennear = { "off" }		--Get this from the config file.
	--statewhenaway = { "ghost" }
	
	laststate = nil;
	--lastnear = nil;
	--animator.setAnimationState( statepart, randomPick( statewhennear ) );
	
	--"empty"
	
	message.setHandler("vsoSpawnerSay",
		function(_, _, ownerKey, message)
			object.say( message );
		end)
		
	message.setHandler("vsoSpawnerAnimState",
		function(_, _, fromKey, state)
			if myvehicle == fromKey then
				changeAnimState( statepart, state );
			end
		end)
		
	message.setHandler( "vsoStorageSaveDataKey",
		function(_, _, fromKey, key, data)
			--sb.logInfo( "vsoStorageSaveData "..tostring( fromKey ).." "..tostring( myvehicle ) );
			if myvehicle == fromKey then
				--sb.logInfo( "vsoStorageSaveData "..tostring( fromKey ).." "..tostring( myvehicle ) );
				storage.vso[ key ] = data;
			end
		end )
		
	message.setHandler( "vsoStorageSaveData",
		function(_, _, fromKey, data)
			--sb.logInfo( "vsoStorageSaveData "..tostring( fromKey ).." "..tostring( myvehicle ) );
			if myvehicle == fromKey then
				--sb.logInfo( "vsoStorageSaveData "..tostring( fromKey ).." "..tostring( myvehicle ) );
				storage.vso = data;
			end
		end )
		
	message.setHandler( "vsoStorageLoadData",
		function(_, _, fromKey)
			--sb.logInfo( "vsoStorageLoadData "..tostring( fromKey ).." "..tostring( myvehicle ) );
			if myvehicle == fromKey then
				--sb.logInfo( "vsoStorageLoadData: "..tostring( storage.vso ) );
				world.sendEntityMessage( myvehicle, "vsoStorageLoadData", entity.id(), storage.vso )
			end
		end )
		
	script.setUpdateDelta( 60 )
end

function update( dt )
	--[[if object.isTouching( myvehicle ) then
		if lastnear ~= true then
			animator.setAnimationState( statepart, randomPick( statewhennear ) );
		end
		lastnear = true;
	else
		if lastnear ~= false then
			animator.setAnimationState( statepart, randomPick( statewhenaway ) );
		end
		lastnear = false;
	end]]--
end

function die()
	spovSpawnerDie( myvehicle );
end

function onInteraction(args)
	spovSpawnerInteracted( myvehicle, args );
end

function onNpcPlay(npcId)
	spovSpawnerNPCInteracted( myvehicle, npcId );
end
