--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ 

require("/scripts/vore/vsosimple.lua")

--[[

CREATURENAME plan:

	Write your plan here, so you can keep track of it while coding!
	
]]--

function loadStoredData()
	vsoStorageSaveAndLoad( function()	--Get defaults from the item spawner itself
		if storage.colorReplaceMap ~= nil then
			vsoSetDirectives( vsoMakeColorReplaceDirectiveString( storage.colorReplaceMap ) );
		end
	end )
end

function showEmote( emotename )	--helper function to express a emotion particle	"emotesleepy","emoteconfused","emotesad","emotehappy","love"
	if vsoTimeDelta( "emoteblock" ) > 1 then
		animator.setParticleEmitterBurstCount( emotename, 1 );
		animator.burstParticleEmitter( emotename )
	end
end

-------------------------------------------------------------------------------

function onForcedReset( )	--helper function. If a victim warps, vanishes, dies, force escapes, this is called to reset me. (something went wrong) 

	vsoAnimSpeed( 1.0 );
	vsoVictimAnimVisible( "drivingSeat", false )
	vsoUseLounge( false, "drivingSeat" )
	vsoUseSolid( false )
		
	vsoNext( "state_idle" )
	vsoAnim( "bodyState", "idle" )
	
	vsoMakeInteractive( true )
end

-------------------------------------------------------------------------------

function onBegin()	--This sets up the VSO ONCE.

	vsoEffectWarpIn();	--Play warp in effect
	
	onForcedReset();	--Do a forced reset once.
	
	vsoStorageLoad( loadStoredData );	--Load our data (asynchronous, so it takes a few frames)
	
	vsoOnBegin( "state_idle", function()
		vsoUseLounge( false, "drivingSeat" )
		vsoAnim( "bodyState", "idle" )
		vsoMakeInteractive( true )
	end )
	
	vsoOnInteract( "state_idle", function( targetid )
	
		local anim = vsoAnimCurr( "bodyState" );

		showEmote("emotehappy");
		
		vsoSetTarget( "food", targetid )
		
		vsoNext( "state_full" )	--release
		
	end )
	
	vsoOnEnd( "state_idle", function()
	
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_full", function()
	
		vsoAnim( "bodyState", "full"  )
		
		vsoVictimAnimVisible( "drivingSeat", false )
		vsoUseLounge( true, "drivingSeat" )
		vsoEat( vsoGetTargetId( "food" ), "drivingSeat" )
		
		vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatebelly" } );
		
		vsoTimerSet( "gurgle", 1.0, 8.0 )	--For playing sounds
		
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_release", function()
	
	end )
	
	vsoOnEnd( "state_release", function()

		vsoUneat( "drivingSeat" )
		
		vsoApplyStatus( "food", "droolsoaked", 5.0 );	--Add status effect "droolsoaked"
		
		vsoSetTarget( "food", nil )
		vsoAnim( "bodyState", "idle" )
		vsoUseLounge( false, "drivingSeat" )
	end )

end

-------------------------------------------------------------------------------

function onEnd()
	
	vsoEffectWarpOut();
	
end

-------------------------------------------------------------------------------

function state_idle()
	
	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then

		vsoAnim( "bodyState",  "idle"  )
	end
end

-------------------------------------------------------------------------------

function state_full()

	if vsoTimerEvery( "gurgle", 1.0, 8.0 ) then	--play gurgle sounds <= "Play sound from list [soundlist] every [ 1 to 8 seconds ]"
		vsoSound( "digest" )
	end

	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then

		vsoAnim( "bodyState", "full"  )
	end
	
	if vsoHasAnySPOInputs( "drivingSeat" ) then
		vsoNext( "state_release" )	--release
	end
end

-------------------------------------------------------------------------------

function state_release()
	if vsoVictimAnimClearReady( "drivingSeat" ) then
		vsoNext( "state_idle" )	--release
	end
end
