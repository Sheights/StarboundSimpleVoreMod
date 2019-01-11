
function init()
	if status.resource("food") < 0.95 then
		status.modifyResource("food", 0.05)
	else
		status.setResourcePercentage("food", 1.0)
	end
end