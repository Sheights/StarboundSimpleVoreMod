require "/scripts/vore/npcvore.lua"

playerLines = {	"Ooh, keep squirming~",
					"Mmm, might just keep you in there all night.",
					"*groans, stroking over your form.*",
					"Nnnngg... lively one, aren't you?"

}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex	
	legs[2] = {
		name = "sykeslegsballs",
		parameters = {
					colorIndex = index
	}}
end

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function loseHook()
	if containsPlayer() then
		npc.say("Come back anytime, hehe.")
	end
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end