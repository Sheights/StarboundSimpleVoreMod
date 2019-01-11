require "/scripts/vore/npcvore.lua"

animFlagEat	= false
animFlagLay	= false
soundLock	= false

animTimer	= 0

playerLines = {	"I hope its cozy in there.",
				"I'm going to be keeping you in my belly for a little while.",
				"Yoshi <3"
}

function initHook()

	if storage.mi == nil then
		mi = npc.getItemSlot("head").name
		if mi == "dezzyyoshihead11" then
			mi = 1
		else
			mi = 2
		storage.mi = mi
		end
	else
		mi = storage.mi
	end
	legs = {
		name = "dezzyyoshilegs",
		parameters = {
					colorIndex = 8
	}}	
	legsbelly = {
		name = "dezzyyoshilegsbelly",
		parameters = {
					colorIndex = 8
	}}
	if mi == 1 then
		head = {
			name = "dezzyyoshihead11",
			parameters = {
				colorIndex = 8
		}}	
		head2 = {
			name = "dezzyyoshihead12",
			parameters = {
				colorIndex = 8
		}}	
		head3= {
			name = "dezzyyoshihead13",
			parameters = {
				colorIndex = 8
		}}	
		head4 = {
			name = "dezzyyoshihead14",
			parameters = {
				colorIndex = 8
		}}	
		head5 = {
			name = "dezzyyoshihead15",
			parameters = {
				colorIndex = 8
		}}
	else
		head = {
			name = "dezzyyoshihead21",
			parameters = {
				colorIndex = 8
		}}	
		head2 = {
			name = "dezzyyoshihead22",
			parameters = {
				colorIndex = 8
		}}	
		head3= {
			name = "dezzyyoshihead23",
			parameters = {
				colorIndex = 8
		}}	
		head4 = {
			name = "dezzyyoshihead24",
			parameters = {
				colorIndex = 8
		}}	
		head5 = {
			name = "dezzyyoshihead25",
			parameters = {
				colorIndex = 8
		}}
	end
end

function dress()
end

function feedHook()
	npc.say("Mmmm...Yoshi <3")
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "yoshitongueprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	animFlagEat = true
	animTimer 	= 0
	soundLock 	= true
end

function requestHook(args)
	npc.say("Mmmm...Yoshi <3")
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "yoshitongueprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	animFlagEat = true
	animTimer 	= 0
	soundLock 	= true
end

function interactHook()
	if math.random(5) == 1 then
		world.spawnProjectile( "yoshiyoshiprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
end

function digestHook(id, time, dead)
	npc.say("That was delightful, I hope you've enjoyed the trip <3")
	world.spawnProjectile( "yoshilayprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	world.sendEntityMessage( id, "applyStatusEffect", "npceggyoshiorange", 60, entity.id() )
	npc.setItemSlot( "legs", legs )
	animFlagEat = false
	animFlagLay = true
end

function releaseHook(input, time)
	npc.say("That was delightful, I hope you've enjoyed the trip <3")
	if time >= 60 then
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "voreclear", 1, entity.id() )
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "npceggyoshiorange", 60, entity.id() )
	end
	world.spawnProjectile( "yoshilayprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	npc.setItemSlot( "legs", legs )
	animFlagEat = false
	animFlagLay = true
end

function updateHook(dt)
	if math.random(700) == 1 and containsPlayer() then
		sayLine ( playerLines )
	end
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