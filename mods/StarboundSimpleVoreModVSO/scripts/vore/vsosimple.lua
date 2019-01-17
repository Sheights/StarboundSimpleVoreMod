--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

require "/scripts/rect.lua"
--From monsters/pets
require "/scripts/vsopathing.lua"
--require "/scripts/stateMachine.lua"
require "/scripts/util.lua"
require "/scripts/vec2.lua"

--"script" : "/scripts/vore/vsosimple.lua",

--require "/scripts/util.lua"

--Issues:

--Exlusion requests, aka "cheaters"
vsoExcludeByType = {
	
}

--Status effects that make a target un-targetable
vsoInvalidTargetStats = {
	["vsokeepsit"]=1
	,["vsokeepsit0"]=1
	,["vsokeepsit1"]=1
	,["vsokeepsit2"]=1
	,["vsokeepsit3"]=1
	,["vsokeepsit4"]=1
	,["vsokeepsit5"]=1
	,["vsokeepsit6"]=1
	,["vsokeepsit7"]=1
	,["vsoforcesit"]=1
	,["vsoinvisible"]=1
	,["healvore"]=1
	,["dragonacid"]=1
	,["dragonvore"]=1
	,["dragonUB"]=1
	,["dragonUBmed"]=1
	,["dragonvoremed"]=1
	,["harpyvore"]=1
	,["npcheal"]=1
	,["healvore"]=1
	,["monstervore"]=1
	,["monstervorerequest"]=1
	,["npcacid"]=1
	,["npcprey"]=1
	,["npcpreyacid"]=1
	,["npcvore"]=1
	,["objectvore"]=1
	,["rpvore"]=1
	,["rpvoredigest"]=1
	,["rpvoreegg"]=1
	,["rpvorefeed"]=1
	,["rpvoreheal"]=1
	,["rpvoreub"]=1
	,["yoshiblack"]=1
	,["yoshicyan"]=1
	,["yoshigreen"]=1
	,["yoshiindigo"]=1
	,["yoshiorange"]=1
	,["yoshipink"]=1
	,["yoshipurple"]=1
	,["yoshired"]=1
	,["yoshiwhite"]=1
	,["yoshiyellow"]=1
	,["rptool2status"]=1
	,["rptool2statusd"]=1
	,["rptool2statusegg"]=1
	,["rptool2statush"]=1
}

--Inputs are NOT scaled to facing direction. The logical versions ARE.
vsoInputsKnown ={
	["L"] = "left"
	,["R"] = "right" 
	,["U"]  = "up"
	,["D"]  = "down"
	,["A"]  = "PrimaryFire"
	,["B"]  = "AltFire"
	,["J"]  = "jump"
}

--1 is lightest, 4 is darkest
vsoDefaultPrimaryColorOptions = {
	{ "a7d485",  "5fab55",  "338033",  "18521a" }	--dino green
	,{ "838383",  "555555",  "383838",  "151515" }
	,{ "b5b5b5",  "808080",  "555555",  "303030" }
	,{ "e6e6e6",  "b6b6b6",  "7b7b7b",  "373737" }
	,{ "f4988c",  "d93a3a",  "932625",  "601119" }
	,{ "ffd495",  "ea9931",  "af4e00",  "6e2900" }
	,{ "ffffa7",  "e2c344",  "a46e06",  "642f00" }
	,{  "b2e89d",  "51bd3b",  "247824",  "144216" }
	,{  "96cbe7",  "5588d4",  "344495",  "1a1c51" }
	,{  "d29ce7",  "a451c4",  "6a2284",  "320c40" }
	,{  "eab3db",  "d35eae",  "97276d",  "59163f" }
	,{  "ccae7c",  "a47844",  "754c23",  "472b13" }
}

-------------------------------------------------------------------------------
--Core isolated utilities and algorithms------------------------------------
-------------------------------------------------------------------------------
function vsoError( msg )
	sb.logInfo( "#VSOERROR("..tostring(entity.id())..") "..tostring( msg ) )
	self.vsoForcedToDie = true;	--Yup.
end
		
function vsoInfo( msg )
	sb.logInfo( "#VSOINFO("..tostring(entity.id())..") "..tostring( msg ) )
end

function vsoNotnil( val, msg )	--IF a value is not nil, returns it. otherwise, errors
	if val == nil then vsoError( msg ) end
	return val;
end
		
function vsoIfnil( val, repl )	--IF a value is nil, returns the repl. otherwise, returns the value.
	if val == nil then return repl end
	return val;
end

function vsoInList( list, value )	--Returns true if a value is found in a list
	for k,v in pairs( list ) do
		if v == value then
			return true
		end
	end
	return false;
end

function vsoClamp( v, minv, maxv )
	if minv ~= nil then 
		if v < minv then v = minv end 
	end
	if maxv ~= nil then 
		if v > maxv then v = maxv end 
	end
	return v;
end

function mathround( v )
  return math.floor( v + 0.5 )
end

function vsoAddClamp( v, del, minv, maxv )
	return vsoClamp( v + del, minv, maxv )
end

function vsoRatioSafe( aval, b )
	if a ~= nil then
		if type(a) == "table" then
			b = a[2]
			a = a[1]
		elseif b == nil then
			b = 0;
		end
		if b ~= 0 then
			return 1.0*a/b
		elseif a > 0 then
			return 1.0;
		end
	end
	return 0.0;
end

function vsoRand( vmin, vmax )
	if vmin ~= nil then
		if vmax ~= nil then
			return vmin + vmax*math.random()
		else
			return vmin*math.random()
		end
	else
		return math.random()
	end
end

function vsoRandomPick( list )--Select a random element from a list
	local dowhat = #list;
	if dowhat > 0 then
		dowhat = math.random( dowhat );
		if dowhat >= #list then
			dowhat = 0
		end
		return list[ dowhat + 1 ];
	end
	return nil;
end

function vsoHistoIndex( chances )	--Returns a index from a array of histogram chances ( {1,1,1} would give 1,2, or 3 evenly, {1,4,1} would mostly give 2's )
	local total = 0
	for k,v in pairs( chances ) do
		total = total + v;
	end
	local findme = math.random() * total;
	local bestdex = 1;
	total = 0;
	for k,v in pairs( chances ) do
		total = total + v;
		if total >= findme and v > 0 then	--0 influence elements are ignored (but the FIRST element may be selected as default)
			bestdex = k;
			break;
		end
	end
	return bestdex;
end

function vsoHistoPick( mylist, chances )	--Given a list, and a list of corresponding chances, select a element from that list. First element is default, a 0 value will never be selected unless it's element 1
	return mylist[ vsoHistoIndex( chances ) ];
end

function vsoChance( npercent )	--100 always happens. 1 is 1/100 percent change.
	return ( math.random() * 100.0 ) <= npercent;
end

function vsoStringReplacer( msg, terms )	--Given a string with "Hello ^[name];!" and a { name="bob" } performs the term replacement, result "Hello bob!"

	if msg ~= nil then
		local si = 1;
		local simax = string.len( msg );
		local endmsg = "";
		while si < simax do	--careful
			local nextd = string.find( msg, "%^%[", si)
			if nextd ~= nil then
				local closed = string.find( msg, "%];", nextd + 2 )
				if closed ~= nil then
					--
					local term = string.sub( msg, nextd + 2, closed-1 );
					
					--Now replace with term dictionary
					if terms[term] ~= nil then
						if (nextd - 1) > si then
							endmsg = endmsg..string.sub( msg, si, nextd - 1 )..terms[term]
						else
							endmsg = endmsg..terms[term]
						end
					else
						if (nextd - 1) > si then
							endmsg = endmsg..string.sub( msg, si, nextd - 1 ).."<"..term..">"
						else
							endmsg = endmsg.."<"..term..">"
						end
					end
					
					si = closed + 2;
				else
					--SYNTAX ERROR
					endmsg = endmsg..string.sub( msg, si );
					break;
				end			
			else
				endmsg = endmsg..string.sub( msg, si );
				break;
			end
		end
		return endmsg;
	end
	return ""
end
--Testing Passed:
--sb.logInfo( vsoStringReplacer( "Hello, ^[what];", { what = "Joe" } ) )
--sb.logInfo( vsoStringReplacer( "^[1];+^[2];=^[3];", { ["1"] = "A", ["2"]= "B", ["3"]="C" } ) )


--This is a NON LOOPING NON THROUGH varient. Given an array of times, return the two indices to interpolate, with the linear dt.
function _animArrayGetRange( tv, t )
	local maxdex = 0;
	for k,v in ipairs( tv ) do
		if v > t then
			maxdex = k;
			break;
		end
	end
	if maxdex < 1 then
		return #tv, #tv, 0.0	--RIGHT end of array
	elseif maxdex == 1 then
		return 1, 1, 0.0	--LEFT end of array
	else
		local spreadt = tv[maxdex] - tv[maxdex-1];
		if spreadt == 0 then spreadt = 1; end
		local difft = (t - tv[maxdex-1]) / spreadt;
		return maxdex-1, maxdex, difft
	end
end

function _animArrayInterpListLinear( A, i0, i1, dt )	--Given a list, two indicies and a dt, interpolate them linearly.
	if i0 > #A then i0 = #A end
	if i1 > #A then i1 = #A end
	if i0 < 1 then i0 = 1; end
	if i1 < 1 then i1 = 1; end
	--if i0 < 1 then i0 = 1 end
	--if i1 < 1 then i1 = 1 end
	return (A[i1] - A[i0]) * dt + A[i0];
end

function _animArrayInterpListRound( A, i0, i1, dt )	--Given a list, two indicies and a dt, interpolate them linearly.
	if i0 < 1 then i0 = 1; end
	if i1 < 1 then i1 = 1; end
	if i0 > #A then i0 = #A end
	if i1 > #A then i1 = #A end
	if dt > 0.5 then
		return A[i0];
	else
		return A[i1];
	end
end

function _animArrayGetListClamp( A, i0 )
	if i0 < 1 then i0 = 1; end
	if i0 > #A then i0 = #A end
	return A[i0];
end

-------------------------------------------------------------------------------
--Isolated Utility functions and objects---------------------------------------
-------------------------------------------------------------------------------
function vsoTT( maxtime )	--Create a time tracker that starts at 0.0, and can be checked with ttAdd.
	return { 0.0, maxtime }
end

function vsoTTRestart( v )	--Restart a time tracker to 0.0 no matter what
	v[1] = 0;
	return true;
end

function vsoTTCheck( v )	--When this returns true, the elapsed time has passed. It does NOT reset the time
	return v[1] >= v[2];
end

function vsoTTAdd( v, dt )	--When this returns true, the elapsed time has passed. It does NOT reset the time
	v[1] = v[1] + dt
	if v[1] >= v[2] then
		return true;
	end
	return false;
end

function vsoTTWrap( v, dt )	--Wrap the time around to be in the 0..deltime range
	if v[1] >= v[2] then
		v[1] = v[1] - v[2];
		if v[1] >= v[2] then
			v[1] = v[1] - math.floor( v[1] / v[2] ) * v[2]
		end
		return true;
	end
	return false;
end

-------------------------------------------------------------------------------
--Utility functions with self VSO scope----------------------------------------
-------------------------------------------------------------------------------
function vsoChangeSpawnOwnerState( towhat )	--Changes the spawn owner animation state (spawn owner config selects part and such...)
	if towhat ~= self.vsoSpawnOwnerState then
		self.vsoSpawnOwnerState = towhat
		if self.vsoSpawnOwner ~= nil then
			world.sendEntityMessage( self.vsoSpawnOwner, "vsoSpawnerAnimState", entity.id(), self.vsoSpawnOwnerState );
		end
	end
end

function vsoShouldFlipAnimator()
	if self.vsoInitialDirection == -1 then
		if self.vsoCurrentDirection == -1 then
			return true;
		else
		end
	else
		if self.vsoCurrentDirection == -1 then
		else
			return true;
		end
	end
	return false
end

function vsoDirection()
	return self.vsoCurrentDirection
end

function vsoRelativeRect( xMin, yMin, xMax, yMax )	--Get a rectangle relative to my mcontroller position (center of physical bounding box)

	local c = mcontroller.position()
	if xMin > xMax then local t=xMin; xMin = xMax; xMax = t; end
	if yMin > yMax then local t=yMin; yMin = yMax; yMax = t; end
	local pos1 = { c[1] + xMin, c[2] + yMin }
	local pos2 = { c[1] + xMax, c[2] + yMax }
	if vsoShouldFlipAnimator() then
		pos1[1] = c[1] - xMax
		pos2[1] = c[1] - xMin
	end
	return { pos1, pos2 }
end

function vsoRelativePoint( xMin, yMin )	--Get a rectangle relative to my mcontroller position (center of physical bounding box)
	local c = mcontroller.position()
	local R = { c[1] + xMin, c[2] + yMin }
	if vsoShouldFlipAnimator() then
		R[1] = c[1] - xMin
	end
	return R
end

function vsoToLocalPoint( xMin, yMin )	--Get a rectangle relative to my mcontroller position (center of physical bounding box)
	--#ERROR make later (for big dragon or boat dragon)
end

function vsoToGlobalPoint( xMin, yMin )	--Get a rectangle relative to my mcontroller position (center of physical bounding box)
	--#ERROR make later (for big dragon or boat dragon)
	
	--What is our rotation? do the matrix thing later...
	
	--PRoblems if rotation is factored in. MAke sure we handle that
	local c = mcontroller.position()
	local R = { xMin - c[1], yMin - c[2] }
	if vsoShouldFlipAnimator() then
		R[1] = -R[1]
	end
	return R
end

--Might want to reevaluate this.
--function vsoForceSit( victimid, seatindex )
--	if world.isNpc( victimid ) then
--		world.callScriptedEntity( victimid, "npc.setLounging", entity.id(), seatindex )
--	else
--		world.sendEntityMessage( victimid, "vsoForcePlayerSit", entity.id(), seatindex )
--	end
--end

function vsoEatForce( victimid, seatindex )
	if world.entityExists( victimid ) then
		if vsoExcludeByType[ world.entityType( victimid ) ] == nil then
			--Not sure how to input the seat index yet... #ERROR
			--vsoForceSit( victimid, seatindex );	---Hm!
			
			local rpcresult = world.sendEntityMessage( victimid, "applyStatusEffect", "vsokeepsit"..tostring(seatindex), 0.1, entity.id() );
			
			--world.callScriptedEntity( entity.id(), "npc.resetLounging" );
			--world.callScriptedEntity( victimid, "npc.setLounging", entity.id(), seatindex )
			
			--Its possible to try eating someone who IS EATEN. careful.
			--Need to know about this. Can the status effect do this?? Hm...
			
			return true;
		end
	end
	return false;
end

			
function vsoFacePoint( x )
	if x ~= nil then
		if x < mcontroller.position()[1] then
			if self.vsoInitialDirection == -1 then
				animator.setFlipped( true )
				self.vsoCurrentDirection = -1
			else
				animator.setFlipped( true )
				self.vsoCurrentDirection = 1
			end
		else
			if self.vsoInitialDirection == -1 then
				animator.setFlipped( false )
				self.vsoCurrentDirection = 1
			else
				animator.setFlipped( false )
				self.vsoCurrentDirection = -1
			end
		end
	end
end

function vsoInputCreate( seatname )
	local R = {}
	R.names = {}
	R.holdLength = 0.333;	--1/3 second. Adjustable.
	for k,v in pairs( vsoInputsKnown ) do
		R[ k ] = 0;
		local rna = { k.."t", k.."r", k.."f", k.."s" }
		R[ rna[1] ] = 0;	--tap
		R[ rna[2] ] = 0;	--release
		R[ rna[3] ] = 0;	--fast
		R[ rna[4] ] = 0;	--slow
		R.names[ k ] = rna;
	end
	--logical inputs
	R.slowdx = 0;
	R.slowdy = 0;
	R.fastdx = 0;
	R.fastdy = 0;
	R.slowA=0;
	R.fastA=0;
	R.slowB=0;
	R.fastB=0;
	R.slowJ=0;
	R.fastJ=0;
	R.tx = 0;
	R.ty = 0;
	R.dx = 0;
	R.dy = 0;
	return R
end

function vsoClipPositive( v )
	if v < 0 then return 0; else return v; end
end

function clipNonzero( v )
	if v ~= 0 then return 1; end
	return 0; 
end

function vsoInputComputeLogical( input, dt )
	
	local dir = 1;
	if vsoShouldFlipAnimator() then dir = -1; end
	--Logical inputs (pleasentness) -> +x is FORWARD
	input.slowdx = dir * ( vsoClipPositive(input.Rs) - vsoClipPositive(input.Ls))
	input.slowdy = (vsoClipPositive(input.Us) - vsoClipPositive(input.Ds))
	input.fastdx = dir * (input.Rf - input.Lf)
	input.fastdy = (input.Uf - input.Df)
	
	input.slowA = input.As;
	input.slowB = input.Bs;
	input.slowJ = input.Js;
	input.fastA = input.Af;
	input.fastB = input.Bf;
	input.fastJ = input.Jf;
	
	input.tx = dir * ( clipNonzero(input.Rt) - clipNonzero(input.Lt) )
	input.ty = clipNonzero(input.Ut) - clipNonzero(input.Dt)
	input.dx = dir * ( clipNonzero(input.R) - clipNonzero(input.L) )
	input.dy = clipNonzero(input.U) - clipNonzero(input.D)

	if input["Etap"] ~= nil then		
		if input["E"] == nil then
			input["E"] = 0;
		end
		if input["Etap"] > 0 then
			input["E"] = input["E"] + 1;
		else
			input["E"] = input["E"] - dt;
			if input["E"] < 0 then
				input["E"] = 0;
			end
		end
		input["Etap"] = 0;
	end
end

function vsoInputUpdate( seatname, input, dt, overrides )

	--Low level inputs (directness)
	for k,vstarboundinputname in pairs( vsoInputsKnown ) do
	
		local names = input.names[ k ]	--avoid doing string updates each frame!!!
		local ktap = names[1];
		local krelease = names[2];
		local kfast = names[3];
		local kslow = names[4];
		
		input[ktap] = 0;
		input[kslow] = 0;
		input[kfast] = 0;
		
		local over = false;
		if overrides ~= nil then
			if overrides[k] ~= nil then
				if overrides[k] > 0 then
					over = true;
				end
			end
		end
		
		if vehicle.controlHeld( seatname, vstarboundinputname ) or over then
			if input[k] <= 0 then
				input[ktap] = 1	--we TAPPED this key this frame
			end
			if (input[k] < input.holdLength) and ((input[k] + dt) >= input.holdLength) then
				input[kslow] = 1	--Held a key long enough to be a "slow" hold this frame
			end
			
			input[k] = input[k] + dt;	--Increase input timer
		else
			if input[k] > 0 then
				input[krelease] = input[k]	--Release tells us HOW LONG a input is held.
				
				if input[k] < input.holdLength then
					input[kfast] = 1
				end
			end
			input[k] = 0;	--clear out input timer
		end
	end
	
	vsoInputComputeLogical( input, dt )

	--Check for special case resets: ( hold primary, secondary, and jump, then tap "down" )
	input.specialEscape = 0;
	if (input["A"] > 0) and (input["B"] > 0) and (input["J"] > 0) and (input["Dt"] > 0) then
		input.specialEscape = 1;
	end
end


function vsoTargetGetEatenSeat( targetname )
	local targ = self.sv.targets[ targetname ];
	local seatname = nil;
	if targ ~= nil then
		local targetid = targ.id;
		for k,v in pairs( self.sv.eaten ) do
			if v.id == targetid then
				seatname = k;
				break;
			end
		end
	end
	return seatname;
end

function vsoTargetIsEaten( targetname, thresh )
	if thresh == nil then thresh = 15 end
	local targ = self.sv.targets[ targetname ];
	local seatname = nil;
	if targ ~= nil then
		local targetid = targ.id;
		for k,v in pairs( self.sv.eaten ) do
			if v.id == targetid then
				--Might need STRONGER evidence since you can tap E to escape like this
				if v.noteaten ~= nil then
					--sb.logInfo( tostring( v.noteaten ) .. " "..tostring( thresh ) )
					return (v.noteaten < thresh);
				else
					return true;
				end
			end
		end
	end
	return false;
end

--function vsoTargetFights4Wiggles4( targetname, adata )
function vsoFights4Wiggles4( seatname, adata )

	local returnval = 0;
	local playanim = nil;
	--local seatname = vsoTargetGetEatenSeat( targetname )
	--if seatname ~= nil then
	local eatenstruct = self.sv.eaten[ seatname ]
	if eatenstruct ~= nil then
		local input = eatenstruct.input
		if input ~= nil then
		
			local id = eatenstruct.id;	--vsoGetTargetId( targetname )
		
			local fx = input.fastdx;
			local fy = input.fastdy;
			local sx = input.slowdx;
			local sy = input.slowdy;
			local tx = input.dx;
			local ty = input.dy;
			if id >= 0 then
				--It's a NPC/other. So.
				--Generate struggling inputs? Somehow? based on npc mood?
				
			end
		
			if fx ~= 0 or fy ~= 0 then
				if fx ~= 0 then
					if fx > 0 then playanim = adata.Ffast; returnval = 1; end
					if fx < 0 then playanim = adata.Bfast; returnval = 1; end
				else
					if fy > 0 then playanim = adata.Ufast; returnval = 1; end
					if fy < 0 then playanim = adata.Dfast; returnval = 1;  end
				end
			elseif sx ~= 0 or sy ~= 0 then
				if sx ~= 0 then
					if sx > 0 then playanim = adata.Fslow; returnval = -1;  end
					if sx < 0 then playanim = adata.Bslow; returnval = -1;  end
				else
					if sy > 0 then playanim = adata.Uslow; returnval = -1;  end
					if sy < 0 then playanim = adata.Dslow; returnval = -1; end
				end
			end
			if playanim == nil then
				if tx ~= 0 then
					if tx > 0 then playanim = adata.F; returnval = 2; end
					if tx < 0 then playanim = adata.B; returnval = 2;  end
				else
					if ty > 0 then playanim = adata.U; returnval = 2;  end
					if ty < 0 then playanim = adata.D; returnval = 2;  end
				end
			end
			
			if type(playanim) == "table" then
				--If it's a table of 2 tables, then we HISTO pick:
				if #playanim == 2 then
					if type(playanim[1]) == "table" and type(playanim[2]) == "table" then
						playanim = vsoHistoPick( playanim[1], playanim[2] );
					else
						playanim = vsoRandomPick( playanim );
					end					
				else
					playanim = vsoRandomPick( playanim );
				end
			end
			
		end
	end
	return returnval, playanim
end

--function vsoTargetFights4Wiggles4( targetname, adata )
function vso4DirectionInput( seatname )

	local returntype = 0;
	local returndir = nil;
	--local seatname = vsoTargetGetEatenSeat( targetname )
	--if seatname ~= nil then
	local eatenstruct = self.sv.eaten[ seatname ]
	if eatenstruct ~= nil then
		local input = eatenstruct.input
		if input ~= nil then
		
			local id = eatenstruct.id;	--vsoGetTargetId( targetname )
		
			local fx = input.fastdx;
			local fy = input.fastdy;
			local sx = input.slowdx;
			local sy = input.slowdy;
			local tx = input.dx;
			local ty = input.dy;
			if id >= 0 then
				--It's a NPC/other. So.
				--Generate struggling inputs? Somehow? based on npc mood?
				--difficult problem.
				returntype = -1;
			end
		
			if fx ~= 0 or fy ~= 0 then
				if fx ~= 0 then
					if fx > 0 then returndir = 'F'; returntype = 1; end
					if fx < 0 then returndir = 'B'; returntype = 1; end
				else
					if fy > 0 then returndir = 'U'; returntype = 1; end
					if fy < 0 then returndir = 'D'; returntype = 1;  end
				end
			elseif sx ~= 0 or sy ~= 0 then
				if sx ~= 0 then
					if sx > 0 then returndir = 'F'; returntype = 2;  end
					if sx < 0 then returndir = 'B'; returntype = 2;  end
				else
					if sy > 0 then returndir = 'U'; returntype = 2;  end
					if sy < 0 then returndir = 'D'; returntype = 2; end
				end
			elseif input.J > 0 then
				returntype = 3;
				returndir = 'J'; 
			end
			--[[if returntype == 0 then
				if tx ~= 0 then
					if tx > 0 then returndir = 'F'; returntype = 1; end
					if tx < 0 then returndir = 'B'; returntype = 1;  end
				else
					if ty > 0 then returndir = 'U'; returntype = 1;  end
					if ty < 0 then returndir = 'D'; returntype = 1;  end
				end
				if returntype == 0 then
					if input.J > 0 then
						returntype = 3;
						returndir = 'J'; 
					end
				end
			end]]--
		end
	end
	return returntype, returndir
end
	
-------------------------------------------------------------------------------
--Message Handlers for self VSO scope------------------------------------------
-------------------------------------------------------------------------------
function vsoMsgHdlCreatedFrom(_, _, ownerKey, originalPos)	--Handle created from message
	self.vsoSpawnOwner = ownerKey;
	self.vsoSpawnCenter = originalPos;
	vsoChangeSpawnOwnerState( self.vsoSpawnOwnerStateDefault )
end

function vsoMsgHdlCreatedMonster(_, _, ownerKey, originalPos)	--Handle created as monster message
	self.vsoSpawnOwner = ownerKey;
	self.vsoSpawnCenter = originalPos;
	self.vsoSpawnMonster = true;
	vsoChangeSpawnOwnerState( self.vsoSpawnOwnerStateDefault )
end

function vsoMsgHdlComeHome(_, _, ownerKey, whotouched)	--Handle a interact on the spawn owner
	if self.vsoSpawnOwner ~= nil then
		local laststate = self.sv.laststate;
		if laststate ~= nil then
			local doit = self.sv.ss[ laststate ].comehomefn
			if doit ~= nil then
				if doit( whotouched ) then
					mcontroller.setPosition( self.vsoSpawnCenter );	--Warp!
				end
			end
		end
	end
end

function vsoMsgHdlPlayerInteracted(_, _, ownerKey, whotouched)	--Handle a interact from a player
	if self.vsoSpawnOwner ~= nil then
		local laststate = self.sv.laststate;
		if laststate ~= nil then
			--If we HAVE eaten:
				--treat as belly rub by player
			--Else:
				--change target to this thing
			onInteraction( { sourceId=whotouched } )
		end
	end
end

function vsoMsgHdlNPCInteracted(_, _, ownerKey, whotouched)	--Handle a interact from a npc
	if self.vsoSpawnOwner ~= nil then
		local laststate = self.sv.laststate;
		if laststate ~= nil then
			--If we HAVE eaten:
				--treat as belly rub by NPC
			--Else:
				--change target to this thing
			onInteraction( { sourceId=whotouched } )
			
		end
	end
end

function vsoMsgDlgInteracted(_, _, arg1, arg2)	--Handle a dialog response
	if self.vsoSpawnOwner ~= nil then
		onDialog( { response=arg1, sourceId=arg2 } )
	end
end

function vsoMsgHdlGet(_, _, parama, paramb )	--return vso.controllerAnimatorPanelGet( self, parama )
	
	if self[ parama ] then
		return self[ parama ];
	else
		--
	end
	return nil;
end

function vsoMsgHdlSeatIndexGet(_, _, victimid, ownercheck )
	--UHM.
	local retv = nil;
	for k,v in pairs( self.sv.eaten ) do
		if v ~= nil then
			if v.id == victimid then
				vehicle.setLoungeEnabled( k, true );	--Just in case?
				sb.logInfo( "Found seat : "..tostring( v.id ) .." "..k.." "..tostring( self.vsoLoungeNameToIndex[ k ] ) )
				retv = self.vsoLoungeNameToIndex[ k ]
				break;
			end
		end
	end
	return retv;	--UHM!!!
end

function vsoMsgHdlStorageLoadData(_, _, objectid, data )
	if self.vsoSpawnOwner ~= nil then
		--sb.logInfo( "vsoMsgHdlStorageLoadData calling "..tostring(objectid).." "..tostring(self.vsoSpawnOwner) );
		if objectid == self.vsoSpawnOwner then
			if self._storagecallback ~= nil then
				--sb.logInfo( "vsoMsgHdlStorageLoadData ok "..tostring(data) );
				self._storagecallback( data );
			end
		end
	end
end

function notify( notification )
	vsoInfo( " #NOTIFY "..notification.type.." "..tostring(notification.sourceId) );
	--notification.sourceId;
	--notification.targetId;
	--notification.type;
end

function vsoStorageAble()
	if self.vsoSpawnOwner ~= nil then
		return true;
	end
	return false;
end

function _vsoStorageLoadData( callback )
	--Queue this so we can wait for the vsoSpawnOwner... (forced single queue first in first out)
	--sb.logInfo( "vsoStorageLoadData "..tostring(self.vsoSpawnOwner) );
	if self.vsoSpawnOwner ~= nil then
		self._storagecallback = callback;
		--sb.logInfo( "vsoStorageLoadData sent" );
		world.sendEntityMessage( self.vsoSpawnOwner, "vsoStorageLoadData", entity.id() )
		return true
	end
	return false;
end

function _vsoStorageSaveData( data, optionalcallback )
	--Queue this so we can wait for the vsoSpawnOwner... (forced single queue first in first out)
	--sb.logInfo( "vsoStorageSaveData "..tostring(self.vsoSpawnOwner) );
	if self.vsoSpawnOwner ~= nil then
		--sb.logInfo( "vsoStorageSaveData sent" );
		--data is sent as a json string?
		local rpc = world.sendEntityMessage( self.vsoSpawnOwner, "vsoStorageSaveData", entity.id(), data )
		if optionalcallback ~= nil then
			_add_vso_rpc( rpc, optionalcallback );
		end
		return true
	end
	return false;
end

function _vsoStorageSaveDataKey( key, data )
	--Queue this so we can wait for the vsoSpawnOwner... (forced single queue first in first out)
	--sb.logInfo( "vsoStorageSaveData "..tostring(self.vsoSpawnOwner) );
	if self.vsoSpawnOwner ~= nil then
		--sb.logInfo( "vsoStorageSaveData sent" );
		--data is sent as a json string?
		world.sendEntityMessage( self.vsoSpawnOwner, "vsoStorageSaveDataKey", entity.id(), key, data )
		return true
	end
	return false;
end

function vsoStorageLoadData( callback )
	self._storageLoadQueue = { callback }
end

function vsoStorageSaveData( userdata, optcallback )
	self._storageSaveQueue = { userdata, optcallback }	--HARDLY A QUEUE. Sheesh.
end

function vsoStorageSetIfNotNil( defaults )
	for k,v in pairs( defaults ) do
		if storage[k] ~= nil then
			--Dont overwrite.
		else
			storage[k] = v;
		end
	end
end
	
function vsoStorageSave( optcallback )
	--Should do this every time anything you want saved changes (the object can be destroyed ANY time so. careful. memory loss for tragedy)
	R = {}
	for k,v in pairs( storage ) do
		R[ k ] = v
	end
	vsoStorageSaveData( storage, optcallback );
end

function vsoStorageSaveKey( key )
	_vsoStorageSaveDataKey( key, storage[ key ] );
end

function vsoStorageLoad( callback )
	vsoStorageLoadData( function( data )
	
		--Load values from data
		if data ~= nil then
			for k,v in pairs( data ) do
				storage[ k ] = data[ k ];
			end
		end
		
		callback( data )
	end )
		
end

--Useful.
function vsoStorageSaveAndLoad( callback )
	vsoStorageSave( function() 		--Because we CHANGED defaults... AND the item config changed them...
		vsoStorageLoad( callback )
	end );
end

--Useful for a treed statistic ( stattable -> method -> key = value
function vsoAddStoredStat( stattable, method, key, value )
	if storage[stattable] == nil then
		storage[stattable] = {}
	end
	if storage[stattable][method] == nil then
		storage[stattable][method] = {};
	end
	if storage[stattable][method][key] == nil then
		storage[stattable][method][key] = 0;	
	end
	storage[stattable][method][key] = storage[stattable][method][key] + value;
	vsoStorageSaveKey( stattable );
end


function vsoTimeDelta( timername, readonly )

	--Get the current delta time since the last time this was called (0.0 by default)
	--local nowvalue = self.vsoclock;	--os.clock();	--world.time()
	local retv = 0.0;
	if self.sv.td[ timername ] ~= nil then
		retv = self.vsoclock - self.sv.td[ timername ];
	end
	if readonly == true then
		--
	else
		self.sv.td[ timername ] = self.vsoclock;
	end
	return retv;
end

function vsoTimeDeltaEvery( timername, readonly, maxdelta )

	local dv = vsoTimeDelta( timername, readonly );
	if dv > 0 then
		if maxdelta ~= nil then
			return dv > ( maxdelta*math.random() );
		else
			--ignore
		end
	end
	return false
end
	
-------------------------------------------------------------------------------
--State Handlers for self VSO scope------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
function applyDamage( damageRequest )	--Take damage, or not
	local laststate = self.sv.laststate;
	local res = {};
	local healthLost = 0;
	local usematerial = "organic";
	if laststate ~= nil then
		local doit = self.sv.ss[ laststate ].damagefn
		if doit ~= nil then
			
			local sourcentity = damageRequest.sourceEntityId;
			local damagekind = damageRequest.damageSourceKind;
			
			res = doit( damageRequest )
			
			if res ~= nil then
			
				local damage = 0;
				if res.damage ~= nil then damage = res.damage end
				if res.targetMaterialKind ~= nil then usematerial = res.targetMaterialKind end
				if res.damagekind ~= nil then damagekind = res.damageSourceKind end
				
				if damage > 0 then
					healthLost = math.min( storage.health, damage );
				end
			
				res = {{	--squishy? adjust targetMaterialKind
					sourceEntityId = sourcentity,
					targetEntityId = entity.id(),
					position = mcontroller.position(),
					damageDealt = damage,
					healthLost = healthLost,
					hitType = "Hit",
					damageSourceKind = damagekind,
					targetMaterialKind = usematerial,
					killed = storage.health <= 0
				}}
			else
				res = {};
			end
		end
	end
	--But if you are a MONSTER Then.
	--Damage overriden always. you can still respond if damaged however.
	if self.vsoSpawnMonster then
		if damageRequest.damage > 0 then
			healthLost = math.min( storage.health, damageRequest.damage );
			storage.health = storage.health - healthLost;
		end
		res = {{	--squishy? adjust targetMaterialKind
			sourceEntityId = damageRequest.sourceEntityId,
			targetEntityId = entity.id(),
			position = mcontroller.position(),
			damageDealt = damageRequest.damage,
			healthLost = healthLost,
			hitType = "Hit",
			damageSourceKind = damageRequest.damageSourceKind,
			targetMaterialKind = usematerial,
			killed = storage.health <= 0
		}}
	end
	storage.health = storage.health - healthLost;
	return res;--return vso.applyDamage( self, damageRequest )
end

function _acquireConfig( path, defval )
	return config.getParameter( path, defval );
end

function vsoMakeChoiceDialog( data )

	--Hack to force a JSON object
	local default_choicedlg = sb.jsonMerge( {}, {
		config = "/interface/scripted/vsochoice/vsochoiceempty.config"
		,gui = {
			panefeature = {
				type = "panefeature"
			}
			,background = {
				type = "background",
				fileHeader = "/interface/confirmation/header.png",
				fileBody = "/interface/confirmation/body.png",
				fileFooter = "/interface/confirmation/footer.png"
			}
			,bgShine = {
				type = "image",
				file = "/interface/confirmation/shine.png",
				position = {0, 20},
				zlevel = -1
			}
			,windowtitle = {
				type = "title",
				position = {0, 254},
				title = "",
				subtitle = "",
				icon = {
					type = "image",
					file = "",
					position = {0, 0},
					zlevel = -1
				}
			}
			,close = {
				callback = "buttonClickEvent",
				type = "button",
				base = "/interface/x.png",
				hover = "/interface/xhover.png",
				pressed = "/interface/xpress.png",
				pressedOffset = {0, 0},
				position = {220, 132},
				caption = ""
			}
			,message = {
				type = "label",
				position = {60, 119},
				hAnchor = "left",
				vAnchor = "top",
				wrapWidth = 173,
				lineSpacing = 1.0,
				color = "white",
				value = ""
			}
			,portrait = {
				type = "image",
				file = "",
				position = {30, 90},
				scale = 1.5,
				centered = true
			}
			,name = {
				type = "label",
				position = {27, 52},
				hAnchor = "mid",
				vAnchor = "bottom",
				wrapWidth = 50,
				color = "white"
			}
		}
		,scriptWidgetCallbacks = { "buttonClickEvent" }
		,scripts = {"/interface/scripted/vsochoice/vsochoice.lua"}
		,scriptDelta = 5
	} )
	
	--How to shape the damn thing... add buttons and whatnot...
	--Generate gui shape and buttons (text dependant? maybe?)
	
	if data.title then
		default_choicedlg.gui.windowtitle.title = data.title;
	end
	
	if data.subtitle then
		default_choicedlg.gui.windowtitle.subtitle = data.subtitle;
	end
	
	if data.message then
		default_choicedlg.gui.message.value = data.message;
	end
	
	if data.options then
	
		--Need to get counts? Use vertical buttons? Hm...
		--some options are long (rather than short quips?)
		
		--this is static constant. Problem is, button sizes VARY so... factor that in? Hm.
		local buttonnamemapping = {
			default = { "/interface/quests/newquest/acceptUp.png", "/interface/quests/newquest/acceptOver.png", 70, 16 }
			,decline = { "/interface/quests/newquest/declineUp.png", "/interface/quests/newquest/declineOver.png", 70, 16 }
		}
		
		--Parameters set by button grid
		local xzero  = 17;
		local yzero = 38;
		local xmax = 173;
		local xsize = 70;
		local ysize = 16;
		
		local xcurrent = xzero;
		local ycurrent = yzero;
		
		local butcount = 0;
		for k,v in pairs( data.options ) do
		
			local btype = "default";
			if buttonnamemapping[ v.button ] ~= nil then
				btype = v.button
			elseif v.button ~= nil then
				--add CUSTOM buton type? [ defaultimage, overimage, width, height ] ?
			end
			
			--Factor in grid size with btype???
			
			local bname = "";
			
			--v.button
			local bdata = {
				callback = "buttonClickEvent",
				type = "button",
				base = buttonnamemapping[btype][1],
				hover =  buttonnamemapping[btype][2],
				position = {xcurrent, ycurrent},
				value = "",
				caption = ""
			}
			xcurrent = xcurrent + xsize;
			if xcurrent > xmax then
				xcurrent = xzero;
				ycurrent = ycurrent - ysize;
			end
			
			if v.value then
				bdata.value = v.value;
				bname = v.value;
			else
				bname = "button_"..tostring( butcount );
				bdata.value = bname
			end
			
			
			if v.caption then
				bdata.caption = v.caption;
			else
				bdata.caption = bname
			end
			
			default_choicedlg.gui[ bname ] = bdata
			
			butcount =  butcount+1;
		end
	end
	
	--If you need to debug it, change it here:
	--sb.logInfo( sb.printJson( default_choicedlg, 1 ) )

	return default_choicedlg

end

--Maps ASCII ord -> to width in DISPLAY pixels, which you can use for the gui conversion maybe...
--gui is 2x the pixels of the DISPLAY coordinates.
--Also, the space BETWEEN each letter is 2 pixels.
vsoCharSizeMap = { 
	3,3,3,3, 3,3,3,3, 3,12,0,3, 3,0,3,3, --0		""	9 == tab, 10 == new line, 13 == carriage return
	3,3,3,3, 3,3,3,3, 3,3,3,3, 3,3,3,3,  --16	""
	3,2,6,10, 8,10,10,2, 4,4,6,6, 4,6,2,10, --32	" !"# $%&' ()*+ ,-./"
	8,4,8,8, 8,8,8,8, 8,8,2,2, 6,6,6,8, --48	"0123 4567 89:; <=>?"
	10,8,9,6, 8,6,6,8, 8,6,8,8, 6,10,8,8, --64 	"@ABCDEFGHIJKLMNO"
	8,8,8,8, 6,8,8,10, 8,8,6,4, 10,4,6,8, --80	"PQRSTUVWXYZ[ \]^_"
	4,8,8,7, 8,8,6,8, 8,2,4,7, 2,10,8,8, --96 	"`abc defg hijk lmno"
	8,8,6,8, 6,8,8,10, 6,8,8,6, 2,6,8,3, --112	"pqrs tuvw xyz{ |}~ "
	3
}

function stripStarboundFormatTags( S )

	if S ~= nil then
		--ok
	else
		return S;
	end
	
	--[[
	
	--SPECIAL CASES for starbound formatting strings:
	--Lua formats as %% in lua.
	--\n becomes 10 from json
	--But this crap: ^green; becomes NO SPACE AT ALL due to starbound formatting rules.
	--we dont know how to get a ^ character. Assume it's ^^?
	if cc == 94 then
		--find the ; within some range?
		--if the NEXT CHARACTER is a ^, then it becomes ^^ and nothing is a problem.
		--^#6f6f6f;
		--^green ^cyan ^white yellow blue lightgray 
		--^shadow,cyan
		--More complicated that I would like 
		--^#6f6f6f;$ status ^cyan;>
		--"^#6f6f6f;$ status -f ^cyan;
		--^#15ce02;
		--List of things found:
		--	^-^		Allowed, ignored?
		--	^reset;
		--		Any of color names 
		--	orange yellow green blue indigo violet black white magenta darkmagenta cyan clear darkcyan cornflowerblue gray lightgray darkgray darkgreen pink
		--	^#FFFFFF;	Hexadecimal color. 
		
	end
	--224 2 Heh! ^green;mmm^white;. Longer strings in buttons.

	--Hey this is handy. Neat. Will it... do anything else?
	sb.replaceTags( string, tagmap )
		from player.config:
			"^cyan;> Name: ^white;<name>\n^cyan;> Job:^white; <role>\n^cyan;> Rank:^white; <rank>\n^cyan;> Status:^white; <status>"
			
		  description = sb.replaceTags(description, {
			  name = self.name or "Cannon Fodder",
			  role = self.role.name or "Soldier",
			  rank = self.rank or "Ensign",
			  status = self.statusText or "Slacking off"
			})
	]]--
	
	--the MAXIMUM LENGTH seen is ^cornflowerblue; so, check the 16 byte substring for the ^..; length
	local matchablecommands = {
		orange=1
		,yellow=1 
		,green=1
		,blue=1
		,indigo=1 
		,violet =1
		,black =1
		,white =1
		,magenta =1
		,darkmagenta =1
		,cyan =1
		,clear =1
		,darkcyan=1 
		,cornflowerblue =1
		,gray =1
		,lightgray =1
		,darkgray =1
		,darkgreen =1
		,pink=1
		,reset=1
	}
	
	local slen = string.len(S)
	if slen > 0 then
		local R = "";
		local si = 1;
		while si <= slen do
			local cc = string.byte(S, si);
			if cc == 94 then
				
				local matched = false;
				local si2 = si + 1;
				if si2 < slen then
					local checks = string.sub( S, si2, si2+15 );
					
					--checks MUST MATCH something (or start as a #)
					local hassemi = string.find( checks, ";" );
					
					if hassemi ~= nil then
						local semiindex = hassemi;	--[1];	--lua issue. string.find does NOT return a pair in this case.
						--we know a list of POSSIBLE codes  this is allowed to be:
						local commandcode = string.sub( checks, 1, semiindex-1 );
						
						--sb.logInfo( "Found checks "..tostring( si ).." "..checks.." "..tostring( hassemi ).." "..commandcode )
					
						--DOES IT MATCH something we know
						if matchablecommands[ commandcode ] ~= nil then
							--valid
							matched = true;
							si = si + semiindex;
						elseif string.sub( commandcode, 1, 1 ) == "#" then
							--assume it's OK if length <=9
							if string.len( commandcode ) <= 9 then
								--valid
								matched = true;
								si = si + semiindex;
							end
						end
					end
				end
				if matched then
					--good.
				else
					R = R..string.sub( S, si, si );	--extract ONE character.
				end
			else
				R = R..string.sub( S, si, si );	--extract ONE character.
			end
			si = si + 1;
		end
		
		--sb.logInfo( "Removing: " );
		--sb.logInfo( S );
		--sb.logInfo( R );
		--[23:29:50.530] [Info] Removing: 
		--[23:29:50.530] [Info] Heh! 2^^2 ^green;mmm^white;. Longer ^#FF00FF;s^#FFFF00;tri^reset;ngs in buttons.
		--[23:29:50.530] [Info] Heh! 2^^2 mmm. Longer strings in buttons.
			
		return R;
	end
	return S;
end

function estimateTextWrap( S, pixels )

	--REad through chracter, find "word pixel size"
	--determine if we need to wrap the line (or cut, in case you have a word that is TOO LONG)
	--split along space.
	--for each word, get length into	array... Hm.
	--
	
	if S ~= nil then
		--ok
	else
		return 0;
	end
	
	S = stripStarboundFormatTags( S );
	
	local nlines = 0;
	
	local slen = string.len(S)
	if slen > 0 then
		nlines = 1;
		local si = 1;
		local lastwordlen = 0;
		local lastlinelen = 0;
		while si <= slen do
			local cc = string.byte(S, si)
			
			local wordend = false;
			local mustline = false;
			local deltalen = 2;
			if cc < #vsoCharSizeMap then
				if cc == 10 then
					mustline = true; deltalen = 0;	--MUST create a new line. Period.
				elseif cc == 32 or cc == 9 then
					wordend = true; --We have ENDED the current word. (tab or space)
					deltalen = deltalen + vsoCharSizeMap[ 32 ];	--Counts as space.
				else
					deltalen = deltalen + vsoCharSizeMap[ cc ];
				end
			else
				deltalen = deltalen + 3;
			end
			
			lastlinelen = lastlinelen + deltalen;
			lastwordlen = lastwordlen + deltalen;
			
			local nextguilen = ( lastlinelen )/2.0;
			if nextguilen > pixels or mustline then
				--MUST wrap a line here.
				--However, we have to check our word length. if our WORD is small enough to NOT split, we push it to the NEXT line.
				
				if mustline then
					lastlinelen = 0;
					lastwordlen = 0;
					wordend = true;
				else
				
					if (lastwordlen)/2.0 > pixels then
					
						lastlinelen = 0;
						wordend = true;
					else
					
						lastlinelen = lastwordlen;
						wordend = true;
					end
				end
				
				nlines = nlines + 1;	
			end
			
			if wordend then
				lastwordlen = 0;
			end
			
			si = si + 1;
		end
	end
	return nlines;
end


function vsoMakeChoiceListDialog( data )

	local default_choicedlg = root.assetJson( "/interface/scripted/vsochoicelist/vsochoicelistdefault.config" );
	
	--The short answer:
	--	There IS no dynamic gui.
	--So, we have to rebuild the damn thing each time.
	--Ugh. THERE ARE radio button lists which we will use.
	--But estimating text size... what a pain in the neck!
	--	Hmph. Just have to make a list. Hm. How to stretch out a gui item???
	--
	--Turns out you CANT have a dynamic gui.
	--But you CAN change the background image out, with a image that would "enclose" the dialog you want...
	--Hm. So how to estimate text wrapping?
	--
	--So we gotta create HOW many headers/footers to have a dynamic width gui?
	--Huh. Option sizes are a thing I guess.
	--
	--Well, division by 16 is fair.
	--Just for LESS resources, 
		
	--Returned value is ALWAYS greater or equal to v, but quantized.
	function floorenclose( v, d )
		ivalue = d*math.floor( v/d )
		if ivalue == v then
			return ivalue
		end
		return ivalue + d
	end
	
	local inwidth = 128
	local inheight = 64
	
	--	
	--local dwidth = 32 * 6;		--DESIRED width and height... Hm.
	--local dheight = 32 * 4;
	--Compute message size, then option sizes (bah!)
	
	local usemessage = data.message;
	if usemessage ~= nil then else usemessage = "" end
	local nlines = 0;
	
	-- we just want 3 lines displayed in general... (hax)
	if data.fixedWidth ~= nil then
		inwidth = floorenclose( data.fixedWidth, 32 );
		nlines = estimateTextWrap( usemessage, inwidth );
	else
		local linewrapsize = floorenclose( inwidth, 32 );
		nlines = estimateTextWrap( usemessage, linewrapsize );
		while nlines >= 5 do
			inwidth = inwidth + 32;	--add some more! Up to a MAXIMUM:
			if inwidth >= 320 then
				inwidth = 320;
				break;
			else
				linewrapsize = floorenclose( inwidth, 32 );
				nlines = estimateTextWrap( usemessage, linewrapsize );
			end
		end
	end
	
	--Okay we have the Width for the MESSAGE
	--But what about the responses? Hmmmm...
	--Force them to same width options? Huh.
	
	
	local dwidth = floorenclose( inwidth, 32 );
	local dybottompadding = 20;
	local dytoppadding = 26;
	local dxleftpadding = 4;
	local dxrightpadding = 14;
	local dbuttonsize = 22;	--button image is about this big... Hm.
	local dtextheight = 10;	--DEFAULT TEXT SIZE is 8 pixels (16 gui pixels) and I've seen 12 as an alternate. Multiply your inputs to scale text results... 8/12*linewidth.
	
	--Estimate wrapping... 
	local cmessageheight = 0;
	if usemessage ~= nil then
		cmessageheight = nlines * dtextheight + 4
	end
	
	local dheight = cmessageheight;--floorenclose( cmessageheight, 32 );
	
	--sb.logInfo( tostring( nlines ).." "..tostring( cmessageheight ).." "..tostring( dwidth ).." "..usemessage )
	
	--Build button list (template???)
	local stackbegin = 0;
	local stackheight = 0;
	--local buttonlist = {};
	--local stacklist = {};
	local childrenset = {};
	if data.options then
		
		--local buttonwrapwidth = dwidth;	--Hm missing padding
		
		--get total size
		local textlineoffset = 2;
		local textlinesize = dtextheight;	--not 8 apparently.
		local buttonsizes = {}
		local dtotalbuttonsize = 0;
		for k,v in pairs( data.options ) do
			
			local nbuttonlines = 0;
			
			if v.icon ~= nil then
				nbuttonlines = estimateTextWrap( v.caption, dwidth - 22 );
			else
				nbuttonlines = estimateTextWrap( v.caption, dwidth - 2 );	--At text size 8, it's 16 gui pixels per line? odd.
			end
			if nbuttonlines < 1 then nbuttonlines = 1; end 	--missing text? Hm...
			
			if v.icon ~= nil then
				dtotalbuttonsize = dtotalbuttonsize + 14;	--button WITH icon size
			else
				dtotalbuttonsize = dtotalbuttonsize + 8;	--button with NO icon size
			end
			dtotalbuttonsize = dtotalbuttonsize + textlinesize * nbuttonlines;
			
			table.insert( buttonsizes, nbuttonlines );
		end
		dheight = floorenclose( cmessageheight + dtotalbuttonsize, 32 );
		
		--Okay, it'd be more aesthetic if we EVENLY divided the buttons, OR worked our way UP.
	
		--Create buttons as needed.
		stackheight = dtotalbuttonsize;
		dtotalbuttonsize = dtotalbuttonsize + dybottompadding;	--Hmmm
		butcount = 0;
		for k,v in pairs( data.options ) do
			butcount = butcount + 1;
			--v.button
			--v.value
			--v.caption
			
			--TYPE of button:
			--	Plain text button
			--	Button with ICON on left (hm)
			--	?
			--
			local nbuttonlines = buttonsizes[ butcount ]
			
			if v.icon ~= nil then
				dtotalbuttonsize = dtotalbuttonsize - 14;	--button WITH icon size
			else
				dtotalbuttonsize = dtotalbuttonsize - 8;	--button with NO icon size
			end
			dtotalbuttonsize = dtotalbuttonsize - textlinesize * nbuttonlines;
			
			--If we use a "layout"
			
			local nbuttonstring = "";
			if nbuttonlines > 1 then
				if nbuttonlines > 7 then
					nbuttonlines = 8;
				end
				nbuttonstring = "_"..tostring( nbuttonlines );
			end
			
			local usecaption = v.caption;
			if usecaption ~= nil then
			
			else
				usecaption = "";
			end
			
			local usevalue = butcount;
			if v.value ~= nil then
				usevalue = v.value
			end
			
			--sb.logInfo( tostring(dwidth).." "..tostring( nbuttonlines ) .. " " .. v.caption );
			
			local adjustedbuttonwrapwidth = dwidth - 2
			if v.icon ~= nil then
				adjustedbuttonwrapwidth = dwidth - 20 - 2;
			end
			
			local imagedirectives = "";
			if v.imagecolor ~= nil then
				if string.len( imagedirectives ) < 1 then
					imagedirectives = "?";
				end
				--multiply=ffffff00=0.85;
				
				--Process image color to ADD alpha.
				local muldir = v.imagecolor
				if string.len( muldir ) == 6 then
					muldir = muldir.."FF"
				end
				
				--imagedirectives = imagedirectives.."replace="..v.imagecolor..";";
				imagedirectives = imagedirectives.."multiply="..muldir..";";
			end
			
			local baseposition = {4, dtotalbuttonsize };
			local stackdata = {
				label={
					type="label"
					,position = { baseposition[1] + 4 + dxleftpadding, baseposition[2]+textlineoffset+textlinesize*nbuttonlines }
					,textAlign = "left"
					,wrapWidth = adjustedbuttonwrapwidth
					,hAnchor = "left"
					,vAnchor = "top"
					,zlevel = 4
					,value = usecaption
				}
				,button = {
					type="button"
					,callback = "buttonClickEvent"
					,base="/interface/scripted/vsochoicelist/gen/gen_item_"..tostring(dwidth)..nbuttonstring..".png"..imagedirectives
					,hover="/interface/scripted/vsochoicelist/gen/gen_itemover_"..tostring(dwidth)..nbuttonstring..".png"..imagedirectives
					,position= baseposition
					,caption= ""
					,pressedOffset={0,0}
					,data = usevalue
					,hAnchor = "left"
					,vAnchor = "top"
					,zlevel = 5
				}
			}
			if v.icon ~= nil then
				stackdata.image = {
					type="image"
					,position = { baseposition[1] + 4+8, baseposition[2]+textlineoffset+textlinesize*nbuttonlines }
					,maxSize = {16,16}
					,centered = true
					,file= v.icon
					,hAnchor = "left"
					,vAnchor = "top"
					,zlevel = 6
				}
				stackdata.label.position = { baseposition[1] + 4 + dxleftpadding + 20, baseposition[2]+5+textlineoffset+textlinesize*nbuttonlines }
			end
			
			if v.color ~= nil then
				--stackdata.label.fontColor = v.color
				stackdata.label.color = v.color
			end
			
			--if v.fontsize ~= nil then
			--	stackdata.label.fontSize = v.fontsize;
			--end
			
			--stackdata.label.fontSize = 8;	--DEFAULT font size.
			
			--Adjust button images.
			if v.icon ~= nil then
				--
				stackdata.button.base = "/interface/scripted/vsochoicelist/gen/gen_itemicon_"..tostring(dwidth)..nbuttonstring..".png"..imagedirectives
				stackdata.button.hover = "/interface/scripted/vsochoicelist/gen/gen_itemiconover_"..tostring(dwidth)..nbuttonstring..".png"..imagedirectives
			end
			
			for stak_k,stak_v in pairs( stackdata ) do
				childrenset[ "btn_"..tostring(butcount).."_"..stak_k ] = stak_v
			end
			
			--table.insert( stacklist, stackdata );
			
			--table.insert( buttonlist, buttondata)
		end
		stackbegin = dtotalbuttonsize;
		
	else
	
		--With NO DIALOG options, it's just a vsoSay??? Hm.
	end
	
	dheight = floorenclose( dheight, 32 );
		
	default_choicedlg = sb.jsonMerge( default_choicedlg, { gui = {
		background = {
			fileBody = "/interface/scripted/vsochoicelist/gen/gen_body_"..tostring(dwidth).."_"..tostring(dheight)..".png"
			,fileHeader = "/interface/scripted/vsochoicelist/gen/gen_header_"..tostring(dwidth)..".png"
			,fileFooter = "/interface/scripted/vsochoicelist/gen/gen_footer_"..tostring(dwidth)..".png"
		}
		,windowtitle = {
			--type="title"
			--,title = ""
			--position = { dxpadding, dheight - 15 - 15 - dypadding }
			--,icon={
				--position = { dxpadding, dheight - 15 - dypadding }
			--}
		}
		,close={
			position = { dwidth - 4, dheight + dybottompadding }	--clsoe button size
		}
		--,collectionButtons = {
		--	buttons = buttonlist
		--}
		,optionsLayout = {
			--rect = { 0, stackbegin+stackheight, dwidth, stackbegin }
			rect = { 0, 0, dwidth+dxleftpadding+dxrightpadding, dheight }	--UH WHY???
			,children = childrenset
		}
	}
	} )
	
	if data.title then default_choicedlg.gui.windowtitle.title = data.title; end
	
	--
	if data.message then default_choicedlg.gui.message.value = data.message; end
	default_choicedlg.gui.message.wrapWidth = dwidth	--Strange...
	default_choicedlg.gui.message.position = { dxleftpadding, dheight + dybottompadding - dtextheight }
	
	--default_choicedlg.gui.windowtitle.position
	
	--[[
	
	--Remapping DIRECT gui assets
	--if data.title then default_choicedlg.gui.windowtitle.title = data.title; end
	if data.title then default_choicedlg.gui.windowtitle.value = data.value; end
	--if data.subtitle then default_choicedlg.gui.windowtitle.subtitle = data.subtitle; end
	if data.message then default_choicedlg.gui.message.value = data.message; end
	
	if data.options then
		
		--uhhhh how to SET the itemList ???
		local txo = {};
		
		local butcount = 0;
		for k,v in pairs( data.options ) do
			table.insert( txo, v );
			--v.button
			--v.value
			--v.caption
		end
		
		default_choicedlg = sb.jsonMerge( default_choicedlg, { textOptionList = txo } )
		--default_choicedlg.textOptionList = txo;
		
	end
	
	]]--
	
	return default_choicedlg
end

-------------------------------------------------------------------------------
function onInteraction( args )	--Iteracted with
	
	if self.useAnimatorFirst then
		if self.A ~= nil then
			if self.A.cora == nil then
				self.A.cora = root.assetJson( "/interface/scripted/vsoanimator/vsoanimatorgui.config" )
				self.A.cora.vsoOwnerID = entity.id()
				self.A.cora.vsoInteractId = args["sourceId"];
			end
			return { "ScriptPane", self.A.cora }
		end
	else
		--return vso.interacted( self, args )
		local laststate = self.sv.laststate;
		if laststate ~= nil then
			local doit = self.sv.ss[ laststate ].interactfn
			if doit ~= nil then
				doit( args["sourceId"] )
			end
		end
		
		if (self.customInteractPanel ~= nil) or (self.customInteractPanelData ~= nil) then
		
			local interactdat = {};
			
			if self.customInteractPanel ~= nil then
				
				--Will CRASH if not defined...
				local panelconf = config.getParameter( self.customInteractPanel, nil );
				
				if panelconf ~= nil then
				
					if panelconf.config then
						interactdat = root.assetJson( panelconf.config )--"/interface/scripted/vsoanimator/vsoanimatorgui.config" )
					end
				
					interactdat = sb.jsonMerge( interactdat, panelconf )
				end
			end
			
			if self.customInteractPanelData ~= nil then
				interactdat = sb.jsonMerge( interactdat, self.customInteractPanelData )
			end
			
			if self.customInteractDataCallback ~= nil then
				self.customInteractDataCallback( interactdat );
			end
			
			interactdat.vsoOwnerID = entity.id()
			interactdat.vsoInteractId = args["sourceId"];
			
			self.customInteractPanel = nil;
			customInteractDataCallback = nil;
			
			--return { "ShowPopup", { title = "Activation Failed!", message = string.format("^red;Microformer failed to activate: %s.", "WAH"), sound = "/sfx/interface/nav_insufficient_fuel.ogg"} }
			
			return { "ScriptPane", interactdat }
		end
	end
	
end

-------------------------------------------------------------------------------
function onDialog( args )	--Interacted with
	local laststate = self.sv.laststate;
	if laststate ~= nil then
		local doit = self.sv.ss[ laststate ].dialogresponsefn
		if doit ~= nil then
			--args["response"] is usually a button name, so... hm.
			doit( args["response"], args["sourceId"] )
		end
	end
end

-------------------------------------------------------------------------------
function uninit( )	--Destroyed
	if onEnd ~= nil then onEnd() end
end

-------------------------------------------------------------------------------
function init()

	self.cfgAnimationFile = vsoNotnil( config.getParameter("animation"), "missing animation in config file" )	--Animation file to use
	self.cfgLounge = vsoNotnil( config.getParameter("loungePositions"), "missing loungePositions in config file" )--Dictionary of seats...
	self.cfgPhysics = vsoIfnil( config.getParameter("physicsCollisions"), {} )	--Do we have platforms or other things? This is required as is
	self.cfgVSO = vsoNotnil( config.getParameter("vso"), "missing vso in config file" )	--VSO settings
	self.directoryPath = vsoNotnil( config.getParameter("directoryPath"), "missing directoryPath in config file" );

	--Required for pathing stuff????
	--self.pathing = {}
	--self.pathing.stuckTimer = 0
	--self.pathing.maxStuckTime = 2

	--self.jumpCooldown = 0
	--self.jumpMaxCooldown = 1

	--self.movementParameters = mcontroller.baseParameters()
	--self.jumpHoldTime = self.movementParameters.airJumpProfile.jumpHoldTime
	--self.jumpSpeed = self.movementParameters.airJumpProfile.jumpSpeed
	--self.runSpeed = self.movementParameters.runSpeed

	--self.stuckPosition = mcontroller.position()
	--self.stuckCount = 0
	---
	  
	if self.cfgVSO ~= nil then
	
		if self.cfgVSO.vals ~= nil then
		
		else
			self.cfgVSO.vals = {};
		end
		
		if self.cfgVSO.sets ~= nil then
		
		else
			self.cfgVSO.sets = {};
		end
		
		if self.cfgVSO.histosets ~= nil then
		
		else
			self.cfgVSO.histosets = {};
		end
	
		if self.cfgVSO.movementSettings ~= nil then
			if self.cfgVSO.movementSettings.default == nil then
				haderrors = true; vsoError( "missing default movementSettings" )
			end
		else
			haderrors = true; vsoError( "missing movementSettings" )
		end
		
		if self.cfgAnimationFile ~= nil and self.cfgLounge ~= nil and self.cfgPhysics ~= nil then
		
			self.useAnimatorFirst = vsoIfnil( self.cfgVSO.useAnimatorFirst, 0 ) > 0;
			
			self.cfgVSO.damageTeamType = vsoIfnil( self.cfgVSO.damageTeamType, "passive" );
			
			self.maxHealth = vsoIfnil( config.getParameter("maxHealth"), 100 );
			
			self.vsoInitialDirection = vsoIfnil( config.getParameter("initialFacing"), 1 );
			self.vsoCurrentDirection = 1;
			
			self.vsoMouthPosition = vsoIfnil( config.getParameter("mouthPosition"), {0.0,0.0} );	--IMPORTANT!!!
			self.mouthPosition = self.vsoMouthPosition;	--Hey you can play with this.
	
			self.vsoForcedToDie = false;
			self.vsoSpawnOwner = nil;
			self.vsoSpawnCenter = mcontroller.position();
			self.vsoSpawnOwnerState = nil;
			self.vsoSpawnOwnerStateDefault = vsoIfnil( config.getParameter("spawnOwnerState"), "off" );
			self.vsoSpawnMonster = false;
			
			self.vsoPhysList = vsoIfnil( config.getParameter("physicsCollisions"), {} );
	
			--THIS MAY NOT BE ACCURATE so pay attention to it!!
			--Wow, this CHANGES ORDER randomly... careful... man. Maybe these keys need to be in some other order?
			--We are ASSUMING alphabetical / sorted keys order
			self.vsoLoungeNameToIndex = {};	--Hm.. Unsure what the "seat index" really is. Damn.
			self.vsoLoungeIndexMax = 0;
			
			function pairsByKeys (t, f)
			  local a = {}
			  for n in pairs(t) do table.insert(a, n) end
			  table.sort(a, f)
			  local i = 0      -- iterator variable
			  local iter = function ()   -- iterator function
				i = i + 1
				if a[i] == nil then return nil
				else return a[i], t[a[i]]
				end
			  end
			  return iter
			end
			
			for k, v in pairsByKeys( self.cfgLounge ) do
				self.vsoLoungeNameToIndex[ k ] = self.vsoLoungeIndexMax;
				
				--mcontroller.setAnchorState( seatcount, true );	--NEW
				--sb.logInfo( "TRUE SEAT MAP : "..k.." = "..tostring( self.vsoLoungeIndexMax ) );
				self.vsoLoungeIndexMax = self.vsoLoungeIndexMax + 1;
			end
			
			--[00:41:29.715] [Info] TRUE SEAT MAP : drivingSeat = 0
			--[00:41:29.715] [Info] TRUE SEAT MAP : bellyrubSeat = 1

			--for k,v in pairs( self.cfgLounge ) do
			--	self.vsoLoungeNameToIndex[ k ] = self.vsoLoungeIndexMax;
				
			--	--mcontroller.setAnchorState( seatcount, true );	--NEW
			--	sb.logInfo( "TRUE SEAT MAP : "..k.." = "..tostring( self.vsoLoungeIndexMax ) );
			--	self.vsoLoungeIndexMax = self.vsoLoungeIndexMax + 1;
			--end
				
			--Apply loaded parameters to starbound universe:
			
			storage.health = self.maxHealth;	--we DO have health.
			
			--SOME PARAMETERS MUST EXIST? Ugh.
			--[[
			"movementSettings" : {
				"collisionPoly" : [ [-1.0, 2.49], [-1.0, -2.49], [1.0, -2.49], [1.0, 2.49] ]
				,"mass" : 1
				
				,"gravityMultiplier" : 1.0
				,"liquidBuoyancy" : 0.0
				,"airBuoyancy" : 0.0
				,"bounceFactor" : 0.0
				,"stopOnFirstBounce" : false
				,"enableSurfaceSlopeCorrection" : false
				,"slopeSlidingFactor" : 0.0
				,"maxMovementPerStep" : 0.8
				,"maximumCorrection" : 3
				,"discontinuityThreshold" : 10

				,"stickyCollision" : false
				,"stickyForce" : 0.0

				,"airFriction" : 1.0
				,"liquidFriction" : 4.0
				,"groundFriction" : 8.0

				,"speedLimit" : 400
				,"collisionEnabled" : true
				,"frictionEnabled" : true
				,"gravityEnabled" : true

				,"ignorePlatformCollision" : false
				,"maximumPlatformCorrection" : 0.02
				,"maximumPlatformCorrectionVelocityFactor" : 0.03
				
				,"airJumpProfile" : {
					"jumpSpeed" : 15.0
					,"jumpControlForce" : 900.0
					,"jumpInitialPercentage" : 1.0
					,"jumpHoldTime" : 0.0

					,"multiJump" : false
					,"reJumpDelay" : 0.05
					,"autoJump" : false
					,"collisionCancelled" : true
				},
			},
			
			self.controlParameters.airFriction = 0
			self.controlParameters.liquidFriction = 0
			self.controlParameters.liquidImpedance = 0
			self.controlParameters.groundFriction = 0
			self.controlParameters = copy(self.options.movementParameters)

			]]--
			
			--REQUIRED:
			--"groundFriction" : 40.0,
			--"ignorePlatformCollision" : true,
			--"groundForce" : 400
			--if true then
			--	local deets = self.cfgVSO.movementSettings.default;
			--	if deets.groundFriction == nil then deets.groundFriction = 40.0; end
			--	if deets.ignorePlatformCollision == nil then deets.ignorePlatformCollision = false; end
			--	if deets.groundForce == nil then deets.groundForce = 400.0; end
			--	sb.logInfo( );
			--end
			
			self.motionControls = {};
			self.motionControls.x = 0;
			self.motionControls.y = 0;
			self.motionControls.jump = 0;
			self.motionControls.dropDown = 0;
		
			--sb.logInfo( "has air jump: ".. tostring( self.cfgVSO.movementSettings.default.airJumpSpeed ) );
			
			mcontroller.resetParameters();-- self.cfgVSO.movementSettings.default ) --Apply movement controller settings
			mcontroller.applyParameters( self.cfgVSO.movementSettings.default );
			
			--sb.logInfo( "STILL has air jump: ".. tostring( mcontroller.parameters().airJumpSpeed ) );
			
			vsoFacePoint( mcontroller.position()[1] + 10*self.vsoInitialDirection );	--hack, should work
			
			vehicle.setInteractive( true );	--Always interactive? Hm.
			vehicle.setPersistent( false );	--Not tracked once level is left?
			vehicle.setDamageTeam( { type = self.cfgVSO.damageTeamType } );	--Not sure. If I'm passive, anyone can damage me?
			
			for k,v in pairs( self.cfgLounge ) do
				--Dynamically, lounge seats can CHANGE as per instructions. 
				--Victim animation can be played on any of them, which should include status effects.
				--Abuse victim animation for changing lounge conditions? hmmmm no.
				vehicle.setLoungeEnabled( k, true );
				vehicle.setLoungeStatusEffects( k, {} );	
				vehicle.setLoungeEmote( k, nil )
				vehicle.setLoungeDance( k, nil )
				vehicle.setLoungeOrientation( k, "stand" )
			end
			
			message.setHandler("store",	--Some vehicles can be stored, so dont let this happen
				function(_, _, ownerKey)
					return { storable = false, healthFactor = 1.0 }
				end)
				
			--Special message stack setup:
			message.setHandler("vsoCreatedFrom", vsoMsgHdlCreatedFrom )
			message.setHandler("vsoCreatedMonster",	vsoMsgHdlCreatedMonster )
			message.setHandler("vsoComeHome", vsoMsgHdlComeHome )
			message.setHandler("vsoGetVictimSeatIndex", vsoMsgHdlSeatIndexGet )

			message.setHandler("vsoGet", vsoMsgHdlGet )
			
			message.setHandler("vsoPlayerInteracted", vsoMsgHdlPlayerInteracted )
			message.setHandler("vsoNPCInteracted", vsoMsgHdlNPCInteracted )
			message.setHandler("vsoDlgInteracted", vsoMsgDlgInteracted )
			
			message.setHandler("vsoStorageLoadData", vsoMsgHdlStorageLoadData );

			--I STILL DONT KNOW WHAT THIS IS FOR (npctoy.lua ?)
			message.setHandler("notify", function (_, _, notification)
				return notify( notification )	--The heck does this DO
			end)
			
			local animdata = root.assetJson( self.directoryPath .. self.cfgAnimationFile )
			
			--Determine mapping from lounge <-> transform
			self.vsoLoungeToTransform = {}	--Useful.
			self.vsoLoungeToPart = {}	--Useful.
			
			for k,v in pairs( self.cfgLounge ) do
				local tfgroupname = v.partAnchor
				if tfgroupname ~= nil then
					self.vsoLoungeToTransform[ k ] = tfgroupname;
				else
					self.vsoLoungeToTransform[ k ] = nil;
				end
				
				local partname = v.part
				if partname ~= nil then
					self.vsoLoungeToPart[ k ] = partname;
				else
					self.vsoLoungeToPart[ k ] = nil;
				end
			end
			
			self.vsoTransformToLounges = {}	--Useful, but more difficult
			self.vsoAnimTransformGroups = {};
			for k,v in pairs( animdata.transformationGroups ) do
				self.vsoAnimTransformGroups[ k ] = {};
			end
			
			for k,v in pairs( animdata.animatedParts.parts ) do
			
				if v.properties ~= nil then
					if v.properties.transformationGroups ~= nil then
						for tgk,tgv in pairs( v.properties.transformationGroups ) do
							for lk,lvt in pairs( self.vsoLoungeToTransform ) do
								if lvt == tgv then
									if self.vsoTransformToLounges[ tgv ] == nil then
										self.vsoTransformToLounges[ tgv ] = {};
									end
									self.vsoTransformToLounges[ tgv ][ lk ] = tgk;
								end
							end
						end
					end
				end
			end
			
			--Ok, then
			--Get time & frame lengths of each state's animation (so we can track it our damn selves! aka testing for "end of animation" without animEnd crap)
			
			self.vsoAnimStateData = {};
			for k,v in pairs( animdata.animatedParts.stateTypes ) do
				local ellis = {};
				ellis.default = v.default
				for ks,vs in pairs( v.states ) do
					ellis[ ks ] = { frames = vsoIfnil(vs.frames, 1), cycle= vsoIfnil( vs.cycle, 1.0 ) };
					
					if vs.cycle == nil then
						vsoError( "animation cycle not defined, using 1.0: "..k.." "..ks );
					end
					if vs.mode ~= "end" then
						vsoError( "animation mode is not end: "..k.." "..ks.." "..vs.mode );
					end
					
					--mode should be something that just "stops" the animation at the end (so we can dt detect that it ended without making a billion anims)
				end
				self.vsoAnimStateData [ k ] = ellis;
			end
			
			--
			self.vsodt = dt;
			self.vsoclock = os.clock();
			self.vsoclock_start = self.vsoclock;
			
			--
			self.ats = {};	--anitag anitags
			
			--You should be able to CLONE states from tracking just this structure... but setup values arent the same.
			self.sv = {}
					
			--State supports
			self.sv.ss = {};
			self.sv.nextstate = nil;
			self.sv.laststate = nil;
			
			--Animation hacks
			self.sv.animspeed = 1.0;	animator.setAnimationRate( 1.0 );
			
			--Transform ANimations share victim animation stuff
			self.sv.ta = {}
			for k,v in pairs( self.vsoAnimTransformGroups ) do
				self.sv.ta[ k ] = {
					tt = vsoTT( 1.0 )
					,curr = nil
					,cycle = 1.0
					,visible = true
					,playing = false
					,x = 0
					,y = 0
					,xs = 1
					,ys = 1
					,r = 0
				}
			end
			
			--Victim animations (per seat)
			self.sv.va = {}
			for k,v in pairs( self.vsoLoungeToTransform ) do
				self.sv.va[ k ] = {
					tt = vsoTT( 1.0 )
					,curr = nil
					,cycle = 1.0
					,visible = true
					,playing = false
					,x = 0
					,y = 0
					,xs = 1
					,ys = 1
					,r = 0
					,emote = ""
					,dance = ""
					,sitpos = "stand"
					,statuslist = {}
				}
			end
			self.sv.vakeys = {}
			self.sv.vafkeys = {}
			for k,v in pairs( self.cfgVSO.victimAnimations ) do
			
				--CHECK animations first.
				if v.seconds ~= nil then
					if #v.seconds > 0 then
					
						self.sv.vakeys[ k ] = v.seconds[ #v.seconds ];
					else
						vsoError( "victimAnimations "..k.." must have seconds with at least one entry " )
					end
					
					if v.frames ~= nil then
						vsoInfo( "victimAnimations "..k.." can't use both frames and seconds; ignoring frames" ); 
					end
					
				elseif v.frames ~= nil then
					self.sv.vafkeys[ k ] = v.frames;
				else
					vsoError( "victimAnimations "..k.." must have seconds or frames defined in order " )
				end
			end
			
			--animation state (not the transform override states)
			self.sv.as = {};
			for k,v in pairs( self.vsoAnimStateData ) do
				self.sv.as[ k ] = { curr=nil, tt=vsoTT( 1.0 ) }
			end
			
			--timers
			self.sv.ts = {};
			self.sv.td = {};
			
			--counters
			self.sv.cs = {};
			
			--Tracking for targets
			self.sv.targets = {};
			
			--Keeping track of who I think I am eating (not related to targets! tied to lounge positions)
			self.sv.eaten = {};
			
			--Map Seat -> Map of entity id -> status?
			self.sv.vsoEatenEject = {};
			for k,v in pairs( self.vsoLoungeToTransform ) do
				self.sv.vsoEatenEject[k] = {};
			end
				
			if self.useAnimatorFirst then
			
			else
				if onBegin ~= nil then
					onBegin();	--USER CALLBACK
				end
			end
		end
	end
end

function vsoDelta()
	return self.vsodt;	--iiiiinteresting idea. emulating slowdown? nope...
end

function vsoDeltaFromStart()
	return self.vsoclock - self.vsoclock_start;	--iiiiinteresting idea. emulating slowdown? nope...
end

function vsoClock()
	return self.vsoclock;	--iiiiinteresting idea. emulating slowdown? nope...
end

function vsoGetRandomInputOverride( inputs, params, controls )

	if inputs.npcdelay == nil then inputs.npcdelay = params.minTime + (params.maxTime - params.minTime) * math.random(); end
	if inputs.overrides == nil then inputs.overrides = {} end
	
	inputs.npcdelay = inputs.npcdelay - params.dt;
	
	if inputs.npcdelay < 0 then
	
		for k,v in pairs( inputs.overrides ) do 
			inputs.overrides[k] = 0;
		end
	
		--Random input... for x seconds
		local useid = math.random( #controls )
		if useid >= #controls then
			--ignore
		else
			inputs.overrides[ controls[ useid + 1 ] ] = 1;
		end
		
		inputs.npcdelay = nil;
	end
	
	return inputs.overrides;
end

function vsoInputOverride( seatname, options )

	local v = self.sv.eaten[ seatname ]
	if v ~= nil then

		if v.input == nil then
			v.input = vsoInputCreate( seatname )
		end
				
		local over = vsoGetRandomInputOverride( v.input, { dt=self.vsodt, minTime=0.2, maxTime=1.0 }, {"L", "R", "U", "D"} );
		vsoInputUpdate( seatname, v.input, self.vsodt, over )
		return true
	end
	return false;
end
-----------------------------------------------------------------------

function update( dt )

	if self._storageLoadQueue ~= nil then
		_vsoStorageLoadData( self._storageLoadQueue[1] );
		self._storageLoadQueue = nil;
	elseif self._storageSaveQueue ~= nil then
		_vsoStorageSaveData( self._storageSaveQueue[1], self._storageSaveQueue[2] );
		self._storageSaveQueue = nil;
	end

	if self.useAnimatorFirst then
	
		if vsoAnimatorDr( dt ) then
			--We're still good.
		else
			self.useAnimatorFirst = false;
			if onBegin ~= nil then
				onBegin();	--USER CALLBACK
			end
			
		end
		
		return false;
	end
	
	if self.rpc_stack ~= nil then
		local nextstack = {};
		for rpcki, rpcv in pairs( self.rpc_stack ) do
			if rpcv[1]:finished() then
				rpcv[2]( rpcv[1]:result() );
				--rpcv[1] = nil
				--rpcv[2] = nil
			else
				table.insert( nextstack, rpcv );
			end
		end
		self.rpc_stack = nextstack;
	end
	
	self.vsodt = dt;
	self.vsoclock = os.clock();
	local mpos = mcontroller.position();	--current mcontroller.position
	
	--Forced to update all timers to keep in sync with REAL timers.
	for k,v in pairs( self.sv.as ) do	--Update all animation trackers
		vsoTTAdd( v.tt, dt*self.sv.animspeed );
	end
	for k,v in pairs( self.sv.ts ) do	--Update all timers
		vsoTTAdd( v, dt );
	end
	for k,v in pairs( self.sv.ta ) do	--Update all animations (expensive)
		vsoTransAnimUpdate( k, dt*self.sv.animspeed );
	end
	--for k,v in pairs( self.sv.va ) do	--Update all animations (expensive)
	--	vsoVictimAnimUpdate( k, dt*self.sv.animspeed );
	--end

	--Also forced to update those we have eaten (occassionally? hm.):
	local forcedtofree =  nil;
	for k,v in pairs( self.sv.eaten ) do
		--if v.success then
		if v.id ~= nil then
			if world.entityExists( v.id ) then	--#ERROR WARNING v.id cannot be nil and it IS when someone warps out or weird stuff happens.
			
				vehicle.setLoungeEnabled( k, true )
				--mcontroller.setAnchorState( self.vsoLoungeNameToIndex[ k ], true );
				
				vsoEatForce( v.id, self.vsoLoungeNameToIndex[ k ] )
					
				--Additionally, we need to UPDATE the input for this structure.
				if v.input == nil then
					v.input = vsoInputCreate( k )
				end
				
				v.input["Etap"] = 0;	--unsure about this...
				if vehicle.entityLoungingIn( k ) == v.id then
					v.noteaten = 0;--They are OK for now but. Nah.
				else
					--Need a FORCE SIT
					--Also this is a "input" if used "E" bu only by a player
					--Also, it seems that by using this, it always resets??? somehow the "lounging in" isnt there...
					v.input["Etap"] = 1;
					if v.noteaten ~= nil then
						v.noteaten = v.noteaten + 1;
					else
						v.noteaten = 1;
					end
					--sb.logInfo( "#VSOERROR("..tostring(entity.id())..") ".."#VSNOTE tapped E "..tostring( v.input["E"] ) )
				end
				
				if world.isNpc( v.id ) then
				
					local overf = nil
					if self.sv.laststate ~= nil then
						overf = self.sv.ss[ self.sv.laststate ].npcoverridefn
					end
					if overf ~= nil then--OPTIONAL NPC input forwarding function (for SPOV's) vsoNPCInputOverride();	--Hm...
						overf( k, v )
					else
						local over = vsoGetRandomInputOverride( v.input, { dt=dt, minTime=0.2, maxTime=1.0 }, {"L", "R", "U", "D"} );
						vsoInputUpdate( k, v.input, dt, over )
					end
				else
					vsoInputUpdate( k, v.input, dt )
				end
				
				
				
				if v.input.specialEscape == 1 then
					if self.vsoSpawnMonster then
						--Can't escape a monster? Hm...
					else
						if forcedtofree == nil  then
							forcedtofree = {}
						end
						table.insert( forcedtofree, k );
					end
				end
				
			else
				
				v.success = false;	--Problems! eaten thing died?
				v.id = nil;
				v.state = 0;
				v.input = nil;
			end
		else
			--v.id
			--v.input = nil;	--Not success.
			--Somehow, player escaped existence
			if forcedtofree == nil  then
				forcedtofree = {}
			end
			table.insert( forcedtofree, k );
		end
		--else
		--	v.input = nil;	--Not success.
		--end
	end
	
	--Gameplay things
	if forcedtofree ~= nil then
		for k,kv in pairs( forcedtofree ) do
			local v = self.sv.eaten[ kv ];
			
			vsoUneat( kv )
			
			local killtargets = {};
			for kt, ktv in pairs( self.sv.targets ) do
				if ktv.id == v.id then
					table.insert( killtargets, kt );
				end
			end
			for kt, ktv in pairs( killtargets ) do
				vsoClearTarget( ktv )
			end
			
			self.sv.eaten[ kv ] = nil;	--Hm..
		end
		self.specialEscapeCooldown = 0.2;
		if onForcedReset ~= nil then onForcedReset() end	
		--In monster land, this involves totaling the effects with a perfect escape.
		--So that involves remaining escape time * effects.
		--IE if you are taking damage over time, and you only had to wiggle for 2.3 more seconds to escape,
		--Then we apply the total damage over the BEST POSSIBLE escape time and apply it.
		--The forced reset is a fair penalty to being impatient about rescue (if your friends help, you'll take less damage!)
	end
	
	--Update eject seats.
	for k,v in pairs( self.sv.vsoEatenEject ) do
		local plist = {};
		for kti, vti in pairs( v ) do 
			--This entity must NOT be sitting in seat k
			if vehicle.entityLoungingIn( k ) == vti then
				vehicle.setLoungeEnabled( k, false )
				--mcontroller.setAnchorState( self.vsoLoungeNameToIndex[ k ], false );
				world.sendEntityMessage( vti, "vsoForceApply", 0, 0, 2, 2 );	--REMOVE velocity just in case?
				world.sendEntityMessage( vti, "applyStatusEffect", "vsoremoveforcesit", 0.1, entity.id() );
				table.insert( plist, vti );
			end
		end
		v = plist;
	end
	
	--Checking for continued existence
	self.vsoForcedToDie = self.vsoForcedToDie or self.sv == nil;	--Must have been created correctly
			
	self.vsoForcedToDie = self.vsoForcedToDie or (mpos[2] < 4)	--offWorld check (forced?)
	
	self.vsoForcedToDie = self.vsoForcedToDie or (storage.health <= 0);	--Invulnerble check
		
	if not self.vsoSpawnMonster then
		self.vsoForcedToDie = self.vsoForcedToDie or (self.vsoSpawnOwner == nil)	--Placed VSO requires a spawn owner check
	end
	
	--Special escape timer cooldown required. Usually 0.1 - 0.25 seconds is fine
	if self.specialEscapeCooldown ~= nil then
		self.specialEscapeCooldown = self.specialEscapeCooldown - dt;
		if self.specialEscapeCooldown < 0 then
			self.specialEscapeCooldown = nil;
		end
		
	elseif not self.vsoForcedToDie then
	
		--Rebroadcast a say message if it failed.
		
		if self.vsoTalkMonsterNext ~= nil then
			if self.vsoTalkMonster ~= nil then
				if world.entityExists( self.vsoTalkMonster ) then
					self.vsoTalkMonsterRpc = world.sendEntityMessage( self.vsoTalkMonster , "vsoSayUpdate", self.vsoTalkMonsterNext[1], entity.id(), self.vsoTalkMonsterNext[2] );
					self.vsoTalkMonsterRpcMsg = endmsg;
					self.vsoTalkMonsterNext = nil;
				else
					self.vsoTalkMonster = nil;
				end
			end
			
			if self.vsoTalkMonster == nil then
				local mouthPos = {0,0}
				local domsg = self.vsoTalkMonsterNext[1];
				if self.vsoTalkMonsterNext ~= nil then
					mouthPos = self.vsoTalkMonsterNext[2];
				end
				self.vsoTalkMonster = world.spawnMonster( "vsomessagemonster", mcontroller.position(), {
					agressive = false,
					level = 1,
					masterId = entity.id(),
					sayMessage = domsg,
					mouthPosition = mouthPos
				} )
				self.vsoTalkMonsterNext = nil;
			end
		end
		
		if self.vsoTalkMonsterRpc ~= nil then
			if self.vsoTalkMonsterRpc:finished() then
				local res = self.vsoTalkMonsterRpc:result()
				if res == true then
					self.vsoTalkMonsterRpc = nil;
				else
					vsoSay( self.vsoTalkMonsterRpcMsg );
				end
			end
		end
		
		if self.vsoForceDelayRequested ~= nil then
		
			self.vsoForceDelayRequested.active = self.vsoForceDelayRequested.active + dt;
			
			if self.vsoForceDelayRequested.active > 0.25 then	--Force Delay max timeout
				self.vsoForceDelayRequested = nil
			end
		end
	
		local laststate = self.sv.laststate;
		local checkstate = self.sv.nextstate;
		
		if checkstate ~= laststate then
				
			--call the end of that state
			local callend = self.sv.ss[ laststate ];
			if callend ~= nil then
				if callend.endfn ~= nil then
					callend.endfn();
				end
			end
			
			--anything that is going to take an update? Hmmm...
			--	PROBLEMS with concurrency
			if checkstate ~= self.sv.nextstate then
				vsoError( "#VSOERROR User changed states in a end function ("..laststate.."); this is not allowed" );
			end
			
			local prevstate = laststate
			self.sv.laststate = checkstate;
			laststate = checkstate;
			
			--call the begin of the next state
			local callbegin = self.sv.ss[ checkstate ];
			local has_begin_fn = false;
			if callbegin ~= nil then
				if callbegin.beginfn ~= nil then
					callbegin.beginfn();
					has_begin_fn = true;
				end
			end
			
			if checkstate ~= self.sv.nextstate then
				vsoError( "#VSOERROR User changed states in a begin function ("..checkstate.."); this is not allowed" );
			end
			
			if _ENV[ checkstate ] ~= nil then
				--ok
			else
				vsoError( "#VSOERROR User changed states from ("..laststate..") to nil; this is not going to work" );
			end
			
		end
		
		--Now call that state function! (it's in the environment)
		if laststate ~= nil then
			if _ENV[ laststate ] ~= nil then
				_ENV[ laststate ]();
			end
		end

		--Handle action state updates...
		if self.vsoAction ~= nil then
		
			self.debug = true;	--Hmmmm nice!
			
			--self.motionControls.dropDown = 0;	--Hm!
			
			--Hmmmmm mcontroller.boundBox() is being called BUT a vehicle does not HAVE that option...
			local ret, retval = self.vsoAction.type( dt , self.vsoAction );
			
			if self.motionControls.dropDown > 0 then
				--We should ignore platforms
				mcontroller.applyParameters( { ignorePlatformCollision = true } );
				
				--FAKE!!! Should turn this off after x TIME as well (works)
				if ( mcontroller.yPosition() < self.motionControls.dropDownLastY - 0.5 ) 
					or ( self.motionControls.dropDownLastT > 0.25 )
				then
					self.motionControls.dropDown = 0;
				else
					self.motionControls.dropDownLastT = self.motionControls.dropDownLastT + dt;
				end
				
			else
				self.motionControls.dropDownLastT = 0;
				self.motionControls.dropDownLastY = mcontroller.yPosition();
				mcontroller.applyParameters( { ignorePlatformCollision = false } );
			end
			
			
			--uh, both have: So.
			--"fake" control move? This is really difficult actually
			--	<- need "solid" controlled motion... how do?
			--mcontroller.approachXVelocity( 4 * direction, 5000 );
			--mcontroller.controlApproachXVelocity(float targetVelocity, float maxControlForce)
			
			--if mcontroller.isColliding() then	--Can do damage on too high of an accel
		  
			--local BackfireMomentum = {0, self.jumpVelocity * 0.5}
			
			--mcontroller.applyParameters(self.occupiedMovementSettings)
			--if groundDistance <= self.hoverTargetDistance then
			--  mcontroller.approachYVelocity((self.hoverTargetDistance - groundDistance) * self.hoverVelocityFactor, self.hoverControlForce)
			--end
			--mcontroller.addMomentum(BackfireMomentum)
			--mcontroller.approachXVelocity(-self.targetHorizontalVelocity, 120 )--self.horizontalControlForce)
			
			--mcontroller.setYVelocity(self.jumpVelocity)
			
			--if self.motionControls.x ~= 0 then
			if self.motionControls.xrunning == true then
				--mcontroller.translate( { dt * 8 * self.motionControls.x , 0 } )
				--mcontroller.setXVelocity( 8 * self.motionControls.x )
				mcontroller.approachXVelocity( 8.0 * self.motionControls.x, 400 )--self.horizontalControlForce)
				--sb.logInfo( "approach 8 "..tostring( 8.0 * self.motionControls.x ) );
			else
				--mcontroller.translate( { dt * 4 * self.motionControls.x , 0 } )
				mcontroller.approachXVelocity( 4.0 * self.motionControls.x, 400 )
				
				--sb.logInfo( "approach 4 "..tostring( 4.0 * self.motionControls.x ) );
			end
			--else
			--	mcontroller.approachXVelocity( 0, 120 )	--Hm. dafuq
			--end
			
			--UHHHHHHH
			--if self.motionControls.y ~= 0 then
			--end
			--mcontroller.approachYVelocity( 4.0 * self.motionControls.x, 400 )
				
			
			--if self.motionControls.y ~= 0 then
				--mcontroller.setXVelocity( 4 * self.motionControls.x )
			--end
			--self.motionControls.jump = 0;
			
			if ret == false then
				--OK
			elseif ret == true then
				self.vsoAction = nil;
				mcontroller.setXVelocity( 0 );	--Hmmm...
			else
				self.vsoAction = nil;
				mcontroller.setXVelocity( 0 );	--Hmmm...
			end
			
			--if ret == false then
				--sb.logInfo( "action "..tostring(self.vsoAction.type).." terminated " ) ;
				--self.vsoAction = nil;
			--end
			
			--util.debugText(self.action, {self.position[1], self.position[2]-2}, "blue")
			
		else
			--mcontroller.setXVelocity( 0 )	--Hm.
		end
		
	end
	
	--Hm
	for k,v in pairs( self.sv.va ) do	--Update all animations (expensive)
		vsoVictimAnimUpdate( k, dt*self.sv.animspeed );
	end
	
	--Update anitags ONLY if they are animating
	for ktag,kdata in pairs( self.ats ) do
		if kdata.times ~= nil then
			if kdata.values ~= nil  then
				
				if kdata.currenttime ~= nil then
					kdata.currenttime = kdata.currenttime + dt;
				else
					kdata.currenttime = dt
				end
			
				--find first index where time < time in array? Hm...
				--lower_bound( );
				--kdata.currenttime / kdata.currenttime
				
				local ti = 1;
				if kdata.lastindex ~= nil then
					ti = kdata.lastindex;	--LINEAR time only
				end
				local timax = #kdata.times;
				local valuelen = #kdata.values;
				while ti <= timax do
					if kdata.currenttime >= kdata.times[ ti ] then
						--
					else
						break;
					end
					ti = ti + 1;
				end
				
				--set current to that value
				if ti < 1 then ti = 1; end
				if ti > valuelen then ti = valuelen end;
				kdata.current = kdata.values[ ti ]
				kdata.lastindex = ti;
				
				--previous
				--lastindex
				
				--sb.logInfo( tostring( kdata.currenttime ).." "..tostring( kdata.times[ timax ] ).." "..tostring( timax ) );
				if kdata.currenttime >= kdata.times[ timax ] then
					
					--sb.logInfo( "time ended" );
						
					local ended = true;
					
					kdata.lastindex = 1;
					kdata.currenttime = 0;
					if kdata.loop ~= nil then
						kdata.loop = kdata.loop - 1;
						if kdata.loop > 0 then
							kdata.current = kdata.values[ 1 ]
							ended = false;
						else
							kdata.loop = nil;
						end
					end
					
					if ended then
					
						--sb.logInfo( "ended" );
								
						--Animation true end.
						if kdata.setend ~= nil then
						
							--sb.logInfo( "has setend" );
							
							if kdata.setend[ ktag ] ~= nil then
								kdata.current = kdata.setend[ ktag ]
							else
								kdata.current = kdata.values[ timax ]
							end
							
							--A BIT more complicated than we would like.
							for k2,v2 in pairs( kdata.setend ) do
								animator.setGlobalTag( k2, tostring( v2 ) )
								--sb.logInfo( "final "..tostring(  v2 ).." " ..k2.." "..tostring( kdata.current) );
							end
						else
						
							--sb.logInfo( "does not have setend" );
						end
						
						kdata.times = nil
						kdata.values = nil
					end
				end
				
				--sb.logInfo( ktag.." "..tostring( ti ).." "..tostring( kdata.times[ ti ] ).." "..tostring( valuelen ).." "..tostring( timax ).." "..tostring(kdata.currenttime)  )
				
				--did it CHANGE?
				if kdata.current ~= kdata.previous then
					--sb.logInfo( tostring(kdata.current) )
					if kdata.current ~= nil then
						animator.setGlobalTag( ktag, tostring( kdata.current ) )
					end
					kdata.previous = kdata.current;
				end
				
				--self.ats[ ktag ] = kdata	--update is automatic
			end
		end
	end

	if self.vsoForcedToDie then
		vehicle.destroy();
	end
	
end

--Get or set a value from the vso.simple config data
function vsoVal( key, setto )
	if setto ~= nil then
		self.cfgVSO.simple.vals[ key ] = setto;
	end
	return self.cfgVSO.simple.vals[ key ]
end

--Get a set (key to values) from the vso.simple config data
function vsoSet( key, values )
	if values ~= nil then
		self.cfgVSO.simple.sets[ key ] = values;
	end
	return self.cfgVSO.simple.sets[ key ]
end

--local animkey = vsoChoose( { "full": "suckle", "fullidle":"lay" }, { "full":25, "fullidle":100 } )
function vsoChoose( dict )
	--Pick a random key from a dictionary
	local count = 0
	for k,v in pairs( dict ) do
		count = count + 1;
	end
	local findme = math.random() * count;
	local total = 0;
	for k,v in pairs( A ) do
		total = total + 1;
		if total >= findme then	--0 influence elements are ignored (but the FIRST element may be selected as default)
			return k;
		end
	end
	return nil;
end

--Get a histo set ( list of lists[ freq, value ] pairs
function vsoHisto( key )

	local A = self.cfgVSO.simple.histosets[ key ]
	
	if A ~= nil then
		
		local total = 0
		for k,v in pairs( A ) do
			total = total + v[1];
		end
		local findme = math.random() * total;
		local bestmsg = A[1][2];
		total = 0;
		for k,v in pairs( A ) do
			total = total + v[1];
			if total >= findme and v[1] > 0 then	--0 influence elements are ignored (but the FIRST element may be selected as default)
				bestmsg = v[2];
				break;
			end
		end
		return bestmsg;
	end
	return nil;
end

function vsoPick( list )
	local listlen = #list;
	if listlen > 0 then
		return list[ 1 + (math.floor( math.random() * listlen ) % listlen) ]
	end
	return nil;
end

function vsoPickIndex( list )
	local listlen = #list;
	if listlen > 0 then
		return 1 + (math.floor( math.random() * listlen ) % listlen)
	end
	return 1;
end

function vsoMakeInteractive( b )
	if b then
		vehicle.setInteractive( true );	--Always interactive? Hm.
	else
		vehicle.setInteractive( false );	--Always interactive? Hm.
	end
end
		
function vsoAnim( state, anim )	--Play animation or get the current animation playing if anim is nil
	
	local asta = self.vsoAnimStateData[ state ]
	
	if asta ~= nil then
	
		if anim == nil then
			return self.sv.as[ state ].curr;
		end
	
		local aa = asta[ anim ] 
		if aa ~= nil then
		
			if self.sv.as[ state ].curr ~= anim or vsoTTCheck( self.sv.as[ state ].tt ) then
			
				self.sv.as[ state ].curr = anim;
				self.sv.as[ state ].tt = vsoTT( aa.cycle )
				self.sv.as[ state ].frames = aa.frames
				self.sv.as[ state ].replayedge = false;
				
				animator.setAnimationState( state, anim, true );
			end
			return true;
		else
		
			vsoError( "vsoAnim called with invalid animation for state "..tostring( state )..": "..tostring( anim ) )
			for k,v in pairs( asta ) do
				vsoInfo( k .." "..tostring( v ) )
			end
		
		end
	else
		vsoError( "vsoAnim called with invalid state: "..tostring( state ) )
	end
	return false;
end

function vsoAnimReplay( state, anim )
	if vsoAnim( state, anim ) then
		self.sv.as[ state ].tt[1] = 0;	--Force restart
		self.sv.as[ state ].replayedge = false;
		animator.setAnimationState( state, anim, true );
		return true;
	end
	return false;
end

function vsoAnimEnd( state )	--Returns true if this state has ended it's current animation
	--But it also CONTINUES to return true forever until you play a new animation... Hm.
	if vsoTTCheck( self.sv.as[ state ].tt ) then
		if self.sv.as[ state ].replayedge then
			--Only fires ONCE the edge is crossed...
		else
			self.sv.as[ state ].replayedge = true;
			return true;
		end
	end
	return false;
end

function vsoAnimEnded( state )	--Constantly returns if animation is "over" ignoring the replay edge
	return vsoTTCheck( self.sv.as[ state ].tt )
end

function vsoAnimTime( state )
	return self.sv.as[ state ].tt[1]
end

function vsoAnimIs( state, anim )	--Returns true if this state's current animation == anim
	return self.sv.as[ state ].curr == anim
end
	
function vsoAnimCurr( state )
	return self.sv.as[ state ].curr
end

function vsoAnimIsAny( state, animlist )	--Returns true if this state's current animation == anim
	return vsoInList( self.sv.as[ state ].curr, animlist );
end

function vsoAnimSpeed( rate )	--Returns true if this state's current animation == anim
	if rate ~= nil then
		self.sv.animspeed = rate;
	end
	animator.setAnimationRate( self.sv.animspeed )
	return self.sv.animspeed;
end

------------------

function vsoCheckItemDrops( relx, rely, distance, types )
	if relx == nil then relx = 0.0 end
	if rely == nil then rely = 0.0 end
	if distance == nil then distance = 2.0 end
	--if types == nil then types = nil end
	
	local R = {};
	
	--Relative position to world position ( toGlobal ):
	local relrect = vsoRelativeRect( relx, rely, relx, rely );
	--local fakepos = vec2.sub( mcontroller.position(), mcontroller.position() )--.add( {0,0}, {relrect[1], relrect[2]} );
	--sb.logInfo( tostring( fakepos[1] ).." "..tostring( fakepos[2] ) );
	--fakepos[1] = relrect[1][1]
	--fakepos[2] = relrect[2]
	--sb.logInfo( tostring( fakepos[1] ).." "..tostring( fakepos[2] ) );
	
	local targetIds = world.entityQuery( relrect[1], distance, { includedTypes = {"itemDrop"}, order = "nearest" } )
	for k,targetId in pairs(targetIds) do
		if entity.entityInSight(targetId) then
			--IS it in types or is types nil?
			if types == nil then
				table.insert( R, targetId );	--return targetId
			else
				--world.itemDropItem( targetId ) --Returns the item descriptor of an item drop's contents.
				local itemname = world.entityName( targetId );	--"For item drops, this will be the name of the contained item."
				if types[ itemname ] ~= nil then
					table.insert( R, targetId );	--return targetId
				end
			end
		end
	end
	return R;
end

--Checks for the FIRST NEAREST item of type (or nil for all items) and returns it's id, and it's entityName... And ONLY checks the first one (efficient)
function vsoCheckItemDrop( relx, rely, distance, types )
		if relx == nil then relx = 0.0 end
	if rely == nil then rely = 0.0 end
	if distance == nil then distance = 2.0 end
	--if types == nil then types = nil end
	
	local hasitem = nil;
	
	--Relative position to world position ( toGlobal ):
	local relrect = vsoRelativeRect( relx, rely, relx, rely );
	--local targetIds = world.entityQuery( relrect[1], distance, { includedTypes = {"itemDrop"}, order = "nearest" } )
	local targetIds = world.itemDropQuery( relrect[1], distance, { includedTypes = {"itemDrop"}, order = "nearest" } )
	for k,targetId in pairs(targetIds) do
		if entity.entityInSight(targetId) then
			--IS it in types or is types nil?
			if types == nil then
				hasitem = targetId
				break;
			else
				--world.itemDropItem( targetId ) --Returns the item descriptor of an item drop's contents.
				--local itemname = world.entityName( targetId );	--"For item drops, this will be the name of the contained item."
				if types[ world.entityName( targetId ) ] ~= nil then
					hasitem = targetId
					break;
				end
			end
		end
	end
	
	if hasitem then
	
		return hasitem, world.entityName( hasitem )
	end
	
	return nil, ""
end

function vsoEatItemDrop( itemId, totarget )

	--Note that, a VSO should keep a RECORD of what item drops it has eaten?
	--Probably should protect this... Actually, a VSO should be a container of some kind...
	--
	--	world.containerAddItems() ??
	--
	--Spawn a temporary thing at the mouth position so the item is sucked up there? Hm...
	--
	--Might be possible to do a query & call a script on a thing...
	local desc = nil;
	if totarget ~= nil then
		--CREATE a target to "eat to" hm...
		--#WIP
		desc = world.takeItemDrop( itemId, totarget )	--Animates TOWARD an entity... hm.
	else
		desc = world.takeItemDrop( itemId, entity.id() )	--Animates TOWARD an entity... hm.
	end
	if desc then
		return desc;
	end
	return nil--FAILED!
end

--Special case of "eat any item with a path like: "*items\generic\meat\*"
--Hm. Because the items just have "food" but not "meat"

------------------

function vsoItemMatch( itemname, itemformat )
	--Returns which bits matched. 1 == config  2 == directory
	local matchbits = 0;
	local exactmatchbits = 0;
	
	if itemformat ~= nil and itemname ~= nil then
		
		local hasitemconfig = root.itemConfig( itemname )
		
		if hasitemconfig ~= nil then
			
			--Directory is the WEAKEST match
			if itemformat.directory ~= nil then
				--itemformat.directory
				--Directory exact
				if hasitemconfig.directory == itemformat.directory then	--"/items/generic/meat/"
					matchbits = matchbits + 1;
				end
				exactmatchbits = exactmatchbits + 1;
			end
			
			--itemformat.directorymatch
			--Directory SIMILAR TO
			--	if stringfind( hasitemconfig.directory, "/items/generic/meat/" ) then
			--	also + 1
			
			--Config values are the second strongest
			if itemformat.config ~= nil then
				--itemformat.config
				--Config parameters EXACT matching ( parametername = "exact string" )
				--	if hasitemconfig.config.category == "food" then
				local valid = true;
				for k,v in pairs( itemformat.config ) do
					if hasitemconfig.config[k] ~= v then
						valid = false;
						break;
					end
				end
				if valid then
					matchbits = matchbits + 2;
				end
				exactmatchbits = exactmatchbits + 2;
			end
			
			--itemformat.configmatch
			--config parameters SIMILAR TO ( parametername = "find string" )
			--	if stringfind( hasitemconfig.config.category, "food" ) then
			--	also + 2
			
			--Tags are the strongest (rare, unique)
			--itemformat.tags
			--Tags ( config.itemTags[] )
			--	if listfindall( config.itemTags, { "some thing", ... } ) then
			-- is + 4 (most important match is tags since those are fairly unique)
			
			--itemformat.tagsmatch
			-- is + 4 
		else
			sb.logInfo( "#ERROR vsoItemMatch called with bad item name: "..itemname )
		end
	end

	return matchbits, exactmatchbits
	
end

function vsoItemMatching( itemname, itemformat )

	local bits, bitsexact = vsoItemMatch( itemname, itemformat );
	if bits > 0 then
		return bits == bitsexact
	end
	return false;
	
	--[[

	if itemformat ~= nil then
		
		--Must be food item on the ground
		local hasitemconfig = root.itemConfig( itemname )
		
		
		if hasitemconfig.config.category == "food" then
		
			--Must be meat
			if hasitemconfig.directory == "/items/generic/meat/" then
				
				--Must be able to "take" it (hm)
				if vsoEatItemDrop( itemId ) then	--it MAY FAIL so. be aware of that. (you can "miss" taking an item...)
				
					--Can create a image of this meat in our animation perhaps?
					--image path = hasitemconfig.directory .. hasitemconfig.config.inventoryIcon
					--
					--Hm!
				
					sb.logInfo( hasitemconfig.directory );
					
					vsoSay( "Yummy, "..itemname.."!" );
					
					--Play eat animation & state stuff?
					vsoSound("swallow");
				
				end
				
			else
			
				vsoSay( "Want meat! Not "..itemname.."!" );
				--PUSH ITEM DROP AWAY? kick it?
			end
			
		else
		
			vsoSay( "Gross, I dont want "..itemname.."." );
			--PUSH ITEM DROP AWAY? kick it?
		end
		
	end
	
	return false;
	]]--
end

--[[
function vsoTargetHasItemMatching( targetname, itemformat )

	--NOTE: This function currently does not work correctly over the network, making it inaccurate when not used from client side scripts such as status. 
	--world.entityHasCountOfItem(EntityId entityId, Json itemDescriptor, [bool exactMatch])
	local targ = self.sv.targets[ targetname ]
	if targ ~= nil then
		if world.entityExists( targ.id ) then
			--Hm...
			--Will require a message: bool player.hasItem(ItemDescriptor item, [bool exactMatch])
			--unsigned player.hasCountOfItem(ItemDescriptor item, [bool exactMatch])
			--ItemDescriptor player.consumeItem(ItemDescriptor item, [bool consumePartial], [bool exactMatch])
			--
			
			--vsoItemMatch( itemname, { config = { category="food" }, directory="/items/generic/meat/" } );
			
			--local bits, bitscomplete = vsoItemMatch( itemname, { config = { category="food" }, directory="/items/generic/meat/" } );
			
			
		end
	end
	
	return nil, "";
end
]]--

function vsoTargetHoldingItemMatch( targetname, itemformat )

	local bestmatch = 0;
	local bestmatchbest = 0;
	local bestname = ""
	
	local hasId = vsoGetTargetId( targetname );
	if hasId ~= nil then
	
		local handa = world.entityHandItem( hasId, "primary" );	--Item held is in THIS hand
		local handb = world.entityHandItem( hasId, "alt" );
		
		local abits, abitscomplete = vsoItemMatch( handa, itemformat );
		local bbits, bbitscomplete = vsoItemMatch( handb, itemformat );
		
		bestmatchbest = abitscomplete;	-- == bbitscomplete then
		
		if abits >= bbits then
			bestmatch = abits;
			bestname = handa
		else
			bestmatch = bbits;
			bestname = handb
		end
	end

	return bestmatch, bestmatchbest, bestname;
end

	--vsoItemMatching()  and vsoTargetHoldingItemMatching() and vsoTargetHasItemMatching()  ??
	
function _add_vso_rpc( rpc, callback )
	if callback ~= nil then
		if self.rpc_stack == nil then
			self.rpc_stack = {};
		end
		table.insert( self.rpc_stack, {rpc, callback} );
	end
end
					
		--Okay... this DOES work but it doesnt always take the item IN the hand...
function vsoTakeItemFromTarget( targetname, itemname, itemcount, callback );
	local hasId = vsoGetTargetId( targetname );
	if hasId ~= nil then
		if itemcount == nil then itemcount = 1 end
		
		--Requires a rpc to get result...
		--May only work with the player...
		_add_vso_rpc( world.sendEntityMessage( hasId, "vsoTakeItem", itemname, itemcount ), callback );
		
	end
	return false;
end
		
function vsoGetItemParameter( itemname, key, defaultvalue )
	local cfg = root.itemConfig( self.foodtargetname );
	if cfg ~= nil then
		if cfg.config ~= nil then
			if cfg.config[key] ~= nil then
				return cfg.config[key]
			end
		end	
	end
	return defaultvalue
end
						
-------------------------------------------------------------
						
function vsoApplyStatus( targetname, statusname, duration )
	--[[
		
		vsoApplyStatus( "food", "droolsoaked", 5.0 );	--Add status effect "droolsoaked" to a target "food" (must have targeted something or this wont work)
	
	local targ = self.sv.targets[ targetname ]
	if targ ~= nil then
		if world.entityExists( targ.id ) then
			if duration == nil then duration = 0.1 end
			world.sendEntityMessage( targ.id, "applyStatusEffect", statusname, duration, entity.id() );
			return true
		end
	end
	return false;
	]]--
	return vsoApplyStatusList( targetname, { statusname }, duration )
end

function vsoApplyStatusList( targetname, statuslist, duration )
	--[[
		
		vsoApplyStatus( "food", "droolsoaked", 5.0 );	--Add status effect "droolsoaked" to a target "food" (must have targeted something or this wont work)
	]]--
	local targ = self.sv.targets[ targetname ]
	if targ ~= nil then
		if world.entityExists( targ.id ) then
			if duration == nil then duration = 0.1 end
			for i, efex in ipairs( statuslist ) do
				world.sendEntityMessage( targ.id, "applyStatusEffect", efex, duration, entity.id() );
			end
			return true
		end
	end
	return false;
end

function vsoStatusPropertySet( targetid, prop, value )
	if world.entityExists( targetid ) then
		world.sendEntityMessage( targetid, "vsoStatusPropertySet", prop, value );
		return true
	end
	return false;
end

function vsoStatusPropertyGet( targetid, prop, value, callback )
	if world.entityExists( targetid ) then
		_add_vso_rpc( world.sendEntityMessage( targetid, "vsoStatusPropertyGet", prop, value ), callback )
		return true
	end
	return false;
end

--Asynchronous
function vsoHasStatusSet( targetid, statmap, callback )
	_add_vso_rpc( world.sendEntityMessage( targetid, "vsoListStatusEffects", statmap ), function( result )
		local hasany = false;
		local hascount = 0;
		if result ~= nil then
			for k,v in pairs( result ) do
				--sb.logInfo("Got status list"..k.." "..tostring(v[1]).." "..tostring( statmap[ v[1] ] ) );
				if statmap[ v[1] ] ~= nil then
					hascount = hascount + 1;
					hasany = true
				end
			end
		end
		for k,v in pairs( statmap ) do
			hascount = hascount - 1;
		end
		
		callback( hasany and hascount == 0 );
	end )
end

--Asynchronous
function vsoHasStatus( targetid, statname, callback )
	local alist = {}
	alist[statname] = 1;
	vsoHasStatusSet( targetid, alist, callback );
end

function vsoResourceGetSummary( targetid, callback )
	if world.entityExists( targetid ) then
		_add_vso_rpc( 	world.sendEntityMessage( targetid, "vsoResourceGetSummary" ), callback )
		return true
	end
	return false;
end

function vsoResourceGet( targetid, resname, callback )
	if world.entityExists( targetid ) then
		_add_vso_rpc( 	world.sendEntityMessage( targetid, "vsoResourceGetSummary", resname ), callback )
		return true
	end
	return false;
end

function vsoResourceAddPercent( targetid, resname, respercent, optcallback )
	if world.entityExists( targetid ) then
		local rpc = world.sendEntityMessage( targetid, "vsoResourceAddPercent", resname, respercent/100.0 )
		if optcallback ~= nil then
			_add_vso_rpc( rpc, optcallback )
		end
		return true
	end
	return false;
end

--------------------------------------------------------------------------------------------

function vsoMakeColorReplaceDirectiveString( colmap )
	local R = "replace=";
	for k,v in pairs( colmap ) do
		R = R..k.."="..v..";"
	end
	return R;
end

function vsoAnitag( anitag, value )
	--keep track of these please...
	self.ats[ anitag ] = { current=value, values=nil, times=nil, setend=nil };
	animator.setGlobalTag( anitag, value )
end

function vsoSetDirectives( dirstring )
	--Note this ONLY WORKS if you add in the <directives> tag like so to your animation files:
    --	 "idle": { "properties": { "image": "normaldino.png:idle.<frame><directives>" }  }
	--Mimicing the giant mechs thing.
	
	--  object.setProcessingDirectives(storage.storedDirectiveString..frameDirectiveString)  would work for a OBJECT but not a vehicle.
	--object.setProcessingDirectives( vsoMakeColorReplaceDirectiveString( colmap ) )
	
	--self.partDirectives = config.getParameter("partDirectives")
	--for k, v in pairs(self.partDirectives) do
	--	animator.setGlobalTag(k .. "Directives", v)
	--end
	--animator.setGlobalTag("directives", string.format("?fade=FCC93C;%.1f", fade))
	--animator.setGlobalTag( "directives", "?".."multiply=808080FF" )
	
	animator.setGlobalTag( "directives", "?"..dirstring )
	
end

--Animated approach
--vsoAnitagAnim( vsoVal( "ani_head_none" ) )
--vsoAnitagAnim( vsoVal( "ani_head_angry" ) )
--vsoAnitagAnim( vsoVal( "ani_head_liplick" ) )
function vsoAnitagAnim( uconfig )
	--[[
		
		,"ani_head_none":{
			"setbegin":{ "heademote" : "empty", "heademoteframe" : 1 }
		}
		,"ani_head_mad":{
			"setbegin":{ "heademote" : "angry", "heademoteframe" : 1 }
		}
		,"ani_head_liplick":{
			"setbegin":{ "heademote" : "liplick", "heademoteframe" : 1 }
			,"anim":{ "heademoteframe" : { "first":1, "last":6, "times":[ 0.2 ] } }
			,"setend":{ "heademote" : "emtpy", "heademoteframe" : 1 }
		}
	]]--
	
	--<-> Hm... only 1 animation per tag...
	--Do we handle this automagically?
	if uconfig ~= nil then
		
		if uconfig.setbegin ~= nil then
			for k,v in pairs( uconfig.setbegin ) do
				--Remove animation for EACH used k anitag... { current=v, values=nil, times=nil }
				vsoAnitag( k, v );
			end
		end

		if uconfig.anim ~= nil then
		
			for k,v in pairs( uconfig.anim ) do
				--anitag == k
				--,"anim":{ "heademoteframe" : { "value":[1,2,3,4,5,6], "time":[ 0.2 ] } }
				--{ "value":[1,2,3,4,5,6], "times":[ 0.2 ] }	Animation of frames from 1 to and including 6 with a frame time for each possible. (reuses last time)
				--vsoAnitag( k, v );
				
				if self.ats[ k ] ~= nil then
					self.ats[ k ].previous = nil
					self.ats[ k ].lastindex = 1
				else
					self.ats[ k ] = { current=nil, values=nil, times=nil, setend=nil };
				end
				
				if v.values ~= nil then
					self.ats[ k ].values = v.values
				else
					self.ats[ k ].values = nil
				end
				if v.times ~= nil then
					self.ats[ k ].times = v.times
				else
					self.ats[ k ].times = nil
					--Autogenerate a INDEX time 1 frame per second.
					if self.ats[ k ].values then
						self.ats[ k ].times = {};
						local timedex = 0;
						for sk,sv in pairs( self.ats[ k ].values ) do
							table.insert( self.ats[ k ].times, timedex )
							timedex = timedex + 1
						end
					end
				end
				
				--Multiply all times
				if v.timemul ~= nil then
					if self.ats[ k ].times ~= nil then
						local itym = 1;
						local itymmax = #self.ats[ k ].times;
						while itym <= itymmax do
							self.ats[ k ].times[ itym ] = self.ats[ k ].times[ itym ] * v.timemul
							itym = itym + 1;
						end
					end
				end
				
				if v.setend ~= nil then
					self.ats[k].setend = v.setend;
				end
				
				self.ats[ k ].currenttime = 0.0
				
			end
		
			--if uconfig.setend ~= nil then
			--	if self.ats[k] ~= nil then
			--		self.ats[k].setend = uconfig.setend;
			--	end
				--[[for k,v in pairs( uconfig.setend ) do
					
					if self.ats[k] ~= nil then
						self.ats[k].setend = v;
					else
						--self.ats[ k ].setend = nil;	--ignore
					end
				end]]--
			--end
		end
	else
		for ktag, v in pairs( self.ats ) do
			vsoAnitagClear( ktag )
		end
		self.ats = {};	--WIPE it out.
	end
end

function vsoAnitagClear( anitagkey )
	if anitagkey ~= nil then
		--animator.setGlobalTag( anitagkey );	--doesnt work
		--animator.setGlobalTag( anitagkey, "" );	--doesnt work
		--animator.setGlobalTag( anitagkey, "<"..anitagkey..">" );	--doesnt work
		--animator.setGlobalTag( anitagkey, "default" );	--doesnt work		
		--animator.setGlobalTag( anitagkey, "" );	--Hm.		/vehicles/spov/simpledino/normaldino_head.png:.
		--animator.setGlobalTag( anitagkey, "default" );	--Hm	/vehicles/spov/simpledino/normaldino_head.frames
		--animator.setGlobalTag( anitagkey, "default" );	--Hm	/vehicles/spov/simpledino/normaldino_head.frames
		
		--animator.setGlobalTag( anitagkey, "default" );	--???	/vehicles/spov/simpledino/normaldino_head.png:<heademote>.<heademoteframe>
		
		--globalTagDefaults
		
		if self.ats[ anitagkey ] ~= nil  then
			self.ats[ anitagkey ] = nil;	--NO REMOVE in lua...
		end
	end
end

--------------------------------------------------------------------------------------------

--[[
function vsoRemoveStatus( targetname, statusname )
	
		
	--	vsoApplyStatus( "food", "vsomask" );	--Remove status effect "vsomask" from a target "food" (must have targeted something or this wont work)
	
	local targ = self.sv.targets[ targetname ]
	if targ ~= nil then
		if world.entityExists( targ.id ) then
			world.sendEntityMessage( targ.id, "applyStatusEffect", statusname, duration, entity.id() );
			return true
		end
	end
	return false;
end
]]--
				
function vsoValidTarget( targetname )	--Return true if a named target exists
	local targ = self.sv.targets[ targetname ]
	if targ ~= nil then
		if world.entityExists( targ.id ) then
			return targ.validstatus and targ.state >= 0
		
			--if targ.validstatus ~= nil then	--Asynchronous checking for status effects.
			--end
			--return targ.state >= 0;
		end
		self.sv.targets[ targetname ] = nil;
		return false;
	end
	return false;
end

function vsoGetTargetId( targetname )	--Return a named target
	local targ = self.sv.targets[ targetname ]
	if targ ~= nil then
		return targ.id;
	end
	return nil;
end

function vsoSetTarget( targetname, newid )	--Set a named target

	if self.sv.targets[ targetname ] ~= nil then
		if self.sv.targets[ targetname ].id == newid then
			return false;	--nothing changes
		end
	end
	self.sv.targets[ targetname ] = { id=newid, state=0, validstatus=false, rpc=nil }
	return true;
end

function vsoClearTarget( targetname )	--Clear a named target
	self.sv.targets[ targetname ] = nil;
end

function vsoTargetHitBox( targetname, xMin, yMin, xMax, yMax )
  
	--1. Does it CURRENTLY exist
	local oldtarget = self.sv.targets[ targetname ];
	
	if oldtarget ~= nil then
	
		if world.entityExists( oldtarget.id ) then

			--Construct world position from RELATIVE coordinates on me.
			--	From my... collision bounds center? (prove this later)
			local R = vsoRelativeRect( xMin, yMin, xMax, yMax )
			local pos1 = R[1];
			local pos2 = R[2];
			
			local hitlist = {};
			if world.isNpc( oldtarget.id ) then
				hitlist = world.npcQuery( pos1, pos2 );
			else
				hitlist = world.playerQuery( pos1, pos2 )
			end
			for k,v in pairs( hitlist ) do
				if v == oldtarget.id then
					return true;
				end
			end
		end
	end
	return false;	
end
  
function vsoUpdateTarget( targetname, xMin, yMin, xMax, yMax, options )

	local retval = false;
	
	--1. Does it CURRENTLY exist
	local oldtarget = self.sv.targets[ targetname ];
	
	local oldtargetid = nil;
	if oldtarget ~= nil then
		if oldtarget.id ~= nil then
			if world.entityExists( oldtarget.id ) then
				if oldtarget.state < 0 then
					--You are updating a EATEN target. this is pointless.
					return true;
				end
				oldtargetid = oldtarget.id;	--I currently exist and am valid!
			end
		end
	end
	
	--2 Check for proximity / new targets

	--Construct world position from RELATIVE coordinates on me.
	--	From my... collision bounds center? (prove this later)
	local R = vsoRelativeRect( xMin, yMin, xMax, yMax )
	local pos1 = R[1];
	local pos2 = R[2];
	if options ~= nil then
		if options.worldspace == true then
			pos1[1] = xMin;
			pos1[2] = yMin;
			pos2[1] = xMax;
			pos2[2] = yMax;
		end
	end
	local hasnpc = world.npcQuery( pos1, pos2, { order = "nearest" } );
	local hasplayer = world.playerQuery( pos1, pos2, { order = "nearest" })
	
	--Check for old target
	local setid = nil;
	if oldtargetid ~= nil then
		for k,v in pairs( hasnpc ) do
			if v == oldtargetid then
				setid = oldtargetid;
				break;
			end
		end
		for k,v in pairs( hasplayer ) do
			if v == oldtargetid then
				setid = oldtargetid;
				break;
			end
		end
	end
	
	--Old target was NOT found.
	if setid == nil then
		--List of targets.
		if #hasnpc > 0 then
			setid = hasnpc[1];	--How do we know WHAT NPC is OK to use as a target??? dammit!!
		elseif #hasplayer > 0 then
			setid = hasplayer[1];
		end
		
		if setid ~= nil then
			self.sv.targets[ targetname ] = { id=setid, state=0, validstatus=true, rpc=nil }	--A NEW TARGET was found.
		else
			self.sv.targets[ targetname ] = nil;	--Lost all targets.
		end
	else
		--old target still around.
		
		--4. Since we are UPDATING the target that is in range.
		--They should not have certain status effects
		if self.sv.targets[ targetname ] ~= nil then
		
			local thisisd = self.sv.targets[ targetname ].id
			local statlist = nil;
			local statlistavailable = false;

			if self.sv.targets[ targetname ].rpc == nil then
				self.sv.targets[ targetname ].rpc = world.sendEntityMessage( thisisd, "vsoListStatusEffects" );
			else
				if self.sv.targets[ targetname ].rpc:finished() then
					statlist = self.sv.targets[ targetname ].rpc:result();
					statlistavailable = true;
					self.sv.targets[ targetname ].rpc = nil
				end
			end

			if statlistavailable then
			
				self.sv.targets[ targetname ].validstatus = true;
				self.sv.targets[ targetname ].statuslist = statlist;
				
				if statlist ~= nil then
					for k,v in pairs( statlist ) do
						local has = vsoInvalidTargetStats[ v[1] ];
						if has ~= nil then
							if has == 1 then
								self.sv.targets[ targetname ].validstatus = false;
								break;
							end
						end
					end
				end
			end
		end
	end
	
	if self.sv.targets[ targetname ] ~= nil then
		if self.sv.targets[ targetname ].validstatus then
			return true;
		end
	end
	return false;
end

function vsoFindTarget( targetname, xMin, yMin, xMax, yMax )
	self.sv.targets[ targetname ] = nil;
	return vsoUpdateTarget( targetname, xMin, yMin, xMax, yMax )
end

function vsoForceTarget( targetid, x, y, xmode, ymode )
	--if ymode == 1 then
	--	mcontroller.setYVelocity( mcontroller.yVelocity() + y )
	--elseif ymode == 2 then
	--	mcontroller.setYVelocity( y )
	--elseif ymode == 3 then
	--	mcontroller.force( { 0,y } )
	--end
	world.sendEntityMessage( targetid, "vsoForceApply", x, y, xmode, ymode );
end
			
--Is someone eaten in this seat?
function vsoHasEaten( seatname )
	if self.sv.eaten[ seatname ] ~= nil then	--Can't DOUBLE eat from a single seat.
		return true;
	end
	return false;
end

function vsoHasEatenTarget( targetname )
	local findid = vsoGetTargetId( targetname )
	for k,v in pairs( self.sv.eaten ) do
		if v ~= nil then
			if v.id == findid then
				return true;
			end
		end
	end
	return false;
end

function vsoHasEatenId( seatname )
	if self.sv.eaten[ seatname ] ~= nil then
		return self.sv.eaten[ seatname ].id
	end
	return nil;
end

function vsoHasAnyInputs( seatname, inputlist )
	
	local eatenstruct = self.sv.eaten[ seatname ]
	if eatenstruct ~= nil then	--Can't DOUBLE eat from a single seat.
		local input = eatenstruct.input
		if input ~= nil then
			--[[
			input.slowdx = dir * ( vsoClipPositive(input.Rs) - vsoClipPositive(input.Ls))
			input.slowdy = (vsoClipPositive(input.Us) - vsoClipPositive(input.Ds))
			input.fastdx = dir * (input.Rf - input.Lf)
			input.fastdy = (input.Uf - input.Df)
			input.tx = dir * ( clipNonzero(input.Rt) - clipNonzero(input.Lt) )
			input.ty = clipNonzero(input.Ut) - clipNonzero(input.Dt)
			input.dx = dir * ( clipNonzero(input.R) - clipNonzero(input.L) )
			input.dy = clipNonzero(input.U) - clipNonzero(input.D)
			]]--
			if inputlist == nil then
				inputlist = vsoInputsKnown
			end
			for k,v in pairs( inputlist ) do
				if input[ k ] > 0 then
					return true
				end
			end
		end
	end
	return false
end

function vsoGetInput( seatname )
	local R = {
		slowdx=0
		,slowdy=0
		,fastdx=0
		,fastdy=0
		,tx=0
		,ty=0
		,dx=0
		,dy=0
		,E=0
		,J=0
		,U=0
		,D=0
		,L=0
		,R=0
		,A=0
		,B=0
		,slowA=0
		,fastA=0
		,slowB=0
		,fastB=0
		,slowJ=0
		,fastJ=0
	}
	local eatenstruct = self.sv.eaten[ seatname ]
	if eatenstruct ~= nil then	--Can't DOUBLE eat from a single seat.
		local input = eatenstruct.input
		if input ~= nil then
			for k,v in pairs( input ) do
				R[k] = v
			end
		end
	end
	return R
end

function vsoGetInputRaw( seatname )
	local eatenstruct = self.sv.eaten[ seatname ]
	if eatenstruct ~= nil then	--Can't DOUBLE eat from a single seat.
		local input = eatenstruct.input
		if input ~= nil then
			return input;
		end
	end
	return nil;
end

function vsoHasAnySPOInputs( seatname, inputlist )

	--Should work for NPC's once they are healed? Or... Other? Hm.
	
	if vsoHasAnyInputs( seatname, { L=1, R=1, U=1, D=1, J=1 } ) then
		return true
	else
		local eatenstruct = self.sv.eaten[ seatname ]
		if eatenstruct ~= nil then	--Can't DOUBLE eat from a single seat.
			local input = eatenstruct.input
			if input ~= nil then
				if input[ "E" ] ~= nil then
					if input[ "E" ] > 2 then	--Special case. E must be tapped repeatedly in 1 second... make this a config value
						--return true	--This isnt reliable yet. Whaaaaat...
					end
				end
			end
		end
	end
	return false
end

function vsoEat( targetid, seatname )
	
	if world.entityExists( targetid ) then
	
		vehicle.setLoungeEnabled( seatname, true )
		--mcontroller.setAnchorState( self.vsoLoungeNameToIndex[ seatname ], true );
		
		local eatst = self.sv.eaten[ seatname ];
		if eatst ~= nil then
			if eatst.id == targetid then
				--Fine
			else
				--Make sure THIS id is UNSAT. from a specific seat. Until eaten again?
				self.sv.vsoEatenEject[ seatname ][ eatst.id ] = 1;
			end
			self.sv.eaten[ seatname ] = { id=targetid, success=false }
		else
			self.sv.eaten[ seatname ] = { id=targetid, success=false }
		end
		
		vsoEatForce( targetid, self.vsoLoungeNameToIndex[ seatname ] )
		
		return true;
	end
	return false;
end

function vsoUneat( seatname )

	vehicle.setLoungeEnabled( seatname, false );
	--mcontroller.setAnchorState( self.vsoLoungeNameToIndex[ seatname ], false );
	
	if self.sv.eaten[ seatname ] ~= nil then
		--Are we ACTUALLY lounging in this seat?
		local targetid = self.sv.eaten[ seatname ].id
	
		if targetid ~= nil then
		
			--Make sure THIS id is UNSAT. from a specific seat. Until eaten again?
			self.sv.vsoEatenEject[ seatname ][ targetid ] = 1;
		
			if vehicle.entityLoungingIn( seatname ) == targetid then
				world.sendEntityMessage( targetid, "vsoForceApply", 0, 0, 2, 2 );	--REMOVE velocity just in case?
				world.sendEntityMessage( targetid, "applyStatusEffect", "vsoremoveforcesit", 0.1, entity.id() );
			end
		end
		self.sv.eaten[ seatname ] = nil;
		return true
	end
	
	return false;
end

function vsoCheckIfStillEating( seatname, maxtime )
	local eatid = vsoHasEatenId( seatname);
	if eatid ~= nil then
		--we have a eaten thing, so yeah we are still eating. reset the timer.
		vsoTimeDelta( seatname.."_vsoCheckIfStillEating", false );	--reset timer to now
		return true;
	else
		if maxtime ~= nil then
			return vsoTimeDelta( seatname.."_vsoCheckIfStillEating", true ) < maxtime;	--read ONLY on timer. return true so long as we are under max timer...
		else
			vsoTimeDelta( seatname.."_vsoCheckIfStillEating", false );	--reset timer to now because you didnt provide a max time.
		end
	end
	return true	--we dont know so it defaults to true?
end

-------------------------------------------------------------------------------

function vsoTimer( timername, secondsmin, secondsmax )	--Returns true when this named time expires or has expired. 
	local tim = self.sv.ts[ timername ];
	if tim == nil then
		if secondsmin ~= nil then
			vsoTimerSet( timername, secondsmin, secondsmax );
		else
			--self.sv.ts[ timername ] = vsoTT( 1.0 );
			vsoError( "missing timer, check and make sure you set it "..timername )
		end
		return false
	elseif vsoTTCheck( tim ) then
		if tim[2] > 0 then
			tim[1] = tim[1] - math.floor( tim[1] / tim[2] ) * tim[2];
		else
			tim[1] = 0;
		end
		return true
	end
	return false;
end

function vsoTimerEvery( timername, secondsmin, secondsmax )
	local tim = self.sv.ts[ timername ];
	if tim == nil then
		vsoTimerSet( timername, secondsmin, secondsmax );
		return false
	elseif vsoTTCheck( tim ) then
		if tim[2] > 0 then
			tim[1] = tim[1] - math.floor( tim[1] / tim[2] ) * tim[2];
		else
			tim[1] = 0;
		end
		vsoTimerSet( timername, secondsmin, secondsmax );
		return true
	end
	return false;
end

function vsoTimerEveryDo( timername, secondsmin, secondsmax, callback, ... )
	if vsoTimerEvery( timername, secondsmin, secondsmax ) then
		callback( ... )
		--Lol well.
		--callback( unpack( select( 4 ) ) )
		--local takeit = select( 2, args )
		--local arg={...}
		--sb.logInfo( #arg );
		--takeit,b,c,d,e,f = select( 1, arg );
		--sb.logInfo( tostring( takeit ) );
		--for k,v in pairs( takeit ) do
		--	sb.logInfo( k.." "..tostring( v ) )
		--end
		--callback( select( 4, arg ) )
	end
end

function vsoParticleBurst( systemname, count )
	animator.setParticleEmitterBurstCount( systemname, count );
	animator.burstParticleEmitter( systemname )
end

function vsoLocalParticle( config )

	 localAnimator.spawnParticle( {
	 
	 
	 } )
end

function vsoTimerReset( timername, secondsmin, secondsmax )
	local tim = self.sv.ts[ timername ];
	if tim == nil then
		--vsoTimerSet( timername, secondsmin, secondsmax );
		return false
	else
		tim[1] = 0;
		--vsoTimerSet( timername, secondsmin, secondsmax );
		return true
	end
end

function vsoTimerSet( timername, secondsmin, secondsmax )	--set this timer to a random time from secondsmin .. secondsmax
	if secondsmax == nil then
		secondsmax = secondsmin;
	end
	self.sv.ts[ timername ] = vsoTT( math.random()*(secondsmax - secondsmin) + secondsmin );
end

function vsoTimerMax( timername )	--force a timer past it's max (in order to force trigger a timer check)
	local tim = self.sv.ts[ timername ];
	if tim == nil then
		vsoError( "missing timer, check and make sure you set it "..timername )
		return false
	else
		tim[1] = tim[2] + vsoDelta()
	end
end

-------------------------------------------------------------------------------

function vsoCounterAdd( countername, amount, countmin, countmax )	--Add amount to counter ( or create it AT 0 ) returns true only on reset
	local countr = self.sv.cs[ countername ]
	if countr == nil then
		if countmin == nil then countmin = 0 end
		if countmax == nil then countmax = countmin + 1 end
		self.sv.cs[ countername ] = { 0, countmin, countmax }
		return true;
	else
		if countmin ~= nil then countr[2] = countmin end
		if countmax ~= nil then countr[3] = countmax end
		if countr[1] == 0 then
			countr[1] = countr[1] + amount;
			return true
		else
			countr[1] = countr[1] + amount;
		end
	end
	return false
end

function vsoCounterSub( countername, amount, countmin, countmax )
	vsoCounterAdd( countername, 0, countmin, countmax );
	local countr = self.sv.cs[ countername ]
	if countr ~= nil then
		countr[1] = countr[1] - amount;
		if countr[1] < 0 then
			countr[1] = 0;
			return true;
		end
	end
	return false;
end

function vsoCounterPercent( countername, countmin, countmax )	--Returns 0..100 (can be way outside of this range) of this counter chance
	vsoCounterAdd( countername, 0, countmin, countmax );
	local countr = self.sv.cs[ countername ]
	if countr ~= nil then
		if countr[3] ~= countr[2] then
			return ( 100.0 * (countr[1] - countr[2]) / (countr[3] - countr[2]) )
		elseif countr[1] >= countr[3] then
			return 100.0;
		end
	end
	return 0.0;
end

function vsoCounterValue( countername )
	local countr = self.sv.cs[ countername ]
	if countr ~= nil then
		return countr[1];
	end
	return 0.0;
end

function vsoCounterChance( countername, countmin, countmax )	--Returns true when this named time expires or has expired. 
	vsoCounterAdd( countername, 0, countmin, countmax );
	local countr = self.sv.cs[ countername ]
	if countr ~= nil then
		if countr[1] > countr[2] then
			if countr[3] > countr[2] then
				return vsoChance( 100.0 * (countr[1] - countr[2]) / (countr[3] - countr[2]) )
			end
		elseif countr[1] >= countr[3] then
			return true;
		end
	end
	return false;
end

function vsoCounterReset( countername, countmin, countmax )	--Returns true when this named time expires or has expired. 
	vsoCounterAdd( countername, 0, countmin, countmax );
	self.sv.cs[ countername ][1] = 0;
end

function vsoCounterSet( countername, value, countmin, countmax )	--Returns true when this named time expires or has expired. 
	vsoCounterAdd( countername, 0, countmin, countmax );
	self.sv.cs[ countername ][1] = value;
end

function vsoCounter( countername, countmin, countmax )	--Add one to counter, return true if we are past countmax
	return vsoCounterAdd( countername, 1, countmin, countmax );
end
	
-------------------------------------------------------------------------------

function vsoGetSayContext( id )	--Speak from this VSO
	return {
		Name = world.entityName( entity.id() )
		,Gender = world.entityGender( entity.id() )
		,Species = world.entitySpecies( entity.id() )
		,Health = math.floor( 100*vsoRatioSafe( world.entityHealth( entity.id() ) ) )
		--,Money = world.entityMoney( entity.id() )
		,Type = world.entityType( entity.id() )
		,DamageTeamType = world.entityDamageTeam( entity.id() ).type
		,DamageTeam = world.entityDamageTeam( entity.id() ).team
		
		,TargetName = world.entityName( id )
		,TargetGender = world.entityGender( id )
		,TargetSpecies = world.entitySpecies( id )
		,TargetHealth = math.floor( 100*vsoRatioSafe( world.entityHealth( id ) ) )
		--,TargetMoney = world.entityMoney( id )
		,TargetType = world.entityType( id )
		,TargetDamageTeamType = world.entityDamageTeam( id ).type
		,TargetDamageTeam = world.entityDamageTeam( id ).team
	}
end

function vsoSetMouthPosition( x, y )	--Change mouth position
	if x == nil then
		self.mouthPosition = self.vsoMouthPosition
	else
		self.mouthPosition[1] = x;
	end
	if y ~= nil then self.mouthPosition[2] = y end
end

function vsoSay( msg, contextr )	--Speak from this VSO
	
	--doing a "say" should be cached, since we can't rely on the "world.callScriptedEntity". Fix this later.
	
	if msg ~= nil then
		if string.len(msg) > 0 then
			--Until vehicle.say( line ) exists, we have to use a dummy monster
			
			local mouthPos = { self.mouthPosition[1], self.mouthPosition[2] }	--Adjust mouth position based on facing THEN send.
			
			if vsoShouldFlipAnimator() then mouthPos[1] = -mouthPos[1]; end
				
			--Apparently the built in replacer logic doesn't work???
			local endmsg = msg
			if contextr ~= nil then
				endmsg = vsoStringReplacer( msg, contextr )
			end
			
			--Not ok: (spawn doesnt happen instantly??? Queue messages)
			--self.vsoTalkMonsterRpc = world.callScriptedEntity( self.vsoTalkMonster , "vsoSayUpdate", endmsg, entity.id(), mouthPos );
			--Might be tricky to RPC self.vsoTalkMonsterrpc = world.sendEntityMessage( self.vsoTalkMonster, "vsoSayUpdate", msg, entity.id() );
			self.vsoTalkMonsterNext = { endmsg, mouthPos }
			--self.vsoTalkMonsterRpc = world.sendEntityMessage( self.vsoTalkMonster , "vsoSayUpdate", endmsg, entity.id(), mouthPos );
			--self.vsoTalkMonsterRpcMsg = endmsg;
			
			return true;
		end
	end
	return false;
end

function vsoSayAt( msg, targetid )
	vsoFacePoint( world.entityPosition( targetid )[1] );
	return vsoSay( msg, vsoGetSayContext( targetid ) )
end

--@brief Returns true if the talk monster has vanished / last message expired
--Does NOT WORK CORRECTLY mind you since we dont know when the last message finished.
function vsoSayLastCompleted()
	return self.vsoTalkMonsterRpc == nil
	--[[if self.vsoTalkMonster ~= nil then
		--vsoTalkMonsterRpc ?
		if world.entityExists( self.vsoTalkMonster ) then
			return false;
		else
			self.vsoTalkMonster = nil;
		end
	end
	return true;]]--
end

-------------------------------------------------------------------------------

function vsoFaceTarget( targetname )
	local targy = vsoGetTargetId( targetname );
	if targy ~= nil then
		vsoFacePoint( world.entityPosition( targy )[1] );
	end
end

function vsoSound( name )
	--Cross check these later.
	animator.playSound( name );
end

function vsoGetHealth( seatname, defaultvalue )

	if defaultvalue == nil then
		defaultvalue = 1.0;
	end
	local eatenstruct = self.sv.eaten[ seatname ]
	if eatenstruct ~= nil then
		local enthp = world.entityHealth( eatenstruct.id );
		
		return enthp[1] / enthp[2]
	end
	return defaultvalue;
end

function vsoGetHealthPercent( seatname, defaultvalue )
	return 100.0 * vsoGetHealth( seatname );
end 

--We would LIKE to also get RESOURCE percentages too...
--	Huh...
function vsoGetResourceHealthPercent( entityid )
	local enthp = world.entityHealth( entityid );
	if enthp ~= nil then
		return 100.0 * enthp[1] / enthp[2];
	end
	return 0.0
end

-------------------------------------------------------------------------------

function vsoUseLounge( flag, specific )	--Enable/disable the use of a named lounge/seat. If none provided, all are changed.
	if specific ~= nil then
		vehicle.setLoungeEnabled( specific, flag );
		--mcontroller.setAnchorState( self.vsoLoungeNameToIndex[ specific ], flag );
	else
		for k,v in pairs( self.vsoLoungeToTransform ) do
			vehicle.setLoungeEnabled( k, flag );
			--mcontroller.setAnchorState( self.vsoLoungeNameToIndex[ k ], flag );
		end
	end
end

function vsoUseSolid( flag, specific )	--Enable/disable the use of a solid part (platform, box) so others can collide with me. If none provided, all are changed.
	if specific ~= nil then
		vehicle.setMovingCollisionEnabled( specific, flag );
	else
		for k,v in pairs( self.vsoPhysList ) do
			vehicle.setMovingCollisionEnabled( k, flag )
		end
	end
end

-------------------------------------------------------------------------------

function vsoNext( statename )	--Set the next state to use

	self.sv.nextstate = statename;
	if self.sv.ss[ statename ] == nil then
		self.sv.ss[ statename ] = {};
	end
	
	--HEY! It's REALLY easy to have a statename that does NOT have a corresponding function. Detect this please.
	
end

function vsoOnBegin( statename, fn )	--Set the function to call when this state is CHANGED to. (repeated loops in this state ignore Begin)
	
	if self.sv.ss[ statename ] == nil then
		self.sv.ss[ statename ] = {};
	end
	self.sv.ss[ statename ].beginfn = fn;
end

function vsoOnEnd( statename, fn )	--Set the function to call when this state is CHANGED from. (called before the next Begin)

	if self.sv.ss[ statename ] == nil then
		self.sv.ss[ statename ] = {};
	end
	self.sv.ss[ statename ].endfn = fn;
end

function vsoOnInteract( statename, fn )	--Set the function to call when this state has a onInteract event

	if self.sv.ss[ statename ] == nil then
		self.sv.ss[ statename ] = {};
	end
	self.sv.ss[ statename ].interactfn = fn;
end

function vsoOnDamage( statename, fn )	--Set the function to call when this state has a onInteract event

	if self.sv.ss[ statename ] == nil then
		self.sv.ss[ statename ] = {};
	end
	self.sv.ss[ statename ].damagefn = fn;
end

function vsoOnComeHome( statename, fn )	--Set the function to call when this state has a onInteract event

	if self.sv.ss[ statename ] == nil then
		self.sv.ss[ statename ] = {};
	end
	self.sv.ss[ statename ].comehomefn = fn;
end

function vsoOnNPCInputOverride( statename, fn )	--Set the function to call to set NPC default input (rather than random stuff)

	if self.sv.ss[ statename ] == nil then
		self.sv.ss[ statename ] = {};
	end
	self.sv.ss[ statename ].npcoverridefn = fn;
end

function vsoOnDialogResponse( statename, fn )	--Set the function to call to respond to a custon gui input (rather than random stuff)

	if self.sv.ss[ statename ] == nil then
		self.sv.ss[ statename ] = {};
	end
	self.sv.ss[ statename ].dialogresponsefn= fn;
end

-------------------------------------------------------------------------------

function vsoStateFunction( elist, ekey, fn )	--VERY POWERFUL. if you have a buch of ifelse's try using one of these. Add a list to the config, and call it like the example
	if elist[ ekey ] ~= nil then
		return fn( elist[ ekey ], ekey )
	end
	return nil;
end

-------------------------------------------------------------------------------

function vsoTransSet( transformname, x, y, rotdeg )
	animator.resetTransformationGroup( transformname );
	if rotdeg ~= nil then
		animator.rotateTransformationGroup( transformname, rotdeg * 0.01745329251994329576923690768489 );
	end
	if x ~= nil and y ~= nil then
		animator.translateTransformationGroup( transformname, { x, y } );
	end
end

function vsoTransMoveTo( transformname, x, y )
	animator.resetTransformationGroup( transformname );	--sad; no way to keep other properties? How to GET transform 
	animator.translateTransformationGroup( transformname, { x, y } );
end

--FIX THIS so we can have transform animations, not just victim animations...
function vsoTransAnim( transformname, name, animstate )
	
	if self.sv.ta[ transformname ] == nil then
		return false;
	end;
	
	local cstate = self.sv.ta[ transformname ];
	if name == nil then
		return cstate.curr;
	end
	if not cstate.playing then
		cstate.curr = nil;
	end
	if name ~= cstate.curr then
	
		cstate.playing = true;
		
		if self.sv.vakeys[ name ] ~= nil then
		
			cstate.cycle = self.sv.vakeys[ name ];	--What
			cstate.curr = name;
			cstate.currtime = 0.0;
			cstate.visible = true;
			cstate.secondsOverride = nil;
			
			return true;
		elseif self.sv.vafkeys[ name ] ~= nil then
		
			if animstate ~= nil then
			
				local curranim = vsoAnim( animstate );
				
				local adata = nil
				if curranim ~= nil then
					adata = self.vsoAnimStateData[ animstate ][ curranim ]
				end
				
				if adata ~= nil then
				
					--Per frame animations ADJUST to current animation playing in a specific state. Call order matters.
					local adata = self.vsoAnimStateData[ animstate ][ curranim ]
					local framedelta = (adata.cycle / (1.0*adata.frames));
					local framedexes = self.sv.vafkeys[ name ];
					
					local seconds = {};
					for kf,vf in pairs( framedexes ) do
						local frametime = vf * framedelta;
						table.insert( seconds, frametime );
					end
					
					cstate.cycle = adata.cycle;	--What
					cstate.curr = name;
					cstate.currtime = 0.0;
					cstate.visible = true;
					cstate.secondsOverride = seconds;
					
					return true;
				else
					vsoError( "transform animation "..tostring(name).." referenced a state with invalid animation" );
				end
			else
				vsoError( "transform animation "..tostring(name).." uses frames and requires a animation state as a third argument" );
			end
		else
			vsoError( "transform animation "..tostring(name).." does not exist" );
		end
	else
		return cstate.playing;
	end
	return false;
end
function vsoTransAnimReplay( transformname, name, animstate )
	
	local didit = false
	if self.sv.ta[ transformname ] ~= nil then
		didit = vsoTransAnimPlay( transformname, name, animstate )
		self.sv.ta[ transformname ].currtime = 0.0;
	end
	return didit;
	
end
function vsoTransAnimVisible( transformname, flag )
	if self.sv.ta[ transformname ] == nil then
		return false;
	end;
	self.sv.ta[ transformname ].visible = flag;
end

function vsoTransAnimUpdate( transformname, dt )
	
	local cstate = self.sv.ta[ transformname ];
	
	if cstate == nil then
		return false;
	end;
	if not cstate.visible then
		return false;
	end

	--looping or not?
	--Advance a time index, rather than a complete search (for longer animations)
	--local reltime = vso.delTaddClamp( cstate.delt, dt );
	if cstate.playing and cstate.curr ~= nil then
		cstate.currtime = cstate.currtime + dt * self.sv.animspeed;
	else
		return false;
	end
	
	local adata = self.cfgVSO.victimAnimations[ cstate.curr ];
	
	if adata == nil then
		vsoError( "#SYS somehow "..cstate.curr.." does not exist" );
		return false;
	end
	
	if (adata.loop == true) then
		if cstate.currtime >= cstate.cycle then
			cstate.currtime = cstate.currtime - cstate.cycle;
		end
	else
		if cstate.currtime > cstate.cycle then
			cstate.currtime = cstate.cycle;
		end
	end
	
	
	local truetime = cstate.currtime--cstate.delt[1];
	
	local secondsarray = adata.seconds
	if cstate.secondsOverride ~= nil then
		secondsarray = cstate.secondsOverride
	end
	local dex1, dex2, dexdt = _animArrayGetRange( secondsarray, truetime );
					
	local interpfunc = _animArrayInterpListLinear;
	--Interpolation modes? Hmmmm
	if adata.interpMode == 0 then
		interpfunc = _animArrayGetListClamp
		dexdt = 0;
	elseif adata.interpMode == 2 then
		interpfunc = _animArrayInterpListLinear
		dexdt = dexdt * dexdt * (3.0 - 2.0 * dexdt);
	end
	--interpfunc = _animArrayGetListClamp
	
	if adata.x ~= nil then cstate.x = interpfunc( adata.x, dex1, dex2, dexdt ); end
	if adata.y ~= nil then cstate.y = interpfunc( adata.y, dex1, dex2, dexdt ); end
	if adata.xs ~= nil then cstate.xs = interpfunc( adata.xs, dex1, dex2, dexdt ); end
	if adata.ys ~= nil then cstate.ys = interpfunc( adata.ys, dex1, dex2, dexdt); end
	if adata.r ~= nil then cstate.r = interpfunc( adata.r, dex1, dex2, dexdt ); end
	
	--You DONT HAVE TO USE every feature. This should allow "blending" ....
	local hasscale = (cstate.xs ~= 1) or (cstate.ys ~= 1)
	local hasrot = (cstate.r ~= 0)
	local haspos = (cstate.x ~= 0) or (cstate.y ~= 0)
	
	if haspos or hasrot or hasscale then
	
		--compose our own matrix? Hm. Nah.
	
		animator.resetTransformationGroup( transformname );
		if hasscale then
			animator.scaleTransformationGroup( transformname, { cstate.xs, cstate.ys } );
		end
		if hasrot then
			animator.rotateTransformationGroup( transformname, cstate.r * 0.01745329251994329576923690768489 );
		end
		if haspos then
			animator.translateTransformationGroup( transformname, { cstate.x, cstate.y } );
		end
	end
	
	return true;
end

-------------------------------------------------------------------------------


function vsoVictimAnimVisible( seatname, flag )
	if self.sv.va[ seatname ] == nil then
		return false;
	end;
	self.sv.va[ seatname ].visible = flag;
end

function vsoVictimAnimStop( seatname )
	if self.sv.va[ seatname ] == nil then
		return false;
	end;
	
	self.sv.va[ seatname ].playing = false;
	self.sv.va[ seatname ].visible = false;	
end

function vsoVictimAnimTime( seatname )
	local cstate = self.sv.va[ seatname ];
	if cstate ~= nil then
		if cstate.playing then
			return cstate.currtime;
		end
	end
	return 0.0;
end

function vsoVictimAnim( seatname, name, animstate )		--Rate is tied to animRate	self.sv.animspeed
	
	if self.sv.va[ seatname ] == nil then
		return false;
	end;
	
	local cstate = self.sv.va[ seatname ];
	if name == nil then
		return cstate.curr;
	end
	if not cstate.playing then
		cstate.curr = nil;
	end
	if name ~= cstate.curr then
	
		cstate.playing = true;
	
		if self.sv.vakeys[ name ] ~= nil then
		
			cstate.cycle = self.sv.vakeys[ name ];	--What
			cstate.curr = name;
			cstate.currtime = 0.0;
			cstate.visible = true;
			cstate.secondsOverride = nil;
			
			return true;
		elseif self.sv.vafkeys[ name ] ~= nil then
		
			if animstate ~= nil then
			
				local curranim = vsoAnim( animstate );
				
				local adata = nil
				if curranim ~= nil then
					adata = self.vsoAnimStateData[ animstate ][ curranim ]
				end
				
				if adata ~= nil then
				
					--Per frame animations ADJUST to current animation playing in a specific state. Call order matters.
					local adata = self.vsoAnimStateData[ animstate ][ curranim ]
					local framedelta = (adata.cycle / (1.0*adata.frames));
					local framedexes = self.sv.vafkeys[ name ];
					
					local seconds = {};
					for kf,vf in pairs( framedexes ) do
						local frametime = vf * framedelta;
						table.insert( seconds, frametime );
					end
					
					cstate.cycle = adata.cycle;	--What
					cstate.curr = name;
					cstate.currtime = 0.0;
					cstate.visible = true;
					cstate.secondsOverride = seconds;
					
					return true;
				else
					vsoError( "victim animation "..tostring(name).." referenced a state with invalid animation" );
				end
			else
				vsoError( "victim animation "..tostring(name).." uses frames and requires a animation state as a third argument" );
			end
		else
			vsoError( "victim animation "..tostring(name).." does not exist" );
		end
	else
		return true;
	end
	return false;
end
function vsoVictimAnimPlay( seatname, name, animstate )	--Old API fix
	return vsoVictimAnim( seatname, name, animstate )
end

function vsoVictimAnimReplay( seatname, name, animstate )
	local didit = false
	if self.sv.va[ seatname ] ~= nil then
		didit = vsoVictimAnimPlay( seatname, name, animstate )
		self.sv.va[ seatname ].currtime = 0.0;
	end
	return didit;
end



function vsoEffectProjectile( name, options )
	world.spawnProjectile( name, mcontroller.position(), entity.id(), {0,0}, true, options )
end
	--Create warp in particle emission...EntityId 
function vsoEffectWarpIn( options ) vsoEffectProjectile( "spovwarpineffectprojectile", options ); end
function vsoEffectWarpOut( options ) vsoEffectProjectile( "spovwarpouteffectprojectile", options ); end


--These are REALLY inefficient. (for n > 10 lol)
function _ListAddStatus( list, statlist )
	local changed = false;
	for k,v in pairs(statlist) do
		local addme = true;
		for ok,ov in pairs(list) do
			if ov == v then
				addme = false;
				break;
			end
		end
		if addme then
			changed = true;
			table.insert( list, v );
		end
	end
	return changed;
end
	
function _ListRemoveStatus( list, statlist )
	local changed = false;
	for k,v in pairs( statlist ) do
		local removeone = 0;
		for ok,ov in pairs(list) do
			if ov == v then
				removeone = ok;
				break;
			end
		end
		if removeone > 0 then
			table.remove( list, removeone );
			changed = true;
		end
	end
	return changed;
end

function vsoVictimAnimClear( seatname, customorigin, makevisible )
	
	local animpartname = self.vsoLoungeToPart[ seatname ]
	
	--REQUIRES the use of " "properties" : { "centerpoint" : [0.0, 0.0] }   " in your json part states?
	local voff = animator.partPoint( animpartname, "drivingSeatPosition" )	--IMPORTANT! tells us where the transform ACTUALLY is... ("offset" nope. 
	local vorigin = animator.partProperty( animpartname, "drivingSeatPosition")
	local exitpoint = {0,0}
	if customorigin ~= nil then
		vorigin[1] = vorigin[1] + customorigin[1]
		vorigin[2] = vorigin[2] + customorigin[2]
		exitpoint[1] = customorigin[1]
		exitpoint[2] = customorigin[2]
	end

	--sb.logInfo( "voff: "..tostring( voff[2] ).." "..tostring( vorigin[2] )  );
	
	vehicle.setLoungeOrientation( seatname, "stand" )	--hmmmm defaults not exist?
	vehicle.setLoungeDance( seatname )	--clears it
	vehicle.setLoungeEmote( seatname );	--clears it
	
	if makevisible then
		vehicle.setLoungeStatusEffects( seatname, {} );
	else
		vehicle.setLoungeStatusEffects( seatname, {"vsoinvisible"} );	--invisible ? (blink out)	
	end
	
	local cstate = self.sv.va[ seatname ];
	if cstate ~= nil then

		--vsoVictimAnimStop( seatname );	-- set cstate to nil... ultimately...
		self.sv.va[ seatname ].playing = false;
		if makevisible then
			self.sv.va[ seatname ].visible = true;
		else
			self.sv.va[ seatname ].visible = false;
		end
		
		if cstate.curr then
		
			local adata = self.cfgVSO.victimAnimations[ cstate.curr ];
			
			if adata ~= nil then
				if animator.hasTransformationGroup( adata.transformGroup ) then
					animator.resetTransformationGroup( adata.transformGroup );
					animator.transformTransformationGroup( adata.transformGroup, 1, 0, 0, 1, exitpoint[1], exitpoint[2] );
					--animator.resetTransformationGroup( adata.transformGroup );
				end
			end
			
			if voff[1] ~= vorigin[1] or voff[2] ~= vorigin[2] then
				--wait for it...
			else
				self.sv.va[ seatname ].curr = nil;		--Uhhhhh
			end
			
			--sb.logInfo( "stopped: "..tostring( adata.transformGroup )  );
			return false;
		else
			--sb.logInfo( "No state curr: "..tostring( seatname )  );
		end
	else
		--sb.logInfo( "No cstate: "..tostring( seatname )  );
		
		--seat maps to transform group??? Hm.
		
	end
	
	if voff[1] ~= vorigin[1] or voff[2] ~= vorigin[2] then
		return false;
	end
	
	return true;
end

function vsoVictimAnimClearReady( seatname, customorigin, makevisible )
	return vsoVictimAnimClear( seatname, customorigin, makevisible );
--[[
	local cstate = self.sv.va[ seatname ];
	if cstate == nil then
		return true;
	end; 
	
	local adata = self.cfgVSO.victimAnimations[ cstate.curr ];
	
	if adata ~= nil then
	
		--Okay but we ALSO have to reset the EMOTE, ROTATION, 
		--animator.scaleTransformationGroup( adata.transformGroup, { cstate.xs, cstate.ys } );
		--animator.rotateTransformationGroup( adata.transformGroup, cstate.r * 0.01745329251994329576923690768489 );
		--animator.translateTransformationGroup( adata.transformGroup, { cstate.x, cstate.y } );
		--vehicle.setLoungeOrientation( seatname, "stand" )	--hmmmm defaults not exist? Odd...
		if animator.hasTransformationGroup( adata.transformGroup ) then
			animator.resetTransformationGroup( adata.transformGroup );
			--if animator.currentRotationAngle( adata.transformGroup ) == 0 then
				--make sure positio is zero AND scale is zero...
				--animator.animationState(String stateType)
			--end
		end
		if not self.sv.va[ seatname ].playing then
		
			return true;
		end
	end
	
	return vsoVictimAnimClear( seatname );
]]--
end

function vsoVictimAnimSetStatus( seatname, statlist )
	--Warning, problems?
	local cstate = self.sv.va[ seatname ];
	if cstate == nil then
		vehicle.setLoungeStatusEffects( seatname, statlist );
	else
		local isvis = cstate.visible;
		if isvis == true then
			_ListRemoveStatus( statlist, {"vsoinvisible"} )
		else
			_ListAddStatus( statlist, {"vsoinvisible"} )
		end
		cstate.statuslist = statlist
		vehicle.setLoungeStatusEffects( seatname, cstate.statuslist );
	end
end

function vsoVictimAnimAddStatus( seatname, statlist )

	local cstate = self.sv.va[ seatname ];
	if cstate == nil then
		vehicle.setLoungeStatusEffects( seatname, statlist );
	else
		if _ListAddStatus( cstate.statuslist, statlist ) then
			vehicle.setLoungeStatusEffects( seatname, cstate.statuslist );
		end
	end;
end

function vsoVictimAnimUpdate( seatname, dt )

	local cstate = self.sv.va[ seatname ];
	if cstate == nil then
		return false;
	end;
	
	if not cstate.visible then
		--Hm. Not visible victim animation meeeeeans
		if _ListAddStatus( cstate.statuslist, { "vsoinvisible" } ) then
			vehicle.setLoungeStatusEffects( seatname, cstate.statuslist );
		end
		return false;
	end

	--[[
	
				,"effectmap": {
					"0":["vsomask_head5"]
					,"1":["vsomask_head5"]
					,"2":["vsomask_head5"]
					,"3":["vsomask_head3"]
					,"4":["vsomask_head2"]
					,"5":["vsomask_head1"]
					,"6":["vsomask_none"]
				}
				,"transformGroup":"victimposition"
				,"visible": [1,1]
				,"x": [ -0.5, -0.5, -1.0, -3.5, -4.75 ]
				,"y": [ -1.375,-1.375, -1.375, -1.375,-1.75 ]
				,"r": [ 90, 90, 90, 90, 100 ]
				,"e": [ 0, 0, 0, 1, 2, 3, 4, 5, 6 ]
	]]--
	
	--looping or not?
	--Advance a time index, rather than a complete search (for longer animations)
	--local reltime = vso.delTaddClamp( cstate.delt, dt );
	if cstate.playing and cstate.curr ~= nil then
		cstate.currtime = cstate.currtime + dt * self.sv.animspeed;
	else
		return false;
	end
	
	local adata = self.cfgVSO.victimAnimations[ cstate.curr ];
	
	if adata == nil then
		vsoError( "#SYS somehow "..cstate.curr.." does not exist" );
		return false;
	end
	
	if (adata.loop == true) then
		if cstate.currtime >= cstate.cycle then
			cstate.currtime = cstate.currtime - cstate.cycle;
		end
	else
		if cstate.currtime >= cstate.cycle then
			cstate.currtime = cstate.cycle - 0.001;	--END of animation...
		end
	end
	
	
	local truetime = cstate.currtime--cstate.delt[1];
	
	local secondsarray = adata.seconds
	if cstate.secondsOverride ~= nil then
		secondsarray = cstate.secondsOverride
	end
	local dex1, dex2, dexdt = _animArrayGetRange( secondsarray, truetime );
					
	local interpfunc = _animArrayInterpListLinear;
	--local interpfuncdigital = _animArrayGetListClamp_animArrayInterpListRound;
	--Interpolation modes? Hmmmm
	if adata.interpMode == 0 then
		interpfunc = _animArrayGetListClamp
		--interpfuncdigital = _animArrayGetListClamp;
		dexdt = 0;
	elseif adata.interpMode == 2 then
		interpfunc = _animArrayInterpListLinear
		--smooth step interpolation? Lol, by cheating with TIME and LINEAR. Hah, eat it.
		--genType t;  /* Or genDType t; */
		--t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
		--return t * t * (3.0 - 2.0 * t);
		--dexdt = clamp((dexdt - 0) / (1 - 0), 0.0, 1.0);
		dexdt = dexdt * dexdt * (3.0 - 2.0 * dexdt);
	end
	--interpfunc = _animArrayGetListClamp
	
	if adata.x ~= nil then cstate.x = interpfunc( adata.x, dex1, dex2, dexdt ); end
	if adata.y ~= nil then cstate.y = interpfunc( adata.y, dex1, dex2, dexdt ); end
	if adata.xs ~= nil then cstate.xs = interpfunc( adata.xs, dex1, dex2, dexdt ); end
	if adata.ys ~= nil then cstate.ys = interpfunc( adata.ys, dex1, dex2, dexdt); end
	if adata.r ~= nil then cstate.r = interpfunc( adata.r, dex1, dex2, dexdt ); end
	if adata.e ~= nil then cstate.e = _animArrayGetListClamp( adata.e, dex1, dex2, dexdt ) end
	
	if adata.emote ~= nil then
	
		--Did the state CHANGE?
		cstate.emote = _animArrayGetListClamp( adata.emote, dex1, dex2, dexdt );
		if cstate.emote ~= "" then
			vehicle.setLoungeEmote( seatname, cstate.emote )
		else
			vehicle.setLoungeEmote( seatname )
		end
	end
	if adata.dance ~= nil then
		
		cstate.dance = _animArrayGetListClamp( adata.dance, dex1, dex2, dexdt );
		if cstate.dance ~= "" then
			vehicle.setLoungeDance( seatname, cstate.dance )
		else
			vehicle.setLoungeDance( seatname )
		end
	end
	if adata.sitpos ~= nil then
		
		cstate.sitpos = _animArrayGetListClamp( adata.sitpos, dex1, dex2, dexdt );
		if cstate.sitpos == "stand" or cstate.sitpos == "sit" or cstate.sitpos == "lay" then
			--must be "stand" "sit" "lay"
			vehicle.setLoungeOrientation( seatname, cstate.sitpos )
		else
			vehicle.setLoungeOrientation( seatname, "stand" )	--hmmmm defaults not exist?
		end
	end
	
	local isvis = cstate.visible;
	if adata.visible ~= nil then
		local doit = _animArrayGetListClamp( adata.visible, dex1, dex2, dexdt )
		if doit > 0 then
			isvis = true;--
		else
			isvis = false;--adata.visible[ dex1 ];
		end
	end
	
	if isvis == true then
		if _ListRemoveStatus( cstate.statuslist, {"vsoinvisible"} ) then
			--sb.logInfo( "#VSOLOG 1"..tostring( cstate.statuslist ) )
			--for lk, lv in pairs( cstate.statuslist ) do
			--	sb.logInfo( "#VSOLOG 1"..tostring( lv ) )
			--end
			vehicle.setLoungeStatusEffects( seatname, cstate.statuslist );
		end
	else
		if _ListAddStatus( cstate.statuslist, {"vsoinvisible"} ) then
			--sb.logInfo( "#VSOLOG 2"..tostring( cstate.statuslist ) )
			--for lk, lv in pairs( cstate.statuslist ) do
			--	sb.logInfo( "#VSOLOG 2"..tostring( lv ) )
			--end
			vehicle.setLoungeStatusEffects( seatname, cstate.statuslist );
		end
	end
	
	--You DONT HAVE TO USE every feature. This should allow "blending" ....
	local hasscale = (cstate.xs ~= 1) or (cstate.ys ~= 1)
	local hasrot = (cstate.r ~= 0)
	local haspos = (cstate.x ~= 0) or (cstate.y ~= 0)
	
	if haspos or hasrot or hasscale then
	
		--compose our own matrix? Hm. Nah.
	
		animator.resetTransformationGroup( adata.transformGroup );
		if hasscale then
			animator.scaleTransformationGroup( adata.transformGroup, { cstate.xs, cstate.ys } );
		end
		if hasrot then
			animator.rotateTransformationGroup( adata.transformGroup, cstate.r * 0.01745329251994329576923690768489 );
		end
		if haspos then
			animator.translateTransformationGroup( adata.transformGroup, { cstate.x, cstate.y } );
		end
	end
	
	if cstate.e ~= nil then
		if adata.effectmap ~= nil then
			if cstate.eprevious ~= cstate.e then
			
				local nexteffectlist = adata.effectmap[ cstate.e ];
				
				--[[
				if nexteffectlist ~= nil then
					
				else
					nexteffectlist = {};
				end
				
				--Apply effects if we didnt already apply them?
				local applyit = true;
				if cstate.lasteffectlist ~= nil then
					applyit = false;
					if #nexteffectlist == #cstate.lasteffectlist then
						table.sort( nexteffectlist );
						--table.sort( cstate.lasteffectlist );
						for i,v in ipairs( nexteffectlist ) do
							if nexteffectlist[ i ] ~= cstate.lasteffectlist[ i ] then
								applyit = true;
								break
							end
						end
					else
						table.sort( nexteffectlist );
					end
				else
					table.sort( nexteffectlist );
				end
				
				if applyit then
				
					cstate.lasteffectlist = nexteffectlist;
				end
				]]--
				
				if nexteffectlist ~= nil then
				
				else
					nexteffectlist = {};
				end
				
				--Remove last effects? Hm...
				
				local seaterid = vehicle.entityLoungingIn( seatname );
				
				cstate.eprevious = cstate.e
				
				if seaterid ~= nil then
					if #nexteffectlist > 0 then
						
						--sb.logInfo( "next status: "..tostring( nexteffectlist ) );
						--for k,v in ipairs( nexteffectlist ) do
						--	sb.logInfo( tostring( v ) );
						--end
						for i, efex in ipairs( nexteffectlist ) do
							world.sendEntityMessage( seaterid, "applyStatusEffect", efex, 0.2, entity.id() );	--world.sendEntityMessage( vsoGetTargetId( "food" ), "vsoForceInteract", "OpenAiInterface", {}, entity.id() );	--REMOVE velocity just in case?
						end
						--vsoApplyStatusList( vehicle.entityLoungingIn( seatname ), nexteffectlist, 0.2 );
					else
						--sb.logInfo( "clearing status: " );
						
						--vsoRemoveStatusList( nexteffectlist );
						--#ERROR hm.
					end
				else
					cstate.eprevious = nil	--can cause problems!
				end
				cstate.lasteffectlist = nexteffectlist;
					
			end
		end
	end
	
	return true;
end

-------------------------------------------------------------------------------

function _vsoAnimatorDrPanelInputAddSpin( A, v, d )
	v = v + d
	if v > #A then v = 1
	elseif v < 1 then v = #A end
	return v;
end

function vsoAnimatorDrPanelDumpLog( ) 

	--"Save" output to log? Hm... Curious. We should be able to WRITE the animation format we care about so much.

	--SAVE
	local Weol = "\r\n";
	local Wtab = "\t";
	local Wquote = "\"";
	local W = Weol	--{}
	W = W.."***BEGIN VSO Animator Saved Output "..Weol
	W = W.."//Current Transforms"..Weol
	
	--transforms
	for k,TT in pairs( self.AA.transformationGroups ) do
	
		local mx = TT.pos[1]
		local my = TT.pos[2]
		
		local ma = math.cos( TT.rot )
		local mb = math.sin( TT.rot )
		local mc = -math.sin( TT.rot )
		local md = math.cos( TT.rot )
	
		local msx = TT.scale[1];
		local msy = TT.scale[2];
		
		W = W..Wquote..TT.name..Wquote..":{"..Weol
		W = W..Wtab.."x:"..tostring( mx )..Weol
		W = W..Wtab.."y:"..tostring( my )..Weol
		W = W..Wtab.."r:"..tostring( TT.rot )..Weol
		W = W..Wtab.."rdegrees:"..tostring( TT.rot * 57.295779513082320876798154814105 )..Weol
		W = W..Wtab.."sx:"..tostring( msx )..Weol
		W = W..Wtab.."sy:"..tostring( msy )..Weol
		W = W..Wtab.."m:[ "..tostring( msx*ma )..","..tostring( msy*mb )..","..tostring( msx*mc )..","..tostring( msy*md )..","..tostring( mx )..","..tostring( my ).." ]"..Weol
		W = W.."}"..Weol
		
	end
	
	--lounges/seats
	W = W.."//Current Seats"..Weol
	for k,v in pairs( self.AA.allSeatsNameList ) do
	
		local aseati = self.AA.current.seatAnimData[ v ]
		
		W = W..Wquote..v..Wquote..":{"..Weol
		
		W = W..Wtab.."stand:".. self.AA.player.stands[ aseati.standIndex ] ..Weol
		W = W..Wtab.."dance:".. self.AA.player.dances[ aseati.danceIndex ] ..Weol
		W = W..Wtab.."emote:".. self.AA.player.emotes[ aseati.emoteIndex ] ..Weol
		
		W = W.."}"..Weol
		
	end
	
	--states + animations
	W = W.."//Current State Animations"..Weol
	for k,v in pairs( self.AA.allStatesNameList ) do
		W = W..Wquote..v..Wquote..":{"..Weol
		
		local aindex = self.AA.current.stateAnimIndex[ v ];
		local animname = self.AA.allStatesAnimNameLists[ v ][ aindex ];
		local adata = self.AA.allStates[ v ][ animname ];
		--Hm...
		
		W = W..Wtab..Wquote..animname..Wquote..":{"..Weol
		
		--Stuff
		W = W..Wtab..Wtab.."time:".. tostring( self.AA.current.stateAnimTime[ v ] ) ..Weol
		W = W..Wtab..Wtab.."cycle:".. tostring( adata.cycle ) ..Weol
		W = W..Wtab..Wtab.."frames:".. tostring( adata.frames ) ..Weol
		W = W..Wtab..Wtab.."mode:".. tostring( adata.mode ) ..Weol
		W = W..Wtab..Wtab.."transition:".. tostring( adata.transition ) ..Weol
		
		W = W..Wtab.."}"..Weol
		W = W.."}"..Weol
	end
	--coded/keyed user animation?
	
	W = W.."***END VSO Animator Saved Output "
	
	sb.logInfo( W );
end

function vsoAnimatorDrPanelClearAnimationSeat()

	local currseat = self.AA.allSeatsNameList[ self.AA.current.seatIndex ]
	local aseat = self.AA.current.seatAnimData[ currseat ]
	aseat.danceIndex = 1	--ASSUMPTION
	aseat.emoteIndex = 1
	vehicle.setLoungeDance( currseat );
	vehicle.setLoungeEmote( currseat );
end

function vsoAnimatorDrPanelClearAnimationTimes()
	for k,v in pairs( self.AA.current.stateAnimTime ) do
		local curranim = self.AA.allStatesAnimNameLists[ k ][ self.AA.current.stateAnimIndex[ k ] ]
		local adata = self.AA.allStates[ k ][ curranim ];
		self.AA.current.stateAnimTime[ k ] = 0.0;
		vsoAnimReplay( k, curranim )--animator.setAnimationState( k, curranim, true )
	end
end

function vsoAnimatorDrPanelClearAnimationAll()
	--Hmmm...
	vsoAnimatorDrPanelClearAnimationSeat()
	vsoAnimatorDrPanelClearAnimationTimes()
	vsoAnimatorDrPanelClearAnimationTransform()
end

function vsoAnimatorDrPanelClearAnimationTransform()

	local Ti = self.AA.current.transformGroupIndex;
	self.AA.transformationGroups[ Ti ].rot = 0;
	self.AA.transformationGroups[ Ti ].pos[1] = 0;
	self.AA.transformationGroups[ Ti ].pos[2] = 0;
	self.AA.transformationGroups[ Ti ].scale[1] = 1;
	self.AA.transformationGroups[ Ti ].scale[2] = 1;
	self.AA.transformationGroups[ Ti ].shear[1] = 0;
	self.AA.transformationGroups[ Ti ].shear[2] = 0;
	animator.resetTransformationGroup( self.AA.transformationGroups[ Ti ].name )
	
end
		
function vsoAnimatorDrPanelInput( controlname, controlvalue ) 
	
	if self.AA ~= nil then
	
		if controlname == "spinStandPosition" then 
			local aseati = self.AA.current.seatAnimData[ self.AA.allSeatsNameList[ self.AA.current.seatIndex ] ]
			aseati.standIndex = _vsoAnimatorDrPanelInputAddSpin( self.AA.player.stands, aseati.standIndex, controlvalue );
		elseif controlname == "spinDance" then 
			local aseati = self.AA.current.seatAnimData[ self.AA.allSeatsNameList[ self.AA.current.seatIndex ] ]
			aseati.danceIndex = _vsoAnimatorDrPanelInputAddSpin( self.AA.player.dances, aseati.danceIndex, controlvalue );
		elseif controlname == "spinEmote" then 
			local aseati = self.AA.current.seatAnimData[ self.AA.allSeatsNameList[ self.AA.current.seatIndex ] ]
			aseati.emoteIndex = _vsoAnimatorDrPanelInputAddSpin( self.AA.player.emotes, aseati.emoteIndex, controlvalue );
		elseif controlname == "spinAnim" then 
			local currstate = self.AA.allStatesNameList[ self.AA.current.stateNameIndex ]
			self.AA.current.stateAnimIndex[ currstate ] = _vsoAnimatorDrPanelInputAddSpin( self.AA.allStatesAnimNameLists[ currstate ], self.AA.current.stateAnimIndex[ currstate ], controlvalue );
		elseif controlname == "spinTransform" then 
			self.AA.current.transformGroupIndex = _vsoAnimatorDrPanelInputAddSpin( self.AA.transformationGroups, self.AA.current.transformGroupIndex, controlvalue );
		elseif controlname == "spinState" then 
			--State index
			self.AA.current.stateNameIndex = _vsoAnimatorDrPanelInputAddSpin( self.AA.allStatesNameList, self.AA.current.stateNameIndex, controlvalue );
		elseif controlname == "spinSeat" then 
			--Seat index
			self.AA.current.seatIndex = _vsoAnimatorDrPanelInputAddSpin( self.AA.allSeatsNameList, self.AA.current.seatIndex, controlvalue );
		elseif controlname == "spinR" then 
			local prot = self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].rot / self.AA.DTR
			prot = self.AA.rotstepsize * mathround( prot / self.AA.rotstepsize ); 
			prot = prot + controlvalue*self.AA.rotstepsize;
			self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].rot = prot * self.AA.DTR;
		elseif controlname == "spinX" then 
			local px = self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].pos[1];
			px = self.AA.gridsize * mathround( px / self.AA.gridsize ); px = px + controlvalue*self.AA.gridsize;
			self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].pos[1] = px;
		elseif controlname == "spinY" then 
			local py = self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].pos[2];
			py = self.AA.gridsize * mathround( py / self.AA.gridsize ); py = py + controlvalue*self.AA.gridsize;
			self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].pos[2] = py;
		elseif controlname == "checkFx" then 
			--scaleX == - or +
			local pscale = self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].scale[1]
			if pscale > 0 then pscale = -1; elseif pscale < 0 then pscale = 1; end
			self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].scale[1] = pscale
		elseif controlname == "checkFy" then 
			--scaleY == - or +
			local pscale = self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].scale[2]
			if pscale > 0 then pscale = -1; elseif pscale < 0 then pscale = 1; end
			self.AA.transformationGroups[ self.AA.current.transformGroupIndex ].scale[2] = pscale
		elseif controlname == "spinSX" then 
			--Scaling Y? uhm. Dangerous?
		elseif controlname == "spinSY" then 
			--Scaling Y? uhm. Dangerous?
		elseif controlname == "button" and controlvalue == "btnLog" then 
			vsoAnimatorDrPanelDumpLog();
		elseif controlname == "button" and controlvalue == "btnClearAnimationSeat" then 
			vsoAnimatorDrPanelClearAnimationSeat();
		elseif controlname == "button" and controlvalue == "btnClearAnimationTimes" then 
			vsoAnimatorDrPanelClearAnimationTimes();
		elseif controlname == "button" and controlvalue == "btnClearAll" then 
			vsoAnimatorDrPanelClearAnimationAll();
		elseif controlname == "button" and controlvalue == "btnClearAnimationTransform" then 
			vsoAnimatorDrPanelClearAnimationTransform();
		else
			vsoInfo( "vsoAnimatorPanelControl "..tostring( controlname ).." = "..tostring( controlvalue ) );
		end
	end
end

function vsoAnimatorDrPanelGet( key ) 

	if self.AA ~= nil then
		if key == "transformGroups" then
			return self.AA.transformationGroups
		elseif key == "current" then
			return self.AA.current
		elseif key == "animationList" then
			return {
				allSeatsNameList = self.AA.allSeatsNameList
				,allStatesNameList = self.AA.allStatesNameList
				,allStatesAnimNameLists = self.AA.allStatesAnimNameLists
				,allStates = self.AA.allStates
			}
			--return self.AA.allAnimationsList
		elseif key == "playerLists" then
			return self.AA.player
		end
	end
	return nil;
end

function vsoAnimatorDataGet( animationpath, animationfilename )

	if animationpath == nil then
		vsoError( "vsoAnimatorDataGet missing \"directoryPath\" in config" )
		return nil
	end
	if animationfilename == nil then
		vsoError( "vsoAnimatorDataGet missing \"animation\" in config" )
		return nil
	end

	local AA = {};
		
	AA.animatorName = animationfilename	--config.getParameter( "animation", nil )
	AA.animatorPath = animationpath
	
	AA.animatorData = root.assetJson( animationpath .. AA.animatorName )
	
	AA.transformationGroups = {};
	for k,v in pairs( AA.animatorData.transformationGroups ) do
	
		animator.resetTransformationGroup( k )
	
		table.insert( AA.transformationGroups,
			{
				name = k
				,index = #AA.transformationGroups
				,pos={ 0.0, 0.0 }
				,rot = 0.0
				,scale = { 1.0,1.0 }
				,shear = { 0.0,0.0 }
				,matrix = {1.0,0.0,0.0,1.0,0.0,0.0}
			}
		);
		
	end
	
	--All the animation states possible (maps to a MAP of animations, [state][animation] = data
	AA.allStates = {};
	AA.allStatesNameList = {};	--List of all  states mapped to name in allStates[ state ]
	AA.allStatesAnimNameLists = {};	--List of all anims for a named state, mapped to allStates[ state ][ anim ]
	AA.allSeats = {};
	AA.allSeatsNameList = {};
	--you can animate different states at different times
	--But you can only animate transform groups as a whole
	
	for k,v in pairs( self.vsoLoungeToTransform ) do
		AA.allSeats[ k ] = v
		table.insert( AA.allSeatsNameList, k )
	end

	--Hm!
	--"valueSeat"	-- Which currently selected seat am I editing for the victim
		--AA.allSeatsNameList[ AA.current.seatIndex ] ?
	--"valueState"	--What animation state am I changing? (each state can only have 1 anim)
		--AA.allStatesNameList[ AA.current.stateNameIndex ]
	--"valueAnim"	--What animation IN the current state am I changing? (must store per each state the local index)
		--AA.allStatesAnimNameLists[ AA.current.stateAnimIndex[ AA.allStatesNameList[  AA.current.stateNameIndex ] ] ]
	--	-> Fix this
	
	
	--All the possible animations???
	AA.allAnimationsList = {};
	for kstate,vstate in pairs( AA.animatorData.animatedParts.stateTypes ) do
	
		AA.allStates[ kstate ] = {};
		AA.allStatesAnimNameLists[ kstate ] = {};
		
		table.insert( AA.allStatesNameList, kstate )
			
		local defaultstate = vstate.default
		for kanim,vanim in pairs( vstate.states ) do
		
			local animid = #AA.allAnimationsList;
			
			local animblock = {
					index = animid + 1,
					name = kanim,
					state = kstate,
					default = defaultstate,
					frames = vanim.frames,
					cycle = vanim.cycle,
					mode = vanim.mode,
					transition = vanim.transition,
				}
			
			table.insert( AA.allAnimationsList, animblock )
			
			animblock.index = 1 + #AA.allStatesAnimNameLists[ kstate ]
			
			table.insert( AA.allStatesAnimNameLists[ kstate ], kanim )
				
			AA.allStates[ kstate ][ kanim ] = animblock
		end
			
	end
	
	
	--translattion grid size
	AA.gridsize = 1/8.0;
	AA.gridheldsize = 8;
	--rotation angle step size
	AA.DTR = 0.01745329251994329576923690768489;
	AA.rotstepsize = 5;-- * 0.01745329251994329576923690768489;
	AA.rotheldstepsize = 90;-- * 0.01745329251994329576923690768489;
	
	--Known player emotes.
	AA.player = {}
	AA.player.emotes = {	--from emotes.config. should load that instead.
		""
		,"idle"
		,"happy"-- : [ ":)", "^_^", "\\o/", ":-)" ],
		,"sad"-- : [ ":'(" ],
		,"neutral"-- : [ ":|", ":-|", "-_-" ],
		,"laugh"-- : [ ":D", "XD", ":-D" ],
		,"annoyed"-- : [ ">:|", "<_<", ":(", ":-(" ],
		,"oh" --: [ ":o", "o.O", "O.o" ],
		,"oooh"-- : [ ":O", "O.O" ],
		,"wink"-- : [ ";)", ";-)" ]
		,"sleep"
	}

	--Fixed list of sit stand postiions. Might be more?
	--AA.player.stands = { "stand", "sit", "lay" }
	AA.player.stands = { "stand", "sit", "lay" }	--"fall", "duck", "walk", "run", "swim", "fly" not available in vehicles.
	
	--Dances can EASILY be made custom! crazy... and there are a lot of them
	--Hm.
	AA.player.dances = { ""
		,"armswingdance"
		,"comfort"
		,"crouchcollect"
		,"crouchwarm"
		,"drink"
		,"estherhover"
		,"flipswitch"
		,"hylotldance"
		,"koichihologramfading"
		,"koichihologramstanding"
		,"koichihologramstudying"
		,"mourn"
		,"posedance"
		,"postmail"
		,"pressbutton"
		,"punch"
		,"sell"
		,"steer"
		,"titanic"
		,"tonauacdoorlifting"
		,"typing"
		,"warmhands"
		,"wave"
		,"wiggledance"
		,"victimrun"
		,"victimsquirm"
		,"victimwalk"
	}
	
	--Custom dances? Hm...
		
	AA.current = {
		transformGroupIndex = 1	--hm!
		--,animationIndex = 1
		--,animTime = 0.0
		,stateAnimTime = {}
		,lastAnimRate = 1.0
		,animRate = 0.0
		,stateNameIndex = 1	--AA.allStatesNameList
		,stateAnimIndex = {}	--AA.allStatesAnimNameLists	maps state -> anim index
		--,playerEmoteIndex = 1
		--,playerStandIndex = 1
		--,playerDanceIndex = 1
		,seatIndex = 1	--AA.allSeatsNameList
		,seatAnimData = {}	--AA.allStatesAnimNameLists	maps seat -> anim indexes
	}
	for k,v in pairs( AA.allStatesNameList ) do
		AA.current.stateAnimIndex[ v ] = 1;
		AA.current.stateAnimTime[ v ] = 0.0;
	end
	for k,v in pairs( AA.allSeatsNameList ) do
		AA.current.seatAnimData[ v ] = {
			emoteIndex = 1
			,standIndex = 1
			,danceIndex = 1
		};
	end
	
	vsoAnimSpeed( AA.current.animRate );
	AA.current.lastAnimRate = AA.current.animRate;
	
	return AA;
end

function vsoAnimatorDr( dt ) 

	--Requires a "driver", any driver ?
	local kill = false;
	if self.A == nil then

		message.setHandler("vsoAnimatorPanelInit",
			function(_, _, ownerCheck )
				self.A.ownerCheck = ownerCheck;
				--vsoInfo( "vsoAnimatorPanelInit "..tostring( ownerCheck ).." "..tostring( entity.id() ) );
			end)

		message.setHandler("vsoAnimatorPanelControl",
			function(_, _, controlname, controlvalue )
				vsoAnimatorDrPanelInput( controlname, controlvalue )
			end)
			
		message.setHandler("vsoAnimatorPanelGet",
			function(_, _, parama )
				return vsoAnimatorDrPanelGet( parama )
			end)
		
		self.A = {};	--Stores stuff
		
		self.A.inputs = {};
		
		--So much to LOAD
		self.AA = vsoAnimatorDataGet( config.getParameter( "directoryPath", nil ), config.getParameter( "animation", nil ) )
		if self.AA == nil then
			kill = true;
		end
		
		--Okay we have a lot loaded. Now,
		
	else
		
		--Abstractio
		local inA = false;--inputs.A > 0;
		local inB = false;--inputs.B > 0;
		local inJ = false;--inputs.J > 0;
		local inL = false;--inputs.Ltap > 0;
		local inR = false;--inputs.Rtap > 0;
		local inU = false;--inputs.Utap > 0;
		local inD = false;--inputs.Dtap > 0;
		local inLtime = 0;--inputs.Ltap > 0;
		local inRtime = 0;--inputs.Rtap > 0;
		local inUtime = 0;--inputs.Utap > 0;
		local inDtime = 0;--inputs.Dtap > 0;
		local inJtap = false;--inputs.Jtap > 0;
		local inJrelease = false;--inputs.Jrelease > 0;
		
		--Update all inputs AGGRESSIVELY (lol)
		for k,v in pairs( self.vsoLoungeToTransform ) do
		
			if vehicle.entityLoungingIn( k ) then
				if self.A.inputs[k] == nil then
					self.A.inputs[k] = vsoInputCreate( k );
				end
				vsoInputUpdate( k, self.A.inputs[k], dt )
				
				local I = self.A.inputs[k];
				inA = inA or I.A > 0;
				inB = inB or I.B > 0;
				inJ = inJ or I.J > 0;
				inL = inL or I.Lt > 0;
				inR = inR or I.Rt > 0;
				inU = inU or I.Ut > 0;
				inD = inD or I.Dt > 0;
				inLtime = math.max( inLtime, I.L );
				inRtime = math.max( inRtime, I.R );
				inUtime = math.max( inUtime, I.U );
				inDtime = math.max( inDtime, I.D );
				inJtap = inJtap or I.Jt > 0;
				inJrelease = inJrelease or I.Jr > 0;
				
				if self.A.inputs[k].specialEscape == 1 then
					kill = true;
				end
			else
				self.A.inputs[k] = nil;
			end
		end
		
		local AA = self.AA;
		
		if not kill then
		
			if inJ then
			
				if inJrelease then
				
					--SAVE current quantized keyframe? t = math.round( time * 20 )
				end
					
				AA.current.animRate = 1.0;
				
				--UPDATE transformations from stored values:
				
			else
			
				AA.current.animRate = 0.0;
				
				if inA and inB then
				
					--Emotes? Dance? ...
				
				elseif not inA and inB then
				
					local prot = AA.transformationGroups[ AA.current.transformGroupIndex ].rot / AA.DTR;
					
					if inL then prot = AA.rotstepsize * mathround( prot / AA.rotstepsize ); prot = prot - AA.rotstepsize; end
					if inR then prot = AA.rotstepsize * mathround( prot / AA.rotstepsize ); prot = prot + AA.rotstepsize; end
					
					if inLtime > 0.5 then prot = prot - dt*AA.rotheldstepsize; end
					if inRtime > 0.5 then prot = prot + dt*AA.rotheldstepsize; end
					
					AA.transformationGroups[ AA.current.transformGroupIndex ].rot = prot * AA.DTR;
					
					--Shearing? Scaling? Flipping?
					
					local pscale = AA.transformationGroups[ AA.current.transformGroupIndex ].scale
					
					if inU then 
						if pscale[1] > 0 then
							pscale[1] = -1;
						elseif pscale[1] < 0 then
							pscale[1] = 1;
						end
					end
					--y flipping is NOT a good idea. change group focus???? (compositing?)
					--if inD then 
					--	if pscale[2] > 0 then
					--		pscale[2] = -1;
					--	elseif pscale[2] < 0 then
					--		pscale[2] = 1;
					--	end
					--end
					
					AA.transformationGroups[ AA.current.transformGroupIndex ].scale = pscale
					
				elseif inA and not inB then
				
					local px = AA.transformationGroups[ AA.current.transformGroupIndex ].pos[1];
					local py = AA.transformationGroups[ AA.current.transformGroupIndex ].pos[2];
					
					if inL then px = AA.gridsize * mathround( px / AA.gridsize ); px = px - AA.gridsize;end
					if inR then px = AA.gridsize * mathround( px / AA.gridsize ); px = px + AA.gridsize; end
					if inD then py = AA.gridsize * mathround( py / AA.gridsize ); py = py - AA.gridsize; end
					if inU then py = AA.gridsize * mathround( py / AA.gridsize ); py = py + AA.gridsize; end
					
					if inLtime > 0.5 then px = px - dt*AA.gridheldsize; end
					if inRtime > 0.5 then px = px + dt*AA.gridheldsize; end
					if inDtime > 0.5 then py = py - dt*AA.gridheldsize; end
					if inUtime > 0.5 then py = py + dt*AA.gridheldsize; end
					
					AA.transformationGroups[ AA.current.transformGroupIndex ].pos[1] = px;
					AA.transformationGroups[ AA.current.transformGroupIndex ].pos[2] = py;
				else
				
					--Parts
					if inL then
						AA.current.transformGroupIndex  = AA.current.transformGroupIndex  - 1;
						if AA.current.transformGroupIndex  < 1 then
							AA.current.transformGroupIndex  = #AA.transformationGroups
						end
						vsoSay( AA.transformationGroups[ AA.current.transformGroupIndex ].name );
					end
					if inR then
						AA.current.transformGroupIndex  = AA.current.transformGroupIndex  + 1;
						if AA.current.transformGroupIndex  > #AA.transformationGroups then
							AA.current.transformGroupIndex  = 1
						end
						vsoSay( AA.transformationGroups[ AA.current.transformGroupIndex ].name );
					end
					
					--Animations?
					--[[
					if inU then
						AA.current.animationIndex  = AA.current.animationIndex  - 1;
						if AA.current.animationIndex  < 1 then
							AA.current.animationIndex  = #AA.allAnimationsList
						end
						vsoSay( AA.allAnimationsList[ AA.current.animationIndex ].name );
						
					end
					if inD then
						AA.current.animationIndex  = AA.current.animationIndex  + 1;
						if AA.current.animationIndex  > #AA.allAnimationsList then
							AA.current.animationIndex  = 1
						end
						vsoSay( AA.allAnimationsList[ AA.current.animationIndex ].name );
						
					end
					]]--
					if inU then
						local currstate = AA.allStatesNameList[  AA.current.stateNameIndex ]
						AA.current.stateAnimIndex[ currstate ] = AA.current.stateAnimIndex[ currstate ] + 1;
						if AA.current.stateAnimIndex[ currstate ]  > #AA.allStatesAnimNameLists[ currstate ] then
							AA.current.stateAnimIndex[ currstate ] = 1
						elseif AA.current.stateAnimIndex[ currstate ]  < 1 then
							AA.current.stateAnimIndex[ currstate ] = #AA.allStatesAnimNameLists[ currstate ]
						end
					end
					if inD then
						local currstate = AA.allStatesNameList[  AA.current.stateNameIndex ]
						AA.current.stateAnimIndex[ currstate ] = AA.current.stateAnimIndex[ currstate ] - 1;
						if AA.current.stateAnimIndex[ currstate ]  > #AA.allStatesAnimNameLists[ currstate ] then
							AA.current.stateAnimIndex[ currstate ] = 1
						elseif AA.current.stateAnimIndex[ currstate ]  < 1 then
							AA.current.stateAnimIndex[ currstate ] = #AA.allStatesAnimNameLists[ currstate ]
						end
					end
				
				end
				
			end
			
			--Change animation rate
			if AA.current.lastAnimRate ~= AA.current.animRate then
				vsoAnimSpeed( AA.current.animRate );
			end
			
			if AA.current.animRate ~= 0 then
			
				--[[
				--Check for looping issues...
				--we KNOW the cycle for this animation.
				local currstate = AA.allStatesNameList[ AA.current.stateNameIndex ]
				local curranim = AA.allStatesAnimNameLists[ currstate ][ AA.current.stateAnimIndex[ currstate ] ]
				local adata = AA.allStates[ currstate ][ curranim ];
				
				local acycle = adata.cycle;
				--local acycle = AA.allAnimationsList[ AA.current.animationIndex ].cycle;
				--local acycle = AA.allAnimationsList[ AA.current.animationIndex ].cycle;
				if acycle == nil then
					AA.current.animTime = 0;	--the heck, this is YOUR fault
				else
					AA.current.animTime = AA.current.animTime + dt;
					if AA.current.animTime > acycle then
						AA.current.animTime = AA.current.animTime - acycle
						AA.current.animTime = 0;
						animator.setAnimationState( currstate, curranim, true )
					end
				end
				]]--
				
				for k,v in pairs( AA.current.stateAnimTime ) do
				
					local currstate = k;--AA.allStatesNameList[ AA.current.stateNameIndex ]
					local curranim = AA.allStatesAnimNameLists[ currstate ][ AA.current.stateAnimIndex[ currstate ] ]
					local adata = AA.allStates[ currstate ][ curranim ];
					
					local currt = v;
					
					local acycle = adata.cycle;
					--local acycle = AA.allAnimationsList[ AA.current.animationIndex ].cycle;
					--local acycle = AA.allAnimationsList[ AA.current.animationIndex ].cycle;
					if acycle == nil then
						currt = 0;	--the heck, this is YOUR fault
					else
						currt = currt + dt;
						if currt > acycle then
							currt = currt - acycle
							currt = 0;
							vsoAnimReplay( currstate, curranim )--animator.setAnimationState( currstate, curranim, true )
						end
						AA.current.stateAnimTime[ currstate ] = currt;
					end
					
				end
				
				
			end
			AA.current.lastAnimRate = AA.current.animRate;
			
			--Change animation
			local currstate = AA.allStatesNameList[ AA.current.stateNameIndex ]
			local curranim = AA.allStatesAnimNameLists[ currstate ][ AA.current.stateAnimIndex[ currstate ] ]
			--local adata = AA.allStates[ currstate ][ curranim ];
			
			--if animator.animationState( AA.allAnimationsList[ AA.current.animationIndex ].state ) ~= AA.allAnimationsList[ AA.current.animationIndex ].name then
			
			--	animator.setAnimationState( AA.allAnimationsList[ AA.current.animationIndex ].state, AA.allAnimationsList[ AA.current.animationIndex ].name, true )
			--	AA.current.animTime = 0;
			--end
			if animator.animationState( currstate ) ~= curranim then
			
				vsoAnimReplay( currstate, curranim )--animator.setAnimationState( currstate, curranim, true )
				AA.current.stateAnimTime[ currstate ] = 0.0;
				--AA.current.animTime = 0;
			end
					
			--Update transformations
			for k,TT in pairs( AA.transformationGroups ) do
			
				animator.resetTransformationGroup( TT.name )
				
				local mx = TT.pos[1]	--Make crunchy? quantize to pixels??? bah.
				local my = TT.pos[2]
				
				local ma = math.cos( -TT.rot )	--I think the rotation convention is reversed from what I'm doing
				local mb = math.sin( -TT.rot )
				local mc = -math.sin( -TT.rot )
				local md = math.cos( -TT.rot )
				
				local msx = TT.scale[1];
				local msy = TT.scale[2];
				
				animator.transformTransformationGroup( TT.name, msx*ma, msy*mb, msx*mc, msy*md, mx, my )
			
			end
			
			--Apply masking
			--animator.setEffectActive
			
			--Play sounds at a specific position
			--	NOTE that we can load a generic sound pool (rather than defining a LOT in the animatorion file)
			--animator.setSoundPool(String soundName, List<String> soundPool)
			--animator.setSoundPosition(String soundName, Vec2F position)
			--animator.playSound(String soundName, [int loops = 0])
			--animator.setSoundVolume(String soundName, float volume, float rampTime)
			--animator.setSoundPitch(String soundName, float pitch, [float rampTime = 0.0])
			--animator.stopAllSounds(String soundName)
			
			for k,v in pairs( AA.current.seatAnimData ) do
			
				vehicle.setLoungeOrientation( k, AA.player.stands[ v.standIndex ] );
				
				if AA.player.dances[ v.danceIndex ] ~= "" then
					vehicle.setLoungeDance( k, AA.player.dances[ v.danceIndex ] )
				else
					vehicle.setLoungeDance( k );
				end
				
				if AA.player.emotes[ v.emoteIndex ] ~= "" then
					vehicle.setLoungeEmote( k, AA.player.emotes[ v.emoteIndex ] )
				else
					vehicle.setLoungeEmote( k );
				end
				
			end
		
			--for k,v in pairs( self.vsoLoungeToTransform ) do
			
				--Each seat has it's OWN stand, dance and emote.
				--And status effects and things of that nature.
			
				--// Idle, Walk, Run, Jump, Fall, Swim, SwimIdle, Duck, Sit, Lay
				--Dance list is needed... Hm.
				--Emote list is needed... fairly static
	
				--vehicle.setLoungeOrientation( k, AA.player.stands[ AA.current.playerStandIndex ] )
				--if AA.player.dances[ AA.current.playerDanceIndex ] ~= "" then
				--	vehicle.setLoungeDance( k, AA.player.dances[ AA.current.playerDanceIndex ] )
				--else
				--	vehicle.setLoungeDance( k )
				--end
				--vehicle.setLoungeEmote( k, AA.player.emotes[ AA.current.playerEmoteIndex ] )
				
			--end
		end
	end

	if not kill then
		return true;	--Until they "stop" with that magic input stroke?
	end
	
	--RESTORE everything the way it was. (somewhat)
	for k,TT in pairs( self.AA.transformationGroups ) do
		animator.resetTransformationGroup( TT.name )
	end

	--Remove stuff
	message.setHandler("vsoAnimatorPanelInit", nil );	--kill message handlers
	message.setHandler("vsoAnimatorPanelControl", nil );	--kill message handlers
	message.setHandler("vsoAnimatorPanelGet", nil );	--kill message handlers
	
	--'Remove' variables
	self.A = nil;
	self.AA = nil;
	
	return false;
end


--------------------------------------------------------------------------------
--MOVEMENT---------------------------------------------------------------------
--------------------------------------------------------------------------------
--	Had to change a lot of this (No way to use existing pathing system) and copy paste a new pathing system
--		Because vehicles dont have mcontroller.boundBox()			( In vehicles it is mcontroller.localBoundBox() )
--		Because vehicles dont have mcontroller.baseParameters()		( In vehicles it is mcontroller.parameters() )
--		Because vehicles dont have mcontroller.facingDirection()		( In vehicles it does not exist so we use self.vsoCurrentDirection )
--

function followActionApproachPoint(dt, targetPosition, stopDistance, running)
  local toTarget = world.distance(targetPosition, mcontroller.position())
  local targetDistance = world.magnitude(targetPosition, mcontroller.position())
  --local groundPosition = findGroundPosition( targetPosition, -20, 1, util.toDirection(-toTarget[1]) )
  --Want to be EVEN with them, not UNDER them (you can adjust that with the -20, 1 argument...)
  local groundPosition = findGroundPosition( targetPosition, -4, 1, true, {"Null", "Block", "Dynamic", "Platform"} )	--{"Null", "Block", "Dynamic", "Platform"}

  if groundPosition then
    self.approachPosition = groundPosition
  end
  if self.pather == nil then
  
	self.pather = PathMover:new( 
	{	run = running
		,pathOptions = {
			mustEndOnGround = false
			,openDoorCallback = nil
		}	
	} )	--Where is PathMover ?
  end
  self.pather.options.run = running
  
  if self.approachPosition and ( targetDistance > stopDistance or not mcontroller.onGround() ) then
  
    local whatdo = self.pather:move(self.approachPosition, dt);
	if whatdo == "running" then
	  mControlFace( self.pather.deltaX or toTarget[1] )
	elseif whatdo == "pathfinding" then
      self.motionControls.x = 0;	--Hm, thinking
	else
	  --
	end
	
    return false
  elseif targetDistance <= stopDistance then
    return true
  end
end

--------------------------------------------------------------------------------
--[[
function move(direction, options)
  if options == nil then options = {} end
  if options.run == nil then options.run = false end
  direction = util.toDirection(direction)

  local position = mcontroller.position()
  local boundsEdge = 0
  local bounds = mBoundBox()
  local tilePosition
  if direction > 0 then
    tilePosition = {math.ceil(position[1]), position[2]}
    boundsEdge = bounds[3]
  else
    tilePosition = {math.floor(position[1]), position[2]}
    boundsEdge = bounds[1]
  end

  --Stop at walls
  if world.lineTileCollision({position[1], position[2] + bounds[2] + 1.5}, { position[1] + boundsEdge + direction, position[2] + bounds[2] + 1.5}, {"Null", "Block", "Dynamic", "Platform"}) then
    return false, "wall"
  end

  --Check if the position ahead is valid, including slopes
  local yDirs = {0, 1, -1}
  for _,yDir in ipairs(yDirs) do
    if validStandingPosition( {tilePosition[1] + direction, tilePosition[2] + yDir}, true, {"Null", "Block", "Dynamic", "Platform"}, bounds ) then
      moveX(direction, options.run)
      return true
    end
  end

  return false, "ledge"
end
]]--

function followActionEnterWith( args )
  if not args.followTarget then return nil end

  local startDistance = 3;--config.getParameter("actionParams.follow.startDistance", 6)
  local targetPosition = world.entityPosition( args.followTarget )
  
  --sb.logInfo( tostring( targetPosition ).." " ..tostring( args.followTarget ).." "..tostring( mcontroller.position() ) )
  --targetPosition can be undefined??? no! (closing/simple error)
  if targetPosition ~= nil then
	  
	  local targetDistance = world.magnitude(targetPosition, mcontroller.position())
	  if targetDistance < startDistance or not entity.entityInSight(args.followTarget) then
		--return nil
	  end

	  return {
		targetId = args.followTarget,
		stopDistance = 2.5;--config.getParameter("actionParams.follow.stopDistance", 3),
		startDistance = startDistance,
		runDistance = 20;--config.getParameter("actionParams.follow.runDistance", 20),
		running = false,
		waiting = false,
		boredTimer = 5;--config.getParameter("actionParams.follow.boredTime", 3)
	  }
  end
  return nil
end

function followActionUpdate(dt, stateData)
  if not world.entityExists(stateData.targetId) then return true end

  local targetPosition = world.entityPosition(stateData.targetId)
  local targetDistance = world.magnitude(targetPosition, mcontroller.position())

  if targetDistance > stateData.runDistance then
    stateData.running = true
  end

  if targetDistance > stateData.startDistance then
    stateData.waiting = false
  end

  if not stateData.waiting and followActionApproachPoint( dt, targetPosition, stateData.stopDistance, stateData.running ) then
    stateData.waiting = true
    stateData.running = false

    --stateData.boredTimer = stateData.boredTimer - dt
    --if stateData.boredTimer <= 0 or self.pathing.stuck then
    --  return true, 15--config.getParameter("actionParams.follow.cooldown", 15)
    --end
  elseif stateData.waiting then
	
	self.motionControls.x = 0;	--Uhhhmmmm
    --mcontroller.setXVelocity(0);
    --setIdleState()
	--sb.logInfo( "wiating" );
  end

  --if status.resource("curiosity") <= 0 or self.pathing.stuck then
  --  return true, 15--config.getParameter("actionParams.follow.cooldown", 15)
  --end
  
  return false, 0;	--State remains
end



function monsterActionEnterWith( args )

	local obstacleHeightThreshold= args.obstacleHeightThreshold
	local obstacleLookaheadDistance= args.obstacleLookaheadDistance
	local setAnimationState=args.setAnimationState
	
  local bounds = config.getParameter("metaBoundBox")	--whaaaat
  local width = bounds[3] - bounds[1]
  local jumpDirection = nil

  local jump = function(direction)
    jumpDirection = direction
    mControlJump()
    setAnimationState("jump")
  end

  local klass = {}
  function klass.move(position, direction, traverseObstacles, run)
    if not mcontroller.onGround() and jumpDirection ~= nil then
      mControlJumpHold()
      moveX(jumpDirection, run)

      return true
    end

    local positionedBounds = {
      bounds[1] + position[1],
      bounds[2] + position[2],
      bounds[3] + position[1],
      bounds[4] + position[2]
    }

    -- Jump over obstacles
    local jumpRegion = { positionedBounds[1], positionedBounds[2] + obstacleHeightThreshold, positionedBounds[3], positionedBounds[4] }
    if direction > 0 then
      jumpRegion[1] = jumpRegion[1] + width
      jumpRegion[3] = jumpRegion[3] + obstacleLookaheadDistance
    else
      jumpRegion[1] = jumpRegion[1] - obstacleLookaheadDistance
      jumpRegion[3] = jumpRegion[3] - width
    end

    if world.rectCollision(jumpRegion, {"Null", "Block", "Dynamic"}) then
      local jumpClearanceRegion = {
        positionedBounds[1] + direction * (positionedBounds[3] - positionedBounds[1]),
        positionedBounds[2] + obstacleHeightThreshold + 0.125,
        positionedBounds[3] + direction * (obstacleLookaheadDistance + positionedBounds[3] - positionedBounds[1]),
        positionedBounds[4] + obstacleHeightThreshold
      }
      if direction > 0 then
        jumpClearanceRegion[1] = jumpClearanceRegion[1] + width
        jumpClearanceRegion[3] = jumpClearanceRegion[3] + (obstacleLookaheadDistance + width)
      else
        jumpClearanceRegion[1] = jumpClearanceRegion[1] - (obstacleLookaheadDistance + width)
        jumpClearanceRegion[3] = jumpClearanceRegion[3] - width
      end
      if not world.rectCollision(jumpClearanceRegion, {"Null", "Block", "Dynamic"}) then
        if traverseObstacles then
          jump(direction)
        end

        return traverseObstacles
      end
    end

    -- Jump over gaps
    local gapRegion = { positionedBounds[1], positionedBounds[2] - obstacleLookaheadDistance, positionedBounds[3], positionedBounds[2] }
    if direction > 0 then
      gapRegion[1] = gapRegion[1] + width
      gapRegion[3] = gapRegion[3] + width / 2
    else
      gapRegion[1] = gapRegion[1] - width / 2
      gapRegion[3] = gapRegion[3] - width
    end

    if not world.rectCollision(gapRegion, {"Null", "Block", "Dynamic", "Platform"}) then
      if traverseObstacles then
        jump(direction)
      end

      return traverseObstacles
    end

    jumpDirection = nil

    if not traverseObstacles then
      local blockedRect = {
        positionedBounds[1] + direction, positionedBounds[2] + 1,
        positionedBounds[3] + direction, positionedBounds[4]
      }
      if world.rectCollision(blockedRect, {"Null", "Block", "Dynamic"}) then
        return false
      end
    end

    setAnimationState("run")
    moveX(direction, run)

    return true
  end

  klass.targetId = args.followTarget
  
  return klass
end

function monsterActionUpdate(dt, stateData)

	--Pathing toward this target? Hmmm... And do the jump and avoid stuff? 
	--		stateData.targetId

	--toggle the running, direction and position and traversing obstacles?
	local retty = stateData.move( position, direction, true, false )
	--stateData.move( position, direction, traverseObstacles, run )
end

function vsoActSet( args, actcreate, actupdate )--followAction )
	if self.vsoAction == nil then
		local newact = actcreate( args )
		if newact ~= nil then
			newact.type = actupdate
			self.vsoAction = newact
			return true;
		end
	elseif self.vsoAction.type ~= actupdate then
		local newact = actcreate( args )
		if newact ~= nil then
			newact.type = actupdate
			self.vsoAction = newact
			return true;
		end
	else
		--Update arguments? args
	end
	return false;
end

function vsoActFollow( targetit )--followAction )
	return vsoActSet( { followTarget=targetit }, followActionEnterWith, followActionUpdate )
end

--Also copy paste in (other actions)
--	monsters/groundMovement
--	returnHomeState
--	

function vsoActMonster( targetit )--followAction )
	return vsoActSet(
		{
			followTarget=targetit
			,obstacleHeightThreshold=2
			,obstacleLookaheadDistance=3
			,setAnimationState= function(v) end
		}
		, monsterActionEnterWith, monsterActionUpdate 
	)
end

--Does this even work? Huh...
--function setupTenant(...)
--  require("/scripts/tenant.lua")
--  tenant.setHome(...)
--end

--mcontroller.controlParameters({collisionPoly = collisionPoly, standingPoly = collisionPoly, crouchingPoly = collisionPoly})
	  
function vsoPolyPath( t0, t1, cuts, coeff )
	--Generate points on a polynomial with coefficients from high to low, by cuts
	local R = {};
	local dcut = (t1 - t0)/(cuts+1.0);
	local cutcount = 0;
	local cmax = #coeff;
	if cmax > 0 then
		while cutcount <= cuts do
			local tv = t0 + cutcount*dcut
			local v = 0.0;
			v = v + coeff[1]
			local coefi = 2;
			local tmul = tv;
			while coefi <= cmax do
				v = v + tmul*coeff[coefi]
				tmul = tmul * tv;
				coefi = coefi + 1;
			end
			--coeff[c]
			--+tv*coeff[c]
			--+tv*tv*coeff[c]
			--+tv*tv*tv*coeff[c]
			table.insert( R, { tv, v } )
			cutcount = cutcount + 1;
		end
	else
		while cutcount <= cuts do
			local tv = t0 + cutcount*dcut
			table.insert( R, { tv, 0 } )
			cutcount = cutcount + 1;
		end
	end
	return R;
end

function vsoLinearPathScale( pointlist, sx, sy )
	for k,v in pairs( pointlist ) do
		v[1] = v[1] * sx
		v[2] = v[2] * sy
	end
end

function vsoLinearPathAdd( pointlist, sx, sy )
	for k,v in pairs( pointlist ) do
		v[1] = v[1] + sx
		v[2] = v[2] + sy
	end
end

function vsoLinearPathLength( pointlist )
	local R = 0.0;
	local i = 2;
	local imax = #pointlist
	local pp = pointlist[1];
	while i <= imax do
		p = pointlist[i];
		local dx = (p[1] - pp[1])
		local dy = (p[2] - pp[2])
		R = R + math.sqrt( dx*dx + dy*dy );
		pp = p;
		i = i + 1;
	end
	return R;
end
		
function vsoLinearPathToDistancePath( pointlist )
	local Dlist = {};
	local R = 0.0;
	local i = 1;
	local imax = #pointlist
	local pp = pointlist[1];
	while i <= imax do
		local p = pointlist[i];
		local dx = (p[1] - pp[1])
		local dy = (p[2] - pp[2])
		local dist = math.sqrt( dx*dx + dy*dy );
		table.insert( Dlist, R );
		R = R + dist;
		pp = p;
		i = i + 1;
	end
	--table.insert( Dlist, R );
	
	--Normalize Dlist to get RELATIVE time parameter.
	local Nlist = {}
	if R <= 0 then
		for k,v in pairs( Dlist ) do
			table.insert( Nlist, (k-1)/#Dlist );
		end
	else
		for k,v in pairs( Dlist ) do
			table.insert( Nlist, v/R );
		end
	end
	
	return { pointlist, Dlist, Nlist, R }
end

function vsoDistancePathDistance( dpath )
	return dpath[4];
end

function vsoDistancePathEval( dpath, relativetime )

	local pi0 = 1;
	local pi1 = 1;
	local rdt = 0;
	local imax = #dpath[1]
	if relativetime <= 0 then
		pi0 = 1;
		pi1 = 1;
	elseif relativetime >= 1 then
		pi0 = imax;
		pi1 = imax;
	else
		local iprev = 1;
		local i = 1;
		while i < imax do
			if relativetime > dpath[3][i] then
				--keep going until we find the FIRST POINT with a larger relative time
				pi0 = iprev
				pi1 = i
			else
				--Stop here and interpolate	 (pi1 is the NEXT highest
				pi0 = iprev
				pi1 = i
				break
			end
			iprev = i;
			i = i + 1;
		end
		local deltarel = (dpath[3][pi1] - dpath[3][pi0])
		if deltarel > 0 then
			rdt = (relativetime - dpath[3][pi0])/deltarel
		else
			rdt = 0;
		end			
	end
	
	--I'd need 4 points to make a continuous, smooth derivative.
	local ps0 = math.max( 1, pi0-1 )
	local ps1 = pi0
	local ps2 = pi1
	local ps3 = math.min( imax, pi1+1 )
	
	local ds0px = ( dpath[1][ps1][1] - dpath[1][ps0][1] );	--0.0 and earlier
	local ds0py = ( dpath[1][ps1][2] - dpath[1][ps0][2] );
	local ds1px = ( dpath[1][ps2][1] - dpath[1][ps1][1] );	--Exactly at 0.5
	local ds1py = ( dpath[1][ps2][2] - dpath[1][ps1][2] );
	local ds2px = ( dpath[1][ps3][1] - dpath[1][ps2][1] );	--1.0 and later
	local ds2py = ( dpath[1][ps3][2] - dpath[1][ps2][2] );
	
	--Computing the smoothed derivative is... Hm. Bezieriffic
	local dp0x = (ds0px+ds1px)/2.0;
	local dp0y = (ds0py+ds1py)/2.0;
	local dp1x = (ds2px+ds1px)/2.0;
	local dp1y = (ds2py+ds1py)/2.0;
	local dpx = (dp1x - dp0x)*rdt + dp0x
	local dpy = (dp1y - dp0y)*rdt + dp0y
	
	return {
		( rdt*ds1px + dpath[1][pi0][1] )
		, ( rdt*ds1py + dpath[1][pi0][2] )
		, dpx
		, dpy
		}
end

function vsoDistancePathEvalRange( dpath, relativetime, relativetimeend, count )
	
	local R = {};
	
	local pi0 = 1;
	local pi1 = 1;
	local imax = #dpath[1]
	local iprev = 1;
	local i = 1;
	
	if relativetime < 0.0 then relativetime = 0.0 end
	if relativetimeend > 1.0 then relativetimeend = 1.0 end
	
	local drelt = (relativetimeend - relativetime)/count
	
	if relativetime <= 0 then
		pi0 = 1;
		pi1 = 1;
	elseif relativetime >= 1 then
		pi0 = imax;
		pi1 = imax;
	end
	
	--Make this more efficient!!!
	
	while count > 0 do

		local rdt = 0;
		while i <= imax do
			if relativetime >= dpath[3][i] then
				--keep going until we find the FIRST POINT with a larger relative time
				pi0 = iprev
				pi1 = i
				iprev = i;
				i = i + 1;
			else
				--Stop here and interpolate	 (pi1 is the NEXT highest
				pi0 = iprev
				pi1 = i
				break
			end
		end
		local deltarel = (dpath[3][pi1] - dpath[3][pi0])
		if deltarel > 0 then
			rdt = (relativetime - dpath[3][pi0])/deltarel
		else
			rdt = 0;
		end		
		
		--I'd need 4 points to make a continuous, smooth derivative.
		local ps0 = math.max( 1, pi0-1 )
		local ps1 = pi0
		local ps2 = pi1
		local ps3 = math.min( imax, pi1+1 )
		
		local ds0px = ( dpath[1][ps1][1] - dpath[1][ps0][1] );	--0.0 and earlier
		local ds0py = ( dpath[1][ps1][2] - dpath[1][ps0][2] );
		local ds1px = ( dpath[1][ps2][1] - dpath[1][ps1][1] );	--Exactly at 0.5
		local ds1py = ( dpath[1][ps2][2] - dpath[1][ps1][2] );
		local ds2px = ( dpath[1][ps3][1] - dpath[1][ps2][1] );	--1.0 and later
		local ds2py = ( dpath[1][ps3][2] - dpath[1][ps2][2] );
		
		--Computing the smoothed derivative is... Hm. Bezieriffic
		local dp0x = (ds0px+ds1px)/2.0;
		local dp0y = (ds0py+ds1py)/2.0;
		local dp1x = (ds2px+ds1px)/2.0;
		local dp1y = (ds2py+ds1py)/2.0;
		local dpx = (dp1x - dp0x)*rdt + dp0x
		local dpy = (dp1y - dp0y)*rdt + dp0y
		
		table.insert( R, {
			( rdt*ds1px + dpath[1][pi0][1] )
			, ( rdt*ds1py + dpath[1][pi0][2] )
			, dpx
			, dpy
			} )
			
		count = count - 1;
		relativetime = relativetime + drelt
	end
	return R;
end

-------------------------------------------------------------------------------

function vsoDebugLine( xMin, yMin, xMax, yMax, color )
	if color == nil then color = "blue" end
	world.debugLine( { xMin, yMin }, { xMax, yMax }, color )
end

function vsoDebugPath( pathpoints, color )
	if color == nil then color = "blue" end
	if #pathpoints > 1 then
		local pp = pathpoints[1];
		for k,v in pairs( pathpoints ) do
			world.debugLine( pp, v, color )
			pp = v;
		end
	end
end

function vsoDebugRect( xMin, yMin, xMax, yMax, color )

	local pos1 = { xMin, yMin }
	local pos2 = { xMax, yMax }
	if color == nil then color = "blue" end
	
	world.debugLine( pos1, pos2, color )
	world.debugLine( { pos1[1], pos2[2] }, { pos2[1], pos1[2] }, color )
	
	world.debugLine( { pos1[1], pos1[2] }, { pos2[1], pos1[2] }, color )
	world.debugLine( { pos2[1], pos1[2] }, { pos2[1], pos2[2] }, color )
	world.debugLine( { pos2[1], pos2[2] }, { pos1[1], pos2[2] }, color )
	world.debugLine( { pos1[1], pos2[2] }, { pos1[1], pos1[2] }, color )
end

function vsoDebugRelativeRect( xMin, yMin, xMax, yMax, color )

	local R = vsoRelativeRect( xMin, yMin, xMax, yMax )
	vsoDebugRect( R[1][1], R[1][2], R[2][1], R[2][2], color );
	
	--local pos1 = R[1]
	--local pos2 = R[2]
	--if color == nil then color = "blue" end
	
	--world.debugLine( pos1, pos2, color )
	--world.debugLine( { pos1[1], pos2[2] }, { pos2[1], pos1[2] }, color )
	
	--world.debugLine( { pos1[1], pos1[2] }, { pos2[1], pos1[2] }, color )
	--world.debugLine( { pos2[1], pos1[2] }, { pos2[1], pos2[2] }, color )
	--world.debugLine( { pos2[1], pos2[2] }, { pos1[1], pos2[2] }, color )
	--world.debugLine( { pos1[1], pos2[2] }, { pos1[1], pos1[2] }, color )
end