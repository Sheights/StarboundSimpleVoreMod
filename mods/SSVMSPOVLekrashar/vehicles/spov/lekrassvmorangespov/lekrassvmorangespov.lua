--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @

require("/scripts/vore/vsosimple.lua")
require("/scripts/vore/wigglemachine.lua")

--[[

Orange plan:

	Orange is supposed to be a really basic SPOV.
	He is static but takes quite a bit of space for his animations. (15.5x8.5 tiles)
	He has only one entrance and one exit: his maw.
	You get ate if you stay in front of him for too long.
	He has no "memory features". (like how full he is and such)
	He is endo by default, but you can put pills to make him fatal.

	ENDO
	TUMMY
	wiggling left or right will either make you exit the gecko or enter his tail.
	wiggling up or down will make the gecko tummy squeeze you a bit.
	TAIL
	wiggling in any direction will result in you returning in the tummy.

	HEALING
	HEALING EFFICIENCY
	the tummy squeezing you yields most of the healing (x5)
	idling in the tail is second best (x3)
	idling in the tummy is normal (x1)
	wiggling is reduced (same value for tummy and tail) (x0.5)
	UNIQUE TO HEALING AND ONLY TO HEALING
	in the tummy, the gecko will randomly squeeze you to heal you up <3

	FATAL
	DIGESTION EFFICIENCY
	idling in the tail is fastest (x5)
	tummy squeezing is second best (x3)
	idling in the tummy is normal (x1)
	wiggling is reduced (same value for tail and tummy) (x0.1)
	ABOVE 75% HP
	you have access to all the endo animations.
	UNDER 75% HP
	TAIL
	struggling too much will result in you directly becoming gecko fat
	TUMMY
	you get shrunk to medium belly size
	digestion while idling is faster (x2)
	struggling too much will result in you directly becoming gecko fat
	UNDER 35% HP
	TUMMY
	you get shrunk to small belly size
	digestion while idling is even faster (x3)
	struggling will do nothing but slow down the digestion process by a bit (x2)
	being digested will result in the gecko burping out a small amount of bones

	"I HATE THIS FEATURE BECAUSE I DUNNO HOW TO WORK AROUND IT" CATEGORY
	FATAL
	UNDER 35% HP
	TUMMY
	should that gecko burp out bones with the "softdigest" pill???
	shall I make a new pill to replace "softdigest" (surely named "safedigest")??? - Oh dear even moar pills. It's not a vore mod but a drug cartel at this point. WHAT HAVE WE DONE?! x3

]]--

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

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

	vsoVictimAnimVisible("drivingSeat", false)
	vsoUseLounge(false, "drivingSeat")

	vsoNext("state_idle")
	vsoAnim("bodyState", "idle_quad")
end

-------------------------------------------------------------------------------

function onBegin()	--This sets up the VSO ONCE.
	vsoEffectWarpIn()	--Play warp in effect
	onForcedReset()	--Do a forced reset once.
	vsoStorageLoad(loadStoredData)	--Load our data (asynchronous, so it takes a few frames)

	---------------------------------------------------------------------------

	vsoOnBegin("state_idle", on_begin_idle)

	vsoOnEnd("state_idle", on_end_idle)

	---------------------------------------------------------------------------

	vsoOnBegin("state_teased", on_begin_teased)

	vsoOnEnd("state_teased", on_end_teased)

	---------------------------------------------------------------------------

	vsoOnBegin("state_pounce", on_begin_pounce)

	vsoOnEnd("state_pounce", on_end_pounce)

	---------------------------------------------------------------------------

	vsoOnBegin("state_miss", on_begin_miss)

	vsoOnEnd("state_miss", on_end_miss)

	---------------------------------------------------------------------------

	vsoOnBegin("state_chomp", on_begin_chomp)

	vsoOnEnd("state_chomp", on_end_chomp)

	---------------------------------------------------------------------------

	vsoOnBegin("state_full_endo", on_begin_full_endo)

	vsoOnEnd("state_full_endo", on_end_full_endo)

	---------------------------------------------------------------------------

	vsoOnBegin("state_tail_endo", on_begin_tail_endo)

	vsoOnEnd("state_tail_endo", on_end_tail_endo)

	---------------------------------------------------------------------------

	vsoOnBegin("state_release", on_begin_release)

	vsoOnEnd("state_release", on_end_release)

	---------------------------------------------------------------------------

	vsoOnBegin("state_idle_fatal", on_begin_idle_fatal)

	vsoOnEnd("state_idle_fatal", on_end_idle_fatal)

	---------------------------------------------------------------------------

	vsoOnBegin("state_full_fatal", on_begin_full_fatal)

	vsoOnEnd("state_full_fatal", on_end_full_fatal)

	---------------------------------------------------------------------------

	vsoOnBegin("state_tail_fatal", on_begin_tail_fatal)

	vsoOnEnd("state_tail_fatal", on_end_tail_fatal)

	---------------------------------------------------------------------------

	vsoOnBegin("state_med_fatal", on_begin_med_fatal)

	vsoOnEnd("state_med_fatal", on_end_med_fatal)

	---------------------------------------------------------------------------

	vsoOnBegin("state_small_fatal", on_begin_small_fatal)

	vsoOnEnd("state_small_fatal", on_end_small_fatal)

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

function on_begin_idle()
	vsoUseLounge(false, "drivingSeat")
	vsoAnim("bodyState", "idle_quad")
	vsoMakeInteractive(false)
	vsoTimerSet("check_prey", 1.0, 2.0)
	vsoTimerSet("random_actions", 5.0, 15.0)
end

function on_end_idle()
end

function state_idle()
	vsoDebugRelativeRect(6, 0, 3.5, 5.5, "red")
	if vsoUpdateTarget("prey", 6, 0, 3.5, 5.5) and vsoAnimIs("bodyState", "idle_quad") then
		if vsoTimer("check_prey") then
			vsoNext("state_teased")
			return nil
		end
	else
		vsoTimerReset("check_prey")
	end

	if vsoAnimEnd("bodyState") then
		local nextAnim = "idle_quad"

		if vsoTimer("random_actions") then
			nextAnim = "idle_quad_breath"
		end

		vsoAnim("bodyState",  nextAnim)
	end
end

-------------------------------------------------------------------------------

function on_begin_teased()
	vsoAnim("bodyState", "stand")
	vsoTimerSet("check_prey", 5.0, 7.5)
	vsoTimerSet("random_actions", 3.0, 5.0)
end

function on_end_teased()
end

function state_teased()
	local anim = vsoAnimCurr("bodyState")
	local hasPrey = vsoUpdateTarget("prey", 6, 0, 3.5, 5.5)

	vsoDebugRelativeRect(6, 0, 3.5, 5.5, "red")

	if vsoTimer("random_actions") and not vsoAnimIs("bodyState", "stand_reverse") then
		vsoAnim("bodyState", "stand_blink")
	end

	if vsoAnimEnd("bodyState") then
		if vsoAnimIs("bodyState", "stand") then
			showEmote("emoteconfused")
		end

		if vsoAnimIs("bodyState", "stand_reverse") then
			showEmote("emotesad")
			vsoNext("state_idle")
		elseif hasPrey then
			vsoAnim("bodyState", "stand_idle")
			if vsoTimer("check_prey") then
				vsoNext("state_pounce")
			end
		else
			vsoAnim("bodyState", "stand_reverse")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_pounce()
	vsoAnim("bodyState", "pounce")
	vsoSound("pounce")
end

function on_end_pounce()
end

function state_pounce()
	local anim = vsoAnimCurr("bodyState")
	local hasPrey = vsoUpdateTarget("prey", 6, 0, 3.5, 5.5)

	vsoDebugRelativeRect(6, 0, 3.5, 5.5, "red")

	if vsoAnimEnd("bodyState") then
		if hasPrey then
			vsoNext("state_chomp")
		else
			vsoNext("state_miss")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_miss()
	showEmote("emotesad")
	vsoSound("nom")
	vsoAnim("bodyState", "miss")
end

function on_end_miss()
end

function state_miss()
	if vsoAnimEnd("bodyState") then
		vsoNext("state_idle")
	end
end

-------------------------------------------------------------------------------

function on_begin_chomp()
	vsoSound("nom")
	vsoAnim("bodyState", "chomp")
	vsoUseLounge(true, "drivingSeat")
	vsoEat(vsoGetTargetId("prey"), "drivingSeat")
	playVictimAnim("drivingSeat", "bodyState", "chomp")
	-- vsoVictimAnimReplay("drivingSeat", "invis", "bodyState")
	-- vsoVictimAnimVisible("drivingSeat", true)
end

function on_end_chomp()
end

function state_chomp()
	if vsoAnimEnd("bodyState") then
		if vsoAnimIs("bodyState", "chomp") then
			showEmote("emotehappystand")
			vsoSound("transfer")
			vsoAnim("bodyState", "swallow")
			playVictimAnim("drivingSeat", "bodyState", "swallow")
		elseif vsoAnimIs("bodyState", "swallow") then
			vsoSound("pounce")
			vsoAnim("bodyState", "acrobatics")
			playVictimAnim("drivingSeat", "bodyState", "acrobatics")
			if vsoPill("digest") or vsoPill("softdigest") then
				vsoNext("state_full_fatal")
			else
				vsoNext("state_full_endo")
			end
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_full_endo()
	wiggleMachine.setMaxAll("drivingSeat", 10)
	wiggleMachine.setMax4DAll("drivingSeat", 5, 5, 5, 5)
	-- wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "full_wiggle_back", "full_wiggle_up", "full_wiggle_front", "full_wiggle_down")
	vsoTimerSet("healing_squeeze", 8.0, 12.0)
	vsoTimerSet("sound", 4.0, 8.0)
	self.dunStruggleplz = false
end

function on_end_full_endo()
end

function state_full_endo()
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	if vsoAnimIs("bodyState", "full_idle") then
		if wiggleMachine.update("drivingSeat", "bodyState") > 0 then
			vsoSound("struggle")
		end
	end

	if vsoAnimEnd("bodyState") then
		if vsoPill("heal") then
			local mult = 1.0
			if vsoAnimIs("bodyState", "full_rumbles") then
				mult = 5.0
				vsoTimerReset("healing_squeeze")
				wiggleMachine.setMaxAll("drivingSeat", 10)
				wiggleMachine.setMax4DAll("drivingSeat", 5, 5, 5, 5)
			elseif not vsoAnimIs("bodyState", "full_idle") then
				mult = 0.5
			end
			vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", 2.5 * mult, 100.0, function (inrange)
			end)

			if vsoTimer("healing_squeeze") and not self.dunStruggleplz then
				vsoAnim("bodyState", "full_rumbles")
				vsoSound("struggle")
				showEmote("emotehappysleep")

				return nil
			end
			if self.dunStruggleplz then
				self.dunStruggleplz = false
			end
		end

		if vsoTimer("sound") then
			vsoSound("full")
		end

		vsoAnim("bodyState", "full_idle")
	end

	if wmType > 0 and vsoAnimIs("bodyState", "full_idle") then
		if wmDir == "F" then
			vsoSound("transfer")
			vsoAnim("bodyState", "tail_transfer")
			playVictimAnim("drivingSeat", "bodyState", "totail")
			showEmote("emotehappysleep")
			vsoNext("state_tail_endo")
		elseif wmDir == "B" then
			vsoSound("transfer")
			vsoAnim("bodyState", "full_regurgitate")
			playVictimAnim("drivingSeat", "bodyState", "regurgitate")
			vsoNext("state_release")
		else
			vsoAnim("bodyState", "full_rumbles")
			vsoSound("struggle")
			showEmote("emotehappysleep")
			wiggleMachine.setMaxAll("drivingSeat", 10)
			wiggleMachine.setMax4DAll("drivingSeat", 5, 5, 5, 5)
			self.dunStruggleplz = true
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_tail_endo()
	wiggleMachine.setMaxAll("drivingSeat", 10)
	wiggleMachine.setMax4DAll("drivingSeat", 5, 5, 5, 5)
	-- wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "tail_wiggle_back", "tail_wiggle_up", "tail_wiggle_front", "tail_wiggle_down")
	vsoTimerSet("sound", 4.0, 8.0)
end

function on_end_tail_endo()
end

function state_tail_endo()
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	if vsoAnimIs("bodyState", "tail_big") then
		if wiggleMachine.update("drivingSeat", "bodyState") > 0 then
			vsoSound("struggle")
		end
	end

	if vsoAnimEnd("bodyState") then
		if vsoPill("heal") then
			local mult = 3.0
			if not vsoAnimIs("bodyState", "tail_big") then
				mult = 0.5
			end
			vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", 2.5 * mult, 100.0, function (inrange)
			end)
		end

		if vsoTimer("sound") then
			vsoSound("full")
		end

		vsoAnim("bodyState", "tail_big")
	end

	if wmType > 0 and vsoAnimIs("bodyState", "tail_big") then
		vsoSound("transfer")
		vsoAnim("bodyState", "tum_transfer")
		playVictimAnim("drivingSeat", "bodyState", "totummy")
		vsoNext("state_full_endo")
	end
end

-------------------------------------------------------------------------------

function on_begin_release()
	self.target = vsoHasEatenId("drivingSeat")
	self.isPudge = false
	if vsoPill("digest") or vsoPill("softdigest") then
		if not vsoAnimIs("bodyState", "full_regurgitate") then
			self.isPudge = true
		end
	end
end

function on_end_release()
end

function state_release()
	if vsoAnimEnd("bodyState") then
		if vsoInList({"full_regurgitate", "small_digest"}, vsoAnimCurr("bodyState")) then
			if vsoAnimIs("bodyState", "full_regurgitate") then
				vsoSound("burp")
				vsoAnim("bodyState", "full_burp")
				playVictimAnim("drivingSeat", "bodyState", "burp")
			end
			if vsoAnimIs("bodyState", "small_digest") then
				vsoSound("burp")
				vsoAnim("bodyState", "small_burp")
				if vsoPill("digest") then
					dropBone(self.target)
				end
			end
		elseif vsoInList({"tail_digest", "med_digest", "full_burp", "small_burp"}, vsoAnimCurr("bodyState")) then
			vsoSound("pounce")
			vsoAnim("bodyState", "acrobatics_reverse")
			if self.isPudge == true then
				playVictimAnim("drivingSeat", "bodyState", "acrobaticsfatal")
			else
				vsoVictimAnimVisible("drivingSeat", false)
				vsoUneat("drivingSeat")
				vsoUseLounge(false, "drivingSeat")
			end
		elseif vsoAnimIs("bodyState", "acrobatics_reverse") then
			if self.isPudge == true then
				vsoNext("state_idle_fatal")
			else
				vsoNext("state_idle")
			end
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_idle_fatal()
	vsoAnim("bodyState", "idle_quad")
	vsoMakeInteractive(false)
	vsoTimerSet("random_actions", 5.0, 15.0)
	self.wannaLeave = false
end

function on_end_idle_fatal()
end

function state_idle_fatal()
	if vsoHasAnySPOInputs("drivingSeat") then
		self.wannaLeave = true
	end

	if vsoAnimEnd("bodyState") then
		local nextAnim = "idle_quad"

		if vsoTimer("random_actions") then
			nextAnim = "idle_quad_breath"
		end

		vsoAnim("bodyState",  nextAnim)
		if self.wannaLeave then
			if vsoPill("digest") then
				world.sendEntityMessage(vsoHasEatenId("drivingSeat"), "applyStatusEffect", "vsokillnpcsit", 1.0, entity.id())
			end
			vsoVictimAnimVisible("drivingSeat", false)
			vsoUneat("drivingSeat")
			vsoUseLounge(false, "drivingSeat")
			vsoNext("state_idle")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_full_fatal()
	wiggleMachine.setMaxAll("drivingSeat", 10)
	wiggleMachine.setMax4DAll("drivingSeat", 5, 5, 5, 5)
	-- wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "full_wiggle_back", "full_wiggle_up", "full_wiggle_front", "full_wiggle_down")
	vsoTimerSet("sound", 4.0, 8.0)
end

function on_end_full_fatal()
end

function state_full_fatal()
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	if vsoAnimIs("bodyState", "full_idle") then
		if wiggleMachine.update("drivingSeat", "bodyState") > 0 then
			vsoSound("struggle")
		end
	end

	if vsoAnimEnd("bodyState") then
		-- local hp = world.entityHealth(vsoHasEatenId("drivingSeat"))
		-- print(hp[1], hp[2], hp[1] / hp[2] * 100.0)
		local mult = 1.0
		if vsoAnimIs("bodyState", "full_rumbles") then
			mult = 3.0
		elseif not vsoAnimIs("bodyState", "full_idle") then
			mult = 0.1
		end

		if vsoTimer("sound") then
			vsoSound("full")
		end

		vsoAnim("bodyState", "full_idle")

		vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -2.5 * mult, 0.0, function (stillalive)
			-- if not stillalive then
			-- 	print("gecko fat")
			-- end
		end)
		local hp = world.entityHealth(vsoHasEatenId("drivingSeat"))
		if hp[1] / hp[2] < 0.75 then
			showEmote("emotehappysleep")
			vsoSound("digest")
			vsoAnim("bodyState", "to_med")
			vsoNext("state_med_fatal")
		end
	end

	if wmType > 0 and vsoAnimIs("bodyState", "full_idle") then
		if wmDir == "F" then
			showEmote("emotehappysleep")
			vsoSound("transfer")
			vsoAnim("bodyState", "tail_transfer")
			playVictimAnim("drivingSeat", "bodyState", "totail")
			vsoNext("state_tail_fatal")
		elseif wmDir == "B" then
			vsoSound("transfer")
			vsoAnim("bodyState", "full_regurgitate")
			playVictimAnim("drivingSeat", "bodyState", "regurgitate")
			vsoNext("state_release")
		else
			wiggleMachine.setMaxAll("drivingSeat", 10)
			wiggleMachine.setMax4DAll("drivingSeat", 5, 5, 5, 5)
			showEmote("emotehappysleep")
			vsoSound("struggle")
			vsoAnim("bodyState", "full_rumbles")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_tail_fatal()
	wiggleMachine.setMaxAll("drivingSeat", 10)
	wiggleMachine.setMax4DAll("drivingSeat", 5, 5, 5, 5)
	-- wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "tail_wiggle_back", "tail_wiggle_up", "tail_wiggle_front", "tail_wiggle_down")
	vsoTimerSet("sound", 4.0, 8.0)
end

function on_end_tail_fatal()
end

function state_tail_fatal()
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	if vsoAnimIs("bodyState", "tail_big") then
		if wiggleMachine.update("drivingSeat", "bodyState") > 0 then
			vsoSound("struggle")
		end
	end

	if vsoAnimEnd("bodyState") then
		local mult = 5.0
		if not vsoAnimIs("bodyState", "tail_big") then
			mult = 0.1
		end

		if vsoTimer("sound") then
			vsoSound("full")
		end

		vsoAnim("bodyState", "tail_big")

		vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -2.5 * mult, 0.0, function (stillalive)
			if not stillalive then
				showEmote("emotehappysleep")
				vsoSound("digest")
				vsoAnim("bodyState", "tail_digest")
				playVictimAnim("drivingSeat", "bodyState", "totummy")
				vsoNext("state_release")
			end
		end)
	end

	if wmType > 0 and vsoAnimIs("bodyState", "tail_big") then
		local hp = world.entityHealth(vsoHasEatenId("drivingSeat"))
		if hp[1] / hp[2] < 0.75 then
			vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -100.0 * hp[1] / hp[2], 0.0, function (stillalive)
			end)
			showEmote("emotehappysleep")
			vsoSound("digest")
			vsoAnim("bodyState", "tail_digest")
			playVictimAnim("drivingSeat", "bodyState", "totummy")
			vsoNext("state_release")
		else
			vsoSound("transfer")
			vsoAnim("bodyState", "tum_transfer")
			playVictimAnim("drivingSeat", "bodyState", "totummy")
			vsoNext("state_full_fatal")
		end
	end
end

-------------------------------------------------------------------------------

function on_begin_med_fatal()
	wiggleMachine.setMaxAll("drivingSeat", 5)
	wiggleMachine.setMax4DAll("drivingSeat", 5, 5, 5, 5)
	-- wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "med_struggle", "med_struggle", "med_struggle", "med_struggle")
	vsoTimerSet("sound", 4.0, 8.0)
end

function on_end_med_fatal()
end

function state_med_fatal()
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	if vsoAnimIs("bodyState", "med_idle") then
		if wiggleMachine.update("drivingSeat", "bodyState") > 0 then
			vsoSound("struggle")
		end
	end

	if vsoAnimEnd("bodyState") then
		-- local hp = world.entityHealth(vsoHasEatenId("drivingSeat"))
		-- print(hp[1], hp[2], hp[1] / hp[2] * 100.0)
		local mult = 2.0
		if not vsoAnimIs("bodyState", "med_idle") then
			mult = 0.2
		end

		if vsoTimer("sound") then
			vsoSound("med")
		end

		vsoAnim("bodyState", "med_idle")

		vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -5.0 * mult, 0.0, function (stillalive)
			-- if not stillalive then
			-- 	print("gecko fat")
			-- end
		end)
		local hp = world.entityHealth(vsoHasEatenId("drivingSeat"))
		if hp[1] / hp[2] < 0.35 then
			showEmote("emotehappysleep")
			vsoSound("digest")
			vsoAnim("bodyState", "to_small")
			vsoNext("state_small_fatal")
		end
	end

	if wmType > 0 and vsoAnimIs("bodyState", "med_idle") then
		local hp = world.entityHealth(vsoHasEatenId("drivingSeat"))
		vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -100.0 * hp[1] / hp[2], 0.0, function (stillalive)
		end)
		showEmote("emotehappysleep")
		vsoSound("digest")
		vsoAnim("bodyState", "med_digest")
		vsoNext("state_release")
	end
end

-------------------------------------------------------------------------------

function on_begin_small_fatal()
	wiggleMachine.setMaxAll("drivingSeat", 9001)
	wiggleMachine.setMax4DAll("drivingSeat", 9001, 9001, 9001, 9001)
	-- wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "small_struggle", "small_struggle", "small_struggle", "small_struggle")
	vsoTimerSet("sound", 4.0, 8.0)
end

function on_end_small_fatal()
end

function state_small_fatal()
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	if vsoAnimIs("bodyState", "small_idle") then
		if wiggleMachine.update("drivingSeat", "bodyState") > 0 then
			vsoSound("struggle")
		end
	end

	if vsoAnimEnd("bodyState") then
		-- local hp = world.entityHealth(vsoHasEatenId("drivingSeat"))
		-- print(hp[1], hp[2], hp[1] / hp[2] * 100.0)
		local mult = 3.0
		if vsoAnimIs("bodyState", "small_struggle") then
			mult = 2.0
		elseif not vsoAnimIs("bodyState", "small_idle") then
			mult = 0.3
		end

		if vsoTimer("sound") then
			vsoSound("small")
		end

		vsoAnim("bodyState", "small_idle")

		vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -2.5 * mult, 0.0, function (stillalive)
			if not stillalive then
				showEmote("emotehappysleep")
				vsoSound("digest")
				vsoAnim("bodyState", "small_digest")
				vsoNext("state_release")
			end
		end)
	end
end

-------------------------------------------------------------------------------
