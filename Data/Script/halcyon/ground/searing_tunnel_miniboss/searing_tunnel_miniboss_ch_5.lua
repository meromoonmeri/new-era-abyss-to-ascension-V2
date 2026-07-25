--[[ 
    searing_tunnel_miniboss_ch_5.lua
    Tunnel Incandescent — Mini-Boss : Torkoal + Magmar
    Apparition : Torkoal émerge de la vapeur, Magmar tombe du plafond en flammes
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

searing_tunnel_miniboss_ch_5 = {}

function searing_tunnel_miniboss_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 440, Direction.Up)
  GROUND:TeleportTo(partner, 272, 440, Direction.Up)
  GAME:MoveCamera(256, 240, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Spring Cave.ogg', false)

  -- Team walks through the tunnel
  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    GROUND:MoveInDirection(partner, Direction.Up, 64, false, 1)
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 64, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GAME:MoveCamera(256, 200, 60, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_001']))
  -- "Cette chaleur devient étouffante... On doit approcher d'une poche de magma."

  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
  GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)

  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_002']))
  -- "Tu entends ça, [hero] ? On dirait... de la vapeur sous pression."

  GAME:WaitFrames(30)

  -- === STEAM BEGINS TO FILL THE CHAMBER ===
  SOUND:FadeOutBGM(40)
  SOUND:LoopSE("Light Earthquake")

  local steamEmitter = RogueEssence.Content.FiniteOverlayEmitter()
  steamEmitter.FadeIn = 40
  steamEmitter.TotalTime = 120
  steamEmitter.Layer = DrawLayer.Back
  steamEmitter.Anim = RogueEssence.Content.BGAnimData("Steam", 2)
  GROUND:PlayVFX(steamEmitter, 256, 200)

  local continueSteam = true
  coro1 = TASK:BranchCoroutine(function()
    while continueSteam do
      GROUND:MoveScreen(RogueEssence.Content.ScreenMover(1, 3, 30))
      GAME:WaitFrames(30)
    end
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    GeneralFunctions.EmoteAndPause(partner, "Sweating", true)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Worried")
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_003']))
    -- "De la vapeur ! Elle vient de partout !"
    continueSteam = false
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(26)
    GeneralFunctions.EmoteAndPause(hero, "Sweatdrop", false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  SOUND:FadeOutSE("Light Earthquake", 30)
  GAME:WaitFrames(30)

  -- === TORKOAL EMERGES FROM THE STEAM ===
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.DownRight}
  })
  GROUND:Hide('Torkoal')

  -- Steam explosion spawn
  local steamExplosion = RogueEssence.Content.FiniteOverlayEmitter()
  steamExplosion.FadeIn = 5
  steamExplosion.TotalTime = 45
  steamExplosion.Layer = DrawLayer.Front
  steamExplosion.Anim = RogueEssence.Content.BGAnimData("Smoke", 0)
  GROUND:PlayVFX(steamExplosion, 220, 232)

  SOUND:PlayBattleSE('_UNK_EVT_102')
  GAME:WaitFrames(10)
  GROUND:Unhide('Torkoal')

  -- Ember particles from Torkoal's shell
  local embers = RogueEssence.Content.FiniteOverlayEmitter()
  embers.FadeIn = 10
  embers.TotalTime = 60
  embers.Movement = RogueElements.Loc(0, -20)
  embers.Layer = DrawLayer.Front
  embers.Anim = RogueEssence.Content.BGAnimData("Ember", 0)
  GROUND:PlayVFX(embers, 220, 232)

  GAME:WaitFrames(20)

  coro1 = TASK:BranchCoroutine(function()
    GROUND:AnimateInDirection(partner, "None", partner.Direction, Direction.Down, 4, 1, 1)
    GeneralFunctions.Recoil(partner, "Hurt", 6, 6, false, false)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:AnimateInDirection(hero, "None", hero.Direction, Direction.Left, 4, 1, 1)
    GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_004']))
  -- "Un Torkoal ! Il nous barre la route !"

  GAME:WaitFrames(20)

  -- === MAGMAR DROPS FROM THE CEILING IN FLAMES ===
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.DownLeft}
  })
  GROUND:Hide('Magmar')

  SOUND:PlayBattleSE('EVT_Battle_Flash')
  -- Magmar descends in a burst of fire
  local fireDrop = RogueEssence.Content.StaticAnim(
    RogueEssence.Content.AnimData("Sacred_Fire_Ranger", 3), 1)
  fireDrop:SetupEmitted(
    RogueElements.Loc(magmar.Position.X + 8, magmar.Position.Y),
    24, RogueElements.Dir8.Down)
  GROUND:PlayVFXAnim(fireDrop, RogueEssence.Content.DrawLayer.Front)

  GAME:WaitFrames(5)
  GROUND:Unhide('Magmar')
  GROUND:CharSetAnim(magmar, "Idle", true)

  -- Fire burst on impact
  local fireBurst = RogueEssence.Content.FiniteOverlayEmitter()
  fireBurst.FadeIn = 3
  fireBurst.TotalTime = 35
  fireBurst.Layer = DrawLayer.Front
  fireBurst.Anim = RogueEssence.Content.BGAnimData("Fire_Burst", 0)
  GROUND:PlayVFX(fireBurst, magmar.Position.X, magmar.Position.Y + 16)

  SOUND:PlayBGM('Rising Fear.ogg', true)

  GAME:WaitFrames(25)
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
    GeneralFunctions.Recoil(partner, "Hurt", 8, 8, false, false)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GROUND:CharAnimateTurnTo(hero, Direction.Right, 4)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  GROUND:CharSetEmote(partner, "sweating", 1)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_005']))
  -- "Un Magmar aussi ! Ils nous ont encerclés !"

  GAME:WaitFrames(30)

  -- === VOICE OF THE ABYSS ===
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_006']))
  -- "Les Maîtres-Forgerons des profondeurs..."

  GAME:WaitFrames(20)
  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(partner, 2, 4, true, false, false, Direction.Down)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    GeneralFunctions.LookAround(hero, 2, 4, false, false, false, Direction.Right)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Surprised")
  GROUND:CharSetEmote(partner, "shock", 1)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_007']))
  -- "Cette voix, encore !"

  GAME:WaitFrames(30)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_008']))
  -- "Ils gardent les fournaises depuis des siècles. Leur chaleur te consumera."

  GAME:WaitFrames(20)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_009']))
  -- "À moins que tu ne prouves ta propre flamme..."

  GAME:WaitFrames(30)

  -- Torkoal releases smoke, Magmar crackles with fire
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharSetAnim(torkoal, "Idle", true)
    local smoke = RogueEssence.Content.FiniteOverlayEmitter()
    smoke.FadeIn = 10
    smoke.TotalTime = 50
    smoke.Layer = DrawLayer.Front
    smoke.Anim = RogueEssence.Content.BGAnimData("Smoke", 0)
    GROUND:PlayVFX(smoke, torkoal.Position.X, torkoal.Position.Y - 16)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    local fireSpark = RogueEssence.Content.FiniteOverlayEmitter()
    fireSpark.FadeIn = 5
    fireSpark.TotalTime = 30
    fireSpark.Layer = DrawLayer.Front
    fireSpark.Anim = RogueEssence.Content.BGAnimData("Ember", 0)
    GROUND:PlayVFX(fireSpark, magmar.Position.X, magmar.Position.Y)
  end)
  TASK:JoinCoroutines({coro1, coro2})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_010']))
  -- "On n'a pas fait tout ce chemin pour rien ! [hero], en avant !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.TunnelMiniBossSeen = true
  GAME:ContinueDungeon("searing_tunnel", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function searing_tunnel_miniboss_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()
  GROUND:CharSetAnim(torkoal, "Idle", true)
  GROUND:CharSetAnim(magmar, "Idle", true)

  GROUND:TeleportTo(hero, 240, 380, Direction.Up)
  GROUND:TeleportTo(partner, 272, 380, Direction.Up)
  GAME:MoveCamera(256, 240, 1, false)

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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_011']))
  -- "De retour. Cette fois, on est prêts !"

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("searing_tunnel", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function searing_tunnel_miniboss_ch_5.DefeatedBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })

  GROUND:CharSetAction(torkoal, RogueEssence.Ground.PoseGroundAction(
    torkoal.Position, torkoal.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
  GROUND:CharSetAction(magmar, RogueEssence.Ground.PoseGroundAction(
    magmar.Position, magmar.Direction,
    RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GROUND:TeleportTo(hero, 240, 320, Direction.Up)
  GROUND:TeleportTo(partner, 272, 320, Direction.Up)
  GAME:MoveCamera(256, 240, 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Spring Cave.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("Inspired")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_012']))
  -- "On a survécu à la fournaise !"

  GAME:WaitFrames(20)
  UI:SetSpeakerEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_013']))
  -- "Cette voix...[pause=15] Elle semble tout savoir de ce donjon."

  GAME:WaitFrames(20)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['STM_014']), "Normal")
  -- "C'est comme si elle nous testait. Continuons."

  GAME:WaitFrames(20)

  -- Torkoal and Magmar fade into steam
  local fadeSteam = RogueEssence.Content.FlashEmitter()
  fadeSteam.FadeInTime = 2
  fadeSteam.HoldTime = 2
  fadeSteam.FadeOutTime = 20
  fadeSteam.StartColor = Color(255, 200, 100, 0)
  fadeSteam.Layer = DrawLayer.Top
  fadeSteam.Anim = RogueEssence.Content.BGAnimData("White", 0)
  GROUND:PlayVFX(fadeSteam, 256, 220)
  SOUND:PlayBattleSE("EVT_Battle_Flash")
  GAME:WaitFrames(16)
  GROUND:Hide('Torkoal')
  GROUND:Hide('Magmar')
  GAME:WaitFrames(40)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function searing_tunnel_miniboss_ch_5.DiedToBoss()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local torkoal = CharacterEssentials.MakeCharactersFromList({
    {'Torkoal', 220, 232, Direction.Down}
  })
  local magmar = CharacterEssentials.MakeCharactersFromList({
    {'Magmar', 292, 208, Direction.Down}
  })
  GROUND:CharSetAnim(torkoal, "Idle", true)
  GROUND:CharSetAnim(magmar, "Idle", true)

  GROUND:Hide(partner.EntName)
  GROUND:Hide(hero.EntName)

  AI:DisableCharacterAI(partner)
  SOUND:StopBGM()

  GAME:MoveCamera(256, 240, 1, false)
  GAME:CutsceneMode(true)

  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  GAME:WaitFrames(40)

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_015']))
  -- "Les flammes t'ont consumé..."

  GAME:WaitFrames(30)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['STM_016']))
  -- "Mais le feu forge l'acier. Reviens, plus fort."

  GAME:WaitFrames(40)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)

  SV.TemporaryFlags.Dinnertime = true
  SV.TemporaryFlags.Bedtime = true
  SV.TemporaryFlags.MorningWakeup = true
  SV.TemporaryFlags.MorningAddress = true

  GAME:CutsceneMode(false)
  GAME:EnterGroundMap("searing_tunnel_entrance", "Main_Entrance_Marker")
end

return searing_tunnel_miniboss_ch_5
