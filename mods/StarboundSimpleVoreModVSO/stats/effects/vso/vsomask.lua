function init()
	--From instanceworlds.config
	--"image" : "/celestial/system/terrestrial/biomes/jungle/maskie3.png?hueshift=75?addmask=/celestial/system/terrestrial/dynamics/temperate/22.png"
	--"image" : "/celestial/system/gas_giant/gas_giant_clouds_0.png?hueshift=-70?addmask=/celestial/system/gas_giant/gas_giant_dynamics/3.png+/celestial/system/gas_giant/gas_giant_dynamics/29.png"
	--/celestial/system/terrestrial/dynamics/temperate/22.png
	--effect.setParentDirectives("multiply=FFFFFF80?addmask="..config.getParameter("maskimage"))
	
	--From ballistic.lua
	--	local velocity = status.statusProperty("ballisticVelocity", default value of some kind )
	
	--This is set using the 
	--	status.setStatusProperty("ballisticVelocity", vec2.mul(vector, 100))
	--Which is found in ballisticapplier.lua 
	--
	--So we need some way to send a string to an effect...
	--OR, use the same technique, and create effectapplyer that sets it as is from a config parameter...
	--Hm. Fiddle with this later. If we can apply directives to a player (multiply) maybe a mask can work?
	
	local hasmaskimage = status.statusProperty("maskimage", nil );
	local hasmultiplycolor = status.statusProperty("maskcolor", nil );
	--if hasmaskimage == nil then
	--	hasmaskimage = config.getParameter("maskimage", nil );
	--end
	
	local hasmultiplycolor = nil;	--"FFFFFFFF"
	
	if hasmaskimage ~= nil then
		if hasmultiplycolor ~= nil then
			effect.setParentDirectives( "multiply="..hasmultiplycolor.."?addmask="..hasmaskimage )
		else
			effect.setParentDirectives( "addmask="..hasmaskimage )
		end
	else
		if hasmultiplycolor ~= nil then
			effect.setParentDirectives( "multiply="..hasmultiplycolor )
		else
			effect.setParentDirectives( "" )
		end
	end
end

function update(dt)
	--Did the status property change?? Hm... that would... make more sense maybe? than remove-reapply?
	
	--effect.modifyDuration( dt );	--hm...
end

function uninit()
  
end
