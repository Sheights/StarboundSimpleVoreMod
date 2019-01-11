--require "/scripts/vore/vso.lua"

--This is used to load / check the vso spawner configuration and return it
function vsoSpawnerLoadConfig()

	local params = config.getParameter("spawner")
	
	if not params then
		sb.logInfo( "VSO spawner at %s is missing configuration!", object.position() )
	else
	
		if params.types == nil then
			sb.logInfo( "VSO spawner at %s is missing spawner.types!", object.position() )
		else
		
			if params.position == nil then
				sb.logInfo( "VSO spawner at %s is missing spawner.position, using 0,0!", object.position() )
				params.position = {0,0}
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
function vsoSpawnerOffsetPosition( params, posvec )

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
function vsoSpawnerInit( params )
	
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
		
		local placepos = vsoSpawnerOffsetPosition( params, {0,0} );
		
		local spawnedone = world.spawnVehicle( params.useThisType, placepos, vehicleParams )--, [Json overrides])
		
		if spawnedone == nil then
			sb.logInfo( "VSO spawner at %s failed to spawn %s", object.position(), params.useThisType )
		else
			world.sendEntityMessage( spawnedone, "vsoCreatedFrom", entity.id(), placepos )
		end
		
		animator.setAnimationState("part", "off")	--Invis when spawned
		
		return spawnedone;
	end
end

--Call this when the spawner is smashed. Give it the id of the spawned vehicle.
function vsoSpawnerDie( spawnedone )
	if spawnedone ~= nil then
		if world.entityExists( spawnedone ) then
			world.callScriptedEntity( spawnedone, "vehicle.destroy" )	--Works perfectly!
			return true;
		end
	end
	return false;
end
	
function vsoSpawnerInteracted( spawnedone, args )
	world.sendEntityMessage( spawnedone, "vsoComeHome", entity.id(), args["sourceId"] )
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

function init()

	params = vsoSpawnerLoadConfig();
	
	myvehicle = vsoSpawnerInit( params );
	
	statepart = "part";
	statewhennear = { "off" }		--Get this from the config file.
	statewhenaway = { "ghost" }
	
	laststate = nil;
	lastnear = nil;
			
	animator.setAnimationState( statepart, randomPick( statewhennear ) );
	
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
		
	script.setUpdateDelta( 60 )
end

function update( dt )

	if object.isTouching( myvehicle ) then
		if lastnear ~= true then
			animator.setAnimationState( statepart, randomPick( statewhennear ) );
		end
		lastnear = true;
	else
		if lastnear ~= false then
			animator.setAnimationState( statepart, randomPick( statewhenaway ) );
		end
		lastnear = false;
	end
end

function die()

	vsoSpawnerDie( myvehicle );
end

function onInteraction(args)

	vsoSpawnerInteracted( myvehicle, args );
	
end
