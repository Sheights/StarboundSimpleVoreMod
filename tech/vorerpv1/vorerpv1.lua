function init()

  self.active = false
  self.cooldown = 0
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

  return nil
end

function update(args)

  if args.actions["active"] and not tech.parentLounging() and self.active == false and self.cooldown >= 0.5 then
  
	local people = world.entityQuery( tech.aimPosition(), 1, {
		withoutEntityId = entity.id(),
		includedTypes = {"player"},
		boundMode = "CollisionArea"
	})
	
	if #people == 1 then
		self.active = true
		self.host = people[1]		
		tech.setParentDirectives("?multiply=00000000")
	end
	
	self.cooldown = 0
	
  elseif args.actions["deactive"] and self.active and self.cooldown >= 0.5 then
	deactivate()
  end

  if self.active then
	if world.entityExists( self.host ) == false then
		self.timer = self.timer + args.dt
		if self.timer >= 1 then
		  deactivate()
		end
	else
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
  tech.setParentDirectives()

end
