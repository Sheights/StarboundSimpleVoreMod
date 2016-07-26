function init()

	object.setInteractive(true)
	
end

function onInteraction(args)

  if animator.animationState("fromographState") == "off" then
    animator.setAnimationState("fromographState", "on")
  else
	animator.setAnimationState("fromographState", "off")
  end
  
end
