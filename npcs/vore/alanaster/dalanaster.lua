require "/scripts/vore/multivore.lua"

duration 	= 120

isDigest = true

projectile	= "dragonvoreprojectile"
dprojectile	= "dragondvoreprojectile"

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
			
function digestHook()

	if #victim > 0 then
		entity.setItemSlot( "legs", "alanasterlegsbelly" .. #victim )
	else
		entity.setItemSlot( "legs", "alanasterlegs" )
	end
	
end

function feedHook()

	if requested then
		entity.say( "Come on in~  There's plenty of room to rest in~" )
	else
		entity.say( "Down you go~" )
	end
	entity.setItemSlot( "legs", "alanasterlegsbelly" .. #victim )
	
end

function updateHook()

	if math.random(600) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true ) then
	
		if #victim == 1 then
			entity.say( smallLines[math.random(#smallLines)])
		elseif #victim == 2 then
			entity.say( medLines[math.random(#medLines)])
		elseif #victim == 3 then
			entity.say( largeLines[math.random(#largeLines)])
		end
		
	end

end

function forceExit()

	entity.say( "That was sooo nice~ Please do come back again~" )
	
	entity.setItemSlot( "legs", "alanasterlegs" )

end