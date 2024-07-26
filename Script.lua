if getgenv().activate == nil then
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local function saveCameraState()
		local camera = game.Workspace.CurrentCamera
		return {
			CameraType = camera.CameraType,
			CameraSubject = camera.CameraSubject,
			CFrame = camera.CFrame
		}
	end

	local function restoreCameraState(state)
		local camera = game.Workspace.CurrentCamera
		camera.CameraType = state.CameraType
		camera.CameraSubject = state.CameraSubject
		camera.CFrame = state.CFrame
	end

	local function followCamera(targetPlayer)
		local localPlayer = Players.LocalPlayer
		if not localPlayer then return end

		local character = targetPlayer.Character
		if not character then return end

		local head = character:FindFirstChild("Head")
		if not head then return end

		local camera = game.Workspace.CurrentCamera
		if not camera then return end

		camera.CameraType = Enum.CameraType.Scriptable
		if not getgenv().automatic then
			mouse1click()
		end
		local endTime = tick() + getgenv().cooldown

		local function updateCamera()
			if tick() > endTime then
				return false
			end

			if not character or not head then
				return false
			end

			camera.CFrame = CFrame.new(head.Position + Vector3.new(0, 1, -1 * (getgenv().distance)), head.Position)
			return true
		end

		while updateCamera() do
			RunService.RenderStepped:Wait()
		end
	end

	
	local function followTeleport(targetPlayer)
		local localPlayer = Players.LocalPlayer
		if not localPlayer then return end

		local character = targetPlayer.Character
		if not character then return end

		local head = character:FindFirstChild("Head")
		if not head then return end
		
		localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(head.Position + Vector3.new(0, 1, -1 * (getgenv().distance)), head.Position)
		followCamera(targetPlayer)
	end

	local function resetCamera(savedCameraState)
		if savedCameraState then
			restoreCameraState(savedCameraState)
		else
			local localPlayer = Players.LocalPlayer
			if not localPlayer then return end

			local character = localPlayer.Character
			if not character then return end

			local head = character:FindFirstChild("Head")
			if not head then return end

			local camera = game.Workspace.CurrentCamera
			if not camera then return end

			camera.CameraType = Enum.CameraType.Custom
			camera.CameraSubject = head
		end
	end

	local function cycleThroughPlayers()
		if getgenv().teleportPlayer then
			local pos = Players.LocalPlayer.Character.HumanoidRootPart.Position
		end
		local savedCameraState = saveCameraState()
		if getgenv().automatic then
			mouse1press()
		end
		for _, player in Players:GetPlayers() do
			if player ~= Players.LocalPlayer and player.Team ~= Players.LocalPlayer.Team and not table.find(getgenv().whitelist, player.Name) then
				if getgenv().teleportPlayer then
					followTeleport(player)
				else
					followCamera(player)
				end
			end
		end
		if getgenv().automatic then
			mouse1release()
		end
		task.wait(1)
		resetCamera(savedCameraState)
		if getgenv().teleportPlayer then
			Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
		end
	end
	if getgenv().chatToActivate then
		Players.LocalPlayer.Chatted:Connect(function(msg)
			if msg == getgenv().message then
				cycleThroughPlayers()
			end
		end)
	else
		UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == getgenv().key then
				cycleThroughPlayers()
			end
		end)
	end

	getgenv().activated = true
end
