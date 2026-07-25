require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

gloomy_forest_boss_ch_6 = {}

function gloomy_forest_boss_ch_6.FirstBossScene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local zarude = CharacterEssentials.MakeCharactersFromList({
		{'Zarude', 276, 208, Direction.Down}
	})

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)
	AI:DisableCharacterAI(zarude)
	GAME:MoveCamera(276, 232, 1, false)
	GAME:FadeOut(false, 1)
	GROUND:TeleportTo(hero, 276, 416, Direction.Up)
	GROUND:TeleportTo(partner, 308, 416, Direction.Up)
	GAME:FadeIn(40)
	SOUND:PlayBGM('Mystifying Forest.ogg', true)

	local coro1 = TASK:BranchCoroutine(function()
		GROUND:MoveToPosition(hero, 276, 288, false, 1)
		GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	end)
	local coro2 = TASK:BranchCoroutine(function()
		GAME:WaitFrames(8)
		GROUND:MoveToPosition(partner, 308, 288, false, 1)
		GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
	end)
	TASK:JoinCoroutines({coro1, coro2})

	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_001']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_002']))

	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_003']))

	GROUND:CharSetEmote(zarude, "notice", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
	GAME:MoveCamera(276, 208, 20, false)
	GAME:WaitFrames(20)
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_004']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_005']))

	UI:SetSpeaker(zarude)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_006']))
	UI:SetSpeaker(partner)
	UI:SetSpeakerEmotion("Angry")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_007']))
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_008']))

	GROUND:CharSetEmote(zarude, "angry", 1)
	SOUND:PlayBattleSE("EVT_Emote_Shock_2")
	UI:SetSpeaker(zarude)
	UI:SetSpeakerEmotion("Shouting")
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_009']))
	UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GF6B_010']))
	GROUND:CharSetEmote(zarude, "", 0)

	SV.Chapter6.GloomyBossEncountered = true
	-- COMMON.BossTransition is the project's verified boss launch: two white
	-- flashes, battle flash SE, whoosh animation and fade into the arena map.
	COMMON.BossTransition()
	GAME:CutsceneMode(false)
	GAME:ContinueDungeon("gloomy_forest", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

return gloomy_forest_boss_ch_6
