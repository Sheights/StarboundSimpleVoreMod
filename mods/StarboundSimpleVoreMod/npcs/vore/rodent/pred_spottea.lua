require "/scripts/vore/npcvore.lua"

legs[2] = "spottealegspredbelly"

playerLines = {	"Mmm, as good as carrot cake!",
				"I don't always eat someone, but I'm glad I made an exception~",
				"Delightful! ",
				"'urrp. Ohh, thats better~",
				"Well you sure hit the Spot~!",
				"It's Tea Takeaway time. Time to take you away~",
				"Oof, feeling a little full now!",
				"Just think of all the carrots your sparing~",
				"Will this affect my concealment?",
				"Will this affect my stealth bonus?",
				"I don't think I'll be hopping for a while now~",
				"You're such a nice little springhare snack~",
				"Ssshsss, just relax and let me take care of you~",
				"I think this should be a new way to hide people, hm?",
				"Mmm, bon appetit indeed!",
				"Delish!"
}

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		npc.say( playerLines )
	end
end