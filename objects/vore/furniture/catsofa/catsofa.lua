
function update(dt)

	-- Animation Handler
	state = animator.animationState("bodyState")

	if state == "idle"  and world.loungeableOccupied(entity.id()) == false then
		if math.random(200) == 1 then
			temp = math.random(6)
			if temp == 1 then
				animator.setAnimationState("bodyState", "tail")
			elseif temp == 2 then
				animator.setAnimationState("bodyState", "struggle")
			elseif temp == 3 then
				animator.setAnimationState("bodyState", "rub")
			elseif temp == 4 then
				animator.setAnimationState("bodyState", "push")
			elseif temp == 5 then
				animator.setAnimationState("bodyState", "pat")
			else
				animator.setAnimationState("bodyState", "lick")
			end
		end
	end
end

function onInteraction(args)

	animator.setAnimationState("bodyState", "idle")
	
end