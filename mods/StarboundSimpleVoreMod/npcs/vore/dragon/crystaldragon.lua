require "/scripts/vore/npcvore.lua"

duration 	= 120

playerLines = {}
playerLines[1] ={	"You must be so lonely in there.",
					"Barely a meal.",
					"I can bet you are comfortable",
					"I have been told my gut is very spacious. Enjoy it while you are alone!"
			}
			
playerLines[2] ={	"I hope you two are getting along.",
					"A fine meal!",
					"Stop figthing in there. It's only natural you would be food.",
					"I've never been a one prey dragon."
				}

playerLines[3] ={	"Now this is more like it!",
					"I'm stuffed!",
					"You three have got to be the most delicious I've had in a while.",
					"Pretty cramped in there is it? Ha!"
				}
			
function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs[2] = {
		name = "crystaldragonlegsbelly1",
		parameters = {
					colorIndex = index
	}}
	
	legs[3] = {
		name = "crystaldragonlegsbelly2",
		parameters = {
					colorIndex = index
	}}
end

function updateHook()
	if math.random(700) == 1 and containsPlayer() then
		if #victim > 0 and #victim < 4 then
			sayLine( playerLines[#victim] )
		end
	end
end