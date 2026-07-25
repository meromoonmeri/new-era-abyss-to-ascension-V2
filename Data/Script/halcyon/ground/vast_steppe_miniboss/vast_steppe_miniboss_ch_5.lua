--[[ 
    vast_steppe_miniboss_ch_5.lua
    Grande Steppe — Mini-Boss : Stantler + Mudbray
    Apparition : Mudbray surgit du sol, Stantler émerge de la brume
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

vast_steppe_miniboss_ch_5 = {}

function vast_steppe_miniboss_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  -- Position the team entering the deep steppe
  GROUND:TeleportTo(hero, 200, 400, Direction.Up)
  GROUND:TeleportTo(partner, 168, 400, Direction.Up)
  GAME:MoveCamera(184, 200, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Sky Peak Prairie.ogg', false)

  -- Party walks forward into the misty steppe
  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 80, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 80, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(184, 160, 60, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_001']))
  -- "Cette brume est de plus en plus épaisse... On n'y voit presque rien."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_002']))
  -- "Hé, [hero]... Tu as l'impression qu'on est observés ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_003']), "Worried")
  -- "...Oui. Depuis un moment déjà."

  GAME:WaitFrames(40)

  -- === SOUND: distant rumbling, the ground begins to shake ===
  SOUND:FadeOutBGM(60)
  SOUND:PlayBattleSE('_UNK_EVT_102')
  local continueShake = true
  coro1 = TASK:BranchCoroutine(function()
    while continueShake do
      GROUND:MoveScreen(RogueEssence.Content.ScreenMover(2, 4, 30))
      GAME:WaitFrames(30)
    end
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GeneralFunctions.EmoteAndPause(partner, "Shock", true)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Surprised")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_004']))
    -- "Qu'est-ce que...?!
    continueShake = false
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(16)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)

  -- === VOICE OF THE ABYSS SPEAKS FIRST ===
  -- The tremors stop. An eerie silence falls.
  GAME:WaitFrames(30)

  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_007']))
  -- "La harde protège son territoire..."

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, true, false, Direction.Down)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Left)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(10)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_008']))
  -- "Qui... qui a dit ça ?!"

  GAME:WaitFrames(30)

  -- === WHITE FLASH ===
  local center = GAME:GetCameraCenter()
  local preEmergeFlash = RogueEssence.Content.FlashEmitter()
  preEmergeFlash.FadeInTime = 3
  preEmergeFlash.HoldTime = 4
  preEmergeFlash.FadeOutTime = 10
  preEmergeFlash.StartColor = Color(255, 255, 255, 0)
  preEmergeFlash.Layer = DrawLayer.Top
  preEmergeFlash.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(preEmergeFlash, center.X, center.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(20)

  -- === MUDBRAY ERUPTS FROM THE EARTH ===
  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  GROUND:Hide('Mudbray')

  -- Ground ruptures open dramatically
  local ruptureLeft = RogueEssence.Content.FiniteOverlayEmitter()
  ruptureLeft.FadeIn = 5
  ruptureLeft.TotalTime = 60
  ruptureLeft.Movement = RogueElements.Loc(-30, -40)
  ruptureLeft.Layer = DrawLayer.Front
  ruptureLeft.Anim = RogueEssence.Content.BGAnimData("Dirt_Burst", 0)
  GROUND:PlayVFX(ruptureLeft, mudbray.Position.X - 24, mudbray.Position.Y + 8)
  local ruptureRight = RogueEssence.Content.FiniteOverlayEmitter()
  ruptureRight.FadeIn = 5
  ruptureRight.TotalTime = 60
  ruptureRight.Movement = RogueElements.Loc(30, -40)
  ruptureRight.Layer = DrawLayer.Front
  ruptureRight.Anim = RogueEssence.Content.BGAnimData("Dirt_Burst", 0)
  GROUND:PlayVFX(ruptureRight, mudbray.Position.X + 24, mudbray.Position.Y + 8)

  SOUND:PlayBattleSE('_UNK_EVT_003')
  local mudbrayEmerge = RogueEssence.Content.StaticAnim(
    RogueEssence.Content.AnimData("Sacred_Fire_Ranger", 3), 2)
  mudbrayEmerge:SetupEmitted(
    RogueElements.Loc(mudbray.Position.X + 8, mudbray.Position.Y + 12),
    32, RogueElements.Dir8.Down)
  GROUND:PlayVFXAnim(mudbrayEmerge, RogueEssence.Content.DrawLayer.Front)
  GAME:WaitFrames(5)
  GROUND:Unhide('Mudbray')
  GROUND:CharSetAnim(mudbray, "Idle", true)

  GAME:WaitFrames(30)
  coro1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
    GeneralFunctions.Recoil(partner, "Hurt", 8, 8, false, false)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Down, 4, 1, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  GeneralFunctions.EmoteAndPause(partner, "Shock", true)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_005']))
  -- "Un Pokémon a surgi du sol !"

  GAME:WaitFrames(20)

  -- === SECOND WHITE FLASH — STANTLER EMERGES FROM THE MIST ===
  GROUND:PlayVFX(preEmergeFlash, center.X, center.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")

  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.DownRight}
  })
  GROUND:Hide('Stantler')

  -- Thick mist rolls in, then Stantler materializes from within
  local mistEmitter = RogueEssence.Content.FiniteOverlayEmitter()
  mistEmitter.FadeIn = 20
  mistEmitter.TotalTime = 80
  mistEmitter.Layer = DrawLayer.Back
  mistEmitter.Anim = RogueEssence.Content.BGAnimData("Steam", 1)
  GROUND:PlayVFX(mistEmitter, 152, 200)

  SOUND:PlayBGM('Rising Fear.ogg', true)
  GAME:WaitFrames(25)
  GROUND:Unhide('Stantler')
  GROUND:CharSetAnim(stantler, "Charge", true)

  -- Stantler steps forward through the mist, antlers glowing
  GAME:WaitFrames(15)
  coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(stantler, Direction.Down, 28, false, 1)
    GROUND:CharAnimateTurnTo(stantler, Direction.Down, 4)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(15)
    GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  GROUND:CharSetEmote(partner, "sweating", 1)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_006']))
  -- "Et celui-là... il nous attendait."

  GAME:WaitFrames(30)

  -- === VOICE SPEAKS AGAIN ===
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_009']))
  -- "Peu importe qui je suis. Ces créatures ne te laisseront pas passer sans combattre."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_010']))
  -- "Montre-leur ta détermination... ou péris."

  GAME:WaitFrames(40)

  -- === Mudbray stomps, Stantler roars ===
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.Hop(mudbray)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_011']))
  -- "Pas le choix ! [hero], on se bat !"

  -- === BOSS TRANSITION ===
  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.SteppeMiniBossSeen = true
  GAME:ContinueDungeon("vast_steppe", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Second encounter (if player died and returns)
function vast_steppe_miniboss_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(mudbray, "Idle", true)
  GROUND:CharSetAnim(stantler, "Charge", true)

  GROUND:TeleportTo(hero, 200, 360, Direction.Up)
  GROUND:TeleportTo(partner, 168, 360, Direction.Up)
  GAME:MoveCamera(184, 200, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Rising Fear.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_012']))
  -- "Ils sont encore là... Cette fois, on ne perd pas !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("vast_steppe", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Player defeated the mini-boss
function vast_steppe_miniboss_ch_5.DefeatedBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.Down}
  })

  GROUND:CharSetAction(mudbray, RogueEssence.Ground.PoseGroundAction(
    mudbray.Position, mudbray.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
  GROUND:CharSetAnim(stantler, "Charge", true)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 200, 300, Direction.Up)
  GROUND:TeleportTo(partner, 168, 300, Direction.Up)
  GAME:MoveCamera(184, 200, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('In The Depths of the Pit.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.Hop(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_013']))
  -- "On a réussi ! Ces deux-là étaient coriaces..."

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_014']))
  -- "Mais cette voix... Qui était-ce ?"

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['VSM_015']), "Worried")
  -- "Je ne sais pas. Continuons d'avancer."

  GAME:WaitFrames(30)
  -- Mudbray and Stantler fade/disappear into the mist
  SOUND:FadeOutBGM(60)
  local emitter = RogueEssence.Content.FlashEmitter()
  emitter.FadeInTime = 2
  emitter.HoldTime = 2
  emitter.FadeOutTime = 20
  emitter.StartColor = Color(255, 255, 255, 0)
  emitter.Layer = DrawLayer.Top
  emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(emitter, mudbray.Position.X, mudbray.Position.Y)
  GROUND:PlayVFX(emitter, stantler.Position.X, stantler.Position.Y)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Mudbray')
  GROUND:Hide('Stantler')
  GAME:WaitFrames(40)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_016']))
  -- "Ils ont disparu... Allez, on continue la mission."

  GAME:WaitFrames(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("vast_steppe", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Player died to the mini-boss
function vast_steppe_miniboss_ch_5.DiedToBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local mudbray = CharacterEssentials.MakeCharactersFromList({
    {'Mudbray', 184, 232, Direction.Down}
  })
  local stantler = CharacterEssentials.MakeCharactersFromList({
    {'Stantler', 152, 200, Direction.Down}
  })

  GROUND:CharSetAnim(mudbray, "Idle", true)
  GROUND:CharSetAnim(stantler, "Idle", true)

  GROUND:Hide(partner.EntName)
  GROUND:Hide(hero.EntName)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GAME:MoveCamera(184, 200, 1, false)
  GAME:CutsceneMode(true)

  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  -- The Voice of the Abyss comments on the defeat
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_017']))
  -- "Pas encore assez fort..."

  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['VSM_018']))
  -- "Mais tu te relèveras. Ils se relèvent toujours."

  GAME:WaitFrames(40)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("vast_steppe_entrance", "Main_Entrance_Marker")
end

return vast_steppe_miniboss_ch_5
