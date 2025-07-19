local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function CreateGui()
    -- GUI Gốc
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "FurinaHub"
    gui.ResetOnSpawn = false

    -- Main Frame
    local main = Instance.new("Frame", gui)
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 300, 0, 400)
    main.Position = UDim2.new(0.5, -150, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(240, 250, 255)
    main.Visible = false

    local uicorner = Instance.new("UICorner", main)
    uicorner.CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", main)
    title.Text = "Furina Hub BETA - By: shinroblox"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(0,0,0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    -- Toggle Menu Button
    local toggleBtn = Instance.new("TextButton", gui)
    toggleBtn.Size = UDim2.new(0, 120, 0, 40)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, -20)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
    toggleBtn.Text = "Furina Hub"
    toggleBtn.TextColor3 = Color3.new(0,0,0)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14

    toggleBtn.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)

    -- Key System
    local keyFrame = Instance.new("Frame", gui)
    keyFrame.Size = UDim2.new(0, 250, 0, 120)
    keyFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
    keyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    keyFrame.Name = "KeyFrame"

    local keyCorner = Instance.new("UICorner", keyFrame)
    keyCorner.CornerRadius = UDim.new(0, 10)

    local keyBox = Instance.new("TextBox", keyFrame)
    keyBox.PlaceholderText = "Nhập key..."
    keyBox.Size = UDim2.new(0.8, 0, 0, 30)
    keyBox.Position = UDim2.new(0.1, 0, 0.2, 0)
    keyBox.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    keyBox.TextColor3 = Color3.new(0,0,0)
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 14

    local submitBtn = Instance.new("TextButton", keyFrame)
    submitBtn.Size = UDim2.new(0.5, 0, 0, 30)
    submitBtn.Position = UDim2.new(0.25, 0, 0.65, 0)
    submitBtn.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
    submitBtn.Text = "OK"
    submitBtn.TextColor3 = Color3.new(0,0,0)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 14

    submitBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == "YTBHS01" then
            keyFrame.Visible = false
            main.Visible = true
        else
            keyBox.Text = "Sai key!"
        end
    end)

    return gui, main
end

local gui, MainFrame = CreateGui()

-- ScrollFrame
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -20, 1, -40)
ScrollFrame.Position = UDim2.new(0, 10, 0, 35)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.Padding = UDim.new(0, 6)

function AddButton(name, callback)
	local btn = Instance.new("TextButton", ScrollFrame)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = name
	btn.MouseButton1Click:Connect(callback)
end

-- Fly
local flying = false
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HRP, BG, BV

function StartFly()
	local char = LocalPlayer.Character
	if not char then return end

	HRP = char:WaitForChild("HumanoidRootPart")
	flying = true

	BG = Instance.new("BodyGyro", HRP)
	BG.P = 9e4
	BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	BG.CFrame = HRP.CFrame

	BV = Instance.new("BodyVelocity", HRP)
	BV.velocity = Vector3.zero
	BV.maxForce = Vector3.new(9e9, 9e9, 9e9)

	coroutine.wrap(function()
		while flying do
			local cam = workspace.CurrentCamera
			BG.CFrame = cam.CFrame
			local dir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
			BV.Velocity = dir.Magnitude > 0 and dir.Unit * 50 or Vector3.zero
			RunService.RenderStepped:Wait()
		end
	end)()
end

function StopFly()
	flying = false
	if BG then BG:Destroy() end
	if BV then BV:Destroy() end
end

AddButton("Fly", StartFly)
AddButton("Unfly", StopFly)

-- ESP
local espEnabled = false
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "FurinaESP"

function createESP(plr, color)
	local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local esp = Instance.new("BoxHandleAdornment", espFolder)
	esp.Size = Vector3.new(4,6,4)
	esp.Adornee = hrp
	esp.AlwaysOnTop = true
	esp.ZIndex = 5
	esp.Color3 = color
	esp.Transparency = 0.5
end

function toggleESP()
	espEnabled = not espEnabled
	espFolder:ClearAllChildren()
	if espEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local color = Color3.fromRGB(255,0,0)
				if plr.Backpack:FindFirstChild("Shrink") then
					color = Color3.fromRGB(0,255,0)
				end
				createESP(plr, color)
			end
		end
	end
end

AddButton("ESP ON/OFF", toggleESP)

-- Hitbox
local hitboxEnabled = false
function setHitbox(plr)
	local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Size = Vector3.new(7,7,7)
		hrp.Transparency = 0.5
		hrp.BrickColor = BrickColor.new("Really red")
		hrp.Material = Enum.Material.ForceField
	end
end

function applyHitboxes()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			setHitbox(plr)
		end
	end
end

AddButton("Hitbox vĩnh viễn", function()
	hitboxEnabled = true
	applyHitboxes()
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if hitboxEnabled then wait(1) setHitbox(plr) end
	end)
end)

-- Chọn người + Teleport
local selectedPlayer = nil

local Label = Instance.new("TextLabel", ScrollFrame)
Label.Size = UDim2.new(1, -10, 0, 30)
Label.BackgroundTransparency = 1
Label.Text = "Chọn người để Teleport:"
Label.TextColor3 = Color3.new(0,0,0)
Label.Font = Enum.Font.GothamBold
Label.TextSize = 14

local selectBtn = Instance.new("TextButton", ScrollFrame)
selectBtn.Size = UDim2.new(1, -10, 0, 40)
selectBtn.BackgroundColor3 = Color3.fromRGB(230,240,255)
selectBtn.Text = "Chưa chọn"
selectBtn.TextColor3 = Color3.new(0,0,0)
selectBtn.Font = Enum.Font.Gotham
selectBtn.TextSize = 14

selectBtn.MouseButton1Click:Connect(function()
	local menu = Instance.new("Frame", MainFrame)
	menu.Position = UDim2.new(0, 320, 0, 40)
	menu.Size = UDim2.new(0, 150, 0, 200)
	menu.BackgroundColor3 = Color3.fromRGB(240,250,255)

	local layout = Instance.new("UIListLayout", menu)
	layout.Padding = UDim.new(0, 4)

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton", menu)
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
			btn.TextColor3 = Color3.new(0,0,0)
			btn.Text = plr.Name
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 13
			btn.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				selectBtn.Text = "Đã chọn: "..plr.Name
				menu:Destroy()
			end)
		end
	end
end)

AddButton("Teleport tới người chơi", function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(selectedPlayer.Character.HumanoidRootPart.Position + Vector3.new(2,0,2))
	end
end)

-- Reload khi chết
LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
	if not gui.Parent then gui.Parent = game.CoreGui end
end)
