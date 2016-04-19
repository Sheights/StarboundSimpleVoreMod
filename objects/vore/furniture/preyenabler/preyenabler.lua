animState = ""
property = false

function init()
	entity.setInteractive(true)
end

function update(dt)
	property = world.getProperty("preyEnabled")
	
	if property then
		entity.setAnimationState("switchState", "on")
	else
		entity.setAnimationState("switchState", "off")
	end
end

function onInteraction(args)

	animState = entity.animationState("switchState")
	
	if animState == "on" then
		world.setProperty("preyEnabled", false)
		entity.setAnimationState("switchState", "off")
		entity.playSound("on")
	else
		world.setProperty("preyEnabled", true)
		entity.setAnimationState("switchState", "on")
		entity.playSound("off")
	end
	
end

function die()
	world.setProperty("preyEnabled", false)
end