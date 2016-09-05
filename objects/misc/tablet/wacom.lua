function init()
  entity.setInteractive(true)
end

function onInteraction(args)
  
  temp = entity.animationState("default")
  
  if temp == "off" then
	entity.setAnimationState("default", "on")
  else
	entity.setAnimationState("default", "off")
  end
  
end
