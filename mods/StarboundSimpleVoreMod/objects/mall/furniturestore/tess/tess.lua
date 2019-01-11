temp = 0

function init()
  self.buyFactor = config.getParameter("buyFactor", root.assetJson("/merchant.config").defaultBuyFactor)

  object.setInteractive(true)
end

function update(dt)

	state = animator.animationState("bodyState")

	if state == "closed" or state == "peek" then
		local people = world.entityQuery( object.position(), 20, {
			includedTypes = {"player"},
			boundMode = "CollisionArea"
		})
		if #people > 0 then
			if math.random(2) == 1 then
				animator.setAnimationState("bodyState", "up")
			else
				animator.setAnimationState("bodyState", "upfull")
			end
			do return end
		else
			if math.random(3) == 1 then
				if state == "closed" then
					animator.setAnimationState("bodyState", "peek")
				else
					animator.setAnimationState("bodyState", "closed")
				end
			end
		end
	elseif math.random(2) == 1 then
		if state == "idle" then
			local people = world.entityQuery( object.position(), 20, {
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people == 0 then
				animator.setAnimationState("bodyState", "down")
				do return end
			end
			temp = math.random(4)
			if temp == 1 then
				animator.setAnimationState("bodyState", "blink")
			elseif temp == 2 then
				animator.setAnimationState("bodyState", "tail")
			elseif temp == 3 then
				animator.setAnimationState("bodyState", "maruup")
			else
				animator.setAnimationState("bodyState", "smile")
			end
		elseif state == "full" then
			local people = world.entityQuery( object.position(), 20, {
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
			if #people == 0 then
				animator.setAnimationState("bodyState", "downfull")
				do return end
			end
			temp = math.random(4)
			if temp == 1 then
				animator.setAnimationState("bodyState", "blinkfull")
			elseif temp == 2 then
				animator.setAnimationState("bodyState", "rub")
			elseif temp == 3 then
				animator.setAnimationState("bodyState", "tailfull")
			else
				animator.setAnimationState("bodyState", "smilefull")
			end
		elseif state == "maru" then
			if math.random(2) == 1 then
				animator.setAnimationState("bodyState", "marudown")
			else
				animator.setAnimationState("bodyState", "teaup")
			end
		elseif state == "tea" then
			animator.setAnimationState("bodyState", "teadown")
		end
	end
end
