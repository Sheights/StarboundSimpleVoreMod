require "/scripts/vore/multivore.lua"

animFlag = false

animTimer = 0
capacity = 4

request		= { false, false, false, false }
victim		= { nil, nil, nil, nil }

playerLines = {}

playerLines[1] = {	"This is nothing, I need more!",
					"Don't get comfy, I'm no where near full yet.",
					"Spacious for ya?",
					"You're a good appetiser.",
					"Don't fall asleep in there.",
					"Having a good time?",
					"I'm enjoying this.",
					"*pats belly*",
					"*rubs belly*",
					"*belches*",
					"Hmm... I want to see what I ate... but... it can wait.",
					"Wow, you're small.",
					"Hows it feel in there?",
					"Hey! Don't do that!",
					"Hey... What are you do-uuuaaaap... Very funny.",
					"I need more.",
					"I'm still hungry.",
					"*stomach growls* Still hungry...",
					"*stomach rumbles* You're not much.",
					"Wish you were bigger.",
					"You're enjoyable, but I could do with more.",
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

playerLines[2] = {	"Ok, this is more like it.",
					"Finally, some sustenance!",
					"Don't fight in there, you two. I want to enjoy this.",
					"H-hey! Don't do that!",
					"*Long belch*",
					"*sighs* so relaxing.",
					"hehehe... enjoying the two of you in there. ",
					"keep squirming, you two. I'm enjoying this.",
					"Aaaah... let me enjoy this...",
					"You two are quite filling.",
					"I can feel one of you softening quite nicely, the other is still solid however.",
					"Which one of you is melting the most?",
					"Hey, you still kicking in there, you two?",
					"Care to be a part of a noven?",
					"I can't wait to try out the extra fluff you two add to me.",
					"Aaah... Digesting nicely.",
					"*sighs in bliss*",
					"*rubs my belly* Smoothing out well.",
					"Care to add a third in there?",
					"You two are so filling... but I still would like a third.",
					"Now... where can I find a third tasty morsal?",
					"Still a little peckish.",
					"Aaah...",
					"Such deliciousness!",
					"You two are a delicacy.",
					"Digest nice and slowly... I want to enjoy this longer.",
					"Almost nothing left...",
					"You two will make fine fluff for me to enjoy.",
					"I can't wait to see the belly i get from this!",
					"Heheh... love having free food.",
					"You're both just food for me now.",
					"Such delicious food!",
					"You all can't have them, these two are my dinner to enjoy!",
					"I hope no one is missing you two... I don't want to be disturbed. ",
					"The first bit of time is the best, after that, its fun to soften you both up.",
					"Don't want anyone to find the bones...",
					"Gotta hide the remains.",
					"I'll take whatever you two are carrying. ",
					"Relax, don't fight it. You two will be gone soon enough.",
					"Don't worry its painless, you two.",
					"Relax, you two wont feel a thing.",
					"You two will just be falling asleep before long. Don't worry.",
					"Gah, your hair and fur are getting stuck in my teeth!",
					"*smacks belly hard like a drum* Don't do that in there!",
					"*pats my belly like a drum to a beat of a song in my head*",
					"Dum-de-do-dum Do-De-Dum-De.",
					"De-Do-da-de-dum Do-do-De.",
					"*hums a tune*",
					"*sings to a song*",
					"*bounces his belly*"
}

playerLines[3] = {	"Now this is what I am talking about!",
					"Finally, Filled as much as I can take!",
					"I bet its pretty tight in there.",
					"Stop fidgeting!",
					"Aaah...let the digestion begin.",
					"*belches long and hard*",
					"ugh... Think I ate too much...but its worth it.",
					"*sighs in complete bliss*",
					"Hard to really move...",
					"This is ganna take a while to digest...",
					"This is ganna make me so fat!",
					"I enjoy being this rounded.",
					"You three are ganna be with me for a long time.",
					"Digest slowly you three...",
					"I want to eat a fourth...but I'd be imobile...",
					"I can feel you three so definely.",
					"I bet its pretty packed in there.",
					"You three okay? May be hard to move in there.",
					"Enjoy your stay, you three!",
					"Aaaah... so full...",
					"Three course meal!",
					"You three wont see the light of day again. Oh wait, you reform... No fair.",
					"Soften up nicely, you three.",
					"keep moving around, it makes food melt faster.",
					"*rubs his swollen belly*",
					"I could do this all day... I want to do this all day...",
					"so much food... So good...",
					"You three are just food for me now.",
					"Perfect, right where food needs to be!",
					"Filling meal for me.",
					"What a delightful meal.",
					"Im so stuffed!",
					"I... Can't... eat any more...",
					"So... Full...",
					"I... don't need more.",
					"Wonder how long you three will last.",
					"You can fight all you want, my stomach will win.",
					"A fitting end for a meal.",
					"let the digestion set in.",
					"Listen carefully... these three will be goo soon...",
					"I'll be so fat after this!",
					"I can't wait to see just how fattening you three make me!",
					"I'm imagining just how you three will form my body. I'd like a bulkier belly and tail.",
					"Churn and churn you three go, crunch and slosh and melt away!",
					"So many bones and remains to take care of. Don't want suspicious eyes finding them."
}

playerLines[4] = {	"Phew! Fit that last one in just barely!",
					"I can barely move!",
					"My stomach is dragging the ground.",
					"OW, ran over a rock.",
					"you guys sure made me stuffed.",
					"... ugh...",
					"What did I do to myself...",
					"Everyone stop struggling! I nearly fell over!",
					"Woah! Cut out the movement! I nearly lost my balance!",
					"Steady... Steady...",
					"Digest slowly you guys... this will last me a long time.",
					"So much food... So much girth...",
					"... This is ganna make me so fat later...",
					"I... Need to cut back... But I don't want to.",
					"My stomach is growling... I hope it can handle so much food.",
					"Fill my belly to the brim, the four of you!",
					"This is beyond a delicious meal!",
					"Combine together into one massive soup of nutrition for me!",
					"Are ya'll still individuals? I can't tell. It won't be for long, anyway.",
					"I'm going to be so incredibly fat later...",
					"Uuuuuuuurrraaap!",
					"Hngh!... ugh... nearly lost it...",
					"This aches a little... but it still feels so good...",
					"I want to just sleep this off...",
					"Let my belly make good use of you!",
					"My stomach will churn you nicely into a soft nutritional froth. heheh.",
					"Huff... huff... one... step at... a time... huff...",
					"*sighs, tiredly*",
					"*yawns loudly*",
					"I could go for a nap...",
					"zzzzzzzzzzzzz..... *pop* huh, what? Was I sleep walking?",
					"oooooh...",
					"Feels so nice...",
					"I could... do this... all day long...",
					"... phew...",
					"Such wonderful meals...",
					"Is the first guy in there still solid?",
					"I'm pretty sure the first guy is just froth now.",
					"I wonder if the second one is still moving?",
					"Hey, still kicking down there?",
					"*pokes his gut, and his hand sinks through a fair bit*",
					"You guys will be a part of me soon. Hopefully not too soon.",
					"A meal fit for a king. hehehe.",
					"You're all my food now. At least for the time being, heheh.",
					"I can't fit a single bite more.",
					"You guys can settle your differences in there. Plenty of time to chat!",
					"You guys comfy?",
					"I hope you're not too tight in there.",
					"You guys must feel like a can of sardines.",
					"Your bodies can be seen on the outside. so defined!",
					"My belly has been waiting a long time for your four.",
					"I hope you don't plan on being anywhere.",
					"Its like a party in my belly!",
					"I'll play some good music. Heheh.",
					"No funny business in there, please.",
					"HGNNNGH OH GOD!! PLEASE STOP THAT!! ITS TOO MUCH!!",
					"AAAAUGH DOn't Tickle that spot! NO!",
					"Aaaah... Yeah... massage more... that feels so good...",
					"That feels so enjoyable...",
					"You guys are making me so sleepy..... *yawns* ... May take a nap."
}

playerLines["eat"] = {	"oooh... you taste so good!",
						"Slide down gently.",
						"You'll fit in nicely.",
						"What a tasty little treat!",
						"Woah hey, slow down!",
						"No pushing! You'll make it.",
						"... So tasty...",
						"Just let me savor this.",
						"Mind the teeth, their sharp.",
						"So eager!",
						"*stares off vacantly*... huh... what? Hey whats down there!?",
						"Stay as long as you like, I love having a full stomach.",
						"Now to find someone else to join ya.",
						"The more you move, the more i enjoy it.",
						"Don't fight it, its inevitable.",
						"Food's edible, you're edible, make the connection.",
						"heheh, yum yum food in my belly.",
						"Delicious!",
						"hmm... You taste off today.",
						"Blech... take a bath next time please."
}

playerLines["exit"] = {	"Aww... come on... I was enjoying that...",
						"Why so soon...?",
						"Don't leave! I... I'll rub some more!",
						"Come on... Why?",
						"It can't be over already!",
						"And I was enjoying myself too...",
						"Aww... but... I'm hungry...",
						"Well... I guess its someone else's turn then?",
						"I guess all good things must end.",
						"Come back soon, I can't wait."
}

function redress()

	digest()
	
end

function digestHook()

	entity.say( #victim )
	if #victim > 0 then
		entity.setItemSlot( "legs", "novenlegsbelly" .. #victim )
	else
		entity.setItemSlot( "legs", "novenlegs" )
	end
	
end

function feedHook()

	entity.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )
	
	if animFlag == true then
		animTimer = 0
	else
		animFlag = true
	end
	
end

function updateHook(dt)

	if animFlag then

		dt = dt or 0.01
		if animTimer < 5.0 then
			entity.setItemSlot( "head", "novenhead2" )
		else
			entity.setItemSlot( "head", "novenhead1" )
			if #victim > 0 then
				entity.setItemSlot( "legs", "novenlegsbelly" .. #victim )
			else
				entity.setItemSlot( "legs", "novenlegs" )
			end
			animFlag = false
			animTimer = 0
		end
		
		animTimer = animTimer + dt
	end
	
	if math.random(500) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true or request[4] == true ) then
		entity.say( playerLines[ #victim ][ math.random( #playerLines[ #victim ] ) ] )
	end
end

function forceExit()

	entity.say( playerLines["exit"][ math.random( #playerLines["exit"] )] )

	if #victim > 1 then
		entity.setItemSlot( "legs", "novenlegsbelly" .. #victim )
	else
		entity.setItemSlot( "legs", "novenlegs" )
	end
	
end