function init()
	--From instanceworlds.config
	--"image" : "/celestial/system/terrestrial/biomes/jungle/maskie3.png?hueshift=75?addmask=/celestial/system/terrestrial/dynamics/temperate/22.png"
	--"image" : "/celestial/system/gas_giant/gas_giant_clouds_0.png?hueshift=-70?addmask=/celestial/system/gas_giant/gas_giant_dynamics/3.png+/celestial/system/gas_giant/gas_giant_dynamics/29.png"
	--/celestial/system/terrestrial/dynamics/temperate/22.png
	--effect.setParentDirectives("multiply=FFFFFF80?addmask="..config.getParameter("maskimage"))
	
	--From ballistic.lua
	--	local velocity = status.statusProperty("ballisticVelocity", default value of some kind )
	
	--This is set using the 
	local hascolor = config.getParameter("maskcolor");
	if hascolor ~= nil  then
		status.setStatusProperty( "maskcolor", hascolor );
	end
	
	local hasimage = config.getParameter("maskimage");
	if hasimage ~= nil  then
		status.setStatusProperty( "maskimage", hasimage );
	end

	status.removeEphemeralEffect( "vsomask" );
	
	if hasimage ~= nil or hascolor ~= nil then
		status.addEphemeralEffect( "vsomask", 1.0, effect.sourceEntity() )--, nil, ? )
	end
		
	effect.expire();
end

function update(dt)
	effect.expire();
end

function uninit()
  
end
