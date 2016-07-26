animState = ""
property = false

function init()
	object.setInteractive(true)
end

function update(dt)
	property = world.getProperty("preyEnabled")
	
	if property then
		animator.setAnimationState("switchState", "on")
	else
		animator.setAnimationState("switchState", "off")
	end
end

function onInteraction(args)

	animState = animator.animationState("switchState")
	
	if animState == "on" then
		world.setProperty("preyEnabled", false)
		animator.setAnimationState("switchState", "off")
		animator.playSound("on")
	else
		world.setProperty("preyEnabled", true)
		animator.setAnimationState("switchState", "on")
		animator.playSound("off")
	end
	
end

function die()
	world.setProperty("preyEnabled", false)
end