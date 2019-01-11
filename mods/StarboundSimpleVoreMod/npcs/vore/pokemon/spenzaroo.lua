require "/scripts/vore/npcvore.lua"

chest[2] = "goodraspenzaroochestmid"
legs[2] = "goodraspenzaroolegsmid"

chest[4] = "goodraspenzaroochestfull"
legs[4] = "goodraspenzaroolegsfull"

capacity = 3
duration = 120

effect = "npcvoreslime"

playerLines = {	"Aaahhhhh you feel delightful in there~",
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
			
function feedHook()
	sayLine( eatLines )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook()
	sayLine( requestLines )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function digestHook(id, time, dead)
	world.sendEntityMessage( id, "applyStatusEffect", "npcslimespenz", 60, entity.id() )
end

function releaseHook(input, time)
	npc.say( "There you go, come back later!" )
	if world.entityHealth(input.sourceId)[1] / world.entityHealth(input.sourceId)[2] <= 0.03 then
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "npcslimespenz", 60, entity.id() )
	end
end

function interactHook()
	if math.random(4) == 1 then
		world.spawnProjectile( "goodraprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
end

function updateHook(dt)
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end