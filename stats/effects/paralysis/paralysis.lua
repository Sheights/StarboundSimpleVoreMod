function init()
  mcontroller.setVelocity({0, 0})
end

function update(dt)
  mcontroller.controlModifiers({
      facingSuppressed = true,
      movementSuppressed = true
    })
end

function uninit()
  
end