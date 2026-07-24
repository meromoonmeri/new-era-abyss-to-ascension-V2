--[[
    Example init.lua

  ****Each maps must have init.lua! ****

    Each map needs to have a init.lua, and a actions.lua file that defines its own instance of the GroundMap class.
    This will be used to determine how to run the map events and more!

    If the base implementation of GroundMap isn't enough, you can override any methods of the
    GroundMap class in here as needed!

    You can add any number of scripts in the map folder as you want! Some special constants are available to fetch the current map's directory
    to load the scripts using a dofile or require function call.

    _SCRIPT_MAP_DIR = global containing the path from the Script root folder to the current folder
]]--
require('common')

local test_grounds = {}


--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function test_grounds.Init(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_test_grounds <<=")

  COMMON.RespawnStarterPartner()

  local partner = CH('Partner')
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  partner.CollisionDisabled = true

  --Set Poochy AI
  local poochy = CH("Poochy")
  --Set the area to wander in
  local poochzone = {X = poochy.X - 100, Y = poochy.Y - 100,
                     W = 200, H = 200};
  AI:SetCharacterAI(poochy,                                      --[[Entity that will use the AI]]--
                    "halcyon.ai.ground_default",                         --[[Class path to the AI class to use]]--
                    RogueElements.Loc(poochzone.X, poochzone.Y), --[[Top left corner pos of the allowed idle wander area]]--
                    RogueElements.Loc(poochzone.W, poochzone.H), --[[Width and Height of the allowed idle wander area]]--
                    0.5,                                         --[[Wandering speed]]--
                    48,                                          --[[Min move distance for a single wander]]--
                    64,                                          --[[Max move distance for a single wander]]--
                    320,                                         --[[Min delay between idle actions]]--
                    620);                                        --[[Max delay between idle actions]]--




  --Spawn our spawner npcs
  GROUND:SpawnerDoSpawn('MerchantSpawner')

  GROUND:SpawnerDoSpawn('MerchantSpawner2')
end

function test_grounds.GameLoad(map)
  PrintInfo('GameLoad_test_grounds')

end

function test_grounds.GameSave(map)
  PrintInfo('GameSave_test_grounds')

end

--Called when the screen fades in as the player enters the map
function test_grounds.Enter(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Enter_test_grounds')
  SV.base_camp.ExpositionComplete = true
  SV.base_camp.FirstTalkComplete = true

  local caterQuest = SV.test_grounds.Missions["CaterQuest"]
  if caterQuest == nil or caterQuest.Complete == COMMON.MISSION_INCOMPLETE then
	GROUND:Hide("Caterpie")
  end
  local volmiseQuest = SV.test_grounds.Missions["VolmiseQuest"]
  if volmiseQuest == nil or volmiseQuest.Complete == COMMON.MISSION_INCOMPLETE then
	GROUND:Hide("Illumise")
  end

  GAME:FadeIn(60)
  UI:ResetSpeaker()

  if not SV.test_grounds.DemoComplete then
    GAME:SetTeamName(STRINGS:FormatKey("TEAM_NAME", "Guildmaster"))
    UI:WaitShowDialogue(STRINGS:Format("Congratulations on completing the toughest dungeon in the demo![pause=0] Enjoy the debug room!"))
	GAME:UnlockDungeon('debug_zone')
	GAME:UnlockDungeon('tropical_path')
  end
  SV.test_grounds.DemoComplete = true
end

--Called constantly while the map is running
function test_grounds.Update(map, time)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
end

function test_grounds.Test_Action()
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Test_Action')

  UI:SetSpeaker(CH('PLAYER'))
  UI:WaitShowDialogue("So cool!")
  GROUND:Unhide("Illumise")
  GROUND:Unhide("Caterpie")
  local groundObject = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Sign", 1), RogueElements.Rect(244, 180, 24, 24), RogueElements.Loc(8, 0), false, "Sign2")
  _ZONE.CurrentGround:AddTempObject(groundObject)
end

--------------------------------------------------
-- Objects Callbacks
--------------------------------------------------
function test_grounds.Sign1_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Sign1_Action')
  UI:ResetSpeaker()
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS.MapStrings['Sign1_Action_Line0'])
  UI:WaitShowVoiceOver("Cette salle comprend de nombreux[pause=0]mécaniques utiles pour les scripts.[br]Dont certains\n\nne peut jamais être utilisé\ndans le jeu final.[scroll]Pour activer le mode développeur,[scroll]exécutez dev.bat dans le dossier du jeu.", -1)
  GAME:WaitFrames(30)
  UI:SetAutoFinish(true)
  UI:WaitShowVoiceOver("Fourchez-nous à[pause=0]https://github.com/audinowho/PMDODump![br]Now...\nLaissez-vous déplacer ![scroll]Prêt dans\n3 2 1", -1)

  TASK:WaitStartEntityTask(activator, function()
    SOUND:PlayBattleSE("EVT_Emote_Confused")
    GROUND:CharSetEmote(activator, "question", 1)
    GAME:WaitFrames(60)
    GROUND:MoveInDirection(activator, Direction.Down, 30, false, 2)
    GROUND:MoveInDirection(activator, Direction.DownLeft, 30, false, 2)
    GROUND:MoveInDirection(activator, Direction.DownRight, 30, false, 2)
    GROUND:MoveInDirection(activator, Direction.UpRight, 30, false, 2)
    GROUND:MoveInDirection(activator, Direction.UpLeft, 30, false, 2)
  end)

  UI:SetAutoFinish(false)
  TASK:WaitEntityTask(activator)
  UI:WaitShowDialogue("Oui,[pause=0], vous venez de vous déplacer tout seul.")

  SOUND:PlayBattleSE("DUN_Explosion")
  local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Flamethrower", 3))
  emitter.LocHeight = 14
  GROUND:PlayVFX(emitter, activator.MapLoc.X, activator.MapLoc.Y)

  GAME:WaitFrames(60)
  UI:WaitShowDialogue("BOOM.")

  SOUND:PlayBattleSE("DUN_Explosion")
  emitter = RogueEssence.Content.FiniteAreaEmitter(RogueEssence.Content.AnimData("Explosion", 3))
  emitter.Range = 72
  emitter.Speed = 72
  emitter.TotalParticles = 12
  GROUND:PlayVFX(emitter, activator.MapLoc.X, activator.MapLoc.Y)

  GAME:WaitFrames(60)
  UI:WaitShowDialogue("BOOM BOOM BOOM.")
end


function test_grounds.Concurrent_Sequence(turnTime)
	local chara = CH('PLAYER')

  GROUND:CharSetAnim(chara, "None", true)
  GROUND:CharAnimateTurnTo(chara, Direction.Left, turnTime)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Right, turnTime, false)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Left, turnTime, true)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Right, turnTime, false)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Left, turnTime, true)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurn(chara, Direction.Right, turnTime, false)
  GAME:WaitFrames(20)
  GROUND:CharAnimateTurnTo(chara, Direction.Up, turnTime)
  GAME:WaitFrames(20)
  SOUND:PlayBattleSE("EVT_Emote_Confused")
  GROUND:CharSetEmote(chara, "question", 1)
  GAME:WaitFrames(20)
  GROUND:CharSetAnim(chara, "None", false)
end

function test_grounds.Sign3_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local chara = CH('PLAYER')
  PrintInfo('Sign2_Action')
  UI:ResetSpeaker()
  UI:SetAutoFinish(true)
  UI:WaitShowDialogue(STRINGS.MapStrings['Sign2_Action_Line0'])
  GAME:FadeOut(false, 30)
  GAME:MoveCamera(0, 120, 1, true)
  --perform this fade without waiting for its completion
  local coro1 = TASK:BranchCoroutine(GAME:_FadeIn(60))
  local coro2 = TASK:BranchCoroutine(function() test_grounds.Concurrent_Sequence(4) end)
  GAME:MoveCamera(0, 0, 60, true)
  --TODO: wait to join coroutines before giving control back to the player
  TASK:JoinCoroutines({coro1, coro2})


  coro1 = TASK:BranchCoroutine(test_grounds.Concurrent_BG)
  coro2 = TASK:BranchCoroutine(test_grounds.Concurrent_Title)
  TASK:JoinCoroutines({coro1, coro2})
end


function test_grounds.Concurrent_Title()

  UI:WaitShowTitle("Like\nComment\nSubscribe", 60)
  GAME:WaitFrames(120)
  UI:WaitHideTitle(60)
end

function test_grounds.Concurrent_BG()

  UI:WaitShowBG("Cosmic_Power", 1, 60)
  GAME:WaitFrames(120)
  UI:WaitHideBG(60)
end

ListType = luanet.import_type('System.Collections.Generic.List`1')
MenuTextChoiceType = luanet.import_type('RogueEssence.Menu.MenuTextChoice')

function test_grounds.Sign2_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local chara = CH('PLAYER')
  GROUND:Unhide('Activation')
  UI:WaitShowDialogue("Le donjon de débogage est accessible à partir d'ici.")
  UI:WaitShowDialogue("Nous n'assumons aucune responsabilité pour les objets cassés que vous y rencontrez.")
  UI:WaitShowDialogue("Si vous êtes bloqué à l'intérieur, essayez de supprimer SAVE/QUICKSAVE.rsqs")
  UI:WaitShowDialogue("Peut-être sauvegardez également votre sauvegarde principale. (ENREGISTRER/ENREGISTRER.rssv)")
end

function test_grounds.Entrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Entrance_Action')
end

function test_grounds.Activation_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Activation_Action')
end

function test_grounds.Assembly_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  SOUND:PlaySE("Menu/Skip")
  UI:AssemblyMenu()
  UI:WaitForChoice()
  result = UI:ChoiceResult()
  UI:WaitShowDialogue("Contrairement aux objets d'assemblage des autres cartes, celle-ci ne recharge pas la carte lors d'un changement d'équipe.")
end

function test_grounds.SouthExit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  local open_dests = {
    { Name="Replay Test Zone", Dest=RogueEssence.Dungeon.ZoneLoc('debug_zone', 4, 0, 0) },
    { Name="Base Camp", Dest=RogueEssence.Dungeon.ZoneLoc('guildmaster_island', -1, 1, 0) }
  }
  local open_dungeons = { 0 }
  local ground_entrances = { 1 }

  UI:ResetSpeaker()
  SOUND:PlaySE("Menu/Skip")
  UI:DestinationMenu(open_dests)
  UI:WaitForChoice()
  dest = UI:ChoiceResult()

  if dest:IsValid() then
    SOUND:PlayBGM("", true)
    GAME:FadeOut(false, 20)
	if dest.StructID.Segment > -1 then
	  GAME:EnterDungeon(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else
	  GAME:EnterZone(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint)
	end
  end
end
--------------------------------------------------
-- Characters Callbacks
--------------------------------------------------
function test_grounds.Mew_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local mew = CH('Mew')
  local player = CH('PLAYER')
  local state = {olddir = mew.CharDir}

  GROUND:CharTurnToChar(mew,player)
  GROUND:CharSetEmote(mew, "", 0)

  UI:SetSpeaker(mew)
  UI:WaitShowTimedDialogue("Marche avec moi !", 120)
  GROUND:CharSetEmote(mew, "happy", 0)

  local coro1 = TASK:BranchCoroutine(function() test_grounds.Walk_Sequence(mew) end)
  local coro2 = TASK:BranchCoroutine(function() test_grounds.Walk_Sequence(player) end)

  TASK:JoinCoroutines({coro1, coro2})

  CH('Mew').CharDir = state.olddir

  local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex("Swing")
  GROUND:CharSetAction(CH('PLAYER'), RogueEssence.Ground.FrameGroundAction(CH('PLAYER').Position, CH('PLAYER').Direction, animId, 5))

  GAME:WaitFrames(60)
  GROUND:CharEndAnim(CH('PLAYER'))
end

function test_grounds.Walk_Sequence(chara)

  GROUND:MoveInDirection(chara, Direction.Up, 20, false, 2)
  GAME:WaitFrames(60)
  GROUND:AnimateInDirection(chara, "Hurt", Direction.Down, Direction.Up, 20, 1, 5)
  GAME:WaitFrames(60)
  GROUND:MoveInDirection(chara, Direction.Down, 20, true, 7)
end


function test_grounds.Caterpie_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Caterpie_Action')
  local olddir = chara.CharDir
  GROUND:CharTurnToCharAnimated(chara, CH('PLAYER'), 4)

  UI:SetSpeaker(chara)
  UI:WaitShowDialogue("So cool!")

end


function test_grounds.Magnezone_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Magnezone_Action')
  GROUND:CharTurnToCharAnimated(chara, CH('PLAYER'), 4)

  UI:SetSpeaker(chara)
  -- check for quest presence
  local quest = SV.test_grounds.Missions["OutlawQuest"]
  if quest == nil then
    -- no outlaw quest? ask to start one
    UI:ChoiceMenuYesNo("Aucune mission Outlaw détectée. Voulez-vous en démarrer un ?")
    UI:WaitForChoice()
    local chres = UI:ChoiceResult()
    if chres then
	  -- Type 0 = Rescue
	  SV.test_grounds.Missions["OutlawQuest"] = { Complete = COMMON.MISSION_INCOMPLETE, Type = COMMON.MISSION_TYPE_OUTLAW, DestZone = "debug_zone", DestSegment = 4, DestFloor = 9, TargetSpecies = "riolu" }
      UI:WaitShowDialogue("Vous pouvez trouver l’agresseur dans la zone de test Replay 10F.  Bonne chance!")
    end
  else
    if quest.Complete == 2 then
	  -- there is an outlaw quest, and it has been completed- thank you note
	  UI:WaitShowDialogue("État de mission du hors-la-loi : Récompensé.  Merci d'avoir appréhendé Riolu !")
	elseif quest.Complete == 1 then
	  UI:WaitShowDialogue("État de la mission hors-la-loi : terminé.  Donnez une récompense et marquez la mission comme récompensée.")
	  quest.Complete = 2
	else
	  -- there is an outlaw quest, but it hasn't been completed?  ask to abandon
      UI:ChoiceMenuYesNo("État de la mission hors-la-loi : incomplet.  Voulez-vous abandonner la mission?")
      UI:WaitForChoice()
      local chres = UI:ChoiceResult()
      if chres then
	    SV.test_grounds.Missions["OutlawQuest"] = nil
        UI:WaitShowDialogue("Mission hors-la-loi supprimée.")
      end
	end
  end
end


function test_grounds.Butterfree_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Butterfree_Action')
  GROUND:CharTurnToCharAnimated(chara, CH('PLAYER'), 4)

  UI:SetSpeaker(chara)
  -- check for quest presence
  local quest = SV.test_grounds.Missions["CaterQuest"]
  if quest == nil then
    -- no caterpie quest? ask to start one
    UI:ChoiceMenuYesNo("Aucune mission Caterpie détectée. Voulez-vous en démarrer un ?")
    UI:WaitForChoice()
    local chres = UI:ChoiceResult()
    if chres then
	  -- Type 0 = Rescue
	  SV.test_grounds.Missions["CaterQuest"] = { Complete = COMMON.MISSION_INCOMPLETE, Type = COMMON.MISSION_TYPE_RESCUE, DestZone = "debug_zone", DestSegment = 4, DestFloor = 4, TargetSpecies = "caterpie" }
      UI:WaitShowDialogue("Vous pouvez trouver Caterpie dans la zone de test Replay 5F.  Bonne chance!")
    end
  else
    if quest.Complete == 2 then
	  -- there is a caterpie quest, and it has been completed- thank you note
	  UI:WaitShowDialogue("État de mission Caterpie : Récompensé.  Merci d'avoir sauvé Caterpie !")
	elseif quest.Complete == 1 then
	  UI:WaitShowDialogue("État de la mission Caterpie : terminé.  Donnez une récompense et marquez la mission comme récompensée.")
	  quest.Complete = 2
	else
	  -- there is a caterpie quest, but it hasn't been completed?  ask to abandon
      UI:ChoiceMenuYesNo("État de la mission Caterpie : Incomplet.  Voulez-vous abandonner la mission?")
      UI:WaitForChoice()
      local chres = UI:ChoiceResult()
      if chres then
	    SV.test_grounds.Missions["CaterQuest"] = nil
        UI:WaitShowDialogue("Mission Caterpie supprimée.")
      end
	end
  end
end


function test_grounds.Illumise_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Illumise_Action')
  local olddir = chara.CharDir
  GROUND:CharTurnToCharAnimated(chara, CH('PLAYER'), 4)

  UI:SetSpeaker(chara)
  UI:WaitShowDialogue("Merci de m'avoir sauvé !")

end

function test_grounds.Volbeat_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Volbeat_Action')
  GROUND:CharTurnToCharAnimated(chara, CH('PLAYER'), 4)

  UI:SetSpeaker(chara)
  -- check for quest presence
  local quest = SV.test_grounds.Missions["VolmiseQuest"]
  if quest == nil then
    -- no caterpie quest? ask to start one
    UI:ChoiceMenuYesNo("Aucune mission Volmise détectée. Voulez-vous en démarrer un ?")
    UI:WaitForChoice()
    local chres = UI:ChoiceResult()
    if chres then
	  -- Type 1 = Escort
	  SV.test_grounds.Missions["VolmiseQuest"] = { Complete = COMMON.MISSION_INCOMPLETE, Type = COMMON.MISSION_TYPE_ESCORT, DestZone = "debug_zone", DestSegment = 4, DestFloor = 3, TargetSpecies = "illumise", EscortSpecies = "volbeat" }
      UI:WaitShowDialogue("Vous pouvez trouver Illumise sur Replay Test Zone 4F.  Je vous rejoindrai à votre entrée !")
    end
  else
    if quest.Complete == 2 then
	  -- there is a caterpie quest, and it has been completed- thank you note
	  UI:WaitShowDialogue("État de mission Volmise : Récompensé.  Merci d'avoir sauvé Illumise !")
	elseif quest.Complete == 1 then
	  UI:WaitShowDialogue("État de la mission Volmise : terminé.  Donnez une récompense et marquez la mission comme récompensée.")
	  quest.Complete = 2
	else
	  -- there is a caterpie quest, but it hasn't been completed?  ask to abandon
      UI:ChoiceMenuYesNo("État de la mission Volmise : Incomplet.  Voulez-vous abandonner la mission?")
      UI:WaitForChoice()
      local chres = UI:ChoiceResult()
      if chres then
	    SV.test_grounds.Missions["VolmiseQuest"] = nil
        UI:WaitShowDialogue("Mission Volmise supprimée.")
      end
	end
  end
end


function test_grounds.Hungrybox_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo('Hungrybox_Action')
  local player = CH('PLAYER')
  local hbox = chara
  local olddir = hbox.CharDir
  GROUND:Hide("PLAYER")
  GROUND:CharTurnToCharAnimated(hbox, player, 4)
  UI:SetSpeaker(hbox)
  UI:TextDialogue(STRINGS:Format(STRINGS.MapStrings['Hungrybox_Action_Line0']), 120)
  UI:WaitDialog()
  GROUND:CharAnimateTurnTo(hbox, olddir, 4)
  chara.CollisionDisabled = true
  GROUND:Unhide("PLAYER")
end


function test_grounds.Poochy_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintSVAndStrings()

  local olddir = chara.CharDir
  GROUND:CharTurnToCharAnimated(chara, activator, 4)
  UI:SetSpeaker(chara)

  if SV.base_camp.AcceptedPooch then
    --If we already talked with poochy and got him to set the ScriptVar
    UI:TextDialogue(STRINGS:Format(STRINGS.MapStrings['Pooch_Action_Line3']))
    UI:WaitDialog()
  else
    --If we haven't gotten poochy to set the script var

    if not SV.base_camp.SpokeToPooch then
      --If we never spoke to poochy before
      UI:TextDialogue(STRINGS:Format(STRINGS.MapStrings['Pooch_Action_Line0A']))
      UI:WaitDialog()
      SV.base_camp.SpokeToPooch = true
    else
      --If we already spoke to poochy before, but didn't get him to set the script var
      UI:TextDialogue(STRINGS:Format(STRINGS.MapStrings['Pooch_Action_Line0B']))
      UI:WaitDialog()
    end

    UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['Pooch_Action_Question1']))
    UI:WaitForChoice()
    local ch = UI:ChoiceResult()

    if ch then
      --The player told poochy to set the script var
      SV.base_camp.AcceptedPooch = true
      SOUND:PlayFanfare("Fanfare/MissionClear")
      SOUND:WaitFanfare()
      UI:TextDialogue(STRINGS:Format(STRINGS.MapStrings['Pooch_Action_Line2A']))
    else
      --The player told poochy NOT to set the script var
      UI:TextDialogue(STRINGS:Format(STRINGS.MapStrings['Pooch_Action_Line2B']))
    end

    UI:WaitDialog()

  end -- if SV.AcceptedPooch
  UI:ResetSpeaker()
  GROUND:CharAnimateTurnTo(chara, olddir, 4)
end

--------------------------------------------------
-- Spawners Callbacks
--------------------------------------------------

--[[
--]]
function test_grounds.MerchantSpawner_EntSpawned(spawner, spawnedent)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("test_grounds.MerchantSpawner_EntSpawned()!!")
end

--[[

--]]
function test_grounds.Merchant_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()

  local olddir = chara.CharDir
  GROUND:CharTurnToCharAnimated(chara, activator, 4)
  UI:SetSpeaker(chara)


  UI:WaitShowDialogue("Votre sprite sera toujours Pikachu et Évoli, uniquement sur cette carte.")
  UI:WaitShowDialogue("Pratique pour les mods qui veulent imiter le hub de style Explorers !")
  UI:WaitDialog()
  GROUND:CharAnimateTurnTo(chara, olddir, 4)
end

--[[
--]]
function test_grounds.MerchantSpawner2_EntSpawned(spawner, spawnedent)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("test_grounds.MerchantSpawner_EntSpawned()!!")
end

--[[

--]]
function test_grounds.Merchant2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()

  local olddir = chara.CharDir
  GROUND:CharTurnToCharAnimated(chara, activator, 4)
  UI:SetSpeaker(chara)

  UI:TextDialogue(STRINGS:Format("HELLO!"))
  UI:WaitDialog()
  GROUND:CharAnimateTurnTo(chara, olddir, 4)
end

function test_grounds.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:SetSpeaker("", false, chara.CurrentForm.Species, chara.CurrentForm.Form, chara.CurrentForm.Skin, chara.CurrentForm.Gender)

  local tbl = LTBL(chara)

  if tbl.TalkAmount == nil then
    UI:WaitShowDialogue("J'ai des variables de script qui me sont spécifiques.")
    UI:WaitShowDialogue("Changez avec moi en appuyant sur 2 et 1.")
    UI:WaitShowDialogue("Nous nous souviendrons du nombre de fois où on nous a parlé.")
	tbl.TalkAmount = 1
  else
	tbl.TalkAmount = tbl.TalkAmount + 1
  end
  UI:WaitShowDialogue("Vous m'avez parlé plusieurs fois " .. tostring(tbl.TalkAmount) .. ".")
end

function test_grounds.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

function test_grounds.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara, true)
end

return test_grounds
