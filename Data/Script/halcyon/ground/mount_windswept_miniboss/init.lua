--[[
    init.lua
    Mount Windswept Mini-Boss Ground Map
    Gligar + Skarmory encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local mount_windswept_miniboss = {}

function mount_windswept_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mount_windswept_miniboss")
end

function mount_windswept_miniboss.Enter(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_mount_windswept_miniboss")

  if SV.Chapter5.MountMiniBossSeen then
    mount_windswept_miniboss.SecondPreBossScene()
  else
    mount_windswept_miniboss.FirstPreBossScene()
  end
end

function mount_windswept_miniboss.Update(map, time)
end

function mount_windswept_miniboss.GameSave(map)
end

function mount_windswept_miniboss.GameLoad(map)
end

return mount_windswept_miniboss
