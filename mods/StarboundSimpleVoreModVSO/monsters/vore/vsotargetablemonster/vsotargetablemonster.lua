--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

function init()

	--monster.setAggressive(false)
	monster.setDamageOnTouch(false)
	monster.setDamageBar("none");
	monster.setInteractive(false)
	
	self.ownerid = config.getParameter("masterId")
	self.targetOffset =  config.getParameter("targetOffset")
	--self.sayMessage = config.getParameter("sayMessage")
	
	self.once = 0;
	
	monster.setAggressive( true );

	message.setHandler("vsoTargetableUpdate",
		function(_, _, killit, ownerKey, offsetpos )
			if ownerKey == self.ownerid then
				self.targetOffset = offsetpos;
				if killit then
					world.sendEntityMessage( entity.id(), "targetOffset", self.targetOffset, 1 );
				else
					self.once = 0;
				end
				return true;
			end
			return false;
		end)
end

function update(dt)
	if self.once == 0 then 
		self.once = 1; 
		status.clearPersistentEffects( "main" );
		--status.addPersistentEffect( "main", "vsolockpositionkill" );--, 6.0, self.ownerid );
		status.addEphemeralEffect( "vsolockpositionkill", 1.0, self.ownerid );
		--monster.say( self.sayMessage );
		world.sendEntityMessage( entity.id(), "targetOffset", self.targetOffset, 0 );
	end
end

