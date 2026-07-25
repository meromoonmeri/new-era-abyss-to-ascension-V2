require 'origin.common'
require 'halcyon.GeneralFunctions'

local gloomy_forest = {}

function gloomy_forest.Init(zone)
	DEBUG.EnableDbgCoro()
	PrintInfo("=>> Init_gloomy_forest")
	SV.TemporaryFlags.LastDungeonEntered = 'gloomy_forest'
end

function gloomy_forest.EnterSegment(zone, rescuing, segmentID, mapID)
	if segmentID == 2 then
		GAME:SetRescueAllowed(false)
	else
		GeneralFunctions.CheckAllowSetRescue(zone.ID)
	end
	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function gloomy_forest.Rescued(zone, name, mail)
	COMMON.Rescued(zone, name, mail)
end

function gloomy_forest.ExitSegment(zone, result, rescue, segmentID, mapID)
	GeneralFunctions.RestoreIdleAnim()
	DEBUG.EnableDbgCoro()
	PrintInfo("=>> ExitSegment_gloomy_forest result " .. tostring(result) .. " segment " .. tostring(segmentID))

	local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
	SV.adventure.Thief = false
	if exited == true then return end

	if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
		-- Eighteen normal floors flow directly into the three depth floors.
		GAME:ContinueDungeon("gloomy_forest", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
		return
	end

	if segmentID == 1 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
		if SV.Chapter6.ChenipentFound then
			GAME:EnterGroundMap('gloomy_forest_boss', 'Main_Entrance_Marker')
		else
			-- The rescue objective is required before the heart of the forest opens.
			SV.Chapter6.MissionAccepted = false
			GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
		end
		return
	end

	if segmentID == 2 then
		if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
			SV.Chapter6.GloomyBossEncountered = true
			SV.Chapter6.DefeatedGloomyBoss = true
			SV.Chapter6.MissionComplete = true
			SV.Chapter6.MissionAccepted = false
		else
			SV.Chapter6.MissionAccepted = false
		end
		GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
		return
	end

	-- Any loss, escape or failed objective returns safely to Metano Town.
	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		GAME:WaitFrames(20)
	end
	SV.Chapter6.MissionAccepted = false
	GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
end

return gloomy_forest
