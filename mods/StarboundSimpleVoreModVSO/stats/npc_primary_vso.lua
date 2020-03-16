--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

hasinteract = interact;

oldinit = init
function init()
	oldinit()
	message.setHandler("vsoListStatusEffects", function( _, _, sourceEntityId ) return status.activeUniqueStatusEffectSummary() end )
	message.setHandler("vsoForceApply", function( _, _, x, y, xmode, ymode )
		if xmode > 0 then
			if xmode == 1 then
				mcontroller.setXVelocity( mcontroller.xVelocity() + x )
			elseif xmode == 2 then
				mcontroller.setXVelocity( x)
			elseif xmode == 3 then
				mcontroller.force( { x,0 } )
			elseif xmode == 4 then
				--mcontroller.approachXVelocity( x, float maxControlForce)
			elseif xmode == 5 then
				--mcontroller.addMomentum
			end
		end
		if ymode > 0 then
			if ymode == 1 then
				mcontroller.setYVelocity( mcontroller.yVelocity() + y )
			elseif ymode == 2 then
				mcontroller.setYVelocity( y )
			elseif ymode == 3 then
				mcontroller.force( { 0,y } )
			elseif ymode == 4 then
				--mcontroller.approachXVelocity( x, float maxControlForce)
			elseif ymode == 5 then
				--mcontroller.addMomentum
			end
		end
	end )
	
	message.setHandler( "vsoStatusPropertySet", function( _, _, prop, value )
		return status.setStatusProperty( prop, value )
	end )
	
	message.setHandler( "vsoStatusPropertyGet", function( _, _, prop, defaultvalue )
		return status.statusProperty( prop, defaultvalue )
	end )
	
	message.setHandler( "vsoResourceGetSummary", function( _, _ )
		local R = {}
		for i,k in pairs( status.resourceNames() ) do
			R[k] = {
				status.resource(k)	--isResource
				,status.resourceMax(k)
				,status.resourcePercentage(k)
				,status.resourcePositive(k)
				,status.resourceLocked(k)
			}
		end
		return R;
	end )
	
	message.setHandler( "vsoResourceAddPercent", function( arga_, argb_, resname, deltapercent, resthresh )
	
		if status.isResource( resname ) and resthresh ~= nil then
			local epsilon = 1;
			local retval = true;
			local resthreshreal = resthresh*status.resourceMax( resname );
			local currval = status.resource( resname );
			local deltaval = deltapercent*status.resourceMax( resname );
			local nextval = currval + deltaval
			if deltapercent < 0 then
				if nextval <= resthreshreal+epsilon then
					status.setResource( resname, resthreshreal+epsilon )
					retval = false;
				else
					status.modifyResource( resname, deltaval )
				end
			elseif deltapercent > 0 then
				if nextval >= resthreshreal-epsilon then
					status.setResource( resname, resthreshreal-epsilon )
					retval = false;
				else
					status.modifyResource( resname, deltaval )
				end
			end
			return retval;
		elseif status.isResource( resname ) then
	
			if deltapercent < 0 then
				status.overConsumeResource( resname, -deltapercent*status.resourceMax( resname ) )
			else
				status.modifyResourcePercentage( resname, deltapercent );
			end
			return status.resource( resname ) > 0;
		else
			--resource DOES NOT EXIST...
		end
	end )
	
	message.setHandler( "vsoPlayerInteract", function( arga_, argb_, config, playerid )
		
		config.sourceId = playerid
		config.source = playerid
		
		--Merchants? do they work??
		
		local res = world.callScriptedEntity( entity.id(), "interact", config ) --uh...
		
		if res ~= nil then
		
			world.sendEntityMessage( playerid, "vsoForceInteract", res[1], res[2], entity.id() );
			
		else
		
			local res = world.callScriptedEntity( entity.id(), "onInteraction", config ) --uh...
		
			if res ~= nil then
			
				world.sendEntityMessage( playerid, "vsoForceInteract", res[1], res[2], entity.id() );
				
			end
		end
		
		--sb.logInfo( "NPC fake interacted2 " );
		
		--??
		--Not sure here which to call...
		--world.callScriptedEntity( entity.id(), "onInteraction", config ) --for objects?
		--sb.logInfo( "vsoPlayerInteract "..tostring( interact ).." "..tostring( _ENV["interact"] ).." "..tostring( tostring( hasinteract ) ) );
		
		--world.callScriptedEntity( entity.id(), "_criticalinteractcall", { source=playerid, sourceId=playerid } )
		
		--Oddly, this doesnt work for QUEST acceptance.
		--	Need to check what is going on there...
		
			--player.interact();
			--sb.logInfo( tostring( res ) );
			
	end )
	
end