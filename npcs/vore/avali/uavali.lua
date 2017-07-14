require "/scripts/vore/npcvore.lua"

audio = false

playerLines = {	"Hehe nice and tucked away~",
				"Can you feel yourself changing?~",
				"I cant wait to see you have a pack of your own~",
				"Oof! That was a strong kick!",
				"I can already imagine you hatching~",
				"Soon you will be an Avali~",
				"I cant wait for you join me again my little hunter~",
				"Oh~ Im glad I chose you to become my hatchling~",
				"Normally on Avalon your egg would be in a communal nest, but since we are here...",
				"Hmm what should I name you?",
				"I hope you dont mind me becoming your new mother~",
				"I can tell you will become a strong Avali when you get older~",
				"Once your an Avali we'll get you a neural augment jack like mama~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex

	legs[2] = {
		name = "avalilegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function digestHook(id, time, dead)
	world.sendEntityMessage( id, "applyStatusEffect", "npceggbase", 60, entity.id() )
end

function releaseHook(input, time)
	if time >= 60 then
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "npceggbase", 60, entity.id() )
	end
end

function updateHook()

	if  math.random(700) == 1 and containsPlayer() then
		sayLine( playerLines )
	end
	
end