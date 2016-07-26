function init()

  self.active = false
  self.audio = false
  self.cooldown = 0
  self.digest = false
  self.heal = false
  self.host = nil
  self.inputSpecial = false
  self.specialLast = false
  self.timer = 0
  
end

function uninit()
  tech.setParentDirectives()
end

function input(args)

  if args.moves["special"] == 1 and not self.specialLast then
    if self.active then
	  return "deactive"
	else
	  self.inputSpecial = true
	  return "active"	  
	end
  end
  
  self.specialLast = args.moves["special"] == 1
  
  if args.moves["up"] and self.active then
  
	return "toggleheal"
	
  end
  
  if args.moves["right"] and self.active then
  
	if self.audio then
	  self.audio = false
    else
	  self.audio = true
	end
	
  end
  
  if args.moves["down"] and self.active then
  
	return "toggledigest"
	
  end
	
  return nil
end

function update(args)

  if args.moves["special"] == 1 and not tech.parentLounging() and self.active == false and self.cooldown >= 0.5 then
  
	local people = world.entityQuery( tech.aimPosition(), 1, {
		withoutEntityId = entity.id(),
		includedTypes = {"player"},
		boundMode = "CollisionArea"
	})
	
	if #people == 1 then
		self.active = true
		self.host = people[1]
		status.addPersistentEffect("fallimmunity", "nofalldamage")
		tech.setParentDirectives("?multiply=00000000")
	end
	
	self.cooldown = 0
	
  elseif args.moves["down"] and self.active and self.cooldown >= 0.5 then
  
    if self.heal then
	  status.clearPersistentEffects("voreheal")
	  self.heal = false
	end
	
	if self.digest then
	  status.clearPersistentEffects("voredigest")
	  self.digest = false
	else
	  status.addPersistentEffect("voredigest", "npcacid")
	  self.digest = true
	end
	
	self.cooldown = 0
	
  elseif args.moves["up"] and self.active and self.cooldown >= 0.5 then
  
    if self.digest then
	  status.clearPersistentEffects("voredigest")
	  self.digest = false
	end
	
	if self.heal then
	  status.clearPersistentEffects("voreheal")
	  self.heal = false
	else
	  status.addPersistentEffect("voreheal", "voreheal")
	  self.heal = true
	end
  
	self.cooldown = 0
	
  elseif args.moves["special"] and self.active and self.cooldown >= 0.5 then
  
	deactivate()
	self.cooldown = 0
	
  end

  if self.active then
	if world.entityExists( self.host ) == false then
		self.timer = self.timer + args.dt
		if self.timer >= 1 then
		  deactivate()
		end
	else
		if self.audio and math.random(600) == 1 then
		  world.spawnProjectile( "digestprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
		end
	  mcontroller.setPosition( world.entityPosition( self.host ) )
	  self.timer = 0
	end
  end
  
  if self.cooldown <= 0.5 then
    self.cooldown =  self.cooldown + args.dt
  end
	
end

function deactivate()

  self.active = false
  self.cooldown = 0
  self.host = nil
  self.timer = 0
  status.clearPersistentEffects("fallimmunity")
  status.clearPersistentEffects("voredigest")
  status.clearPersistentEffects("voreheal")
  tech.setParentDirectives()

end
