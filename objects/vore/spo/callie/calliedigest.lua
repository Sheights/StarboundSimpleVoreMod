animState = "blank"

--animator.setAnimationState("bodyState", "fed4")
--animator.playSound("digest")

idleLines = {	"Heya~!",
				"You seem nice. Wanna hang out?",
				"Do you RP~?",
				"Gosh I'm hungry...",
				"So they were buying a boffer sword from me, but then an actual customer walked in, but I didn't wanna break character, so I just kept talking like a mobster, and they totally rolled with it, so I...",
				"Oh, you make stuff too~?",
				"Aaah, where did I put that foam...",
				"Need a seat?",
				"I'm in a snuggling mood.",
				"Maaaar!",
				"Heehee~",
				"Would you maybe wanna let me eat you sometime?"
}

rpLines = {	"Nyaaan, see here, nyan?",
			"Nyan, if you need a weapon, you've come to the right place, nyan!",
			"Can... uh... can I borrow your gun so we can pretend I'm selling it to you?",
			"*Chews on fake cigar*",
			"Better not start trouble. I take my business VERY seriously.",
			"Pew pew! Dakkadakkadakka!"
}

bellyLines = {	"Hope you're cozy in there~",
				"This is really nice.",
				"Hnnnnn~",
				"Hee, I'm not gonna be able to walk for a week.",
				"Thank you for feeding me~",
				"I wonder how long this will last~",
				"...so that's when the fight spilled out into the common area, and people were having lunch, and darts were flying everywhere, and people were huddling below the tables, and I think someone vaulted a mine cart before...",
				"...And she just stared down at us, with like, 5 darts stuck to her face, all big and scary and draconic, and then everyone burst out laughing. But yeah, now I break character when people are shopping.",
				"Oooh, that was a good spot~",
				"Oh, do you want out? I can try, but I don't have much control at this point...",
				"I'm really nice and full.",
				"This was really sweet of you.",
				"I'm really happy I found you~"
}

digestLines = {	"Can we do this again sometime~?",
				"Haaaah... Haaaah...",
				"Aaaahhh, keep doing that...",
				"Nnnh... yeah, right there.",
				"I'm really gonna miss you~",
				"Just a bit longer~",
				"You'll come back, right~?",
				"That feels amazing~",
				"Gosh, I can feel you melting~",
				"Are you still awake in there~?",
				"That feels wonderful!"
}

animState = "blank"

deathFlag = false
talkFlag = false

health = 0
talkTimer = 0
victim = 0

function init()
	object.setInteractive(true)
end

function update(dt)

	animState = animator.animationState("bodyState")

	if world.loungeableOccupied(entity.id()) then
	
		if ( animState == "idle" or animState == "talk" ) and deathFlag == false then
			talkFlag = false
			talkTimer = 0
			animator.setAnimationState("bodyState", "swallow")
			animator.playSound("swallow")
		end
		
		if math.random(500) == 1 then
			if animState == "digest" then
				object.say( bellyLines[ math.random( #bellyLines ) ] )
			elseif animState == "lowdigest" then
				object.say( digestLines[ math.random( #digestLines ) ] )
			end
		end
		
		if animState == "digest" or animState == "lowdigest" then
			if victim ~= null then
				health = world.entityHealth(victim)[1] / world.entityHealth(victim)[2]
			end
			if health < 0.05 and animState == "lowdigest" then
				animator.setAnimationState("bodyState", "death")
				deathFlag = true
			elseif health < 0.30 and animState == "digest" then
				animator.setAnimationState("bodyState", "lowtran")
			end		
		end
		
		if math.random(400) == 1 then
			world.spawnProjectile( "digestprojectile" , object.position(), entity.id(), {0, 0}, false )
		end
	else
		
		if animState == "swallow" or animState == "foreloop" or animState == "tailpush" then
			animator.setAnimationState("bodyState", "regurgitate")
			do return end
		elseif animState == "digest" or animState == "lowtran" or animState == "lowdigest" then
			animator.setAnimationState("bodyState", "breakheart")
			do return end
		end
		
		if math.random(500) == 1 then
			if animState == "idle" then
				local people = world.entityQuery( object.position(), 10, {
					includedTypes = {"player"},
					boundMode = "CollisionArea"
				})
				if #people > 0 then
					object.say( idleLines[ math.random( #idleLines ) ] )
					animator.setAnimationState("bodyState", "talk")
					talkFlag = true
					do return end
				elseif math.random(10) == 1 then
					animator.setAnimationState("bodyState", "cosidle")
					object.setInteractive(false)
				end
			elseif animState == "cosidle" then
				local people = world.entityQuery( object.position(), 10, {
					includedTypes = {"player"},
					boundMode = "CollisionArea"
				})
				if #people > 0 then
					object.say( rpLines[ math.random( #rpLines ) ] )
					animator.setAnimationState("bodyState", "costalk")
					talkFlag = true
					do return end
				elseif math.random(4) == 1 then
					animator.setAnimationState("bodyState", "idle")
					object.setInteractive(true)
				end
			end
		end
		deathFlag = false
	end
	
	if talkFlag then
		if talkTimer < 5 then
			talkTimer = talkTimer + dt
		else
			if animState == "talk" then
				animator.setAnimationState("bodyState", "idle")
			else
				animator.setAnimationState("bodyState", "cosidle")
			end
			talkFlag = false
			talkTimer = 0
		end
	end
end

function onInteraction(args)
	victim = args.sourceId
end