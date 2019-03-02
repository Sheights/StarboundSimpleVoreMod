--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

require("/scripts/vore/vsosimple.lua")

--[[

dragbagz plan:

	Idle sleeping bag shaped like a dragon (Sheights made it?)
	
	Interact to get inside.
	
	While inside, you are healed (npc's stay inside until they are fully healed)
	
	It'll animate every now and then.
	
	Press any direction to escape.
]]--

-------------------------------------------------------------------------------

function onForcedReset( )

	vsoVictimAnimVisible( "drivingSeat", false )
	vsoUseLounge( true, "drivingSeat" )
	vsoUseSolid( false )
		
	vsoNext( "state_idle" )
	vsoAnim( "bodyState", "idle" )
	
end

-------------------------------------------------------------------------------

function onBegin()

	onForcedReset();
	
	vsoOnBegin( "state_idle", function()
		vsoAnim( "bodyState", "idle" )
		vsoMakeInteractive( true )
	end )
	
	vsoOnInteract( "state_idle", function( targetid )
		vsoSetTarget( "food", targetid )
		vsoNext( "state_full" )
	end )
	
	vsoOnEnd( "state_idle", function()
		vsoMakeInteractive( false )
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_full", function()
	
		vsoEat( vsoGetTargetId( "food" ), "drivingSeat" )
		
		vsoVictimAnimSetStatus( "drivingSeat", { "clothedbed1" } );	--You can change these anytime! Masks have to be reapplied.
		vsoApplyStatus( "food", "spovdragbagz_mask1", 5 )	--Masks have to be reapplied.
		
		vsoSay( "*gulp*" );
		vsoSound("swallow");
		
		vsoVictimAnimReplay( "drivingSeat", "lay" )
		vsoAnim( "bodyState",  "fullidle"  )
		
		self.npcwaittime = vsoRand( 3, 30 );		--If a NPC uses the dragon bag, we want them to just "stay" for a while.
		self.npcstarttime = vsoDeltaFromStart();	--This is very efficient as it requires no resourace management.
		
		vsoOnNPCInputOverride( "state_full", function() 
			if vsoGetResourceHealthPercent( vsoGetTargetId( "food" ) ) < 100 then
				self.npcstarttime = self.npcwaittime + vsoDeltaFromStart();	--Reset time to now
			else
				if vsoDeltaFromStart() > self.npcwaittime then
					vsoInputOverride( "drivingSeat" )
				end
			end
		end )
		
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_release", function()
	
		vsoVictimAnimSetStatus( "drivingSeat", { } );
	end )
	
	vsoOnEnd( "state_release", function()
	
		vsoApplyStatus( "food", "vsomask_none" )	--Remove the mask
		
		vsoUneat( "drivingSeat" )
		vsoSetTarget( "food", nil )
		
		vsoSay( "*belch*" );
		vsoSound("lay");
		
		vsoAnim( "bodyState", "idle" )
	end )
	
end

-------------------------------------------------------------------------------

function onEnd()
	vsoVictimAnimClearReady( "drivingSeat" )	--Just in case.
end

-------------------------------------------------------------------------------

function state_idle()
	--Do nothing?
end

-------------------------------------------------------------------------------

function state_full()

	vsoTimerEveryDo( "gurgle", 1.0, 8.0, vsoSound, "digest" ) --play gurgle sounds <= "Play sound from list [soundlist] every [ 1 to 8 seconds ]"
	
	if vsoAnimEnd( "bodyState" ) then
		
		if vsoGetResourceHealthPercent( vsoGetTargetId( "food" ) ) < 100 then
			vsoVictimAnimSetStatus( "drivingSeat", { "clothedbed1" } );
		else
			vsoVictimAnimSetStatus( "drivingSeat", { "voreheal" } );
		end
		
		vsoApplyStatus( "food", "spovdragbagz_mask1", 5 )	--Masks have to be reapplied.
		
		if vsoChance(25) then
		
			vsoVictimAnimReplay( "drivingSeat", "suckle" )
			vsoAnim( "bodyState",  "full"  )
		else
		
			vsoVictimAnimReplay( "drivingSeat", "lay" )
			vsoAnim( "bodyState",  "fullidle"  )
		end
		
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
	