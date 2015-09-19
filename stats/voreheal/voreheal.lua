function init()

  script.setUpdateDelta(5)

  self.healingRate = 1.0 / effect.configParameter("healTime", 60)
end

function update(dt)
  status.modifyResourcePercentage("health", self.healingRate * dt)
end

function uninit()
end