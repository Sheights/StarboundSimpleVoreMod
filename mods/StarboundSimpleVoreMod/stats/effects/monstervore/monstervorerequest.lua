require "/scripts/actions/status.lua"

--Determine if a Ephemeral/Unique effect is present (find a better solution later)
function hasEffect( x )
	local T = status.activeUniqueStatusEffectSummary();
	for index,value in ipairs(T) do
		if value[1] == x then
			return true;
		end
	end
	return false;
end

--self.ownerPrey = entity.id();		
--self.ownerPred = effect.sourceEntity();

function init()

	self.requestSuccess = false;
	
	if not hasEffect("monstervore") and world.entityExists( effect.sourceEntity() ) then	--does the predator still exist, and without eating something already
			
		status.addEphemeralEffect( "monstervore", effect.duration(), effect.sourceEntity() );
		self.requestSuccess = true;		
	end
end

function update(dt)

	if not self.requestSuccess then
		world.sendEntityMessage( effect.sourceEntity(), "voreAttackStatusMessage", -2, entity.id() );	--Send predator a message, and tell them too bad
	else
		world.sendEntityMessage( effect.sourceEntity(), "voreAttackStatusMessage", 1, entity.id() );	--Send predator a message, and tell them yay
	end
	
	effect.expire();
end