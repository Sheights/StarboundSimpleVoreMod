require "/scripts/vore/npcvore.lua"

legs = "lucarionormallegs"

fulllegs = "lucarionormallegsbelly"

voreeffect = "harpyvore"

audio = false

duration = 60

playerLines = {	"Our aura is merging.",
				"Luu~ Oh my that feels wonderful!",
				"You are quite feisty, arn't you?",
				"The aura tells me how peaceful you are.",
				"Can you feel my aura?",
				"This is such a warming embrace!",
				"Sleep now child. Tomorrow is a new day.",
				"*mmmmm~*"
}

function initHook()
	
	if storage.shiny == nil and math.random(100) == 1 then
		storage.shiny = true
		makeShiny()
	elseif  storage.shiny == true then
		makeShiny()
	else
		storage.shiny = false
	end
	
end

function interactHook()

	if math.random(4) == 1 then
		world.spawnProjectile( "lucarioprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function loseHook()
	
	if isPlayer and stopWatch > 60 then
		npc.say("Goodnight my new little pup <3")
	elseif isPlayer then
		npc.say("I really enjoyed our time. Thank you for making me feel like that. I sense it was as pleasurable for you as it was for me~")
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
	fulllegs = "lucarioshinylegsbelly"

end