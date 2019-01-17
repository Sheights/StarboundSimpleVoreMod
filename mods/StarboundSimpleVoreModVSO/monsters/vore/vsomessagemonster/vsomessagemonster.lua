--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

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

