local RunService = game:GetService("RunService");
local PlayerService = game:GetService("Players");
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TeleportService = game:GetService("TeleportService");

local module = {}

local moduleSettings = {
	["Minimum_Loading_Screen_Display"] = 2, -- The minimum amount of time the loading screen will be visible.

	["Safe_Attempts"] = 3,
	["Retry_Delay"] = 2,

};

if RunService:IsServer() then

	function module.safeTeleport(player, place_ID, teleport_Data)

		local attemptedTries = 0

		repeat

			local success = pcall(function()
				TeleportService:Teleport(
					player, 
					place_ID,
					teleport_Data,
					player["PlayerGui"]:FindFirstChild("TeleportGui")
				)
			end)

			attemptedTries += 1

			if not success then
				warn(([[[WARNING]: Teleport-Core | FAILED TO TELEPORT "%s", TRIES REMAINING: %s]]):format(player.Name, tostring(moduleSettings.Safe_Attempts - attemptedTries)))
				task.wait(moduleSettings.Retry_Delay)
			elseif success then
				warn(([[[WARNING]: Teleport-Core | SUCCESSFULLY TELEPORTED "%s" ON TRY "%s"]]):format(player.Name, tostring(attemptedTries)))
			end

		until success or (attemptedTries == moduleSettings.Safe_Attempts)

	end

elseif RunService:IsClient() then

	local LocalPlayer = PlayerService.LocalPlayer or PlayerService:GetPropertyChangedSignal("LocalPlayer") and PlayerService.LocalPlayer;

	TeleportService.LocalPlayerArrivedFromTeleport:Once(function(customLoadingScreen, teleportData)

		local playerGui = LocalPlayer.LocalPlayer:WaitForChild("PlayerGui")

		customLoadingScreen.Parent = playerGui
		ReplicatedFirst:RemoveDefaultLoadingScreen()

		task.wait(moduleSettings.Minimum_Loading_Screen_Display)

		if not game.Loaded() then
			game.Loaded:Wait();
		end

		customLoadingScreen:Destroy()
	end)

end

return module
