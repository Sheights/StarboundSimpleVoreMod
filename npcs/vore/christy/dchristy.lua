require "/scripts/vore/multivore.lua"

animFlag = false
isDigest = true

animTimer = 0
capacity = 2

request		= { false, false }
victim		= { nil, nil }

playerLines = {}

playerLines[1] = {	"I can see you pressing out on my belly. Mmmm.",
					"You feel so good inside of me.. You're mine!",
					"*stomach churns, squeezing and gurgles around your form in the blue darkness.",
					"I'm usually full with just one prey.. but i could go for seconds~.",
					"Struggle all you want.. You're never leaving..",
					"Enjoying your stay? It'll be almost forever",
					"I'm enjoying your struggles.",
					"*pats my belly near your head. chuckling as you futily wiggle*",
					"*rubs my tummy around the shape you make*",
					"*belches* Head first is usually easier~",
					"Hmm... are you going to push and struggle?",
					"You're just the right size.",
					"Hows it feel in the dark, blue flesh of my stomach?",
					"Hehe.. keep struggling...",
					"I could do with more of your screams.",
					"I could always eat another...",
					"I'm a little peckish still.",
					"*stomach growls as it start to churn and digest* Your friends won't miss you..",
					"Where are your friends? I'm still hungry.",
					"How luck you are.. I wish i was in a stomach too..",
					"Any of your friends you'd want to contribute t be my bellyfat?",
					"You'll be nice and gooey later.",
					"Digest for me...",
					"Don't worry, its painless.",
					"You won't feel a thing.",
					"It won't be long now. You're almost mine, and you'll stay that way",
					"I can feel you getting weaker.. softening inside me.. mmm.",
					"You're not struggling enough.. are you weakening now~?.",
					"*pokes her belly* Are you still digesting~?"
}

playerLines[2] = {	"Oh man.. I can't move.. two is too much.. *Uuuuurp*",
					"Finally, I can digest two people!",
					"Fight and struggle inside me, you two. I'm enojoying it.",
					"Well its pretty tight and form fitting now~",
					"*Long, stretched out belch*",
					"*sighs* Now you're both mine..",
					"Hee.. you both feel so good inside.",
					"Struggle some more.. both of you.. mmm *urp*.",
					"Aaaah... you are both so goooood inside me.",
					"You two are quite filling.",
					"I can feel you both softening inside me.. You're both going to be me~.",
					"Which of you s going to become more of me first?",
					"I can see and feel you both moving.",
					"Care to be a part of me? I am a lovely goddess kitsune~ You'll both make me more beautiful",
					"Aaah.. Digesting nicely.",
					"*sighs and relaxes*",
					"*rubs my belly* Rounding out nicely.. not much left of you two.",
					"You two are going to take a while to melt away~..",
					"Oh man.. i'm gunna be such a fatty after this *guuurrgle*!",
					"Aaah...mmmm..",
					"Soooo good.. mmm!",
					"You two are a delicious.",
					"Digest nice and slowly.. You're mine to enjoy.",
					"Almost nothing left...of you both.. not that anyone will miss you.. *blrpgrrglechurn*",
					"You two will be a perfect addition to my body.",
					"You're both just food for me now.",
					"So very delicious.",
					"I'm usually the one eaten! I don't eat people often.. So you're lucky!",
					"I am ennvious. You're in a hot.. gurgling belly.. I prefer to be in those.. but you're in mine.. Oh well.",
					"Cuddling tummies while and after the are full is always really nice...",
					"There won't be anything left of you.",
					"No one will know wher eyou went.. there wont be any evidence you existed.. now you're mine..no one will ever know where you disappeared.",
					"I'll take whatever you two are carrying.",
					"Relax, don't fight it. You two will be gone soon enough.",
					"Don't worry its painless, you two.",
					"Relax, you two wont feel a thing.",
					"Gah, your hair and fur are getting stuck in my teeth!",
					"*shakes her belly around, making you both get squished, churned and sloshed about inside*",
					"I could just keep you forever. oh but i guess, I already have~! Teehee. <3.",
					"Hmm...maybe now they are digested.. i could find a belly of my own to go inside...",
					"You were both so good.. I'm afraid you both are mine now..!"
}

playerLines["eat"] = {	"Mmmm.. You feel so goood going down my throat..",
						"Taste so good!",
						"Struggle as much as you want, You're going in *glrpglk*.",
						"You'll make me so full...",
						"What a lovely treat!",
						"Hey, not so fast.. *ulp*.",
						"*gulp, swallow, hot, wet throat drags you deeper*",
						"... So delicious...",
						"*keeps swallowing over your body, slurping you down inside*.",
						"Careful of my teeth! They'll scratch you.",
						"You're eager, get in now.",
						"Today's pretty good.. meal on the way in!",
						"You'll be mine.. stay forever.",
						"Second course meal?.",
						"Struggle more.. struggle as you realise you're mine!!",
						"Don't fight it, this is a one way trip.",
						"Foods for eating.. You're food.. get eaten.",
						"Not getting out at all.",
						"I love your taste.",
						"You taste even better today.",
						"I'm going to keep you for a long time."
}

playerLines["exit"] = {	"Aww.. how come you won't stay?",
						"Too soon to leave..",
						"Well, i guess that leaves me free to feed someone else now~.",
						"It was fun! I was digesting you, It was nice <3.",
						"Aww.. already? Stay longer next time.. .",
						"And I was enjoying myself having you become one with me.",
						"I'm still hungry..though...",
						"Looks like i'll just have to feed someone myself then, I'll get a belly still.",
						"Ahh.. you felt good.. But i guess i can let you out for now~.",
						"Come back soon, I'm always around to say hey to."
}

function redress()

	digest()
	
end

function digestHook()

	if #victim > 0 then
		npc.setItemSlot( "legs", "christylegsbelly" .. #victim )
	else
		npc.setItemSlot( "legs", "christylegs" )
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
		if animTimer < 1.0 then
			npc.setItemSlot( "head", "christyheadbelly1" )
		elseif animTimer < 2.0 then
			npc.setItemSlot( "head", "christyheadbelly2" )
		elseif animTimer < 3.0 then
			npc.setItemSlot( "head", "christyheadbelly3" )
		else
			npc.setItemSlot( "head", "christyhead" )
			if #victim > 0 then
				npc.setItemSlot( "legs", "christylegsbelly" .. #victim )
			else
				npc.setItemSlot( "legs", "christylegs" )
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

	npc.setItemSlot( "legs", "christylegs" )

end