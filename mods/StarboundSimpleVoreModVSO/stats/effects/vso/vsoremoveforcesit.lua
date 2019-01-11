function init()
	status.removeEphemeralEffect( "vsokeepsit" );
end

function update(dt)
	status.removeEphemeralEffect( "vsokeepsit" );
	effect.expire();
end

function uninit()
	status.removeEphemeralEffect( "vsokeepsit" );
end
