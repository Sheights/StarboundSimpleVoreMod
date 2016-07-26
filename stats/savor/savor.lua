function init()

  script.setUpdateDelta(5)

  self.digestRate = -(1.0 / config.getParameter("digestTime", 100))
end

function update(dt)

	if status.resourcePercentage("health") > 0.03 then
		status.modifyResourcePercentage("health", self.digestRate * dt)
	end

end

function uninit()

	if status.resourcePercentage("health") <= 0.03 then
		status.modifyResourcePercentage( "health", -0.04 )
	end
	
end