require 'origin.common'
require 'halcyon.GeneralFunctions'

local gloomy_forest = {}

function gloomy_forest.Init(zone)
	DEBUG.EnableDbgCoro()
	PrintInfo("=>> Init_gloomy_forest")
	SV.TemporaryFlags.LastDungeonEntered = 'gloomy_forest'
end

function gloomy_forest.EnterSegment(zone, rescuing, segmentID, mapID)
	GeneralFunctions.CheckAllowSetRescue(zone.ID)
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

	if result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		GAME:WaitFrames(20)
	end

	if result == RogueEssence.Data.GameProgress.ResultType.Cleared and SV.Chapter6.ChenipentFound then
		SV.Chapter6.MissionComplete = true
		SV.Chapter6.MissionAccepted = false
	else
		SV.Chapter6.MissionAccepted = false
	end

	-- The chapter 6 mission returns to the town directly.  The result screen is
	-- still handled by the engine; the next town load plays the short follow-up
	-- only when Chenipent was actually found.
	GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, true, true)
end

return gloomy_forest
