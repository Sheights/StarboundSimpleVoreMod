--[[
_oldnpcinteract = interact
_oldnpcinit = init
function init()
	_oldnpcinit();

	sb.logInfo( "NPCI: "..tostring( interact ) );

	message.setHandler("_criticalinteractcall", function( args )

		sb.logInfo( "iteractoid: "..tostring( args ) );
		interact( args );

	end )
	
end
]]--

--init = _oldnpcinit;

--[[
_oldnpcinit = init

function msgHdlvsoplayerinteract( _, _, config, playerid )	--Handle created from message

	sb.logInfo( "NPC fake interacted " );
	
    world.callScriptedEntity( entity.id(), "onInteraction", { source=playerid, sourceId=playerid } )
    world.callScriptedEntity( entity.id(), "interact", { source=playerid, sourceId=playerid } )
	
	--interact( config );
	
	--world.callScriptedEntity( entity.id(), "interact", config )	--No good for some things

end

function init()
	_oldnpcinit();

	sb.logInfo( "NPC started" );
	
	message.setHandler("vsoplayerinteract", msgHdlvsoplayerinteract )
	
end
--init = _oldnpcinit;
]]--