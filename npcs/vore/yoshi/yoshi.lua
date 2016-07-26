require "/scripts/vore/npcvore.lua"

soundLock = true

ci = nil

duration = 60

swallowsound = "yoshitongueprojectile"

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
		voreeffect = "yoshired"
	elseif ci == 1 then
		voreeffect = "yoshigreen"
	elseif ci == 2 then
		voreeffect = "yoshiindigo"
	elseif ci == 3 then
		voreeffect = "yoshiyellow"
	elseif ci == 4 then
		voreeffect = "yoshiblack"
	elseif ci == 5 then
		voreeffect = "yoshicyan"
	elseif ci == 6 then
		voreeffect = "yoshipink"
	elseif ci == 7 then
		voreeffect = "yoshiwhite"
	elseif ci == 8 then
		voreeffect = "yoshiorange"
	elseif ci == 9 then
		voreeffect = "yoshipurple"
	end
	
end

function interactHook()

	if math.random(4) == 1 then
		world.spawnProjectile( "yoshiyoshiprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function loseHook()

	world.spawnProjectile( "yoshilayprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	
end

function updateHook()

	if fed then
		if stopWatch < 0.3 then
			npc.setItemSlot( "head", head2 )
		elseif	stopWatch < 0.6 then			
			npc.setItemSlot( "head", head3 )
		elseif	stopWatch < 0.9 then			
			npc.setItemSlot( "head", head4 )
			if soundLock then
				world.spawnProjectile( "yoshiswallowprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
				soundLock = false
			end
		elseif	stopWatch < 1.2 then
			soundLock = true
			npc.setItemSlot( "head", head )
			npc.setItemSlot( "legs", legsbelly )
		elseif stopWatch > 59.7 then
			npc.setItemSlot( "head", head5 )
		end
	end

end