require "/tech/doubletap.lua"

function init()
	initiateCommon()
	
	self.doubleTap = DoubleTap:new({"up"}, 0.25, function()
		if self.active then
			animator.playSound( "switch", 0 )
			if self.context == 0 then
				if self.voreType == "base" then
					self.voreType = "digest"
					world.sendEntityMessage( self.target, "applyStatusEffect", "rpvoredigest", 90, entity.id() )
					world.sendEntityMessage( entity.id(), "applyStatusEffect", "rpvorefeed", 90, entity.id() )
					world.spawnProjectile( "rpdigest", mcontroller.position(), 0, {0,1} )

				elseif self.voreType == "digest" then
					self.voreType = "heal"
					world.sendEntityMessage( self.target, "applyStatusEffect", "rpvoreheal", 90, entity.id() )
					world.sendEntityMessage( entity.id(), "applyStatusEffect", "rpvoreclear", 90, entity.id() )
					world.spawnProjectile( "rpheal", mcontroller.position(), 0, {0,1} )
		
				elseif self.voreType == "heal" then
					self.voreType = "base"
					world.sendEntityMessage( self.target, "applyStatusEffect", "rpvore", 90, entity.id() )
					world.spawnProjectile( "rpbase", mcontroller.position(), 0, {0,1} )
				end
			elseif self.context == 1 then
				if self.voreType == "baseub" then
					self.voreType = "heal"
					world.sendEntityMessage( self.target, "applyStatusEffect", "rpvoreheal", 90, entity.id() )
					world.spawnProjectile( "rphealub", mcontroller.position(), 0, {0,1} )

				elseif self.voreType == "heal" then
					self.voreType = "egg"
					world.sendEntityMessage( self.target, "applyStatusEffect", "rpvore", 90, entity.id() )
					world.spawnProjectile( "rpegg", mcontroller.position(), 0, {0,1} )
		
				elseif self.voreType == "egg" then
					self.voreType = "baseub"
					world.spawnProjectile( "rpbaseub", mcontroller.position(), 0, {0,1} )
					
				end
			end
		else
			switchType()
		end
    end)
end

function uninit()
	deactivate()
end

function update(args)
	
	if not self.active then
		if not self.specialLast and args.moves["special"] == 1 and self.timer == 15 then
			self.timer = 0
			attemptActivate()
		end
	else
		if not world.entityExists(self.target) then
			deactivate()
		end
		if not self.specialLast and args.moves["special"] == 1 and self.timer == 15 then
			self.timer = 0
			deactivate()
		end
		
		if self.context == 0 then
			if math.random(350) == 1 then
				world.spawnProjectile( "digestprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
			end
		end
	end
	
	self.specialLast = args.moves["special"] == 1
	
	if self.timer < 15 then
		self.timer = self.timer + 1
	end
	
	self.doubleTap:update(args.dt, args.moves)
end

function attemptActivate()
	if world.getProperty("preyEnabled") then
		local people = world.entityQuery( tech.aimPosition(), 7, {
			withoutEntityId = entity.id(),
			includedTypes = { "player" },
			boundMode = "CollisionArea"
		})
		if #people == 1 then
			self.target = people[1]
			activate()
		else
			animator.playSound( "deactivate", 0 )
		end
	else
		animator.playSound( "deactivate", 0 )
	end
end

function activate()
	self.active = true
	
	if self.voreType == "base" then
		world.sendEntityMessage( self.target, "applyStatusEffect", "rpvore", 90, entity.id() )
		self.context = 0
	
	elseif self.voreType == "digest" then
		world.sendEntityMessage( self.target, "applyStatusEffect", "rpvoredigest", 90, entity.id() )
		world.sendEntityMessage( entity.id(), "applyStatusEffect", "rpvorefeed", 90, entity.id() )
		self.context = 0
		
	elseif self.voreType == "heal" then
		world.sendEntityMessage( self.target, "applyStatusEffect", "rpvoreheal", 90, entity.id() )
		self.context = 0
		
	elseif self.voreType == "baseub" then
		world.sendEntityMessage( self.target, "applyStatusEffect", "rpvore", 90, entity.id() )
		self.context = 1
	end
	
	if self.context == 0 then
		animator.playSound( "swallow", 0 )
	end
	
--	setCostume( player.getItemSlot("legs") );
end

function deactivate()
	if self.target ~= nil then
		world.sendEntityMessage( self.target, "applyStatusEffect", "rpvoreclear", 1, entity.id() )
		if self.voreType == "digest" then
			world.sendEntityMessage( entity.id(), "applyStatusEffect", "rpvoreclear", 1, entity.id() )
			animator.playSound( "burp", 0 )
		elseif self.voreType == "egg" then
			world.sendEntityMessage( self.target, "applyStatusEffect", "rpvoreegg", 60, entity.id() )
			animator.playSound( "lay", 0 )
		end
	end
	self.active = false
	self.target = nil
end

function initiateCommon()
	self.active = false
	self.context = 0
	self.target = nil
	self.timer = 0
	self.typeCount	= 0
	self.voreType	= "base"
	
	sb.logInfo("Initilaized")
end

function switchType()
	animator.playSound("switch", 0 )
	self.typeCount = ( self.typeCount + 1 ) %4
	if self.typeCount == 0 then
	--	Play type switch projectile for base
		self.voreType = "base"
		self.context = 0
		world.spawnProjectile( "rpbase", mcontroller.position(), 0, {0,1} )
	elseif self.typeCount == 1 then
	--	Play type switch projectile for digest
		self.voreType = "digest"
		world.spawnProjectile( "rpdigest", mcontroller.position(), 0, {0,1} )
	elseif self.typeCount == 2 then
	--	Play type switch projectile for heal
		self.voreType = "heal"
		world.spawnProjectile( "rpheal", mcontroller.position(), 0, {0,1} )
	elseif self.typeCount == 3 then
	--	Play type switch projectile for ub
		self.voreType = "baseub"
		self.context = 1
		world.spawnProjectile( "rpbaseub", mcontroller.position(), 0, {0,1} )
	end
end

function uninit()
  if self.active then
	world.sendEntityMessage( self.target, "applyStatusEffect", "rpvoreclear", 1, entity.id() )
	if self.voreType == "digest" then
		world.sendEntityMessage( entity.id(), "applyStatusEffect", "rpvoreclear", 1, entity.id() )
	elseif self.voreType == "egg" then
		world.sendEntityMessage( self.target, "applyStatusEffect", "rpvoreegg", 60, entity.id() )
	end
  end
end