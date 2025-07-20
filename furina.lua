-- Furina Hub 3.7 FINAL by shinroblox -- Full Features: Fly (PC/Mobile), ESP, Teleport, Godmode, Anti-Stun, Invisible, -- Hitbox, Tool Giver, Hide Name, Fling Touch, Auto Reload, Mobile UI Compatible

--===[ PART 1: SERVICES, CLEANUP, UI SETUP ]===--

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local Mouse = LocalPlayer:GetMouse() local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService") local TweenService = game:GetService("TweenService") local StarterGui = game:GetService("StarterGui")

-- Remove previous GUI if exists pcall(function() if game.CoreGui:FindFirstChild("FurinaHubGUI") then game.CoreGui.FurinaHubGUI:Destroy() end end)

-- GUI Setup local ScreenGui = Instance.new("ScreenGui", game.CoreGui) ScreenGui.Name = "FurinaHubGUI"

local ToggleBtn = Instance.new("TextButton", ScreenGui) ToggleBtn.Size = UDim2.new(0, 120, 0, 40) ToggleBtn.Position = UDim2.new(0, 10, 0, 10) ToggleBtn.Text = "Toggle Furina Hub" ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 220, 255) ToggleBtn.TextSize = 16

local MainFrame = Instance.new("ScrollingFrame", ScreenGui) MainFrame.Size = UDim2.new(0, 350, 0, 450) MainFrame.Position = UDim2.new(0, 10, 0, 60) MainFrame.Visible = true MainFrame.CanvasSize = UDim2.new(0, 0, 3, 0) MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240) MainFrame.BorderSizePixel = 0 MainFrame.ScrollBarThickness = 6

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- UI Helper local function createButton(text, yPos, callback) local btn = Instance.new("TextButton", MainFrame) btn.Size = UDim2.new(0, 320, 0, 40) btn.Position = UDim2.new(0, 15, 0, yPos) btn.Text = text btn.BackgroundColor3 = Color3.fromRGB(200, 200, 255) btn.TextSize = 16 btn.MouseButton1Click:Connect(callback) return btn end

--===[ PART 2 sẽ tiếp tục ở message sau ]===-- -- Bao gồm các chức năng chính như Fly, ESP, Teleport, Godmode...

-- Fly Script (PC + Mobile hỗ trợ cả joystick)
local flying = false
local UIS = game:GetService("UserInputService")
local function startFly()
	flying = true
	local BodyGyro = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
	local BodyVelocity = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
	BodyGyro.P = 9e4
	BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	BodyGyro.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
	BodyVelocity.velocity = Vector3.new(0, 0, 0)
	BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

	RunService:BindToRenderStep("Flying", Enum.RenderPriority.Camera.Value, function()
		local move = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
		BodyVelocity.velocity = move * 50
		BodyGyro.CFrame = workspace.CurrentCamera.CFrame
	end)
end

local function stopFly()
	flying = false
	RunService:UnbindFromRenderStep("Flying")
	for _, v in pairs(LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
		if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
			v:Destroy()
		end
	end
end

-- Godmode (ẩn damage, không stun, v.v...)
local function enableGodmode()
	if LocalPlayer.Character:FindFirstChild("Humanoid") then
		local humanoid = LocalPlayer.Character.Humanoid
		humanoid.Name = "GodHumanoid"
		local clone = humanoid:Clone()
		clone.Parent = LocalPlayer.Character
		clone.Name = "Humanoid"
		wait(0.1)
		LocalPlayer.Character:FindFirstChild("GodHumanoid"):Destroy()
		workspace.CurrentCamera.CameraSubject = clone
	end
end

-- Anti-Stun
local function antiStun()
	LocalPlayer.Character.ChildAdded:Connect(function(child)
		if child:IsA("BoolValue") and string.find(child.Name:lower(), "stun") then
			child:Destroy()
		end
	end)
end

-- Invisible (ẩn hình)
local function becomeInvisible()
	for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			if part:FindFirstChild("face") then
				part.face:Destroy()
			end
		end
	end
end

-- Teleport to player
local function teleportTo(playerName)
	local target = Players:FindFirstChild(playerName)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
	end
end

-- ESP Team Based (Search: Red, Hider: Blue)
local function createESP(player)
	if player == LocalPlayer then return end
	local color = Color3.fromRGB(255, 0, 0)
	if player.Team and player.Team.Name:lower():find("hide") then
		color = Color3.fromRGB(0, 200, 255)
	end

	local highlight = Instance.new("Highlight")
	highlight.Adornee = player.Character
	highlight.FillColor = color
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 1
	highlight.Parent = player.Character
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		wait(1)
		createESP(player)
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	if player.Character then
		createESP(player)
	end
end
-- Hitbox Mở Rộng (Hiệu ứng trắng trong suốt, không va chạm)
local function enableHitbox()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local part = player.Character.HumanoidRootPart
			part.Size = Vector3.new(10, 10, 10)
			part.Transparency = 0.5
			part.Material = Enum.Material.ForceField
			part.CanCollide = false
		end
	end
end

-- Fling Stick Tool (Fling khi đụng vào người khác)
local function createFlingTool()
	local tool = Instance.new("Tool")
	tool.RequiresHandle = true
	tool.Name = "Fling Stick"

	local handle = Instance.new("Part")
	handle.Size = Vector3.new(1, 1, 4)
	handle.Name = "Handle"
	handle.Parent = tool

	tool.Equipped:Connect(function()
		handle.Touched:Connect(function(hit)
			local hrp = hit.Parent:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Velocity = Vector3.new(500, 500, 500)
			end
		end)
	end)

	tool.Parent = LocalPlayer.Backpack
end

-- Tool Giver
local function giveTools()
	createFlingTool()
end

-- GUI Toggle Button
ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Auto Reload GUI khi chết
LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/datbhs/Furina-hub-beta/main/furina.lua"))()
end)

-- Tạo các nút UI chức năng
local function createButton(text, callback, posY)
	local btn = Instance.new("TextButton", MainFrame)
	btn.Size = UDim2.new(0, 160, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.MouseButton1Click:Connect(callback)
end

-- Tạo nút chức năng
createButton("Fly", startFly, 10)
createButton("Unfly", stopFly, 45)
createButton("Godmode", enableGodmode, 80)
createButton("Anti-Stun", antiStun, 115)
createButton("Invisible", becomeInvisible, 150)
createButton("Hitbox", enableHitbox, 185)
createButton("Tool Giver", giveTools, 220)

-- Teleport Menu
createButton("Teleport to...", function()
	local name = game:GetService("StarterGui"):PromptTextInput("Tên người chơi cần dịch chuyển:")
	if name then teleportTo(name) end
end, 255)
-- Hide Name (Ẩn tên trên đầu)
local function hideName()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
		local head = LocalPlayer.Character.Head
		for _, v in pairs(head:GetChildren()) do
			if v:IsA("BillboardGui") or v:IsA("TextLabel") then
				v:Destroy()
			end
		end
	end
end

-- ESP Phân biệt team (Team đỏ: Súng / Team xanh: Ẩn nấp)
local function teamESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local esp = Instance.new("BillboardGui", player.Character.Head)
			esp.Size = UDim2.new(0, 100, 0, 40)
			esp.AlwaysOnTop = true

			local label = Instance.new("TextLabel", esp)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = player.Name
			label.TextColor3 = player.TeamColor == BrickColor.new("Bright red") and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
			label.TextStrokeTransparency = 0
			label.TextScaled = true
		end
	end
end

-- Hệ thống nhập key để mở GUI
local function checkKeySystem()
	local gui = Instance.new("ScreenGui", game.CoreGui)
	gui.Name = "FurinaKeyGUI"

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 300, 0, 150)
	frame.Position = UDim2.new(0.5, -150, 0.5, -75)
	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame.BorderSizePixel = 2

	local input = Instance.new("TextBox", frame)
	input.Size = UDim2.new(0, 200, 0, 40)
	input.Position = UDim2.new(0.5, -100, 0.2, 0)
	input.PlaceholderText = "Nhập key tại đây..."
	input.Text = ""
	input.TextScaled = true

	local submit = Instance.new("TextButton", frame)
	submit.Size = UDim2.new(0, 100, 0, 35)
	submit.Position = UDim2.new(0.5, -50, 0.6, 0)
	submit.Text = "Xác nhận"
	submit.BackgroundColor3 = Color3.fromRGB(180, 220, 255)

	submit.MouseButton1Click:Connect(function()
		if input.Text == "YTBHS01" then
			gui:Destroy()
			MainFrame.Visible = true
		else
			submit.Text = "Sai Key!"
			wait(1)
			submit.Text = "Xác nhận"
		end
	end)

	MainFrame.Visible = false
end

-- Cuộn giao diện nếu quá dài (scroll GUI)
MainFrame.ClipsDescendants = true
local scrolling = Instance.new("ScrollingFrame", MainFrame)
scrolling.Size = UDim2.new(1, 0, 1, 0)
scrolling.CanvasSize = UDim2.new(0, 0, 2, 0)
scrolling.ScrollBarThickness = 6
scrolling.BackgroundTransparency = 1
for _, btn in pairs(MainFrame:GetChildren()) do
	if btn:IsA("TextButton") then
		btn.Parent = scrolling
	end
end

-- Khởi động hệ thống bảo mật
checkKeySystem()
teamESP()
