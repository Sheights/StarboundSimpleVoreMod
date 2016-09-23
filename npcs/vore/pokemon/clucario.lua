require "/scripts/vore/npcvore.lua"

legs = "lucarionormallegs"

fulllegs = "lucarioballs"

playerLines = {	"That feels great. Don't stop moving, OK?",
				"I am your master now!",
				"This would be a good spot for a pokeball pun, wouldn't it?",
				"I feel so full!",
				"Our spirits are combined! I feel stronger... and sleepy.",
				"Stay as long as you want!",
				"'Carioooooo"
}

function initHook()

	
end

function interactHook()

	if math.random(4) == 1 then
		world.spawnProjectile( "lucarioprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function loseHook()
	
	if isPlayer then
		npc.say("Don't you feel it? We are becoming one. In more than one way!")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end

function makeShiny()

	npc.setItemSlot( "head", "lucarioshinyhead" )
	npc.setItemSlot( "chest", "lucarioshinychest" )
	npc.setItemSlot( "legs", "lucarioshinylegs" )
	legs = "lucarioshinylegs"
	fulllegs = "lucarioshinylegsballs"

end