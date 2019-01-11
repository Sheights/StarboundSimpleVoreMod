function init()
	status.setStatusProperty( "vsoDigestRate", effect.getParameter( "vsoDigestRate", 0 ) );	-- -(1.0 / 120)	--100% every 120 seconds?
	status.setStatusProperty( "vsoVoreAmount", effect.getParameter( "vsoVoreAmount", 100 ) );	--100% vored
	status.setStatusProperty( "vsoDigestMinimum", effect.getParameter( "vsoDigestMinimum", 0.05 ) );	--100% vored
	status.setStatusProperty( "vsoDigestEnd", effect.getParameter( "vsoDigestEnd", 1 ) );
	self.originalHealthPercent = status.resourcePercentage("health");
end

function update(dt)
	
	--seat effects can't HAVE a duration...
	if effect.duration() == nil then
		--display duration maybe??!? Hmph. icon directives would be nice...
		
	else
		local vamount = status.statusProperty( "vsoVoreAmount", 100 );
		if vamount < 1 then	--1/100
			vamount = 1;
		end
		local estdurationdelta = vamount - effect.duration();
		effect.modifyDuration( estdurationdelta )	--does it change? Property??
	end
	

	--Can we change the icon at least?
	--	"icon" : "/interface/statuses/erchiussickness.png"

	--object.setConfigParameter( "icon", "/interface/statuses/erchiussickness.png" )

	local digesthealth = status.statusProperty( "vsoDigestRate", 0 );
	if digesthealth ~= 0 then
		local currhealth = status.resourcePercentage("health");
		local deltahp = digesthealth * dt
		if deltahp < 0 then
			local digestmin = status.statusProperty( "vsoDigestMinimum", 0.05 );
			if (currhealth-digestmin) < deltahp then
				deltahp = digestmin - currhealth
			end
			status.modifyResourcePercentage( "health", deltahp )
		else
			if currhealth > (100 + deltahp) then
				deltahp = 100.0 - currhealth;
			end
			status.modifyResourcePercentage( "health", deltahp )
		end
	end
end

function uninit()

	if status.statusProperty( "vsoDigestEnd", 1 ) < 0 then
		if status.resourcePercentage("health") <= ( status.statusProperty( "vsoDigestMinimum", 0.05 ) + 0.001 ) then
			--Inform owner of stat that we kill't someone? (or at least intended to)
			
			status.modifyResourcePercentage( "health", -100 );	--Hm.
		end
	elseif status.statusProperty( "vsoDigestEnd", 1 ) > 0 then
		status.modifyResourcePercentage( "health", self.originalHealthPercent - status.resourcePercentage("health") );
	end
end