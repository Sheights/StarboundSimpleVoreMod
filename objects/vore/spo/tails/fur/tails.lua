animState = "blank"

--entity.setAnimationState("bodyState", "fed4")
--entity.playSound("digest")

bellySounds = {	"belly1",
				"belly2",
				"belly3"

				}
eatenLines = {	"Into the void with you!",
				"One trip into the void of fur, coming up!",
				"*Shhf, shufh* there you go, careful not to get tangled in there!",
				"Down you go, hope you enjoy the sea!",
				"One trip to paradise, coming up!",
				"No one expects a fox's fur to swallow them up like food <3",
				"Hey, how about a trip to Paradise?",
				"Ever wondered just how soft a fox's fur can be?",
				"Hey, could you help me brush my tail?"
}

idleLines = {	"Hey, could you help me? I need to test a new pill I just took.",
				"*The twin tails swish eagerly, looking quite fluffy...*",
				"Am I cute or what? Don't I deserve a hug for being this cute?~",
				"Doesn't my fur look all cuddly and snuggable?~",
				"Ever wonder what it's like to wear a 'fox coat'?"
}

bellyLines = {	"Thanks for making me fluffier!",
				"Let me show you something~ *curls his tails around you*",
				"*Snares you to his fur, murring as you start to sink in*",
				"Here, let me give you a 'coat' to keep warm..~",
				"Hope you enjoy being fuzzier than usual!",
				"*Mmmms and snuggles his fluffier fur* Prrrr, you look good like this..~"
}

function update(dt)
		
	animState = entity.animationState("bodyState")
		
	if world.loungeableOccupied(entity.id()) then
	
		if animState == "idle" then
			entity.setAnimationState("bodyState", "swallow")
			entity.say( eatenLines[ math.random( #eatenLines ) ] )
		end
		
		if math.random(700) == 1 then
			entity.say( bellyLines[ math.random( #bellyLines ) ] )
		end
		
	else
		
		if animState == "full"  then
			entity.setAnimationState("bodyState", "idle")
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