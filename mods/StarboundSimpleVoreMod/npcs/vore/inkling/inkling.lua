require "/scripts/vore/npcvore.lua"

playerLines = {		"I'm a kid~, I'm a squid~, I'm *URP* ...rather full.",
					"Mmm, you taste a lot better than sushi!",
					"Keep squirming, it feels inkredible~",
					"Easier to carry around than a splatling!",
					"Stay as long as you want. Big bellies are always in style!",
					"Oof, this feels so good~",
					"I wonder if they'll let me into the next turf match like this.",
					"Woomy~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	chest[2] = {
		name = "inklingchest",
		parameters = {
					colorIndex = index
	}}
	
	legs[2] = {
		name = "inklingbellylegs",
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

function digestHook(id, time, dead)
	if containsPlayer() then
		npc.say("Come back anytime you feel like a stay in a warm squidkid belly~")
	end
end
function releaseHook(input, time)
	if containsPlayer() then
		npc.say("Come back anytime you feel like a stay in a warm squidkid belly~")
	end
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end
