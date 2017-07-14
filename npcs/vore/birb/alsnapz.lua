require "/scripts/vore/npcvore.lua"

legs[2] = "alsnapzbellylegs"

eatLines = {	"Ahhhh... that hit the spot.",
				"Glk~! Ah, enjoy your stay!",
				"Urp! Mm, 'scuse me.",
				"Mmm! A tad... heavier, than I'm used to..!",
				"Gglp!"
}

playerLines = {	"Mmm... enjoying your stay?",
				"Y'know, it's a little hard to move around with you in there...",
				"Urp..! Mrrf...",
				"Mm. Only 5 stars at the birbo hotel!",
				"Do you need anything? Wiggle a little if you do.",
				"This... mm, this is nice...",
				"Kyaaah...",
				"Haven't been this full in a while..."
}

rubLines = {
				"Oh! H-hi, didn't see you there.",
				"Urp! Oh, sorry, excuse me!",
				"Kyah? I'm uh... lil' busy here.",
				"Hmm? You wanna go too?",
				"Sorry, you're uh... gunna have to wait your turn..."
}
function initHook()
	script.setUpdateDelta(1)
end

function feedHook()
	sayLine(eatLines)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function rub(args)
	sayLine(rubLines)
end

function updateHook()

	if math.random(700) == 1 and containsPlayer() then
		sayLine(playerLines)
	end
	
	if mcontroller.facingDirection() == 1 then
		npc.setItemSlot( "head", "alsnapzrighthead" )
	else
		npc.setItemSlot( "head", "alsnapzlefthead" )
	end

end