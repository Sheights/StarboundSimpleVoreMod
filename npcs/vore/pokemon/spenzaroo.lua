require "/scripts/vore/multivore.lua"

chest = "goodraspenzaroochest"
legs = "goodraspenzaroolegs"

midchest = "goodraspenzaroochestmid"
midlegs = "goodraspenzaroolegsmid"

fullchest = "goodraspenzaroochestfull"
fulllegs = "goodraspenzaroolegsfull"

duration = 120

projectile	= "dragonvoreprojectile"
dprojectile	= "dragondvoreprojectile"

bellyLines = {	"Aaahhhhh you feel delightful in there~",
				"*squeezes the gooey belly around you* <3",
				"Keep on squirming, you'll notice when your body starts to turn into goo~",  
				"Shame that other goodra can't do things quite the same~"
			}
			
eatLines = 	{	"Down you go cutie~ <3",
				"*gulps down lewdly~*",
				"*swallows with a hungry murr~*"
			}

requestLines = 	{	"Aw, so sweet of you <3",
					"Have fun while in there, cutie~"
				}
			
function initHook()
	
end

function feedHook()
	npc.say( eatLines[math.random(#eatLines)])
end

function forceExit()
	npc.say( "There you go, come back later!" )
end

function forceFeed()
	npc.say( requestLines[math.random(#requestLines)])
end

function interactHook()

	if math.random(4) == 1 then
		world.spawnProjectile( "goodraprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function updateHook()

	if math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true ) then
		npc.say( bellyLines[math.random(#bellyLines)])	
	end

end