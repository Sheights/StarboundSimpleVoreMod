animState = "blank"

--entity.setAnimationState("bodyState", "fed4")
--entity.playSound("digest")

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

bellyLines = {	"Shhh, let my stomach lull you off into a good night's sleep.",
				"Rest all you need to, i'll let you out whenever you're ready.",
				"Comfy in there little one? I hope so."
}

rubLines = {	"Sorry, hotel Lunar is fully booked right now.",
				"I'll be happy to give you a turn once I let this cutie go."
}

releaseLines = {	"Thank you, I hope you enjoyed being in there.",
					"You're welcome to come back any time.",
					"Take care of yourself. I'll be here if ever you need me again."
}

function update(dt)
		
	animState = entity.animationState("bodyState")
		
	if world.loungeableOccupied(entity.id()) then
	
		if animState == "idle" then
			entity.setAnimationState("bodyState", "swallow")
			entity.say( eatenLines[ math.random( #eatenLines ) ] )
			entity.playSound("swallow")
		end
		
		if math.random(700) == 1 then
			entity.say( bellyLines[ math.random( #bellyLines ) ] )
			entity.playSound( bellySounds[ math.random( #bellySounds ) ] )
		end
		
		if math.random(700) == 1 then
			entity.setAnimationState("bodyState", "blinkfull")
		end
		
	else
		
		if animState == "idlefull"  then
			entity.setAnimationState("bodyState", "regurg")
			entity.say( releaseLines[ math.random( #releaseLines ) ] )
		end
		
		if math.random(700) == 1 then
			local people = world.entityQuery( entity.position(), 7, {
				withoutEntityId = entity.id(),
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people > 0 then
				entity.say( idleLines[ math.random( #idleLines ) ] )
			end
		end
	end
end

function onInteraction(args)

	if world.loungeableOccupied(entity.id()) then
		entity.say( releaseLines[ math.random( #releaseLines ) ] )
	end
end