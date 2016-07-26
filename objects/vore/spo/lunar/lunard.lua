animState = "blank"

--animator.setAnimationState("bodyState", "fed4")
--animator.playSound("digest")

bellySounds = {	"belly1",
				"belly2",
				"belly3"
}

eatenLines = {	"Let's tuck you into your bed.",
				"Don't worry, i'll keep you safe and warm."
}

idleLines = {	"Hello there, how are you today?",
				"Would you like to snuggle with a ninetales?"
}

bellyLines = {	"Sorry, sometimes even I need to claim a meal.",
				"Please forgive me for doing this.",
				"It's nothing personal, Just am really hungry."
}

rubLines = {	"Sorry, hotel Lunar is fully booked right now.",
				"I'll be happy to give you a turn once I let this cutie go."
}

releaseLines = {	"Thank you, I hope you enjoyed being in there.",
					"You're welcome to come back any time.",
					"Take care of yourself. I'll be here if ever you need me again."
}

function update(dt)
		
	animState = animator.animationState("bodyState")
		
	if world.loungeableOccupied(entity.id()) then
	
		if animState == "idle" then
			animator.setAnimationState("bodyState", "swallow")
			object.say( eatenLines[ math.random( #eatenLines ) ] )
			animator.playSound("swallow")
		end
		
		if math.random(700) == 1 then
			object.say( bellyLines[ math.random( #bellyLines ) ] )
			animator.playSound( bellySounds[ math.random( #bellySounds ) ] )
		end
		
		if math.random(700) == 1 then
			animator.setAnimationState("bodyState", "blinkfull")
		end
		
	else
		
		if animState == "idlefull"  then
			animator.setAnimationState("bodyState", "regurg")
			object.say( releaseLines[ math.random( #releaseLines ) ] )
		end
		
		if math.random(700) == 1 then
			local people = world.entityQuery( object.position(), 7, {
				withoutEntityId = entity.id(),
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people > 0 then
				object.say( idleLines[ math.random( #idleLines ) ] )
			end
		end
	end
end

function onInteraction(args)

	if world.loungeableOccupied(entity.id()) then
		object.say( releaseLines[ math.random( #releaseLines ) ] )
	end
end