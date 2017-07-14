fed = false
victim = nil
stopwatch = 0

animState = ""

function init()
	object.setInteractive(true)
end

function containerCallback()
	if math.random(30) == 1 and fed == false and animState == "fullOpen" then
		local people = world.entityQuery( object.position(), 4, {
			includedTypes = {"player"},
			boundMode = "CollisionArea"
		})
		if #people > 0 then
			victim = people[math.random(#people)]
			if victim ~= nil then
				world.sendEntityMessage( victim, "applyStatusEffect", "npcdigestvore", 90, entity.id() )
				animator.setAnimationState("bodyState", "eat")
				object.setInteractive(false)
				fed = true
			end
		end
	end
end

function update(dt)
	animState = animator.animationState("bodyState")
	
	if fed then
		stopwatch = stopwatch + dt
		if animState == "idle3" and math.random(600) == 1 then
			animator.setAnimationState("bodyState", "fed")
			do return end
		end
		if stopwatch >= 90 then
			if world.entityHealth(victim)[1]/world.entityHealth(victim)[2] < 0.03 then
				world.containerAddItems( entity.id(), { name= "bone", count= 5, data={}} )
			end
			if victim ~= nil then
				world.sendEntityMessage( victim, "applyStatusEffect", "voreclear", 90, entity.id() )
			end
			animator.setAnimationState("bodyState", "spitup")
			object.setInteractive(true)
			animator.playSound("close")
			stopwatch = 0
			victim = nil
			fed = false
			do return end
		end
	end

	if animState == "idle1" and math.random(600) == 1 then
		animator.setAnimationState("bodyState", "idle2")
		do return end
	end
	
	local people = world.entityQuery( object.position(), 4, {
		includedTypes = {"player"},
		boundMode = "CollisionArea"
	})
	if animState == "idle1" and #people > 0 then
		animator.setAnimationState("bodyState", "open")
		-- play open sound
		animator.playSound("open")
	elseif animState == "fullOpen" and #people == 0 then
		animator.setAnimationState("bodyState", "close")
		-- play close sound
		animator.playSound("close")
	end
end