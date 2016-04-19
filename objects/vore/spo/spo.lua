require "/objects/vore/spo/vorechatscript.lua"

function initHook()

	bellySize = entity.configParameter("bellySize")

end

function updateHook()

	if isFull then
		entity.setAnimationState("pred", bellySize)
	else
		entity.setAnimationState("pred", "waiting")
	end
	
end