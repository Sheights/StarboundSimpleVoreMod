require "/scripts/util.lua"
require "/scripts/rect.lua"
require "/interface/cockpit/cockpitutil.lua"

function init()
	--Expect to be able to popup dialogs for a player / player predator
	--Unsure what we can do here. Better than using companion scripts?
	
	--sb.logInfo( "generic script player_vso" );
	--for k,v in pairs( ControlMap ) do
	--
	--	sb.logInfo( k .. " = "..tostring( v ) );
	--end
	
	--We have:
	--script
	--player
	--sb
	--world
	--mcontroller
	--storage  ????
	--ControlMap	???	.values(), .add(), .new(), .contains(), .setActive()	
	--
	
end

function update(dt)
end