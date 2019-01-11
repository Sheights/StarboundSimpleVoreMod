function init()

	script.setUpdateDelta(5)	--Hm! Update every 5 game ticks (dt is scaled appropriately)

	--targetdelta = status.statusProperty( "seconds", 60 )
	--targetresource = status.statusProperty( "resource", "health" )
	targetdelta = config.getParameter( "seconds", 60 )
	targetresource = config.getParameter( "resource", "health" )	--"energy", "health", "food", "breath"
			
	if math.abs( targetdelta ) >= 1 then
		targetdelta = -1.0 / targetdelta;	--100% per what? (1/60th or a percent per second)
	else
		if targetdelta > 0 then
			targetdelta = -1.0;	--DRAIN
		else
			targetdelta = 1.0;	--HEAL
		end
	end
	
	--hmmmm this is curious. really we should do ALL of these but.
	if targetresource == "energy" then
		effect.addStatModifierGroup({
			{stat = "energyRegenPercentageRate", effectiveMultiplier = 0}	--from biomecold
		});
	elseif targetresource == "health" then
		effect.addStatModifierGroup({
			{stat = "healthRegen", effectiveMultiplier = 0}	--added
		});
	elseif targetresource == "food" then
		effect.addStatModifierGroup({
			{stat = "foodDelta", effectiveMultiplier = 0}	--added
		});
	elseif targetresource == "breath" then
		effect.addStatModifierGroup({
			{stat = "breathRegenerationRate", effectiveMultiplier = 0}	--added
			,{stat = "breathDepletionRate", effectiveMultiplier = 0}	--added
		});
	end
	
end

function update(dt)
	status.modifyResourcePercentage( targetresource, targetdelta * dt )
end

function uninit()
  
end