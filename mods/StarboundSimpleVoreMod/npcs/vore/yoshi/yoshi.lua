require "/scripts/vore/npcvore.lua"

ci			= nil

animFlagEat	= false
animFlagLay	= false
soundLock	= false

animTimer	= 0

eggEffect	= "npceggbase"

function initHook()
	if storage.ci == nil then
		ci = npc.getItemSlot("legs").parameters.colorIndex
		storage.ci = ci
	else
		ci = storage.ci
	end
	legs = {
		name = "yoshilegs",
		parameters = {
					colorIndex = ci
	}}	
	legsbelly = {
		name = "yoshilegsbelly",
		parameters = {
					colorIndex = ci
	}}	
	head = {
		name = "yoshihead1",
		parameters = {
		colorIndex = ci
	}}	
	head2 = {
		name = "yoshihead2",
		parameters = {
					colorIndex = ci
	}}	
	head3= {
		name = "yoshihead3",
		parameters = {
					colorIndex = ci
	}}	
	head4 = {
		name = "yoshihead4",
		parameters = {
					colorIndex = ci
	}}	
	head5 = {
		name = "yoshihead5",
		parameters = {
					colorIndex = ci
	}}
	if ci == 0 then
		eggEffect = "npceggyoshired"
	elseif ci == 1 then
		eggEffect = "npceggyoshigreen"
	elseif ci == 2 then
		eggEffect = "npceggyoshiindigo"
	elseif ci == 3 then
		eggEffect = "npceggyoshiyellow"
	elseif ci == 4 then
		eggEffect = "npceggyoshiblack"
	elseif ci == 5 then
		eggEffect = "npceggyoshicyan"
	elseif ci == 6 then
		eggEffect = "npceggyoshipink"
	elseif ci == 7 then
		eggEffect = "npceggyoshiwhite"
	elseif ci == 8 then
		eggEffect = "npceggyoshiorange"
	elseif ci == 9 then
		eggEffect = "npceggyoshipurple"
	end
end

function dress()
end

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "yoshitongueprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	animFlagEat = true
	animTimer 	= 0
	soundLock 	= true
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "yoshitongueprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	animFlagEat = true
	animTimer 	= 0
	soundLock 	= true
end

function interactHook(input)
	if math.random(4) == 1 then
		world.spawnProjectile( "yoshiyoshiprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end	
end

function digestHook(id, time, dead)
	world.spawnProjectile( "yoshilayprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	world.sendEntityMessage( id, "applyStatusEffect", eggEffect, 60, entity.id() )
	npc.setItemSlot( "legs", legs )
	animFlagEat = false
	animFlagLay = true
end

function releaseHook(input, time)
	if time >= 60 then
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "voreclear", 1, entity.id() )
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", eggEffect, 60, entity.id() )
	end
	world.spawnProjectile( "yoshilayprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	npc.setItemSlot( "legs", legs )
	animFlagEat = false
	animFlagLay = true
end

function updateHook(dt)
	if animFlagEat then
		if animTimer < 0.3 then
			npc.setItemSlot( "head", head2 )
		elseif	animTimer < 0.6 then			
			npc.setItemSlot( "head", head3 )
		elseif	animTimer < 0.9 then			
			npc.setItemSlot( "head", head4 )
			if soundLock then
				world.spawnProjectile( "yoshiswallowprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
				soundLock = false
			end
		else
			npc.setItemSlot( "head", head )
			npc.setItemSlot( "legs", legsbelly )
			animFlagEat = false
			animTimer = 0
		end
		animTimer = animTimer + dt
	end
	if animFlagLay then
		if animTimer < 0.4 then
			npc.setItemSlot( "head", head5 )
		else
			npc.setItemSlot( "head", head )
			animFlagLay = false
		end
		animTimer = animTimer + dt
	end
end