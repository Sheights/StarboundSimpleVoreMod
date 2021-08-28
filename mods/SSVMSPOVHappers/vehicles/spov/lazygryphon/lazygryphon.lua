--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @

require("/scripts/vore/vsosimple.lua")
require("/scripts/vore/wigglemachine.lua")

--[[

dev notes:
	neutral:
		idle:
			random emotes -> includes mlem
			random mlem -> guaranteed vore
			interact -> pet with increase chance of being vored
			pet -> emote happy
			no interaction -> fall asleep
		belly:
			struggle around 3 times to get out
			no struggle to get into sleep mode
			digest -> idle
	sleep:
		idle:
			random chance to wake up
			no interaction -> "non-vore sleep"
		nvidle:
			interact to annoy, interact again to get vored
		belly:
			struggle around 3 times to wake the gryphon up
			digest -> sleep idle
extra dev notes:
	shall I add some emote so we could differentiate the sleep and the non-vore sleep? Hm
	how long shall the gryphon stay awake? and how long asleep?
	shall I switch back from nv to simple sleep?


lazygryphon plan:

	start at Standard_idle, can transition into sleep_idle if not interacted with and with random chance.

	Vore can start at both standard_idle and sleep_idle
		at standard_idle:
			The player, pressing E on the gryphon will "pet" it, each consecutive pet increases the chance of the gryphon attempting vore instead being petted
			There's a Chance that the gryphon will play the "mlem" tongue lick animation while being idle, 
				in which case the chance of vore being attempted is garunteed on the first "E" presss within a 5 second time span. 
		at sleep_idle: vore is attempted when interacting with the VSO twice in a short timespan (maybe 5 seconds)

	If the victim is in standard_belly:
		Struggling:
		if the victim does not struggle for a while, then the gryphon may fall asleep, transitioning into sleep_belly
		ideally at least 3 wiggles before a chance to escape?

	If the victim is in sleep_belly:
		the victim has to struggle to wake up the griffon, then struggle out of the standard belly
		ideally at least 3 wiggles before the wake-up sequence

	Pills:
		Digestion:
			basic, digest animation happens at the end of life
		soft digest:
			player still digests, presses space to exit after? (maybe through the regurgitation animation?)
		anti-escape:
			makes it require more wiggles before a chance to escape
				Ideally 6 wiggles before a chance to escape/change state
		easy-escape:
			inverse of anti-escape
				Ideally 1 wiggles before a chance to escape/change state
		healing:
			Player heals in belly
				press space to be released (maybe through the regurgitation animation?)

	Ideally, the VSO will play "emotes" whilst in the standard, non-vore idle
		"yawn"
		"blink"
		"mlem" (Either for use in the vore mechanics, or just another emote if the former is unused)
		"pet" (on interaction, see above)
]]--

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function updatePillsEffect()
	if vsoPill("heal") then
		local healthPerSecond = 2.0
		-- local healthPerSecond = 33.0
		vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", healthPerSecond / 60.0, 100.0, function(inrange) end)
	end
	if vsoPill("softdigest") or vsoPill("digest") then
		local damagePerSecond = 0.75
		-- local damagePerSecond = 25.0
		vsoResourceAddPercentThreshold(vsoHasEatenId("drivingSeat"), "health", -damagePerSecond / 60.0, 0.5, function (stillalive) end)
	end
end

-------------------------------------------------------------------------------

function getFatalStatus()
	local result = false

	if vsoPill("softdigest") or vsoPill("digest") then
		local targetid = vsoHasEatenId("drivingSeat")

		if targetid ~= nil then
			local hp = world.entityHealth(targetid)

			if hp ~= nil then
				if 100.0 * hp[1] / hp[2] < 2.5 then
					result = true
				end
			end
		end
	end

	return result
end

-------------------------------------------------------------------------------

function playVictimAnim(seat, state, anim)
	vsoVictimAnimVisible(seat, true)
	vsoVictimAnimReplay(seat, anim, state)
end

-------------------------------------------------------------------------------

function showEmote(emotename)	--helper function to express a emotion particle	"emotesleepy","emoteconfused","emotesad","emotehappy","love"
	if vsoTimeDelta("emoteblock") > 1 then
		animator.setParticleEmitterBurstCount(emotename, 1)
		animator.burstParticleEmitter(emotename)
	end
end

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
	vsoAnimSpeed(1.0)
	vsoVictimAnimVisible("drivingSeat", false)
	vsoUseLounge(false, "drivingSeat")
	vsoUseSolid(false)
	vsoTimeDelta("emoteblock")
	vsoTimeDelta("mlem")
	vsoTimeDelta("annoy")

	vsoNext("state_idle")
	vsoAnim("bodyState", "idle")

	vsoMakeInteractive(true)
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function onBegin()	--This sets up the VSO ONCE.
	vsoEffectWarpIn()	--Play warp in effect
	onForcedReset()	--Do a forced reset once.
	vsoStorageLoad(loadStoredData)	--Load our data (asynchronous, so it takes a few frames)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_idle", on_begin_idle)

	vsoOnInteract("state_idle", on_interact_idle)

	vsoOnEnd("state_idle", on_end_idle)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_sleep", on_begin_sleep)

	vsoOnInteract("state_sleep", on_interact_sleep)

	vsoOnEnd("state_sleep", on_end_sleep)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_chompn", on_begin_chompn)

	vsoOnEnd("state_chompn", on_end_chompn)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_chomps", on_begin_chomps)

	vsoOnEnd("state_chomps", on_end_chomps)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_swallown", on_begin_swallown)

	vsoOnEnd("state_swallown", on_end_swallown)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_swallows", on_begin_swallows)

	vsoOnEnd("state_swallows", on_end_swallows)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_bellyn", on_begin_bellyn)

	vsoOnEnd("state_bellyn", on_end_bellyn)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_bellys", on_begin_bellys)

	vsoOnEnd("state_bellys", on_end_bellys)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_digestn", on_begin_digestn)

	vsoOnEnd("state_digestn", on_end_digestn)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_digests", on_begin_digests)

	vsoOnEnd("state_digests", on_end_digests)

	-------------------------------------------------------------------------------

	vsoOnBegin("state_regurgitate", on_begin_regurgitate)

	vsoOnEnd("state_regurgitate", on_end_regurgitate)
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
-------------------------------------------------------------------------------

function on_begin_idle()
	vsoTimerSet("sleep", 200, 300)
	-- vsoTimerSet("sleep", 10, 20)
	-- vsoTimerSet("sleep", 1, 2)
	vsoTimerSet("emote", 3, 8)
	vsoCounterSet("pet", 0)
end

-------------------------------------------------------------------------------

function on_interact_idle(targetid)
	if vsoAnimIs("bodyState", "idle") then
		local hasEaten = false
		vsoTimerReset("sleep")

		-- If something interact within the first 6 seconds after the gryphon is placed, this counter will make sure it has mlem-ed at least once
		-- Otherwise the timeDelta would think the gryphon has mlem-ed while it hasn't
		-- Fortunately enough, we don't have this issue with the sleep version
		if vsoCounterValue("mlem") > 0 then
			if vsoTimeDelta("mlem", true) < 6 then
				hasEaten = true
			end
		end

		if hasEaten == false then
			-- since vsoChance(0) CAN return true, having vsoCounterValue("pet") in the negatives will make sure the first pet won't make you being vored
			local petIteration = vsoCounterValue("pet")
			if petIteration == 0 then
				petIteration = -1
			end
			if vsoChance(petIteration * 25.0) == false then
				vsoCounter("pet")
				vsoAnim("bodyState", "pet")
				showEmote("emotehappy")
			else
				hasEaten = true
				if vsoHasEatenId("drivingSeat") ~= nil then
					vsoCounter("pet")
					vsoAnim("bodyState", "pet")
					showEmote("emotehappy")
				end
			end
		end

		if hasEaten == true and vsoHasEatenId("drivingSeat") == nil then
			vsoNext("state_chompn")
		end
	end
end

-------------------------------------------------------------------------------

function on_end_idle()
	-- body
end

-------------------------------------------------------------------------------

function state_idle()
	local nextAnim = "idle"

	if vsoHasEatenId("drivingSeat") ~= nil then
		if vsoHasAnySPOInputs("drivingSeat") then
			if vsoPill("digest") then
				world.sendEntityMessage(vsoHasEatenId("drivingSeat"), "applyStatusEffect", "vsokillnpcsit", 1.0, entity.id())
			end
			vsoVictimAnimVisible("drivingSeat", false)
			vsoUneat("drivingSeat")
			vsoUseLounge(false, "drivingSeat")
		end
	end

	if vsoAnimEnd("bodyState") then
		if vsoAnimIs("bodyState", "idle_to_sleep") then
			vsoNext("state_sleep")
			nextAnim = "sleep"
		elseif vsoAnimIs("bodyState", "idle") then
			if vsoTimer("sleep") then
				nextAnim = "idle_to_sleep"
			elseif vsoTimer("emote") then
				nextAnim = vsoPick({ "mlem", "yawn", "blink" })
				if nextAnim == "mlem" then
					vsoTimeDelta("mlem")
					vsoCounterSet("mlem", 5)
				end
			end
		end

		vsoAnim("bodyState", nextAnim)
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_sleep()
	vsoTimerSet("wakeup", 200, 300)
	-- vsoTimerSet("wakeup", 10, 20)
end

-------------------------------------------------------------------------------

function on_interact_sleep(targetid)
	if vsoAnimIs("bodyState", "sleep") then
		local hasEaten = false
		vsoTimerReset("wakeup")

		if vsoTimeDelta("annoy", true) < 6 then
			hasEaten = true
			if vsoHasEatenId("drivingSeat") ~= nil then
				vsoAnim("bodyState", "sleep_annoy")
				vsoTimeDelta("annoy")
			end
		else
			vsoAnim("bodyState", "sleep_annoy")
			vsoTimeDelta("annoy")
		end

		if hasEaten == true and vsoHasEatenId("drivingSeat") == nil then
			vsoNext("state_chomps")
		end
	end
end

-------------------------------------------------------------------------------

function on_end_sleep()
	-- body
end

-------------------------------------------------------------------------------

function state_sleep()
	local nextAnim = "sleep"

	if vsoHasEatenId("drivingSeat") ~= nil then
		if vsoHasAnySPOInputs("drivingSeat") then
			if vsoPill("digest") then
				world.sendEntityMessage(vsoHasEatenId("drivingSeat"), "applyStatusEffect", "vsokillnpcsit", 1.0, entity.id())
			end
			vsoVictimAnimVisible("drivingSeat", false)
			vsoUneat("drivingSeat")
			vsoUseLounge(false, "drivingSeat")
		end
	end

	if vsoAnimEnd("bodyState") then
		if vsoAnimIs("bodyState", "sleep_to_idle") then
			vsoNext("state_idle")
			nextAnim = "idle"
		elseif vsoAnimIs("bodyState", "sleep") then
			if vsoTimer("wakeup") then
				nextAnim = "sleep_to_idle"
			end
		end

		vsoAnim("bodyState", nextAnim)
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_chompn()
	vsoAnim("bodyState", "chomp")
end

-------------------------------------------------------------------------------

function on_end_chompn()
	-- body
end

-------------------------------------------------------------------------------

function state_chompn()
	vsoDebugRelativeRect(4.5, -3.5, 7.125, 1.0, "green")
	vsoUpdateTarget("prey", 4.5, -3.5, 7.125, 1.0)

	if vsoAnimEnd("bodyState") then
		if vsoAnimIs("bodyState", "chomp_miss") then
			vsoNext("state_idle")
			vsoAnim("bodyState", "idle")
		elseif vsoGetTargetId("prey") ~= nil then
			vsoNext("state_swallown")
		elseif vsoAnimIs("bodyState", "chomp") then
			vsoAnim("bodyState", "chomp_miss")
		end
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_chomps()
	vsoAnim("bodyState", "sleep_chomp")
end

-------------------------------------------------------------------------------

function on_end_chomps()
	-- body
end

-------------------------------------------------------------------------------

function state_chomps()
	vsoDebugRelativeRect(4.5, -3.5, 7.125, 1.0, "green")
	vsoUpdateTarget("prey", 4.5, -3.5, 7.125, 1.0)

	if vsoAnimEnd("bodyState") then
		if vsoAnimIs("bodyState", "sleep_chomp_miss") then
			vsoNext("state_sleep")
			vsoAnim("bodyState", "sleep")
		elseif vsoGetTargetId("prey") ~= nil then
			vsoNext("state_swallows")
		elseif vsoAnimIs("bodyState", "sleep_chomp") then
			vsoAnim("bodyState", "sleep_chomp_miss")
		end
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_swallown()
	vsoAnim("bodyState", "chomp_devour")
	vsoSound("slurp")
	vsoUseLounge(true, "drivingSeat")
	vsoEat(vsoGetTargetId("prey"), "drivingSeat")
	playVictimAnim("drivingSeat", "bodyState", "chomp_devour")
end

-------------------------------------------------------------------------------

function on_end_swallown()
	-- body
end

-------------------------------------------------------------------------------

function state_swallown()
	if vsoAnimEnd("bodyState") then
		if vsoAnimIs("bodyState", "chomp_devour") then
			vsoAnim("bodyState", "bellyn_intro")
			vsoSound("swallow")
			playVictimAnim("drivingSeat", "bodyState", "bellyn_intro")
		elseif vsoAnimIs("bodyState", "bellyn_intro") then
			vsoNext("state_bellyn")
		end
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_swallows()
	vsoAnim("bodyState", "sleep_chomp_devour")
	vsoSound("slurp")
	vsoUseLounge(true, "drivingSeat")
	vsoEat(vsoGetTargetId("prey"), "drivingSeat")
	playVictimAnim("drivingSeat", "bodyState", "sleep_chomp_devour")
end

-------------------------------------------------------------------------------

function on_end_swallows()
	-- body
end

-------------------------------------------------------------------------------

function state_swallows()
	if vsoAnimEnd("bodyState") then
		vsoSound("swallow")
		vsoNext("state_bellys")
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_bellyn()
	local maxStruggles = 5
	local struggles = 3

	if vsoPill("easyescape") then
		maxStruggles = 3
		struggles = 2
	elseif vsoPill("antiescape") then
		maxStruggles = 10
		struggles = 6
	end

	wiggleMachine.setMaxAll("drivingSeat", maxStruggles)
	wiggleMachine.setMax4DAll("drivingSeat", struggles, struggles, struggles, struggles)
	wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "bellyn_struggle_right", "bellyn_struggle_up", "bellyn_struggle_left", "bellyn_struggle_down")

	vsoTimerSet("full_sleep", 8, 15)
	vsoTimerSet("sound", 3, 8)
	vsoAnim("bodyState", "bellyn")
end

-------------------------------------------------------------------------------

function on_end_bellyn()
	-- body
end

-------------------------------------------------------------------------------

function state_bellyn()
	local nextAnim = "bellyn"
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	updatePillsEffect()

	if getFatalStatus() then
		vsoNext("state_digestn")
		vsoAnim("bodyState", "bellyn_digest")
		vsoSound("digest")
	end

	if vsoAnimIs("bodyState", "bellyn") then
		-- wiggleMachine.update("drivingSeat", "bodyState")
		if wiggleMachine.update("drivingSeat", "bodyState") > 0 then
			vsoTimerReset("full_sleep")
		end
	end

	if vsoTimer("sound") then
		vsoSound("digest")
	end

	if vsoAnimEnd("bodyState") then
		if wmType > 0 then
			vsoNext("state_regurgitate")
			nextAnim = "bellyn_regurgitate"
		elseif vsoTimer("full_sleep") then
			nextAnim = "bellyn_to_bellys"
		elseif vsoAnimIs("bodyState", "bellyn_to_bellys") then
			vsoNext("state_bellys")
			nextAnim = "bellys"
		end

		vsoAnim("bodyState", nextAnim)
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_bellys()
	local maxStruggles = 5
	local struggles = 3

	if vsoPill("easyescape") then
		maxStruggles = 3
		struggles = 2
	elseif vsoPill("antiescape") then
		maxStruggles = 10
		struggles = 6
	end

	wiggleMachine.setMaxAll("drivingSeat", maxStruggles)
	wiggleMachine.setMax4DAll("drivingSeat", struggles, struggles, struggles, struggles)
	wiggleMachine.setSoundAll("drivingSeat", "struggle")
	wiggleMachine.setAnimAll("drivingSeat", "bellys_struggle_right", "bellys_struggle_up", "bellys_struggle_left", "bellys_struggle_down")

	vsoTimerSet("sound", 3, 8)
	vsoAnim("bodyState", "bellys")
end

-------------------------------------------------------------------------------

function on_end_bellys()
	-- body
end

-------------------------------------------------------------------------------

function state_bellys()
	local nextAnim = "bellys"
	local wmType, wmDir = wiggleMachine.getStatus("drivingSeat")

	updatePillsEffect()

	if getFatalStatus() then
		vsoNext("state_digests")
		vsoAnim("bodyState", "bellys_digest")
		vsoSound("digest")
	end

	if vsoAnimIs("bodyState", "bellys") then
		wiggleMachine.update("drivingSeat", "bodyState")
	end

	if vsoTimer("sound") then
		vsoSound("digest")
	end

	if vsoAnimEnd("bodyState") then
		if vsoAnimIs("bodyState", "bellys_to_bellyn") then
			vsoNext("state_bellyn")
			nextAnim = "bellyn"
		elseif wmType > 0 then
			nextAnim = "bellys_to_bellyn"
		end

		vsoAnim("bodyState", nextAnim)
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_digestn()
	-- body
end

-------------------------------------------------------------------------------

function on_end_digestn()
	vsoCounterSet("leave", 0)
end

-------------------------------------------------------------------------------

function state_digestn()
	if vsoAnimEnd("bodyState") then
		vsoNext("state_idle")
		vsoAnim("bodyState", "idle")
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_digests()
	-- body
end

-------------------------------------------------------------------------------

function on_end_digests()
	vsoCounterSet("leave", 0)
end

-------------------------------------------------------------------------------

function state_digests()
	if vsoAnimEnd("bodyState") then
		vsoNext("state_sleep")
		vsoAnim("bodyState", "sleep")
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function on_begin_regurgitate()
	playVictimAnim("drivingSeat", "bodyState", "bellyn_regurgitate")
	vsoSound("lay")
end

-------------------------------------------------------------------------------

function on_end_regurgitate()
	-- body
end

-------------------------------------------------------------------------------

function state_regurgitate()
	if vsoAnimEnd("bodyState") then
		vsoVictimAnimVisible("drivingSeat", false)
		vsoUneat("drivingSeat")
		vsoUseLounge(false, "drivingSeat")
		vsoNext("state_idle")
		vsoAnim("bodyState", "idle")
	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
