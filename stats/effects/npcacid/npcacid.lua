function init()

  script.setUpdateDelta(5)

  self.digestRate = -(0.65 * world.entityHealth(entity.id())[2] / 90) / 100
end

function update(dt)
  status.modifyResourcePercentage("health", self.digestRate * dt)
end

function uninit()
  
end