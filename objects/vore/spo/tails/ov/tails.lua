animState = "blank"

--animator.setAnimationState("bodyState", "fed4")
--animator.playSound("digest")

bellySounds = {	"belly1",
				"belly2",
				"belly3"
}

eatenLines = {	"*Happily grasps and parts his maw* Come to Tails, tasty~!",
				"*Oms, gulps and swallows, murring deeply* Mmmmm...",
				"Mmmhnn *glp* nnhh *Glrk..* unhh.. *Glorp..* Huuu..",
				"*Gulp.. gluck.. squiiish-splosh* Oooohh.. *brarrrrrp..* That's the spot..~",
				"*Rawrs and pounces wide-mawed, quickly swallowing and purring as you fill his gut*"
}

idleLines = {	"Hey there, ever wondered what a fox's belly is like?",
				"Would you mind helping me test a new tablet I made?",
				"*His stomach gurgles audibly as he looks you over*",
				"*Pulls out a scanner and runs a beam over you, studying the screen with interest, his mouth watering*",
				"*Turns to the side and pulls his belly fur, showing off his flexible belly* mind filling me out?"
}

bellyLines = {	"Sure beats rescuing animals.",
				"A shame Sonic never lets me do this, I think he'd enjoy being in your place.",
				"*Rubs over your head softly* Comfy in there?",
				"Glad I made that tablet, might have been a bad mixture, but the stretchy belly is a definite improvement.",
				"*Uses his tails to rub at the bulge you make*",
				"BREEAAAP! urrph, keep up the wiggling, feels nice.",
				"Wonder if the gang would be jealous to see me with you.",
				"*idly traces a finger along the shaped bulges you make*"
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
		
	else
		
		if animState == "full"  then
			animator.setAnimationState("bodyState", "regurg")
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