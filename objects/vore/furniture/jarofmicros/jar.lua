timer = 0
state = true
function init()
	entity.setInteractive(true)
end

function update(dt)

	if state == false and timer < 0.5 then
		timer = timer + dt
	elseif timer >= 0.5 then
		entity.playSound("scream")
		entity.setInteractive(true)
		state = true
		timer = 0
	end
	
end

function onInteraction(args)

	if state then
		entity.playSound("effect")
		entity.setInteractive(false)
		state = false
	end

end