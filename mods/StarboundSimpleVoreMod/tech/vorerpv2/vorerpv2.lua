function init()
	self.active = false
	self.cooldown = 0
	self.prey = nil
	self.spacialLast = false
	self.inputSpecial = false
	self.timer = 0
end

function uninit()

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
	
	-- Nothing is returned is no action is taken.
	return nil
end

function update(args)
	-- Check value of Machine
		-- Switch if required
	
	-- #========================#
	-- |   Grabbing your prey   |
	-- #========================#
	
	-- Activates the tool, getting information about your prey.
	
	if args.actions["active"] and not tech.parentLounging() and self.active == false and self.cooldown >= 0.5 then
	
		-- Scans for potential preys at your mouse.
		if world.getProperty("preyEnabled") then
			local targets = world.entityQuery( tech.aimPosition(), 1, {
				includedTypes = {"player"},
				boundMode = "CollisionArea"
			})
		
			if #targets == 1 then
				local people = world.entityQuery( world.entityPosition( targets[1] ), 7, {
					withoutEntityId = entity.id(),
					includedTypes = {"player"},
					boundMode = "CollisionArea"
				})
				if #people == 1 then
					self.active = true
					self.prey = people[1]
					world.spawnProjectile( "rptool2projectile" , world.entityPosition( targets[1] ), entity.id(), {0, 0}, false )
					world.spawnProjectile( "swallowprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
				end
			end
		end
	
		if self.active == false then
			tech.playSound("failure")
		end
		-- Cooldown reset.
		self.cooldown = 0

	elseif args.actions["deactive"] and self.active and self.cooldown >= 0.5 then
		deactivate()
		self.cooldown = 0
	end
	
	-- #==========================================================#
	-- |   Deactivate Abillity if host vanishes and audio check   |
	-- #==========================================================#
	
	if self.active then
	
		if math.random(600) == 1 then
			world.spawnProjectile( "digestprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
		end
			
		if world.entityExists( self.prey ) == false then
			self.timer = self.timer + args.dt
			if self.timer >= 1 then
				deactivate()
			end
		end	
		self.timer = 0
	end
 
	-- #==========================#
	-- |   Cooldown Calculation   |
	-- #==========================#
 
	if self.cooldown <= 0.5 then
		self.cooldown =  self.cooldown + args.dt
	end
end

function deactivate()
	-- Turn everything back off
	self.active = false
	self.cooldown = 0
	self.prey = nil
	self.timer = 0
	self.spacialLast = false
	self.inputSpecial = false
	
	world.spawnProjectile( "cleanser" , mcontroller.position(), entity.id(), {0, 0}, false )
end