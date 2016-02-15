require "/scripts/vore/npcvore.lua"

digested = false
isDigest = true

breasts = nil

playerLines = {}

playerLines["idle"] = {	"With every moment that passes, more of your energy becomes my own.",
						"I feel every movement you make in there.~",
						"A prey a day keeps hunger at bay.~",
						"You. Want. This.",
						"I have an idea what to do with all those nutrients you're providing me... hehe...",
						"As weak as you other races are, you do have at least one good purpose... and it's not combat.",
						"I like to appreciate the bigger pleasures in life, such as feeling live prey squirming in my gut.",
						"Are you seriously struggling? Don't make me laugh.",
						"A bigger gut is better than a bigger gun, that's what I always say.~",
						"Soon you'll just melt away.",
						"With our without armor, my belly is a sight to behold!~",
						"No armor can hold back the power of my belly!",
						"During either wartime or peacetime, a quick snack always proves refreshing.",
						"I can feel you getting weaker and weaker in there.",
						"You won't last much longer with all those acids around you.",
						"The only flood you have to deal with is the flood of my stomach acids all over you.~",
						"That's it... let it happen.",
						"Glorp, glurp, blorp.",
						"Hahahahahaha!",
						"I can still fight better than you ever could, even with you inside me!",
						"Having you inside me doesn't slow me down one bit!",
						"Ah, what a satisfying belly-bulge you make.~",
						"Charing into battle with a belly like this should sufficiently distract any enemy!",
						"I might need to replace my nanoweave under-armor after this meal, hehehe...",
						"Scared? You should be.",
						"The feeling of a victim in my belly never gets old.",
						"I've lost count of how many humans that have perished in my belly. It's quite a lot.",
						"Walking around with a prey in my belly makes me want a foot massage. Any volunteers?",
						"You might impress others, but your strength doesn't impress me, prey.",
						"Let go... become mine...",
						"You'll be done for soon enough..."
}

playerLines["eat"] = {	"The Sangheili are the superior race in the galaxy! All others are food to us!",
						"After all the fighting I've done in my life, I deserve a treat like you.~",
						"I am strong. You are weak. This is the way of how things must be.",
						"That's it, don't struggle. Submit to your new mistress.~",
						"My mouth was made to eat prey like you!",
						"I like your taste, weakling. Could use some salt, though.",
						"Your tears add to your flavor.~",
						"Stay still so I can swallow you!",
						"If I want food, then I'm going to get food, and you're the closest meal!",
						"Enjoy the trip down my long throat! Or don't. It doesn't matter to me.",
						"Don't accidentally get yourself poked on any of my teeth.~",
						"You're mine.",
						"You were asking for it. Look how appetizing you are.",
						"If I can swallow a Brute, I can swallow you.",
						"My belly isn't big enough without you in it. Get in. Now.",
						"You're nothing but prey to me, weakling.",
						"Anyone who I can overpower, I eat."
}

playerLines["release"] = {	"You can go free. For now. But I'd better see you back on your knees in front of me by tomorrow.",
							"I bet one thousand Pixels that you'll be back before tomorrow.",
							"You won't be able to stay away from me... for long.",
							"Once you go Sangheili you never go back.~",
							"You'll want to be back inside soon enough.",
							"I'd better not see you with any other preds. Actually, I really don't mind, as long as they're okay with sharing.",
							"I'm letting you out, but know that you're living on borrowed time, weakling.",
							"I'll let you live. For now.",
							"Watch the teeth on your way out.",
							"You're out of my belly, but your life belongs to me now. You are mine for as long as you live, and even after that.~",
}

playerLines["request"] = {	"You want to die, hmm? Well, if you insist.~",
							"You know your place well, slave-species.",
							"Just couldn't resist my exotic beauty, could you?~",
							"Well, you asked for it...~",
							"My mandibles will be gentle, don't worry.~",
							"My maw has quite the alluring quality to it, doesn't it? Why not take a closer look?~",
							"If you keep treating me nice like this, I might let you feel my breasts a bit.~",
							"You see my belly? You want in there?~",
							"Good prey. Maybe next time I'll let you listen to me digest another prey.",
							"You want to be eaten? Weirdo...~",
							"Another meal seduced!~",
							"I've still got my charm.~",
							"My good looks never fail me at getting free food!"
}

playerLines["leave"] = {	"What, you want out already? I'm just getting started on you.",
							"Only if you ask nicely, weakling.",
							"What, aren't you having fun?",
							"Come on, don't be a coward.",
							"If you keep thrashing around than I am going to let you out.",
							"Not comfortable in there, huh?"
}

playerLines["die"] = {	"After all that, and I'm not even full yet. Anyone else want to offer themselves up as a second course?",
						"How does it feel to be dead? Since I killed you, you should feel honored.",
						"I know what you prey are like. You'll die, but you'll be back alive and well. I'll see you then.~",
						"No prey survives the stomach acids of a Sangheili!",
						"Hm, you lasted longer than most... still not very long.",
						"You weren't my first prey, weakling, and you sure won't be the last.",
						"Just like I thought; you went straight to my breasts.",
						"When my belly gets smaller, my breasts get bigger. How about that!",
						"My breasts are sore from growing so much. I should find someone lucky to massage them.~"
}


	
function initHook()

	if storage.breasts == nil then
		breasts = 0
	else
		breasts = storage.breasts
	end
	
	if breasts == 0 then
		legs = "elitelegs"
		fulllegs = "elitelegsbelly"
	elseif breasts == 1 then
		legs = "elitelegsbreasts"
		fulllegs = "elitelegsbellybreasts"
	else
		legs = "elitelegsbreastsxl"
		fulllegs = "elitelegsbellybreastsxl"
	end
	
end

function feedHook()
	if request then
		entity.say( playerLines["request"][math.random(#playerLines["request"])])
	else
		entity.say( playerLines["eat"][math.random(#playerLines["eat"])])
	end
end

function loseHook()
	
	if digested == false then
		if stopWatch <= 91 and stopWatch >=89 then
			entity.say( playerLines["release"][math.random(#playerLines["release"])])
		else
			entity.say( playerLines["leave"][math.random(#playerLines["leave"])])
		end
	else
		digested = false
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines["idle"][math.random(#playerLines["idle"])])
	end
	
	if digested == false then
		if fed and world.entityHealth(victim)[1] <= 5 and (stopWatch <= 85 or request) then
			digested = true
			
			if breasts < 2 then
				breasts = breasts + 1
				storage.breasts = breasts
			end
			
			if breasts == 1 then
				legs = "elitelegsbreasts"
				fulllegs = "elitelegsbellybreasts"
			else
				legs = "elitelegsbreastsxl"
				fulllegs = "elitelegsbellybreastsxl"
			end
			
			if isPlayer then
				entity.say( playerLines["die"][math.random(#playerLines["die"])])
			end
		end
	end
end