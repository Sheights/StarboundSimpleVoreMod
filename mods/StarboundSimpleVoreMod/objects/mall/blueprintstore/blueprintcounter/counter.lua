temp = 0
bonus = 0

idleLines = {	"Sheights: Welcome to Do it Yourself. Where you can, do it yourself!",
				"Sheights: I can help you find anything you might need.",
				"Sheights: I spent a week in a slime blob trying to get some blueprints. Well worth it!",
				"Sheights: You would be surprised how many times treasure is gobbled up. Only one way to get it out."
}

function init()
  self.buyFactor = config.getParameter("buyFactor", root.assetJson("/merchant.config").defaultBuyFactor)

  object.setInteractive(true)
end

function update(dt)

	state = animator.animationState("bodyState")

	temp = math.random(20)
	
	if temp < 4 then
		if state == "TY" then
			animator.setAnimationState("bodyState", "TYTblink")
		elseif state == "NinIdle" then
			animator.setAnimationState("bodyState", "NinLick")
		elseif state == "AvaliIdle" then
			animator.setAnimationState("bodyState", "AvaliT")
		elseif state == "ClydeIdle" then
			animator.setAnimationState("bodyState", "ClydeBlink")
		elseif state == "SkylerIdle" then
			animator.setAnimationState("bodyState", "SkylerRub")
		elseif state == "DevoutIdle" then
			animator.setAnimationState("bodyState", "DevoutSmug")
		end
	elseif temp < 7 then
		if state == "TY" then
			animator.setAnimationState("bodyState", "TYTblink")
		elseif state == "NinIdle" then
			animator.setAnimationState("bodyState", "NinLick")
		elseif state == "AvaliIdle" then
			animator.setAnimationState("bodyState", "AvaliT")
		elseif state == "ClydeIdle" then
			animator.setAnimationState("bodyState", "ClydeBlink")
		elseif state == "SkylerIdle" then
			animator.setAnimationState("bodyState", "SkylerRub")
		elseif state == "DevoutIdle" then
			animator.setAnimationState("bodyState", "DevoutThump")
		end
	elseif temp < 10 then
		if state == "TY" then
			animator.setAnimationState("bodyState", "TYYblink")
		elseif state == "NinIdle" then
			animator.setAnimationState("bodyState", "NinFlick")
		elseif state == "AvaliIdle" then
			animator.setAnimationState("bodyState", "AvaliY")
		elseif state == "ClydeIdle" then
			animator.setAnimationState("bodyState", "ClydeBlink")
		elseif state == "SkylerIdle" then
			animator.setAnimationState("bodyState", "SkylerRub")
		elseif state == "DevoutIdle" then
			animator.setAnimationState("bodyState", "DevoutHelp")
		end
	elseif temp < 13 then
		if state == "TY" then
			animator.setAnimationState("bodyState", "TYYblink")
		elseif state == "NinIdle" then
			animator.setAnimationState("bodyState", "NinFlick")
		elseif state == "AvaliIdle" then
			animator.setAnimationState("bodyState", "AvaliY")
		elseif state == "ClydeIdle" then
			animator.setAnimationState("bodyState", "ClydeBlink")
		elseif state == "SkylerIdle" then
			animator.setAnimationState("bodyState", "SkylerRub")
		elseif state == "DevoutIdle" then
			animator.setAnimationState("bodyState", "DevoutIdle")
		end
	elseif temp + bonus > 25 then
	
		local people = world.entityQuery( object.position(), 100, {
			includedTypes = {"player"},
			boundMode = "CollisionArea"
		})
		
		if #people == 0 then
			temp = math.random(7)
			if temp == 7 then
			elseif state == "NinIdle" or state == "AvaliIdle" or state == "ClydeIdle" or state == "SkylerIdle" or state == "DevoutIdle" then
			
			animator.setAnimationState("bodyState", "TY")
			idleLines = {	"Sheights: Welcome to Do it Yourself. Where you can, do it yourself!",
							"Sheights: I can help you find anything you might need.",
							"Sheights: I spent a week in a slime blob trying to get some blueprints. Well worth it!",
							"Sheights: You would be surprised how many times treasure is gobbled up. Only one way to get it out."
			}
			
			else
				if temp == 1 then
					animator.setAnimationState("bodyState", "NinIdle")
					
					idleLines = {	"The usual shopkeepers? I'm sure they're still around~",
									"*urp* oh man, some rodents are more filling than they look.",
									"I sell whatever I can't digest, and you won't find better prices anywhere*!",
									"You should come find me when I'm done here, I could always use more gear to sell :9",
									"I don't do returns, and that includes the partially digested stuff!",
									"It's a shame YOU weren't the one watching the shop before I got here :9",
									"Maybe it's the fox half, but boy do I love a good rodent or two.",
									"You're looking for Tea? Uhh, I think a nearby vending machine may have some?",
									"That mouse mumbled something about points not mattering, bah, I want them anyway!",
									"Any food we get in stock mysteriously *urp* vanishes, so you'll have to buy food elsewhere!"
					}
					
				elseif temp == 2 then
					animator.setAnimationState("bodyState", "AvaliIdle")
					
					idleLines = {	"Hi hi hi!",
									"The long eared one froze up when we got close! It was so cute~",
									"It's amazing what people leave lying around. Money, mechanical documents, delicious mamals.",
									"Jassari's asleep right now but I can help you with things.",
									"Oh, you look sweet, but I just ate~",
									"Hehehe, the round eared one is still kicking~",
									"Sheights: C-Can anyone lend me a hand?",
									"Tea: MMmmmmm... S-so fluffy... -////-"
					}
				elseif temp == 3 then
					animator.setAnimationState("bodyState", "ClydeIdle")
					idleLines = {	""
					}
				elseif temp == 4 then
					animator.setAnimationState("bodyState", "SkylerIdle")
					idleLines = {	""
					}
				elseif temp == 5 then
					animator.setAnimationState("bodyState", "DevoutIdle")
					
					idleLines = {	"Would teach them to pay next time...",
									"Got a new shipment in recently.",
									"A few of my golems ran off. Watch yourself.",
									"Crystals and Gems for your every day needs.",
									"Don't pay, then you'll join the other freeloaders.",
									"Could always pay me in bodies. Just kidding.",
									"heh, they tickle.",
									"Got a lot to do, stop squirming!",
									"mmph. Can't focus with the struggles.",
									"Selling what you need! Come by!",
									"Got the wares you need right here.",
									"I'll buy whatever you're selling."
					}
					
				elseif temp == 6 then
					temp = math.random(3)
					
					if temp == 1 then
						animator.setAnimationState("bodyState", "AutumnT")
					
						idleLines = {	""
						}
					elseif temp == 2 then
						animator.setAnimationState("bodyState", "AutumnY")
					
						idleLines = {	""
						}
					else
						animator.setAnimationState("bodyState", "AutumnFull")
					
						idleLines = {	"Oof, I'm stuffed...",
										"Where's Tea? It's a secret to everybody...",
										"Sweet dreams, little bun <3",
										"Squishy poofy mousey baby~",
										"Sorry about the blueprints. They're a bit, uh... sticky.",
										"Fixed your vermin problem. Sorry about the, um, mess...",
										"^.^",
										">3>",
										"<3"


						}
					end
				end
			end
		end
		bonus = 0
	else
		
		local people = world.entityQuery( object.position(), 20, {
			includedTypes = {"player"},
			boundMode = "CollisionArea"
		})
		
		if #people > 0 then
			object.say( idleLines[ math.random( #idleLines ) ] )
		end
		
		bonus = bonus + 1
	end
end

function onInteraction(args)

	local interactData = config.getParameter("interactData")
	
	if state == "NinIdle" or state == "NinLick" or state == "NinFlick" then
		interactData.items[#interactData.items + 1] = { item = "adventuregear"}
		interactData.items[#interactData.items + 1] = { item = "nomadrobes"}
	end

	return { "OpenMerchantInterface", interactData }
  
end