--[[
    init.lua
    Searing Tunnel Mini-Boss Ground Map
    Torkoal + Magmar encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

local searing_tunnel_miniboss = {}

function searing_tunnel_miniboss.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_searing_tunnel_miniboss")
end

function searing_tunnel_miniboss.Enter(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_searing_tunnel_miniboss")

  if SV.Chapter5.TunnelMiniBossSeen then
    searing_tunnel_miniboss.SecondPreBossScene()
  else
    searing_tunnel_miniboss.FirstPreBossScene()
  end
end

function searing_tunnel_miniboss.Update(map, time)
end

function searing_tunnel_miniboss.GameSave(map)
end

function searing_tunnel_miniboss.GameLoad(map)
end

return searing_tunnel_miniboss
