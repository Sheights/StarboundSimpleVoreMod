function init()

	script.setUpdateDelta(5)
	
end

function update(dt)

	status.modifyResourcePercentage("food", 5 * dt)
	
	if status.resourcePercentage("food") == 100 then
		status.modifyResourcePercentage("health", 1/120 * dt)
	end

end