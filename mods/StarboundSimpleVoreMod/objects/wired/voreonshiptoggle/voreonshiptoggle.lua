function isAShip()

	--Must find one of these objects	-- -> get config, "blockKey.config"
	local parts = { "hylotlshiplocker", "novakidshiplocker", "humanshiplocker", "glitchshiplocker", "floranshiplocker", "avianshiplocker", "apexshiplocker" };
	local anytrue = false;
	
	--world.universeFlags()
	--	"shipLockerPosition"
	--local lockerpos = world.getProperty("shipLockerPosition");	--was nil
	--sb.logInfo( "voreshiptoggle "..tostring( lockerpos ) );
	
	for key,val in ipairs( parts ) do
		
		--Must be within 5 tiles of ship locker
		local objectIds = world.objectQuery( object.position(), 5, { name = val } );
		if #objectIds > 0 then
			--sb.logInfo( "voreshiptoggle isAShip is a "..val.." ship" );
			anytrue = true;
			break;
		else
			--sb.logInfo( "voreshiptoggle isAShip NOT a "..val.." ship" );
		end
	end
	
	return anytrue;
end

function init()

	setStateAnimation( getState() );
	object.setInteractive( true );
	
	self.validship = isAShip();
	
	if self.validship then
		--ok
	else
		setState( false );
		object.smash( false );
	end
	
end

function getState()
  return not world.getProperty("invinciblePlayers");
end

function setState( v )
	return world.setProperty("invinciblePlayers", not v);
end

function setStateAnimation( v )
	if v then
		animator.setAnimationState("switchState", "on")
	else
		animator.setAnimationState("switchState", "off")
	end
end

function onInteraction( args )
	if self.validship then
		if getState() then
			setState( false );
			setStateAnimation( false );
		else
			setState( true );
			setStateAnimation( true );
		end
	end
end

function onNpcPlay( npcId )
	--onInteraction()
end

--Hope this is all client side, we set scriptDelta to 60 tics hopeing that would be enough
function update(dt)
	setStateAnimation( getState() );
end

--When we de-init, should restore to normal
function uninit()
	--sb.logInfo( "voreshiptoggle uninit " );
	setState( false );	--Hm!
end