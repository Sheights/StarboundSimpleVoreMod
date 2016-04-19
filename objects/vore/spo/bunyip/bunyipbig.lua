animState = "blank"

victim = nil
health = nil

lock = true
--entity.setAnimationState("bodyState", "fed4")
--entity.playSound("digest")

bellySounds = {	"belly1",
				"belly2",
				"belly3"
}

eatenLines = {	"In you go~",
				"Best bed in the galaxy~",
				"Enjoy your stay~",
				"Weclome to Casa de Me~"
}

bellyLines = {	"Feeling a bit better in there now?", 
				"I don't mind you staying once your injuries are all fixed up. Just saying.",
				"Shh...Relax. I'll make it all better for you...",
				"Sorry if there's any fishbones in there. They get everywhere, you know how it is..."
}

rubLines = {	"You're pretty good at this, mind doing it for longer?",
				"Ooohh! Thanks for the massage ~",
				"Now i'm getting a massage from both sides.",
				"I love a good belly rub ~"
}

chatEmpty = {	"Feeling a bit injured? I can help with that~",
				"You look a little tired...Want me to look after you?"
}

chatFull = {	"Sorry, no vacancies~",
				"Come back later~",
				"Sorry, one person per... room~"
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
			entity.say( eatenLines[ math.random( #eatenLines ) ] )
			entity.playSound("swallow")
		end
		
		if health == nil then
			health = 1
		end
		
		if math.random(700) == 1 then
			entity.say( bellyLines[ math.random( #bellyLines ) ] )
		end
		
		if math.random(700) == 1 then
			entity.playSound( bellySounds[ math.random( #bellySounds ) ] )
		end
		
		if math.random(700) == 1 then
			local people = world.entityQuery( entity.position(), 7, {
				withoutEntityId = entity.id(),
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people > 1 then
				entity.say( chatFull[ math.random( #chatFull ) ] )
			end
		end
		
	else
		
		lock = true

		entity.setAnimationState("bodyState", "idle")

		if math.random(700) == 1 then
			local people = world.entityQuery( entity.position(), 7, {
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people > 0 then
				entity.say( chatEmpty[ math.random( #chatEmpty ) ] )
			end
		end
	end
end

function onInteraction(args)

	victim = args.sourceId
	
	if world.loungeableOccupied(entity.id()) then
		entity.say( rubLines[ math.random( #rubLines ) ] )
	end
	
end