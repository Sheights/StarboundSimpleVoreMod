animState = "blank"

victim = nil
health = nil

lock = true

eatenLines = {	"God it feels good to be full.",
				"Enjoy your slow digestion, snack.",
				"*UUURP* Ahhh, went down nice and smooth"
}

idleLines = {	"Hey, get in my gut, I demand you.",
				"*BURAWP* Damn, that one was foul.",
				"I promise to make your digestion slow and gurgly",
				"Ever wanted to be a devil's assfat?",
				"Hey, walking snack, come get in my stomach where you belong."
}

bellyLines = {	"Try not to digest too fast.",
				"You're probably gonna end up on my ass like everyone else.",
				"I really hope you have a toilet nearby.",
				"I think I'll not digest your soul, you're too yummy.",
				"*BUWAAARP* Damn you make me gassy."
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