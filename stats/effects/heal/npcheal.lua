function init()

script.setUpdateDelta(5)
end

function update(dt)
	
	status.modifyResourcePercentage("health", 0.5 * dt)

	if effect.duration() < 2 then
		effect.modifyDuration(2)
	end

end

function uninit()
  
end