--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @

require("/scripts/vore/vsosimple.lua")
require("/scripts/vore/wigglemachine.lua")

--[[

Derulfa plan:

Just a silly, heavy direct vertical SPOV that'll use line of sight and shape-casting to detect ground level with a max range. Should not work if there is no ground in range. (platforms included)
The shape casting shall be semi-smart. If it detects a tile it stops, if it detects a platform it should look for more. A detection box will be created per ground found.
He will choose between ground pounding the victim or diving in depending on precedent action. Random at first selection.
Endo and Fatal are basically the same, in fatal he will try to digest the victim though.
He will talk, the goal is to have teasy lines for both endo/fatal with included "long term memory". (as long as the SPOV object is not deleted, he will keep track of some stats I suppose)
He will only move upward and downward, surely with housemade move function since it's very specific. He MUST NOT move horizontally and he MUST NOT be affected by any sort of external force. (IE Gravity, tiles...)

NOT YET IMPLEMENTED
memory. One day maybe, but with the current architecture I am reaaaaally not into adding this much complexity
smoothen up the translation. the translate function works weirdly. It may be vsoDelta's fault though?

]]--

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local MAX_RANGE = 128.0
local messages = {}
local ENDO_MESSAGES = {
	["land"] = {
		"Huff. It's hard to fly with this much weight.",
		"Alright~\nI suppose it means \"play time\"~",
		"I'd sleep with you inside if you weren't this heavy, you know~",
		"Oh dear you're fa-...\nI mean! You are quite filling <3"
	},
	["nowiggle"] = {
		"Not feeling wiggly today? Aaw how cute <3",
		"I see there is no need to tell you to relax~",
		"I am suuuure you willingly stood under me as a meal! <3",
		"Stay in there as long as you'd like! I won't complain <3"
	},
	["squeeze"] = {
		"I am sure you enjoy this as much as I do~",
		"Mrr~\nGet all the squish and the squeeze! <3",
		"Ooh do I love this part sooo much!~",
		"Let me hold you tight, since you seem to get eaten so often!~"
	},
	["leave"] = {
		"Aaah~",
		"Mrr~",
		"Ooooh~",
		"Mmmphrr~"
	},
	["blush"] = {
		"Huff~\nCome back anytime, tasty thing~",
		"Come back sooooon! <3",
		"You might end up as my bed, one day~",
		"You're leaving so soon? Oh well! That was fun while it lasted~"
	}
}
local FATAL_MESSAGES = {
	["airdigest"] = {
		"Already?~\nYou got me used to much longer~\nOh well! <3",
		"I guess that's what you call a drive-by meal~",
		"Aaw~\nWhat a shame. I wanted to play with this food~",
		"What a way to trigger a game over <3"
	},
	["land"] = {
		"I am sure in two minutes I could fly like nothing happened~",
		"You should give me access to your clone bay so we can do this more often <3",
		"At this rate I may need a diet~",
		"Let me show you a magic trick! I'll make you give me exps <3"
	},
	["nowiggle"] = {
		"What? You're already giving up?\nFine by me! <3",
		"I'd prefer a wiggly meal but you will do just fine~",
		"Don't be mean to me! I am just doing my job after all~",
		"You really want to end up as a part of me it seems <3"
	},
	["squeeze"] = {
		"You won't be leaving anytime soon! I'm telling you <3",
		"Please tell me when you melt!\nOh wait~",
		"I hope I won't fall asleep on my pudgy tummy! <3",
		"Help yourself and become a part of this fluffy cute Noivern already!~"
	},
	["leave"] = {
		"Aaah~",
		"Mrr~",
		"Ooooh~",
		"Mmmphrr~"
	},
	["blush"] = {
		"Huff~\nYou lucky little meal~",
		"Next time you will be part of this butt! <3",
		"Daaw~\nI admit it! You won this one~",
		"I know you'll come back~\nYou looove one way trips~"
	},
	["urps"] = {
		"Huff~\nI hope no one heard this!~",
		"Ooh dear! There is really nothing left of this meal~",
		"Just made more room for the next meal~",
		"Aah~\nI hope you like your new home!\nBecause you will stay there forever <3"
	}
}

function showEmote(emotename)	--helper function to express a emotion particle	"emotesleepy","emoteconfused","emotesad","emotehappy","love"
	if vsoTimeDelta("emoteblock") > 1 then
		animator.setParticleEmitterBurstCount(emotename, 1)
		animator.burstParticleEmitter(emotename)
	end
end

function dropBone(targetid)
	local item = "bone"

	local position = mcontroller.position()
	position[1] = position[1] + (5 * -vsoDirection())
	position[2] = position[2] + 1.5

	local count = math.random(3) + math.random(2)

	local parameters = {}
	local name = world.entityName(targetid)
	local species = world.entitySpecies(targetid)
	parameters["shortdescription"] = name.."'s bone"
	parameters["description"] = "A surprisingly clean bone of some unlucky "..species.."..."

	local velocity = { -(3 + math.random(3)) * vsoDirection(), 1.0 }

	local pickuptime = 3.0

	world.spawnItem(item, position, count, parameters, velocity, pickuptime)
end

function playVictimAnim(seat, state, anim)
	vsoVictimAnimReplay(seat, anim, state)
	vsoVictimAnimVisible(seat, true)
end

function getGroundPositions(isDebug)
	local results = {}
	local blockResults = {}
	local platformResults = {}
	local searchRange = MAX_RANGE
	local nearestBlock = vsoRelativePoint(0.0, -MAX_RANGE)

	-- 1.) check for any ground to limit our future platform research
	for i = 1, 6 do
		local startPos = vsoRelativePoint(0.0, 0.0)
		local endPos = vsoRelativePoint(0.0, -MAX_RANGE)
		local intersection = nil

		startPos[1] = startPos[1] + i - 3.5
		endPos[1] = endPos[1] + i - 3.5
		intersection = world.lineTileCollisionPoint(startPos, endPos, {"block"})

		if intersection ~= nil then
			table.insert(blockResults, intersection[1])
			if isDebug then vsoDebugLine(startPos[1], startPos[2], intersection[1][1], intersection[1][2], "green") end
		else
			table.insert(blockResults, endPos)
			if isDebug then vsoDebugLine(startPos[1], startPos[2], endPos[1], endPos[2], "green") end
		end
	end

	-- 2.) the terrain MUST be flat to count as valid ground
	for i = 1, #blockResults do
		if blockResults[i][2] > nearestBlock[2] then
			-- 2.1.) update the nearest block, in case the terrain is NOT flat
			nearestBlock[2] = blockResults[i][2]
		end
	end

	-- 3.) update the search range accordingly
	searchRange = world.distance(vsoRelativePoint(0.0, -7.5), nearestBlock)[2]

	-- 4.) send a SINGLE beam. if it hits, check it's surrounding for a flat terrain. How magic
	for i = 1, math.floor(searchRange + 2) do
		local intersection = nil
		local startPos = vsoRelativePoint(0.25, -i - 7.5 + 0.75)
		local endPos = vsoRelativePoint(0.25, -i - 7.5 + 0.25)

		if isDebug then vsoDebugLine(startPos[1], startPos[2], endPos[1], endPos[2], "orange") end
		intersection = world.lineTileCollisionPoint(startPos, endPos, {"platform", "block"})

		if intersection ~= nil then
			-- vsoDebugLine(startPos[1], startPos[2], intersection[1][1], intersection[1][2], "red")
			for j = 1, 6 do
				local startCheckPos = vsoRelativePoint(0.0, 0.0)
				local endCheckPos = vsoRelativePoint(0.0, 0.0)
				intersection = nil

				startCheckPos[1] = startCheckPos[1] + j - 3.5
				startCheckPos[2] = startPos[2]
				endCheckPos[1] = endCheckPos[1] + j - 3.5
				endCheckPos[2] = endPos[2]

				if isDebug then vsoDebugLine(startCheckPos[1], startCheckPos[2], endCheckPos[1], endCheckPos[2], "red") end
				intersection = world.lineTileCollisionPoint(startCheckPos, endCheckPos, {"platform", "block"})

				if intersection ~= nil then
					table.insert(platformResults, intersection[1])
					-- vsoDebugLine(startPos[1], startPos[2], intersection[1][1], intersection[1][2], "red")
				-- else
				-- 	table.insert(blockResults, endPos)
				-- 	vsoDebugLine(startPos[1], startPos[2], endPos[1], endPos[2], "green")
				end
			end
			-- If all six are platforms/blocks, it's flat! we have a terrain <3
			if #platformResults == 6 then
				table.insert(results, platformResults[1])
			end
			platformResults = {}
		end
	end

	-- extra.) debug line these, please~
	if isDebug then
		local foo = vsoRelativePoint(-vsoDirection() * 2.5, -7.5)
		vsoDebugLine(foo[1] - 0.5, foo[2], foo[1] + 5.5, foo[2], "red")
		for i = 1, #results do
			vsoDebugLine(results[i][1] - 0.5, results[i][2], results[i][1] + 5.5, results[i][2], "yellow")
		end
	end

	return results
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function loadStoredData()
	vsoStorageSaveAndLoad(function()	--Get defaults from the item spawner itself
		if storage.colorReplaceMap ~= nil then
			vsoSetDirectives(vsoMakeColorReplaceDirectiveString(storage.colorReplaceMap))
		end
	end)
end

-------------------------------------------------------------------------------

function onForcedReset()	--helper function. If a victim warps, vanishes, dies, force escapes, this is called to reset me. (something went wrong)
	vsoMakeInteractive(false)
	vsoAnimSpeed(1.0)
	vsoUseSolid(false)
	vsoTimeDelta("emoteblock")
	self.ceiling = mcontroller.yPosition() + 8.5
	self.lastAttempt = vsoPick({"dive", "ground_pound"})

	vsoVictimAnimVisible("drivingSeat", false)
	vsoUseLounge(false, "drivingSeat")

	vsoNext("state_hang")
	vsoAnim("bodyState", "hang_idle")
end

-------------------------------------------------------------------------------

function onBegin()	--This sets up the VSO ONCE.
	vsoEffectWarpIn()	--Play warp in effect
	onForcedReset()	--Do a forced reset once.
	vsoStorageLoad(loadStoredData)	--Load our data (asynchronous, so it takes a few frames)

	---------------------------------------------------------------------------

	vsoOnBegin("state_hang", on_begin_hang)

	vsoOnEnd("state_hang", on_end_hang)

	---------------------------------------------------------------------------

	vsoOnBegin("state_ground_pound", on_begin_ground_pound)

	vsoOnEnd("state_ground_pound", on_end_ground_pound)

	---------------------------------------------------------------------------

	vsoOnBegin("state_dive", on_begin_dive)

	vsoOnEnd("state_dive", on_end_dive)

	---------------------------------------------------------------------------

	vsoOnBegin("state_flyup", on_begin_flyup)

	vsoOnEnd("state_flyup", on_end_flyup)

	---------------------------------------------------------------------------

	vsoOnBegin("state_fullflight", on_begin_fullflight)

	vsoOnEnd("state_fullflight", on_end_fullflight)

	---------------------------------------------------------------------------

	vsoOnBegin("state_fullflight_endo", on_begin_fullflight_endo)

	vsoOnEnd("state_fullflight_endo", on_end_fullflight_endo)

	---------------------------------------------------------------------------

	vsoOnBegin("state_full_endo", on_begin_full_endo)

	vsoOnEnd("state_full_endo", on_end_full_endo)

	---------------------------------------------------------------------------

	vsoOnBegin("state_fullflight_fatal", on_begin_fullflight_fatal)

	vsoOnEnd("state_fullflight_fatal", on_end_fullflight_fatal)

	---------------------------------------------------------------------------

	vsoOnBegin("state_fullflight_digest", on_begin_fullflight_digest)

	vsoOnEnd("state_fullflight_digest", on_end_fullflight_digest)

	---------------------------------------------------------------------------

	vsoOnBegin("state_full_fatal", on_begin_full_fatal)

	vsoOnEnd("state_full_fatal", on_end_full_fatal)

	---------------------------------------------------------------------------

	vsoOnBegin("state_full_digest", on_begin_full_digest)

	vsoOnEnd("state_full_digest", on_end_full_digest)

	---------------------------------------------------------------------------

	vsoOnBegin("state_release", on_begin_release)

	vsoOnEnd("state_release", on_end_release)

	---------------------------------------------------------------------------
end

-------------------------------------------------------------------------------

function onEnd()
	vsoEffectWarpOut()
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_hang()
	vsoUseLounge(false, "drivingSeat")
	vsoAnim("bodyState", "hang_idle")
	vsoMakeInteractive(false)
	vsoTimerSet("grounds_check", 1.0, 1.0)
	vsoTimerSet("prey_check", 3.0, 7.0)
	self.groundPositions = {}
	if vsoPill("digest") or vsoPill("softdigest") then
		messages = FATAL_MESSAGES
	else
		messages = ENDO_MESSAGES
	end
end

function on_end_hang()
	animator.setParticleEmitterActive("drips", false)
end

function state_hang()
	local currAnim = vsoAnimCurr("bodyState")
	local hasPrey = false

	if vsoTimer("grounds_check") then
		self.groundPositions = getGroundPositions()
		-- if #self.groundPositions > 0 then vsoSay(tostring(self.groundPositions[#self.groundPositions][2])) end
	end
	-- getGroundPositions(true)

	for i,v in ipairs(self.groundPositions) do
		local p1 = vsoRelativePoint(0.0, 0.0)
		local p2 = v
		local d = p2[2] - p1[2]

		vsoDebugRelativeRect(-0.5, d, -2.0, d + 0.5, "green")
		if vsoUpdateTarget(tostring(i), -0.5, d, -2.0, d + 0.5) then
		-- vsoDebugRelativeRect(2.0, d, -2.0, d + 2.5, "green")
		-- if vsoUpdateTarget(tostring(i), 2.0, d, -2.0, d + 2.5) then
			hasPrey = true
			if currAnim == "hang_idle" then
				vsoTimerReset("prey_check")
				vsoAnim("bodyState", "hang_to_tease")
			elseif currAnim == "hang_tease" then
				if vsoTimer("prey_check") then
					if vsoPill("ovonly") then
						vsoNext("state_dive")
					elseif vsoPill("avonly") then
						vsoNext("state_ground_pound")
					elseif self.lastAttempt == "ground_pound" then
						self.lastAttempt = "dive"
						vsoNext("state_dive")
					else
						self.lastAttempt = "ground_pound"
						vsoNext("state_ground_pound")
					end
				end
			end
		end
	end

	if not hasPrey then
		if vsoTimeDelta("noprey", true) > 2.0 and currAnim ~= "hang_idle" then
			vsoAnim("bodyState", "hang_idle")
			animator.setParticleEmitterActive("drips", false)
		end
	else
		vsoTimeDelta("noprey")
	end

	if vsoAnimEnd("bodyState") then
		if currAnim == "hang_idle" then
			vsoAnim("bodyState",  "hang_idle")
		elseif currAnim == "hang_to_tease" then
			animator.setParticleEmitterActive("drips", true)
			vsoAnim("bodyState", "hang_tease")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_dive()
	vsoAnim("bodyState", "dive")
end

function on_end_dive()
end

function state_dive()
	local currAnim = vsoAnimCurr("bodyState")
	local hasPrey = false
	local gpos = self.groundPositions[#self.groundPositions]

	vsoDebugRelativeRect(-0.5, 0.0, -2.0, -7.5, "red")
	vsoUpdateTarget("prey", -0.5, 0.0, -2.0, -7.5)

	if currAnim == "dive" then
		for i = #self.groundPositions, 1, -1 do
			if not hasPrey then
				local p1 = vsoRelativePoint(0.0, 0.0)
				local p2 = self.groundPositions[i]
				local d = p2[2] - p1[2]

				vsoDebugRelativeRect(-0.5, d, -2.0, d + 0.5, "green")
				vsoUpdateTarget(tostring(i), -0.5, d, -2.0, d + 0.5)
				-- vsoDebugRelativeRect(2.0, d, -2.0, d + 2.5, "green")
				-- vsoUpdateTarget(tostring(i), 2.0, d, -2.0, d + 2.5)
				if vsoGetTargetId(tostring(i)) == vsoGetTargetId("prey") and vsoGetTargetId("prey") ~= nil then
					hasPrey = true
					gpos = p2
					mcontroller.setYPosition(gpos[2] + 7.5)
					vsoAnim("bodyState",  "dive_catch")
					vsoSound("nom")
					vsoUseLounge(true, "drivingSeat")
					vsoEat(vsoGetTargetId("prey"), "drivingSeat")
					playVictimAnim("drivingSeat", "bodyState", "ovcatch")
				end
			end
		end
		if not hasPrey then
			if mcontroller.yPosition() - 8.0 <= gpos[2] then
				mcontroller.setYPosition(gpos[2] + 7.5)
				vsoAnim("bodyState",  "dive_fail")
			else
				-- I tried vsoDelta but it was funky. Oh well
				mcontroller.translate({0.0, -9.81 * 2.0 / 60.0})
			end
		end
	end

	if vsoAnimEnd("bodyState") then
		if currAnim == "dive_catch" then
			vsoSound("transfer")
			vsoAnim("bodyState", "dive_swallow")
			playVictimAnim("drivingSeat", "bodyState", "ovswallow")
		elseif currAnim == "dive_swallow" then
			vsoNext("state_fullflight")
		elseif currAnim == "dive_fail" then
			vsoAnim("bodyState",  "take_off")
		elseif currAnim == "take_off" then
			vsoNext("state_flyup")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_ground_pound()
	vsoAnim("bodyState", "tease_to_ground_pound")
end

function on_end_ground_pound()
end

function state_ground_pound()
	local currAnim = vsoAnimCurr("bodyState")
	local hasPrey = false
	local gpos = self.groundPositions[#self.groundPositions]

	vsoDebugRelativeRect(-0.5, 0.0, -2.0, -7.5, "red")
	vsoUpdateTarget("prey", -0.5, 0.0, -2.0, -7.5)

	if currAnim == "ground_pound" then
		for i = #self.groundPositions, 1, -1 do
			if not hasPrey then
				local p1 = vsoRelativePoint(0.0, 0.0)
				local p2 = self.groundPositions[i]
				local d = p2[2] - p1[2]

				vsoDebugRelativeRect(-0.5, d, -2.0, d + 0.5, "green")
				vsoUpdateTarget(tostring(i), -0.5, d, -2.0, d + 0.5)
				-- vsoDebugRelativeRect(2.0, d, -2.0, d + 2.5, "green")
				-- vsoUpdateTarget(tostring(i), 2.0, d, -2.0, d + 2.5)
				if vsoGetTargetId(tostring(i)) == vsoGetTargetId("prey") and vsoGetTargetId("prey") ~= nil then
					hasPrey = true
					gpos = p2
					mcontroller.setYPosition(gpos[2] + 7.5)
					vsoAnim("bodyState",  "ground_pound_catch")
					vsoSound("pounce")
					vsoUseLounge(true, "drivingSeat")
					vsoEat(vsoGetTargetId("prey"), "drivingSeat")
					playVictimAnim("drivingSeat", "bodyState", "avcatch")
				end
			end
		end
		if not hasPrey then
			if mcontroller.yPosition() - 7.0 <= gpos[2] then
				mcontroller.setYPosition(gpos[2] + 7.5)
				vsoAnim("bodyState",  "ground_pound_fail")
			else
				-- I tried vsoDelta but it was funky. Oh well
				mcontroller.translate({0.0, -9.81 * 4.0 / 60.0})
			end
		end
	end

	if vsoAnimEnd("bodyState") then
		if currAnim == "tease_to_ground_pound" then
			vsoAnim("bodyState", "ground_pound")
		elseif currAnim == "ground_pound_catch" then
			vsoSound("transfer")
			vsoAnim("bodyState", "ground_pound_swallow")
			playVictimAnim("drivingSeat", "bodyState", "avswallow")
		elseif currAnim == "ground_pound_swallow" then
			vsoNext("state_fullflight")
		elseif currAnim == "ground_pound_fail" then
			vsoAnim("bodyState",  "take_off")
		elseif currAnim == "take_off" then
			vsoNext("state_flyup")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_flyup()
	vsoAnim("bodyState",  "fly")
end

function on_end_flyup()
end

function state_flyup()
	local currAnim = vsoAnimCurr("bodyState")
	if currAnim == "fly" then
		if mcontroller.yPosition() + 8.5 >= self.ceiling then
			mcontroller.setYPosition(self.ceiling - 8.5)
			vsoAnim("bodyState",  "hang")
		else
			mcontroller.translate({0.0, 3.2 * vsoDelta()})
		end
	end

	if vsoAnimEnd("bodyState") then
		if currAnim == "hang" then
			vsoNext("state_hang")
		elseif currAnim == "fly" then
			vsoAnim("bodyState", "fly")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_fullflight()
	vsoAnim("bodyState",  "full_flight_take_off")
	playVictimAnim("drivingSeat", "bodyState", "takeoff")
	vsoCounterSet("flight_struggle", 0, 0, 5)
end

function on_end_fullflight()
end

function state_fullflight()
	local currAnim = vsoAnimCurr("bodyState")

	if vsoAnimEnd("bodyState") then
		if currAnim == "full_flight_take_off" then
			vsoAnim("bodyState", "full_flight_idle")
		elseif currAnim == "full_flight_idle" then
			if vsoCounterPercent("flight_struggle") >= 100.0 then
				if vsoPill("digest") or vsoPill("softdigest") then
					vsoNext("state_fullflight_fatal")
				else
					vsoNext("state_fullflight_endo")
				end
			else
				vsoAnim("bodyState", "full_flight_idle")
				if vsoCounterValue("flight_struggle") % 3 == 0 then
					vsoSound("small")
				end
				vsoCounter("flight_struggle")
			end
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_fullflight_endo()
	vsoAnim("bodyState",  "full_flight_land")
	playVictimAnim("drivingSeat", "bodyState", "land")
	vsoCounterSet("teasy_landing", 0, 0, 5)
end

function on_end_fullflight_endo()
end

function state_fullflight_endo()
	local currAnim = vsoAnimCurr("bodyState")

	if vsoAnimEnd("bodyState") then
		if currAnim == "full_flight_land" then
			vsoSay(vsoPick(messages["land"]))
			vsoAnim("bodyState", "stand_tease_in")
		elseif vsoInList({"stand_tease_in", "stand_tease"}, currAnim) then
			if vsoCounterPercent("teasy_landing") >= 100.0 then
				vsoAnim("bodyState", "stand_tease_out")
			else
				vsoAnim("bodyState", "stand_tease")
				vsoCounter("teasy_landing")
			end
		elseif currAnim == "stand_tease_out" then
			vsoNext("state_full_endo")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_full_endo()
	vsoAnim("bodyState",  "stand_full")
	wiggleMachine.setMaxAll("drivingSeat", 8)
	wiggleMachine.setMax4DAll("drivingSeat", 6, 6, 6, 6)
	-- wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "full_wiggle_front", "full_wiggle_up", "full_wiggle_back", "full_wiggle_down")
	vsoTimer("sound", 3.0, 8.0)
	vsoTimer("no_struggle", 4.0, 8.0)
	vsoCounterSet("wiggles", 0, 0, 5)
	vsoCounterSet("squeeze", 0, 0, 8)
end

function on_end_full_endo()
end

function state_full_endo()
	local currAnim = vsoAnimCurr("bodyState")
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	if vsoAnimIs("bodyState", "stand_full") then
		if wiggleMachine.update("drivingSeat", "bodyState") > 0 then
			vsoSound("struggle")
			vsoTimerReset("no_struggle")
			vsoCounter("wiggles")
		end

		if vsoTimer("no_struggle") then
			vsoSay(vsoPick(messages["nowiggle"]))
			vsoAnim("bodyState", "stand_tease_in")
			-- I know, I know. It's silly and unnecessary
			vsoCounter("wiggles")
			vsoCounter("wiggles")
			vsoCounter("wiggles")
		end
	end

	if vsoAnimEnd("bodyState") then
		if vsoTimer("sound") then
			vsoSound("full")
		end

		if vsoInList({"stand_tease_in", "stand_tease"}, currAnim) then
			if vsoTimer("no_struggle") then
				vsoAnim("bodyState", "stand_tease_out")
			else
				vsoAnim("bodyState", "stand_tease")
				if vsoPill("heal") then
					vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", 1.25, 100.0, function(inrange) end)
				end
			end
		else
			if vsoCounterPercent("wiggles") >= 100.0 then
				if vsoInList({"wiggle_react_in", "wiggle_react"}, currAnim) then
					if vsoCounterPercent("squeeze") >= 100.0 then
						if wmType > 0 then
							vsoNext("state_release")
						else
							vsoAnim("bodyState", "wiggle_react_out")
							vsoTimerReset("no_struggle")
						end
						vsoCounterReset("wiggles")
						vsoCounterReset("squeeze")
					else
						vsoAnim("bodyState", "wiggle_react")
						if vsoPill("heal") then
							vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", 3.0, 100.0, function(inrange) end)
						end
						vsoCounter("squeeze")
					end
				else
					vsoAnim("bodyState", "wiggle_react_in")
					vsoSay(vsoPick(messages["squeeze"]))
				end
			else
				vsoAnim("bodyState", "stand_full")
				if vsoPill("heal") then
					vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", 0.5, 100.0, function(inrange) end)
				end
			end
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_fullflight_fatal()
	vsoAnim("bodyState",  "full_flight_attempt_digest_in")
	vsoCounterSet("digest_attempt", 0, 0, 6)
	vsoCounterSet("teasy_landing", 0, 0, 5)
end

function on_end_fullflight_fatal()
end

function state_fullflight_fatal()
	local currAnim = vsoAnimCurr("bodyState")

	if vsoAnimEnd("bodyState") then
		if currAnim == "full_flight_attempt_digest_in" then
			vsoAnim("bodyState", "full_flight_attempt_digest")
		elseif currAnim == "full_flight_attempt_digest" then
			if vsoCounterPercent("digest_attempt") > 100.0 then
				vsoAnim("bodyState",  "full_flight_attempt_digest_out")
			else
				vsoAnim("bodyState", "full_flight_attempt_digest")
				if vsoCounterValue("digest_attempt") % 3 == 0 then
					vsoSound("digest")
				end
				vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -3.0, 0.0, function (stillalive)
					if not stillalive then
						vsoNext("state_fullflight_digest")
					end
				end)
				vsoCounter("digest_attempt")
			end
		elseif currAnim == "full_flight_attempt_digest_out" then
			vsoAnim("bodyState", "full_flight_idle")
		elseif currAnim == "full_flight_idle" then
			vsoAnim("bodyState",  "full_flight_land")
			playVictimAnim("drivingSeat", "bodyState", "land")
		elseif currAnim == "full_flight_land" then
			vsoSay(vsoPick(messages["land"]))
			vsoAnim("bodyState", "stand_tease_in")
		elseif vsoInList({"stand_tease_in", "stand_tease"}, currAnim) then
			if vsoCounterPercent("teasy_landing") >= 100.0 then
				vsoAnim("bodyState", "stand_tease_out")
			else
				vsoAnim("bodyState", "stand_tease")
				vsoCounter("teasy_landing")
			end
		elseif currAnim == "stand_tease_out" then
			vsoNext("state_full_fatal")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_fullflight_digest()
	vsoSetMouthPosition(3.0, 3.5)
	vsoSay(vsoPick(messages["airdigest"]))
	vsoSound("digest")
	vsoAnim("bodyState",  "full_flight_digest_fast")
	vsoCounterSet("leave", 0, 0, 1)
end

function on_end_fullflight_digest()
end

function state_fullflight_digest()
	local currAnim = vsoAnimCurr("bodyState")

	if vsoHasAnySPOInputs("drivingSeat") and currAnim == "fly" then
		vsoCounter("leave")
	end

	if vsoAnimEnd("bodyState") then
		if vsoInList({"fly", "full_flight_digest_normal"}, currAnim) then
			vsoAnim("bodyState", "fly")
		elseif currAnim == "full_flight_digest_fast" then
			vsoAnim("bodyState", "full_flight_digest_normal")
		end
		if vsoCounterPercent("leave") >= 100.0 then
			if vsoPill("digest") then
				world.sendEntityMessage(vsoHasEatenId("drivingSeat"), "applyStatusEffect", "vsokillnpcsit", 1.0, entity.id())
			end
			vsoSetMouthPosition(2.5, 0.0)
			vsoVictimAnimVisible("drivingSeat", false)
			vsoUneat("drivingSeat")
			vsoUseLounge(false, "drivingSeat")
			vsoNext("state_flyup")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_full_fatal()
	vsoAnim("bodyState",  "stand_full")
	wiggleMachine.setMaxAll("drivingSeat", 8)
	wiggleMachine.setMax4DAll("drivingSeat", 6, 6, 6, 6)
	-- wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "full_wiggle_front", "full_wiggle_up", "full_wiggle_back", "full_wiggle_down")
	vsoTimer("sound", 3.0, 8.0)
	vsoTimer("no_struggle", 4.0, 8.0)
	vsoCounterSet("wiggles", 0, 0, 5)
	vsoCounterSet("squeeze", 0, 0, 8)
	vsoCounterSet("digest", 0, 0, 1)
end

function on_end_full_fatal()
end

function state_full_fatal()
	local currAnim = vsoAnimCurr("bodyState")
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	if vsoAnimIs("bodyState", "stand_full") then
		if wiggleMachine.update("drivingSeat", "bodyState") > 0 then
			vsoSound("struggle")
			vsoTimerReset("no_struggle")
			vsoCounter("wiggles")
		end

		if vsoTimer("no_struggle") then
			vsoSay(vsoPick(messages["nowiggle"]))
			vsoAnim("bodyState", "stand_tease_in")
			-- I know, I know. It's silly and unnecessary™️
			vsoCounter("wiggles")
			vsoCounter("wiggles")
			vsoCounter("wiggles")
		end
	end

	if vsoAnimEnd("bodyState") then
		if vsoTimer("sound") then
			vsoSound("full")
		end

		if vsoInList({"stand_tease_in", "stand_tease"}, currAnim) then
			if vsoTimer("no_struggle") then
				vsoAnim("bodyState", "stand_tease_out")
			else
				vsoAnim("bodyState", "stand_tease")
				vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -0.25, 35.0, function (stillalive)
					if not stillalive then
						vsoCounter("digest")
					end
				end)
			end
		else
			if vsoCounterPercent("wiggles") >= 100.0 then
				if vsoInList({"wiggle_react_in", "wiggle_react"}, currAnim) then
					if vsoCounterPercent("squeeze") >= 100.0 then
						if wmType > 0 then
							vsoNext("state_release")
						elseif vsoCounterValue("digest") > 0 then
							vsoNext("state_full_digest")
						else
							vsoAnim("bodyState", "wiggle_react_out")
							vsoTimerReset("no_struggle")
						end
						vsoCounterReset("wiggles")
						vsoCounterReset("squeeze")
					else
						vsoAnim("bodyState", "wiggle_react")
						vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -1.5, 35.0, function (stillalive)
							if not stillalive then
								vsoCounter("digest")
							end
						end)
						vsoCounter("squeeze")
					end
				else
					vsoAnim("bodyState", "wiggle_react_in")
					vsoSay(vsoPick(messages["squeeze"]))
				end
			else
				vsoAnim("bodyState", "stand_full")
				vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -1.0, 35.0, function (stillalive)
					if not stillalive then
						vsoCounter("digest")
					end
				end)
			end
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_full_digest()
	vsoSay(vsoPick(messages["leave"]))
	vsoSound("digest")
	vsoAnim("bodyState",  "digest")
	vsoCounterSet("digest", 0, 0, 1)
	vsoCounterSet("absorb", 0, 0, 1)
	vsoCounterSet("leave", 0, 0, 1)
	vsoTimerSet("sound", 4.0, 8.0)
end

function on_end_full_digest()
end

function state_full_digest()
	local currAnim = vsoAnimCurr("bodyState")

	if vsoHasAnySPOInputs("drivingSeat") and currAnim == "blush" then
		vsoCounter("leave")
	end

	if vsoTimer("sound") then
		if currAnim == "digest_tease" then
			vsoSound("full")
		end
		if currAnim == "absorb_idle" then
			vsoSound("small")
		end
	end

	if vsoAnimEnd("bodyState") then
		if currAnim == "digest" then
			-- vsoSay(vsoPick(messages["digest"]))
			vsoAnim("bodyState", "digest_tease_in")
		elseif vsoInList({"digest_tease_in", "digest_tease"}, currAnim) then
			if vsoCounterValue("digest") > 0 then
				-- vsoSay(vsoPick(messages["absorb"]))
				vsoSound("med")
				vsoAnim("bodyState", "absorb")
			else
				vsoAnim("bodyState", "digest_tease")
				vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -0.5, 22.5, function (stillalive)
					if not stillalive then
						vsoCounter("digest")
					end
				end)
			end
		elseif vsoInList({"absorb", "absorb_idle"}, currAnim) then
			if vsoCounterValue("absorb") > 0 then
				vsoSound("transfer")
				vsoAnim("bodyState", "hold_urps")
			else
				vsoAnim("bodyState", "absorb_idle")
				vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -1.0, 0.0, function (stillalive)
					if not stillalive then
						vsoCounter("absorb")
					end
				end)
			end
		elseif currAnim == "hold_urps" then
			vsoSound("burp")
			showEmote("urps")
			vsoAnim("bodyState", "urps")
		elseif currAnim == "urps" then
			vsoSay(vsoPick(messages["urps"]))
			vsoAnim("bodyState", "blush")
		elseif currAnim == "blush" then
			vsoAnim("bodyState", "blush")
		end
		if currAnim == "take_off" then
			vsoNext("state_flyup")
		end
		if vsoCounterPercent("leave") >= 100.0 and vsoHasEatenId("drivingSeat") ~= nil then
			if vsoPill("digest") then
				world.sendEntityMessage(vsoHasEatenId("drivingSeat"), "applyStatusEffect", "vsokillnpcsit", 1.0, entity.id())
			end
			vsoVictimAnimVisible("drivingSeat", false)
			vsoUneat("drivingSeat")
			vsoUseLounge(false, "drivingSeat")
			vsoAnim("bodyState", "take_off")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_release()
	vsoSay(vsoPick(messages["leave"]))
	vsoSound("transfer")
	vsoAnim("bodyState",  "leave")
	playVictimAnim("drivingSeat", "bodyState", "leave")
	vsoTimer("leave", 5.0, 10.0)
end

function on_end_release()
end

function state_release()
	local currAnim = vsoAnimCurr("bodyState")
	if vsoTimer("leave") and currAnim == "blush" then
		vsoAnim("bodyState", "take_off")
	end

	if vsoAnimEnd("bodyState") then
		if currAnim == "leave" then
			vsoUneat("drivingSeat")
			vsoAnim("bodyState", "blush")
			vsoSay(vsoPick(messages["blush"]))
		elseif currAnim == "take_off" then
			vsoNext("state_flyup")
		end
	end
end

-------------------------------------------------------------------------------
