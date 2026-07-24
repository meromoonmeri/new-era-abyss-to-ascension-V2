require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_town_ch_5 = {}

function metano_town_ch_5.SetupGround()
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')
	
	--block player from leaving town north or east 
	local northBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
									RogueElements.Rect(232, 8, 40, 8),
									RogueElements.Loc(0, 0), 
									true, 
									"Event_Trigger_1")
									
	local eastBlock = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("", 1), 
									RogueElements.Rect(1496, 592, 8, 144),
									RogueElements.Loc(0, 0), 
									true, 
									"Event_Trigger_2")	
										
	northBlock:ReloadEvents()
	eastBlock:ReloadEvents()

	GAME:GetCurrentGround():AddTempObject(northBlock)
	GAME:GetCurrentGround():AddTempObject(eastBlock)
	
	
	
	local growlithe = CH('Growlithe')
	
	if not SV.Chapter5.TalkedToSnubbull then
		local snubbull =
			CharacterEssentials.MakeCharactersFromList({
				{'Snubbull', 1056, 864, Direction.Up}
			})
	end

	--Move Growlithe from his desk. If you saw Almotz say goodbye to his family, then he'll be at storage with Hyko.
	if SV.Chapter5.SawZigzagoonFamilyCutscene then
		local zigzagoon = 
			CharacterEssentials.MakeCharactersFromList({
				{'Zigzagoon', 1236, 888, Direction.UpLeft}
			})
		
		GROUND:TeleportTo(growlithe, 1260, 912, Direction.UpLeft)
	else
		GROUND:TeleportTo(growlithe, 1216, 916, Direction.DownLeft)
		AI:SetCharacterAI(growlithe, "halcyon.ai.ground_default", RogueElements.Loc(1200, 900), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	end


	
	local cranidos, mareep, gloom, nidorina, electrike, audino, numel, wooper_girl, wooper_boy,
		  meditite, medicham, machamp, oddish, azumarill, metapod, silcoon, marill, jigglypuff, 
		  spheal = 
		CharacterEssentials.MakeCharactersFromList({
			{'Cranidos', 1180, 1304, Direction.UpLeft},
			{'Mareep', 1204, 1304, Direction.Left},
			{'Gloom', 512, 184, Direction.DownRight},
			{'Nidorina', 536, 208, Direction.UpLeft},
			{'Electrike', 256, 944, Direction.DownRight},
			{'Audino', 1096, 1032, Direction.DownRight},
			{'Numel', 184, 384, Direction.DownLeft},
			{'Wooper_Girl', 328, 1000, Direction.DownLeft},
			{'Wooper_Boy', 328, 1040, Direction.UpLeft},
			{'Meditite', 296, 1020, Direction.Right},
			{'Medicham', 888, 240, Direction.UpRight},			
			{'Machamp', 464, 464, Direction.Left},
			{'Oddish', 864, 600, Direction.Up},
			{'Azumarill', 888, 712, Direction.Down},
			{'Metapod', 'Cafe_Seat_1'},
			{'Silcoon', 'Cafe_Seat_2'},
			{'Marill', 1184, 1144, Direction.DownRight},
			{'Jigglypuff', 1224, 1144, Direction.DownLeft},
			{'Spheal', 1204, 1176, Direction.Up}
		})
	
	AI:SetCharacterAI(machamp, "halcyon.ai.ground_default", RogueElements.Loc(machamp.Position.X-16, machamp.Position.Y-16), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(oddish, "halcyon.ai.ground_default", RogueElements.Loc(oddish.Position.X-16, oddish.Position.Y-16), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	
	AI:SetCharacterAI(jigglypuff, "halcyon.ai.ground_talking", true, 240, 60, 50, false, 'Default', {marill, spheal})
	AI:SetCharacterAI(marill, "halcyon.ai.ground_talking", true, 240, 60, 130, false, 'Default', {jigglypuff, spheal})
	AI:SetCharacterAI(spheal, "halcyon.ai.ground_talking", true, 240, 60, 0, false, 'Default', {jigglypuff, marill})


	
	GAME:FadeIn(20)
	
end


--She is getting supplies from Kec. She goes inside to the storage room after you talk
--to her to get her out of the way
function metano_town_ch_5.Snubbull_Action(chara, activator)

end 

function metano_town_ch_5.Snubbull_Kecleon_Cutscene()
	--[[
	
	
	
	]]--
	
end


function metano_town_ch_5.Mareep_Action(chara, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartConversation(chara, "Oh,[pause=10] " .. hero:GetDisplayName() .. " and " .. partner:GetDisplayName() .. "![pause=0] Ca-a-a-an you believe the expedition's finally here?", "Happy")
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_001']))
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_002']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Cranidos_Action(chara, activator)
	local item = RogueEssence.Dungeon.InvItem("machine_recall_box")
	GeneralFunctions.StartConversation(chara, "You greenhorns better get all your moves in order before we leave.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_003'], item:GetDisplayName()))
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_004']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Audino_Action(chara, activator)

end


--Need to highlight better chemistry between these two. They're very tell don't show right now.
--Hyko is a hyperactive, idiot-savantish type puppy dog, almotz is a cheery, but is the straight man nerd to play off of.
--Have this play into that, and edit some of the chapter 4/5 dialogue to help accomodate as well I think.
function metano_town_ch_5.Growlithe_Action(chara, activator)

end

function metano_town_ch_5.Zigzagoon_Action(chara, activator)

end

function metano_town_ch_5.Mawile_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Word around town is that the guild is leaving on a big expedition today.")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_005']))
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_006']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Electrike_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Wooper_Boy") .. " and " .. CharacterEssentials.GetCharacterName("Wooper_Girl") .. " are still playing with that other Pokémon,[pause=10] huh...?", "Sad")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_007']))
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_008']))
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_009']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Azumarill_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " hear that guild is going away for a while.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_010'], chara:GetDisplayName(), chara:GetDisplayName()))
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_011'], chara:GetDisplayName(), chara:GetDisplayName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_012'], chara:GetDisplayName(), chara:GetDisplayName()))
	GeneralFunctions.EndConversation(chara)
end

--GeneralFunctions.StartConversation(chara, chara:GetDisplayName() .. " hear that guild is going on big expedition.")
--UI:SetSpeakerEmotion("Worried")
--UI:WaitShowDialogue(chara:GetDisplayName() .. " not understand need for big trip though...")
--UI:WaitShowDialogue("Best water for swimming is right here in town![pause=0] Why go anywhere else?")
--GeneralFunctions.EndConversation(chara)

--[[
--free domi blends!
function metano_town_ch_5.Doduo_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Did you hear?[pause=0] " .. CharacterEssentials.GetCharacterName("Shuckle") .. "'s giving away free drinks today!")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_013']))
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_5.Bagon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "This drink " .. CharacterEssentials.GetCharacterName("Shuckle") .. " doesn't taste very good...", "Sad")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_014']))
	GeneralFunctions.EndConversation(chara)
end 
]]--

function metano_town_ch_5.Metapod_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, CharacterEssentials.GetCharacterName("Silcoon") .. " and I got a free drink from the café today.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_015']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Silcoon_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Did you hear?[pause=0] " .. CharacterEssentials.GetCharacterName("Shuckle") .. "'s giving away free drinks today!")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_016']))
	GeneralFunctions.EndConversation(chara)
end

--Mountain - the cold turned her back or was too much for her?
--Cave - ironic, given her current living situation? The lack of sun got to her and she now submits herself to it willingly as a weird self punishment?
function metano_town_ch_5.Oddish_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "The weird lady told me an awesome story about an adventure she had in a cave a long time ago!", "Inspired")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_017']))
	GROUND:CharSetAnim(chara, "Idle", true)
	GROUND:CharSetEmote(chara, "glowing", 0)
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_018']))
	GROUND:CharSetEmote(chara, "", 0)
	GeneralFunctions.EndConversation(chara)
end


function metano_town_ch_5.Numel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "I've been working really hard so my momma will make me more Lava Cakes!", "Happy")
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_019']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Machamp_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Me daughter is off makin' merry wit' her new pals.")
	UI:SetSpeakerEmotion("Joyous")
	GROUND:CharSetEmote(chara, "glowing", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_020']))
	GROUND:CharSetEmote(chara, "", 0)
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Medicham_Action(chara, activator)
	--Strength is not everything. A sharp mind is just as, if not more important.
	--Clever thinking can help you to overcome any challenges you may face.
	--It would be wise to keep that in mind on your upcoming journey!
	GeneralFunctions.StartConversation(chara, "Everything strength not is.[pause=0] Just is a sharp mind as,[pause=10] if not important more.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_021']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_022']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Spheal_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "An expedition?[pause=0] Sounds like hungry work![pause=0] Make sure to pack lots of food!")
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_023']))
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_5.Marill_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Good luck on the expedition![pause=0] I hope you all make a big discovery!", "Happy")
	GeneralFunctions.EndConversation(chara)
end 

function metano_town_ch_5.Jigglypuff_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, "Take care on your expedition.[pause=0] For a trip like that, you'll be on the road for some time,[pause=10] so make sure to pack lots of supplies.")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_024'], CharacterEssentials.GetCharacterName('Kangaskhan')))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_025']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_5.Nidorina_Action(chara, activator)
	metano_town_ch_5.Nidorina_Gloom_Dialogue(chara, activator)
end

function metano_town_ch_5.Gloom_Action(chara, activator)
	metano_town_ch_5.Nidorina_Gloom_Dialogue(chara, activator)
end

function metano_town_ch_5.Nidorina_Gloom_Dialogue(chara, activator)
	local nidorina = CH('Nidorina')
	local gloom = CH('Gloom')
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	
	partner.IsInteracting = true
	GROUND:CharSetAnim(gloom, 'None', true)
	GROUND:CharSetAnim(nidorina, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharSetAnim(partner, 'None', true)
	
	UI:SetSpeaker(gloom)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_026']))
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(nidorina)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_027']))
	GAME:WaitFrames(20)
	
	GROUND:CharSetAnim(gloom, "Idle", true)
	UI:SetSpeaker(gloom)
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_028']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_029']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_030']))
	GAME:WaitFrames(20)
	
	GROUND:CharSetAnim(gloom, "None", true)
	UI:SetSpeaker(nidorina)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_031']))
	GAME:WaitFrames(20)
	
	GROUND:CharSetEmote(gloom, "sweating", 1)
	UI:SetSpeaker(gloom)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_032']))
	
	
	GROUND:CharEndAnim(gloom)
	GROUND:CharEndAnim(nidorina)
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end




function metano_town_ch_5.Event_Trigger_1_Touch(obj, activator)
	local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("illuminant_riverbed")

	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation(STRINGS:Format(STRINGS.MapStrings['MT5_039'], zone:GetColoredName()))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_033']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_034']))
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_035'], hero:GetDisplayName()))
	GeneralFunctions.EndConversation(partner)
end

function metano_town_ch_5.Event_Trigger_2_Touch(obj, activator)
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GeneralFunctions.StartPartnerConversation(STRINGS:Format(STRINGS.MapStrings['MT5_040']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_036']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_037']))
	UI:SetSpeakerEmotion("Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT5_038'], hero:GetDisplayName()))
	GeneralFunctions.EndConversation(partner)
end