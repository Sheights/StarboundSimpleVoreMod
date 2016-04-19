function init()

	entity.setInteractive(true)
	
end

function onInteraction(args)

  if entity.animationState("fromographState") == "off" then
    entity.setAnimationState("fromographState", "on")
  else
	entity.setAnimationState("fromographState", "off")
  end
  
end
