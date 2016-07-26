function init()

  script.setUpdateDelta(5)

  self.digestRate = -(1.0 / config.getParameter("digestTime", 60))
end

function update(dt)
  status.modifyResourcePercentage("health", self.digestRate * dt)
end

function uninit()
  
end