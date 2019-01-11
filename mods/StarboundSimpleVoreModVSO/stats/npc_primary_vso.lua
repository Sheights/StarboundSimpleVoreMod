
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
end