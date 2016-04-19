animState = "blank"

victim = nil
health = nil
lock = true

temp = 0
stopWatch = 0

bellyLines = {	"Struggle all you want, you'll be soup soon in there~",
				"Ahh~  Nothing like the feeling of wriggling prey~",
				"Oh! Just a little more until you're pudge~",
				"Still can't believe you made it so easy to catch you~",
				"I can feel your struggles weakening~",
				"Don't stop~  I think you're almost slurry now~"
}

gulpLines = {	"Can't believe you fell for that~!",
				"Got another one~  Good Job~!",
				"Guess she wanted more than a petting~"
}

idleLines = {	"Go ahead and pet her, she'll love it~",
				"Come closer, She has a secret to tell you.",
				"I agree, they do look tasty.. I mean, Hello~"
}

releaseLines = {	"Awww... you got free, please come back",
					"Guess she thought you had enough, or you weren't that tasty",
					"You were this close to becoming not solid~"
}

gurgleLines = {	"Ahhh~ All gone~",
				"Mmmm~ Let's see if we can catch another~",
				"You look pretty good on my belly now~"
}

function init()

end

function update(dt)
		
	animState = entity.animationState("bodyState")
		
	if world.loungeableOccupied(entity.id()) then
	
		if victim ~= nil then
			health = world.entityHealth(victim)[1] / world.entityHealth(victim)[2]
		end
		
		if animState == "idle" and lock then
			entity.setAnimationState("bodyState", "swallow")
			lock = false
			entity.playSound("swallow")
			entity.say( gulpLines[ math.random( #gulpLines ) ] )
		end
		
		if health == nil then
			health = 1
		end
		
		if health < 0.1 and animState == "fullidle" then
			entity.setAnimationState("bodyState", "digest")
			entity.say( gurgleLines[ math.random( #gurgleLines ) ] )
		end
		
		if math.random(500) == 1 then
			if animState == "fullidle" then
				temp = math.random(4)
				if temp == 1 then
					entity.setAnimationState("bodyState", "rubs")
				elseif temp == 2 then
					entity.setAnimationState("bodyState", "blink")
				elseif temp == 3 then
					entity.setAnimationState("bodyState", "fullsmile")
				else
					entity.setAnimationState("bodyState", "struggle")
				end
				temp = math.random(3)
				if temp == 1 then
					entity.playSound("belly1")
				elseif temp == 2 then
					entity.playSound("belly2")
				else
					entity.playSound("belly3")
				end
			end
		elseif math.random(500) == 1 and animState ~= "idle" then
			entity.say( bellyLines[ math.random( #bellyLines ) ] )
		end
	else
		
		lock = true
		
		if animState == "fullidle" then
			entity.setAnimationState("bodyState", "reg")
			entity.say( releaseLines[ math.random( #releaseLines ) ] )
		end
		
		local players = world.entityQuery( world.entityPosition(entity.id()), 8, {
			includedTypes = {"player"},
			boundMode = "CollisionArea"
		})
	
		if #players > 0 and stopWatch >= 7 then
			entity.say( idleLines[ math.random( #idleLines ) ] )
			stopWatch = 0
		end
			
	end
	
	if math.random(500) == 1 then
		if animState == "idle" then
			if math.random(2) == 1 then
				entity.setAnimationState("bodyState", "smile")
			else
				entity.setAnimationState("bodyState", "uad")
			end
		end
	end
	
	if stopWatch <= 7 then
		stopWatch = stopWatch + dt
	end
end

function onInteraction(args)

	victim = args.sourceId
	
end