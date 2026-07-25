--[[
    init.lua
    Vast Steppe Guardian Ground Map
    Alpha Stantler encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local vast_steppe_guardian = {}

function vast_steppe_guardian.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vast_steppe_guardian")
end

function vast_steppe_guardian.Enter(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_vast_steppe_guardian")

  if SV.Chapter5.SteppeGuardianSeen then
    vast_steppe_guardian.SecondPreBossScene()
  else
    vast_steppe_guardian.FirstPreBossScene()
  end
end

function vast_steppe_guardian.Update(map, time)
end

function vast_steppe_guardian.GameSave(map)
end

function vast_steppe_guardian.GameLoad(map)
end

return vast_steppe_guardian
