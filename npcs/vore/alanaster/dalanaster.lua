require "/scripts/vore/npcvore.lua"

duration 	= 120

effect = "npcdigestvore"
capacity = 3
idDigest = true
legs[2] = "alanasterlegsbelly2"
legs[3] = "alanasterlegsbelly3"

smallLines = {	"Mrrr~ So nice to have someone in my belly~",
				"Hush now~  No need to be fussy~",
				"I'm hoping you don't mind it being a bit gooey in there~",
				"You're going to be one of the cutest goobur ever~"
			}
			
medLines = {	"Hehe~ Its been a while since I've had 2 in my belly~",
				"Relax you 2, there's plenty of room to stretch in there~",
				"You both are making my belly wiggle so much~",
				"If only we can find another, then you'll make the perfect little clutch~"
			}

largeLines = {	"*purrs* My belly feels so full with you three in there~",
				"Don't wiggle so much~  You're making it a little hard to walk~",
				"It won't be long, soon you all will be my perfect little clutch~",
				"I'll take good care of you all~"
			}

function feedHook(input) 
	npc.say( "Down you go~" )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(input)
	npc.say( "Come on in~  There's plenty of room to rest in~" )
end

function updateHook()

	if math.random(700) == 1 and containsPlayer() then
	
		if #victim == 1 then
			sayLine(smallLines)
		elseif #victim == 2 then
			sayLine(medLines)
		elseif #victim == 3 then
			sayLine(largeLines)
		end
		
	end

end

function releaseHook(input, time)

	npc.say( "That was sooo nice~ Please do come back again~" )

end