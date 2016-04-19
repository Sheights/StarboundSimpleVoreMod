animState = "blank"

victim = nil
health = nil

lock = true
--entity.setAnimationState("bodyState", "fed4")
--entity.playSound("digest")

eatenLines = {	"Delicious~",
				"Oog, never eaten someone in space before.",
				"Enjoy your stay in my gut",
				"Try not to wiggle too much."
}

idleLines = {	"Thank god, you guys get Wi-fi out here.",
				"So...any coffee shops around?",
				"I bet you're wondering how I got roped into this...So am I.",
				"So uh...wanna get in my belly?",
				"Hey could I borrow your soul for like a day or so? No reason."
}

bellyLines = {	"Cozy in there?",
				"So...wanna give me your soul?",
				"You're a real squirmer~",
				"Maybe I should rent myself out as a hotel.",
				"And mom says digestion is the only way to enjoy vore."
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
			entity.say( eatenLines[ math.random( #eatenLines ) ] )
		end
		
		if health == nil then
			health = 1
		end
		
		if math.random(700) == 1 then
			entity.say( bellyLines[ math.random( #bellyLines ) ] )
		end
		
		if health < 0.8 and animState == "full1" then
			entity.setAnimationState("bodyState", "digest1")
		elseif health < 0.5 and animState == "full2" then
			entity.setAnimationState("bodyState", "digest2")
		elseif health < 0.2 and animState == "full3" then
			entity.setAnimationState("bodyState", "digest3")
		end
		
	else
		
		lock = true
		
		if animState == "full1" or animState == "full2" or animState == "full3" then
			entity.setAnimationState("bodyState", "idle")
		end
		
		if animState == "midle" or animState == "stomachidle" then
			entity.setAnimationState("bodyState", "standing")
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
	
	if animState == "idle" and math.random(300) == 1 then	
		entity.setAnimationState("bodyState", "idle1")
	elseif animState == "idle" and math.random(300) == 1 then
		entity.setAnimationState("bodyState", "idle2")
	end
end

function onInteraction(args)

	victim = args.sourceId
	
end