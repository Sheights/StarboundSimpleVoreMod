animState = "blank"

victim = nil
health = nil
lock = true

temp = 0
stopWatch = 0

bellyLines = {	"Don't struggle too much, it your fault that you got yourself caught by her!",
				"And no book to read.. -sigh-",
				"I told you not to get too close...-w-;",
				"Best to get settle in there, she won't let you go so easily.."
}

gulpLines = {	"Oh! Looks like she got another one.",
				"-sigh- Not again...",
				"You got close too close to her, didn't you..."
}

idleLines = {	"My tail looks soft, but don't get too close to her" ,
				"You don't happen to know any good books to read?",
				"Don't mind the hungry looks my tail is giving you. ^-^;"
}

releaseLines = {	"Make sure not to get caught again, or she might not let you go next time.",
					"You got out safely, that's good..",
					"Guess its too soon to ask about book now, huh?"
}

gurgleLines = {	"Ahhh~ All gone~",
				"Mmmm~ Let's see if we can catch another~",
				"You look pretty good on my belly now~"
}

function init()

end

function update(dt)
		
	animState = animator.animationState("bodyState")
		
	if world.loungeableOccupied(entity.id()) then
	
		if victim ~= nil then
			health = world.entityHealth(victim)[1] / world.entityHealth(victim)[2]
		end
		
		if animState == "idle" and lock then
			animator.setAnimationState("bodyState", "swallow")
			lock = false
			animator.playSound("swallow")
			object.say( gulpLines[ math.random( #gulpLines ) ] )
		end
		
		if health == nil then
			health = 1
		end
		
		if health < 0.1 and animState == "fullidle" then
			animator.setAnimationState("bodyState", "digest")
			object.say( gurgleLines[ math.random( #gurgleLines ) ] )
		end
		
		if math.random(500) == 1 then
			if animState == "fullidle" then
				temp = math.random(4)
				if temp == 1 then
					animator.setAnimationState("bodyState", "rubs")
				elseif temp == 2 then
					animator.setAnimationState("bodyState", "blink")
				elseif temp == 3 then
					animator.setAnimationState("bodyState", "fullsmile")
				else
					animator.setAnimationState("bodyState", "struggle")
				end
				temp = math.random(3)
				if temp == 1 then
					animator.playSound("belly1")
				elseif temp == 2 then
					animator.playSound("belly2")
				else
					animator.playSound("belly3")
				end
			end
		elseif math.random(500) == 1 and animState ~= "idle" then
			object.say( bellyLines[ math.random( #bellyLines ) ] )
		end
	else
		
		lock = true
		
		if animState == "fullidle" then
			animator.setAnimationState("bodyState", "reg")
			object.say( releaseLines[ math.random( #releaseLines ) ] )
		end
		
		local players = world.entityQuery( world.entityPosition(entity.id()), 8, {
			includedTypes = {"player"},
			boundMode = "CollisionArea"
		})
	
		if #players > 0 and stopWatch >= 7 then
			object.say( idleLines[ math.random( #idleLines ) ] )
			stopWatch = 0
		end
			
	end
	
	if math.random(500) == 1 then
		if animState == "idle" then
			if math.random(2) == 1 then
				animator.setAnimationState("bodyState", "smile")
			else
				animator.setAnimationState("bodyState", "uad")
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