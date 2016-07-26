timer = 0
state = true
function init()
	object.setInteractive(true)
end

function update(dt)

	if state == false and timer < 0.5 then
		timer = timer + dt
	elseif timer >= 0.5 then
		animator.playSound("scream")
		object.setInteractive(true)
		state = true
		timer = 0
	end
	
end

function onInteraction(args)

	if state then
		animator.playSound("effect")
		object.setInteractive(false)
		state = false
	end

end