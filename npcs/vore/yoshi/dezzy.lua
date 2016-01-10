require "/scripts/vore/npcvore.lua"

soundLock = true

mi = nil

duration = 60

swallowsound = "yoshitongueprojectile"
voreeffect = "yoshiorange"

playerLines = {	"I hope its cozy in there.",
				"I'm going to be keeping you in my belly for a little while.",
				"Yoshi <3"
}

function feedHook()

	entity.say("Mmmm...Yoshi <3")

end

function initHook()

	if storage.mi == nil then
		mi = entity.getItemSlot("head").name
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

function interactHook()

	if math.random(5) == 1 then
		world.spawnProjectile( "yoshiyoshiprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function loseHook()

	world.spawnProjectile( "yoshilayprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	entity.say("That was delightful, I hope you've enjoyed the trip <3")
	
end

function updateHook()

	if fed then
		if stopWatch < 0.4 then
			entity.setItemSlot( "head", head2 )
		elseif	stopWatch < 0.8 then			
			entity.setItemSlot( "head", head3 )
		elseif	stopWatch < 1.2 then			
			entity.setItemSlot( "head", head4 )
			if soundLock then
				world.spawnProjectile( "yoshiswallowprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
				soundLock = false
			end
		elseif	stopWatch < 1.6 then
			soundLock = true
			entity.setItemSlot( "head", head )
			entity.setItemSlot( "legs", legsbelly )
		elseif stopWatch > 59.5 then
			entity.setItemSlot( "head", head5 )
		end
	end

end