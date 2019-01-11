function init()

	monster.setAggressive(false)
	monster.setDamageOnTouch(false)
	monster.setDamageBar("none");
	monster.setInteractive(false)
	
	self.ownerid = config.getParameter("masterId")
	self.sayMessage = config.getParameter("sayMessage")
	self.mouthPosition =  config.getParameter("mouthPosition")
	
	self.once = 0;

	message.setHandler("vsoSayUpdate",
		function(_, _, msg, ownerKey, mouthpos )
			if ownerKey == self.ownerid then
				self.mouthPosition = mouthpos;
				self.sayMessage = msg;
				self.once = 0;
				return true;
			end
			return false;
		end)
end

function update(dt)
	if self.once == 0 then 
		self.once = 1; 
		status.addEphemeralEffect( "vsolockspeakpositionkill", 6.0, self.ownerid );
		monster.say( self.sayMessage );
		world.sendEntityMessage( entity.id(), "mouthPosition", self.mouthPosition );
	end
end

