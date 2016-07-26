function init()
	self.gravityModifier = config.getParameter("gravityModifier")
	self.movementParams = mcontroller.baseParameters()
	
	-- NOTE TO SELF:  ACTUALLY REMEMBER THIS PART NEXT TIME.
	setGravityMultiplier()

end

function setGravityMultiplier()
	local oldGravityMultiplier = self.movementParams.gravityMultiplier or 1

	self.newGravityMultiplier = self.gravityModifier * oldGravityMultiplier
end

function update(dt)
  mcontroller.controlParameters({
     gravityMultiplier = self.newGravityMultiplier
  })
end

function uninit()

end