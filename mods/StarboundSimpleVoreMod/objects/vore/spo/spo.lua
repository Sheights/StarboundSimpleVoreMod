require "/objects/vore/spo/vorechatscript.lua"

function initHook()

	bellySize = config.getParameter("bellySize")

end

function updateHook()

	if isFull then
		animator.setAnimationState("pred", bellySize)
	else
		animator.setAnimationState("pred", "waiting")
	end
	
end