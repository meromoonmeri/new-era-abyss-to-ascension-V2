require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

metano_town_ch_6 = {}

local function RestorePartnerAI(partner)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
end

local function AddDazzlingPlazaTrigger()
	local plazaTrigger = RogueEssence.Ground.GroundObject(
		RogueEssence.Content.ObjAnimData("", 1),
		RogueElements.Rect(760, 736, 288, 224),
		RogueElements.Loc(0, 0),
		false,
		"Event_Trigger_9")
	plazaTrigger:ReloadEvents()
	GAME:GetCurrentGround():AddTempObject(plazaTrigger)
end

function metano_town_ch_6.SetupGround()
	GROUND:Hide('Swap_Owner')
	GROUND:Hide('Swap')

	if not SV.Chapter6.DazzlingIntroPlayed then
		AddDazzlingPlazaTrigger()
	end

	local butterfree, adagio, aria, sonata = CharacterEssentials.MakeCharactersFromList({
		{'Butterfree', 824, 816, Direction.Right},
		{'Adagio', 1080, 784, Direction.Left},
		{'Aria', 1112, 816, Direction.Left},
		{'Sonata', 1144, 848, Direction.Left}
	})
	local mawile, floatzel, quagsire = CharacterEssentials.MakeCharactersFromList({
		{'Mawile', 736, 960, Direction.Up},
		{'Floatzel', 928, 1040, Direction.UpLeft},
		{'Quagsire', 640, 1008, Direction.UpRight}
	})
	AI:SetCharacterAI(mawile, "halcyon.ai.ground_default", RogueElements.Loc(720, 944), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(floatzel, "halcyon.ai.ground_default", RogueElements.Loc(912, 1024), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)
	AI:SetCharacterAI(quagsire, "halcyon.ai.ground_default", RogueElements.Loc(624, 992), RogueElements.Loc(32, 32), 1, 16, 32, 40, 180)

	if SV.Chapter6.DazzlingIntroPlayed then
		GROUND:TeleportTo(butterfree, 824, 816, Direction.Right)
		GROUND:TeleportTo(adagio, 1008, 784, Direction.DownLeft)
		GROUND:TeleportTo(aria, 1040, 816, Direction.Left)
		GROUND:TeleportTo(sonata, 1072, 848, Direction.Left)
	end

	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})

	if SV.Chapter6.MissionComplete and not SV.Chapter6.PostMissionScenePlayed then
		local venipede = CharacterEssentials.MakeCharactersFromList({
			{'Venipede', 864, 848, Direction.Left}
		})
		AI:DisableCharacterAI(butterfree)
		AI:DisableCharacterAI(venipede)
	end

	GAME:FadeIn(20)
end

function metano_town_ch_6.Event_Trigger_9_Touch(obj, activator)
	if SV.Chapter6.DazzlingIntroPlayed then return end
	GROUND:Hide('Event_Trigger_9')
	metano_town_ch_6.DazzlingIntroduction()
end

function metano_town_ch_6.DazzlingIntroduction()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local butterfree = CH('Butterfree')
	local adagio = CH('Adagio')
	local aria = CH('Aria')
	local sonata = CH('Sonata')
	local mawile = CH('Mawile')
	local floatzel = CH('Floatzel')
	local quagsire = CH('Quagsire')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(butterfree)
	AI:DisableCharacterAI(adagio)
	AI:DisableCharacterAI(aria)
	AI:DisableCharacterAI(sonata)
	GAME:MoveCamera(896, 816, 1, false)

	local coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(butterfree, 872, 816, false, 1)
		GROUND:CharAnimateTurnTo(butterfree, Direction.Down, 4)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(10)
		GROUND:MoveToPosition(hero, 792, 896, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
	end)
	local coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:MoveToPosition(partner, 824, 896, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	-- The square notices the commotion before the rivals speak.  This gives
	-- the entrance the same lived-in rhythm as the guild scenes.
	local crowd1 = TASK:BranchCoroutine(function()
		GROUND:CharAnimateTurnTo(mawile, Direction.UpRight, 4)
		GROUND:CharSetEmote(mawile, "notice", 1)
	end)
	local crowd2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:CharAnimateTurnTo(floatzel, Direction.UpLeft, 4)
		GROUND:CharSetEmote(floatzel, "notice", 1)
	end)
	local crowd3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(14)
		GROUND:CharAnimateTurnTo(quagsire, Direction.Up, 4)
		GROUND:CharSetEmote(quagsire, "question", 1)
	end)
	TASK:JoinCoroutines({crowd1, crowd2, crowd3})
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeaker(mawile)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_042']))
	UI:SetSpeaker(floatzel)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_043']))
	UI:SetSpeaker(quagsire)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_044']))

	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_002']))
	GAME:WaitFrames(12)

	coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(adagio, 1008, 784, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.DownLeft, 4)
	end)
	coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(aria, 1040, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Left, 4)
	end)
	coro3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(sonata, 1072, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Left, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2, coro3})

	GROUND:CharAnimateTurnTo(adagio, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(aria, Direction.Down, 4)
	GROUND:CharAnimateTurnTo(sonata, Direction.Down, 4)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_045']))
	GeneralFunctions.Hop(aria, "None", 6, 6, true, true)
	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_046']))
	GeneralFunctions.DoubleHop(sonata)
	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_047']))

	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_003']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_004']))

	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_005']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_006']))

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Angry")
	GeneralFunctions.EmoteAndPause(partner, "angry", true)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_007']))

	-- Aria tests the partner physically, but backs off as soon as she has
	-- obtained the reaction she wanted.
	local bump1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(aria, 880, 864, false, 1)
		GROUND:MoveInDirection(partner, Direction.DownRight, 8, false, 1)
	end)
	local bump2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		SOUND:PlayBattleSE("EVT_Emote_Shock_2")
		GROUND:CharSetEmote(partner, "shock", 1)
	end)
	TASK:JoinCoroutines({bump1, bump2})
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_048']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_049']))
	GROUND:MoveToPosition(aria, 1040, 816, false, 1)
	GROUND:CharAnimateTurnTo(aria, Direction.Left, 4)

	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Happy")
	GROUND:CharSetEmote(sonata, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_008']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_009']))
	GROUND:CharSetEmote(sonata, "", 0)

	local trick = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(sonata, 848, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local trick2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(12)
		SOUND:PlayBattleSE("EVT_Emote_Confused_2")
		GROUND:CharSetEmote(partner, "question", 1)
	end)
	TASK:JoinCoroutines({trick, trick2})
	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_050']))
	GROUND:MoveToPosition(sonata, 1072, 848, false, 1)
	GROUND:CharAnimateTurnTo(sonata, Direction.Left, 4)

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_010']))

	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_011']))

	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_012']))

	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_013']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_014']))

	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_015']))
	GROUND:CharSetEmote(adagio, "happy", 0)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(adagio, "", 0)

	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_016']))

	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_017']))

	UI:SetSpeaker(floatzel)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_051']))
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_052']))
	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_053']))
	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_054']))

	local exit1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(aria, 1120, 816, false, 1)
		GROUND:CharAnimateTurnTo(aria, Direction.Right, 4)
	end)
	local exit2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(sonata, 1152, 848, false, 1)
		GROUND:CharAnimateTurnTo(sonata, Direction.Right, 4)
	end)
	local exit3 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(16)
		GROUND:MoveToPosition(adagio, 1080, 784, false, 1)
		GROUND:CharAnimateTurnTo(adagio, Direction.Right, 4)
	end)
	TASK:JoinCoroutines({exit1, exit2, exit3})
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_055']))
	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_056']))

	SV.Chapter6.DazzlingIntroPlayed = true
	SV.Chapter6.MissionAvailable = true
	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	RestorePartnerAI(partner)
	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})
end

function metano_town_ch_6.Butterfree_Action(chara, activator)
	if not SV.Chapter6.DazzlingIntroPlayed then return end
	if SV.Chapter6.MissionComplete then
		GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_018']), "Happy")
		GeneralFunctions.EndConversation(chara)
		return
	end

	local partner = CH('Teammate1')
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_019']), "Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_020']))
	UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['MT6_021']), true)
	UI:WaitForChoice()
	local result = UI:ChoiceResult()
	if result then
		SV.Chapter6.MissionAccepted = true
		GeneralFunctions.EndConversation(chara)
		AI:DisableCharacterAI(partner)
		SOUND:FadeOutBGM(40)
		GAME:FadeOut(false, 40)
		GAME:EnterGroundMap("gloomy_forest_entrance", "Main_Entrance_Marker")
	else
		UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_022']))
		GeneralFunctions.EndConversation(chara)
	end
end

function metano_town_ch_6.Venipede_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_035']), "Happy")
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Adagio_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_023']), "Normal")
	UI:SetSpeakerEmotion("Sigh")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_024']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Aria_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_025']), "Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_026']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Sonata_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_027']), "Happy")
	GROUND:CharSetEmote(chara, "happy", 0)
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_028']))
	GROUND:CharSetEmote(chara, "", 0)
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.PostMissionCutscene()
	if SV.Chapter6.PostMissionScenePlayed ~= false or not SV.Chapter6.MissionComplete then return end
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local butterfree = CH('Butterfree')
	local venipede = CH('Venipede')
	local adagio = CH('Adagio')
	local aria = CH('Aria')
	local sonata = CH('Sonata')

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(butterfree)
	AI:DisableCharacterAI(venipede)
	AI:DisableCharacterAI(adagio)
	AI:DisableCharacterAI(aria)
	AI:DisableCharacterAI(sonata)
	GAME:MoveCamera(896, 816, 1, false)

	UI:SetSpeaker(butterfree)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_029']))
	UI:SetSpeaker(venipede)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_030']))
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_031']))
	UI:SetSpeaker(aria)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_032']))
	UI:SetSpeaker(sonata)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_033']))
	UI:SetSpeaker(adagio)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_034']))

	SV.Chapter6.PostMissionScenePlayed = true
	GAME:WaitFrames(20)
	GAME:CutsceneMode(false)
	RestorePartnerAI(partner)
	AI:EnableCharacterAI(butterfree)
	AI:EnableCharacterAI(venipede)
	AI:SetCharacterAI(adagio, "halcyon.ai.ground_talking", false, 240, 60, 0, false, 'Default', {aria, sonata})
	AI:SetCharacterAI(aria, "halcyon.ai.ground_talking", false, 240, 60, 60, false, 'Default', {adagio, sonata})
	AI:SetCharacterAI(sonata, "halcyon.ai.ground_talking", false, 240, 60, 120, false, 'Default', {adagio, aria})
end

function metano_town_ch_6.Mawile_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_036']), "Inspired")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_037']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Floatzel_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_038']), "Normal")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_039']))
	GeneralFunctions.EndConversation(chara)
end

function metano_town_ch_6.Quagsire_Action(chara, activator)
	GeneralFunctions.StartConversation(chara, STRINGS:Format(STRINGS.MapStrings['MT6_040']), "Happy")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['MT6_041']))
	GeneralFunctions.EndConversation(chara)
end

-- Existing town characters still dispatch through the chapter-specific module.
-- Keep unused Chapter 6 interactions safe until their dedicated reputation
-- lines are authored, rather than letting the dynamic dispatcher fail.
for _, action_name in ipairs({
	"Luxray_Action", "Electrike_Action", "Manectric_Action", "Bellossom_Action",
	"Vileplume_Action", "Gloom_Action", "Oddish_Action", "Numel_Action",
	"Camerupt_Action", "Machamp_Action", "Meditite_Action", "Medicham_Action",
	"Furret_Action", "Linoone_Action", "Sentret_Action", "Wooper_Girl_Action",
	"Wooper_Boy_Action", "Floatzel_Action", "Quagsire_Action", "Nidorina_Action",
	"Nidoran_Male_Action", "Nidoking_Action", "Nidoqueen_Action", "Mawile_Action",
	"Azumarill_Action", "Gulpin_Action", "Lickitung_Action", "Roselia_Action",
	"Spinda_Action", "Ludicolo_Action", "Jigglypuff_Action", "Marill_Action",
	"Spheal_Action", "Bagon_Action", "Doduo_Action", "Metapod_Action",
	"Silcoon_Action", "Mareep_Action", "Cranidos_Action", "Snubbull_Action",
	"Audino_Action", "Zigzagoon_Action", "Growlithe_Desk_Action"
}) do
	if metano_town_ch_6[action_name] == nil then
		metano_town_ch_6[action_name] = function(chara, activator) end
	end
end

return metano_town_ch_6
