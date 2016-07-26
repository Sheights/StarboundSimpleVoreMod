require "/scripts/vore/multivore.lua"

animFlag = false

animTimer = 0

playerLines = {}

playerLines[1] = {	"You're surrounded by the milky way!",
					"I can see your figure on my belly. heheh.",
					"I can see where your head would be!",
					"Its like elastic, so form fitting.",
					"You are such a good appetiser.",
					"Face the side so you don't get a face full of flesh.",
					"Enjoying your stay in there?",
					"I'm enjoying this. So much so.",
					"*pats belly near your head.*",
					"*rubs my belly around your form*",
					"*belches* I wish you went in head first. heheh...",
					"Hmm... I wonder how far you can stretch out?",
					"You're just the right size.",
					"Hows it feel in there? Comfy?",
					"Hehe.. keep going.",
					"I could do with more of that.",
					"I need more, its not enough yet.",
					"I'm still pretty hungry.",
					"*stomach growls* Still hungry... Wheres your friends?",
					"*stomach rumbles* Let me feast on your woes.",
					"Where are your buddies?",
					"You're quite delectable, but I could do with much more.",
					"Any of your friends you won't miss?",
					"You'll be nice and gooy later.",
					"Digest slowly...",
					"Don't worry, its painless.",
					"You won't feel a thing.",
					"It won't be long now.",
					"I can feel your body softening.",
					"Your struggles are slowing.",
					"*pokes belly* still kicking in there?"
}

playerLines[2] = {	"Enjoy the ride through the galaxy. hehehe...",
					"Ok, this is more like it.",
					"Finally, some sustenance!",
					"Don't fight in there, you two. I want to enjoy this.",
					"Well its not quite so form fitting. Where are your heads?",
					"*Long, stretched out belch*",
					"*sighs* such a relaxing time.",
					"hehehe.. I enjoy having the two of you in there.",
					"keep squirming, you two. I'm enjoying this so much.",
					"Aaaah... what a treat.",
					"You two are quite filling.",
					"I can feel one of you softening quite nicely, the other is still solid however.",
					"Which one of you will join my body first?",
					"I can see your kicks and hands moving.",
					"Care to be a part of the monster under your bed?",
					"I'll be going hunting soon. Don't make a peep. That kid next door won't know what hit him.",
					"Aaah.. Digesting nicely.",
					"*sighs in bliss*",
					"*rubs my belly* Smoothing out well.",
					"Care to add a third in there?",
					"You two are so filling.. but I still would like a third.",
					"Now.. where can I find a third tasty morsal?",
					"Still a little peckish. Something else must fill my hunger.",
					"Aaah...",
					"Such deliciousness!",
					"You two are a delicacy.",
					"Digest nice and slowly.. I want to enjoy this longer.",
					"Almost nothing left...",
					"You two will be a perfect addition to my body.",
					"Don't stop moving yet! I want to enjoy this longer!",
					"Heheh.. love having free food.",
					"You're both just food for me now.",
					"Such delicious food!",
					"I wonder if anyone's missing you yet?",
					"I hope no one is missing you two... I don't want to be disturbed.",
					"The first bit of time is the best, after that, its fun to soften you both up.",
					"There won't even be bones left.",
					"No remains, no evidence, no one will ever know where you disappeared.",
					"I'll take whatever you two are carrying.",
					"Relax, don't fight it. You two will be gone soon enough.",
					"Don't worry its painless, you two.",
					"Relax, you two wont feel a thing.",
					"You two will just be falling asleep before long. Don't worry.",
					"Gah, your hair and fur are getting stuck in my teeth!",
					"*Picks up my belly and bounces it around, shuffling you about*",
					"I could just roll you up and keep you forever. oh Wait, I already did.",
					"Hmm. What to eat next.",
					"What a way to go in the belly of a beast. hehe.",
					"*twists around, squeasing you tightly*",
					"What a good meal for me!",
					"You two aren't escaping just yet!"
}

playerLines[3] = {	"A three body trip through space? What a chance!",
					"Now this is what I am talking about!",
					"Finally, Filled as much as I can take!",
					"I bet its pretty tight in there.",
					"Stop fidgeting!",
					"Aaah.. let the digestion begin.",
					"*belches long and hard*",
					"Ugh... Think I ate too much.. but its worth it.",
					"*sighs in complete bliss*",
					"Heheh.. feel sorry for the guy stuck in my tail by himself. he should be digesting much faster.",
					"This is ganna take a while to digest...",
					"This is ganna make me so fat!",
					"I enjoy being this rounded.",
					"You three are ganna be with me for a long time.",
					"Digest slowly you three...",
					"I want to eat a fourth.. but I'd be imobile...",
					"I can feel you three so definely.",
					"I bet its pretty packed in there.",
					"You three okay? May be hard to move in there.",
					"Enjoy your stay, you three!",
					"Aaaah... so full...",
					"Three course meal!",
					"You three wont see the light of day again. Oh wait, you reform... No fair.",
					"Soften up nicely, you three.",
					"Keep moving around, it makes food melt faster.",
					"*rubs his swollen belly*",
					"I could do this all day... I want to do this all day...",
					"So much food... So good...",
					"You three are just food for me now.",
					"Perfect, right where food needs to be!",
					"Filling meal for me.",
					"What a delightful meal.",
					"Im so stuffed!",
					"Heheh.. So stuffed.",
					"Let my belly make good use of you!",
					"Digest slowly you guys... this will last me a long time.",
					"Wonder how long you three will last.",
					"You can fight all you want, my stomach will win.",
					"A fitting end for a meal.",
					"Let the digestion set in.",
					"Listen carefully... these three will be goo soon...",
					"My stomach will churn you nicely into a soft nutritional froth. heheh.",
					"I can't wait to see just how fattening you three make me!",
					"I'm imagining just how you three will form my body. I'd like a bulkier belly and tail.",
					"Churn and churn you three go, crunch and slosh and melt away!",
					"So many bones and remains to take care of. Don't want suspicious eyes finding them.",
					"You guys must feel like a can of sardines.",
					"Your bodies can be seen on the outside. so defined!",
					"My belly has been waiting a long time for your four.",
					"I hope you don't plan on being anywhere.",
					"I want to just sleep this off..."
}

playerLines["eat"] = {	"Look at all the stars around you. So pretty to look at, right?",
						"Oooh.. you taste so good!",
						"Slide down rough, I love the fighters.",
						"You'll fit in nicely.",
						"What a tasty little meal!",
						"Hey, Slow down, I want to enjoy this.",
						"No pushing! You'll make it.",
						"... So delicious...",
						"Just let me savor this for a while.",
						"Mind those teeth! They are very pointy.",
						"You're an eager one.",
						"What a wonderful day this turned out for me!",
						"Stay as long as you want to, I love being full.",
						"Now for an entre.",
						"Move more, I want you to move around more!",
						"Don't fight it, this is a one way trip.",
						"Food's edible, you're edible, make the connection.",
						"Heheh, yum yum food in my belly.",
						"I love your taste.",
						"You taste different today.",
						"There isn't much I can say except, yum! hmhm.",
						"I'd like to keep you for a long time."
}

playerLines["exit"] = {	"Why So soon?",
						"Care to stay a bit longer next time?",
						"And I thought we were spending quality time together.",
						"Fun times. I was full of such lovely food. you were digesting away... fun times.",
						"Over too soon.",
						"And I was enjoying myself.",
						"I'm still hungry.",
						"Looks like its time to find another meal.",
						"All good things just repeat again, heheh.",
						"Come back soon, I can't wait."
}

function redress()

	digest()
	
end

function digestHook()

	if #victim > 0 then
		npc.setItemSlot( "legs", "lalimlegsbelly" .. #victim )
	else
		npc.setItemSlot( "legs", "lalimlegs" )
	end
	
end


function feedHook()

	npc.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )
	
	if animFlag == true then
		animTimer = 0
	else
		animFlag = true
	end
	
end

function updateHook(dt)
	
	if animFlag then

		dt = dt or 0.01
		if animTimer < 0.7 then
			npc.setItemSlot( "chest", "lalimchestbelly" )
		else
			npc.setItemSlot( "chest", "lalimchest" )
			if #victim > 0 then
				npc.setItemSlot( "legs", "lalimlegsbelly" .. #victim )
			else
				npc.setItemSlot( "legs", "lalimlegs" )
			end
			animFlag = false
			animTimer = 0
		end
		
		animTimer = animTimer + dt
	end
	
	if math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true or request[4] == true ) then
		npc.say( playerLines[ #victim ][ math.random( #playerLines[ #victim ] ) ] )
	end
	
end

function forceExit()

	npc.say( playerLines["exit"][ math.random( #playerLines["exit"] )] )

	if #victim > 1 then
		npc.setItemSlot( "legs", "lalimlegsbelly" .. #victim )
	else
		npc.setItemSlot( "legs", "lalimlegs" )
	end
	
end