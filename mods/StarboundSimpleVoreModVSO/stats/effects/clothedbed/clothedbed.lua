require "/scripts/rect.lua"

function init()
  effect.addStatModifierGroup({{stat = "foodDelta", effectiveMultiplier = 0}})
  if status.isResource("food") and not status.resourcePositive("food") then
    status.setResource("food", 0.01)
  end

  animator.setParticleEmitterOffsetRegion("healing", rect.rotate(mcontroller.boundBox(), mcontroller.rotation()))
  animator.setParticleEmitterActive("healing", true)

  script.setUpdateDelta(5)

  self.healingRate = 1.0 / config.getParameter("healTime", 60)
end

function update(dt)
  status.modifyResourcePercentage("health", self.healingRate * dt)
end

function uninit()

end
