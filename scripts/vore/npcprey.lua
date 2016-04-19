require "/scripts/vore/profiles.lua"

oldDie = die
oldInit = init
oldInteract = interact
oldUpdate = update
oldPreserved = tenant.preservedStorage

---------------------------------------------------------------------------------------
--#####################################################################################
--CONFIG SECTION

--There was a config here. It's gone now.

--#####################################################################################
---------------------------------------------------------------------------------------
amount = 0
familiarity	= 1
stopWatch	= 0
talkTimer	= 1

bribe 		= false
eaten 		= false
isDigest	= false

profile		= nil
myProfile 	= nil
predator	= nil

voreeffect	= "npcprey"
projectile	= "npcpreprojectile"

function tenant.preservedStorage()
	local newtable = {
		names = storage.names,
		freq = storage.freq
	}

	return util.mergeTable(newtable, oldPreserved() or {})
end

function init()

	oldInit()

	if storage.names == nil then
		storage.names = {}
		storage.freq = {}
	end

	if storage.profile == nil then
		profile = math.random( #profiles )
		storage.profile = profile
	else
		profile = storage.profile
	end
	
	myProfile = profiles[ profile ]
	
	initHook()
	
end

function die()
	
	world.logInfo("ping1")
	world.spawnProjectile( "cleanser" , mcontroller.position(), entity.id(), {0, 0}, true )
	if eaten then
		entity.say( myProfile["death"][familiarity][ math.random( #myProfile["death"][familiarity] ) ] )
		if math.random() > 0.8 then
			world.spawnItem( "money", world.entityPosition(entity.id()), math.random(200) + 100 )
		end
		world.spawnItem( "bone", world.entityPosition(entity.id()), 3 )
	end
	oldDie()
	
end

function interact(args)

	interactHook()
	
	if talkTimer < 1 then
	
		if eaten then

			world.spawnProjectile( "cleanser" , mcontroller.position(), entity.id(), {0, 0}, true )
			entity.say( myProfile["release"][familiarity][ math.random( #myProfile["release"][familiarity] ) ] )
			if bribe then
				world.spawnItem( "money", world.entityPosition(entity.id()), math.random(200) + 100 )
				bribe = false
			end
			eaten = false
			talkTimer = 1

		else
		
			local people = world.entityQuery( mcontroller.position(), 7, {
				withoutEntityId = entity.id(),
				includedTypes = {"npc", "player"},
				boundMode = "CollisionArea"
			})
			
			local personalspace = world.entityQuery( mcontroller.position(), 2, {
				withoutEntityId = entity.id(),
				includedTypes = {"npc", "player"},
				boundMode = "CollisionArea"
			})

			if #people == 1 and #personalspace == 0 then

				predator = people[1]
				familiarize( world.entityName( predator ) )
				entity.say( myProfile["consumed"][familiarity][ math.random( #myProfile["consumed"][familiarity] ) ] )
				
				if isDigest then
					local mergeOptions = {
						statusEffects = {{
							effect = "savor",
							duration = 1000
					}}}

--					world.spawnProjectile( "healprojectile" , args.sourcePosition, nil, {0, 0}, false)
					world.spawnProjectile( "npcpreyprojectile" , mcontroller.position(), entity.id(), {0, 0}, false, mergeOptions)
				else
					world.spawnProjectile( "npcpreyprojectile" , mcontroller.position(), entity.id(), {0, 0}, false)
				end
				eaten = true
			else
				entity.say("I do not want to be eaten.")
			end
			talkTimer = 1
		end
	do return end
	else
		talkTimer = 0
	end
	
	recognize( world.entityName( args.sourceId ) )
	
	if math.random() < 0.1 + .2 * familiarity then
		entity.say( myProfile["interact"][familiarity][ math.random( #myProfile["interact"][familiarity] ) ] )
	elseif not eaten then
		oldInteract(args)
	end

end

function update(dt)
	
	tempupdate = update
	tempinteract = interact
	oldUpdate(dt)

	if talkTimer < 1 then
		talkTimer = talkTimer + dt
	end
	
	if eaten and math.random(700) == 1 then
		if isDigest and math.random() < 0.02 * familiarity then
			entity.say( "^orange;" .. myProfile["bribe"][familiarity][ math.random( #myProfile["bribe"][familiarity] ) ] )
			bribe = true
		else
			entity.say( myProfile["idle"][familiarity][ math.random( #myProfile["idle"][familiarity] ) ] )
		end
	end
	
	updateHook(dt)

	update = tempupdate
	interact = tempinteract
end

function familiarize( name )

	temp = storage.names


	
	for i=0, #temp do
		if temp[i] == name then
			storage.freq[i] = storage.freq[i] + 1
			temp = storage.freq[i]
			
			if temp < 10 then
				familiarity = 1
			elseif temp < 20 then
				familiarity = 2
			else
				familiarity = 3
			end
			do return end
		end
	end
	
	storage.freq[#temp+1] = 1
	storage.names[#temp+1] = name
	
	familiarity = 1

end

function recognize( name )

	temp = storage.names
	
	for i=0, #temp do
	
		if temp[i] == name then
		
			temp = storage.freq[i]
			
			if temp < 10 then
				familiarity = 1
			elseif temp < 20 then
				familiarity = 2
			else
				familiarity = 3
			end
			do return end
		
		end
	end
	familiarity = 1
end

function initHook()

end

function updateHook(dt)

end

function interactHook()

end