function init(virtual)
  if not virtual then
    self.detectArea = config.getParameter("detectArea")
  end
end

function update(dt)
	-- Vore Chat Handler
	local players = world.entityQuery(object.position(), 6, {
      includedTypes = {"player"},
      boundMode = "CollisionArea"
	})
	-- Animation Handler
	state = animator.animationState("bodyState")
	
    -- animator.setAnimationState("bodyState", "blink")
	-- animator.animationState
	
	if #players == 0 and state == "idle" then
		animator.setAnimationState("bodyState", "shutdown")
	end
	
	if #players > 0 and state == "off" then
		animator.setAnimationState("bodyState", "startup")
	end
	
	if math.random(200) == 1 and state == "idle" then
		animator.setAnimationState("bodyState", "open")
	end
	
	if state == "turn" then
		local storeFront = world.entityQuery( object.position(), 3, {
		includedTypes = {"player"},
		boundMode = "CollisionArea"
		})
		if #storeFront == 0 then
			animator.setAnimationState("bodyState", "turnback")
		end
	end
end

function onInteraction(args)

	local interactData = config.getParameter("interactData")
	
	animator.setAnimationState("bodyState", "turn")
	
	return { "OpenCraftingInterface", interactData }
	
end