-- Furina Hub 3.6 FINAL FIXED by shinroblox
-- Full Features: Fly (PC/Mobile), ESP, Teleport, Godmode, Anti-Stun, Invisible, Hitbox, Tool Giver, Hide Name, Key System, Auto Reload

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

-- Destroy existing GUI
if game.CoreGui:FindFirstChild("FurinaHubGUI") then
	game.CoreGui.FurinaHubGUI:Destroy()
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FurinaHubGUI"

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 120, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "Toggle Furina Hub"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
ToggleBtn.TextSize = 16

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 500)
MainFrame.BackgroundColor3 = Color3.fromRGB(230, 240, 255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

local Scrolling = Instance.new("ScrollingFrame", MainFrame)
Scrolling.Size = UDim2.new(1, 0, 1, 0)
Scrolling.CanvasSize = UDim2.new(0, 0, 5, 0)
Scrolling.ScrollBarThickness = 8
Scrolling.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", Scrolling)
UIListLayout.Padding = UDim.new(0, 5)

local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
	btn.Text = text
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Parent = Scrolling
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Fly
local flying = false
local function Fly()
	local char = LocalPlayer.Character
	local hrp = char:WaitForChild("HumanoidRootPart")
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1, 1, 1) * 100000
	bv.Velocity = Vector3.zero
	bv.Parent = hrp
	flying = true
	local speed = 60

	RunService:BindToRenderStep("Fly", Enum.RenderPriority.Input.Value, function()
		if not flying then
			bv:Destroy()
			return
		end
		local vel = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += workspace.CurrentCamera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= workspace.CurrentCamera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= workspace.CurrentCamera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += workspace.CurrentCamera.CFrame.RightVector end
		bv.Velocity = vel.Magnitude > 0 and vel.Unit * speed or Vector3.zero
	end)
end

local function Unfly()
	flying = false
	RunService:UnbindFromRenderStep("Fly")
end

-- ESP
local function ESP(toggle)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if toggle then
				if not player.Character:FindFirstChild("FurinaESP") then
					local esp = Instance.new("BillboardGui", player.Character)
					esp.Name = "FurinaESP"
					esp.Size = UDim2.new(0, 100, 0, 40)
					esp.AlwaysOnTop = true
					local name = Instance.new("TextLabel", esp)
					name.Size = UDim2.new(1, 0, 1, 0)
					name.BackgroundTransparency = 1
					name.Text = player.Name
					name.TextColor3 = player.Team and player.Team.Name:lower():find("hide") and Color3.new(0,1,0) or Color3.new(1,0,0)
					name.TextScaled = true
				end
			else
				local old = player.Character:FindFirstChild("FurinaESP")
				if old then old:Destroy() end
			end
		end
	end
end

-- Godmode
local function Godmode()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Name = "1"
		local new = hum:Clone()
		new.Name = "Humanoid"
		new.Parent = LocalPlayer.Character
		wait(1)
		hum:Destroy()
	end
end

-- Anti-Stun
local function AntiStun()
	local char = LocalPlayer.Character
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BoolValue") and (v.Name:lower():find("stun") or v.Name:lower():find("ragdoll")) then
			v:Destroy()
		end
	end
end

-- Invisible
local function Invisible()
	for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") then
			v.Transparency = 1
		end
	end
end

-- Noclip
local noclip = false
local function toggleNoclip()
	noclip = not noclip
	RunService.Stepped:Connect(function()
		if noclip and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid:ChangeState(11)
		end
	end)
end

-- Hitbox
local function WidenHitbox()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			for _,part in ipairs(p.Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.Size = Vector3.new(5, 5, 5)
					part.CanCollide = false
				end
			end
		end
	end
end

-- Tool Giver
local function GiveTool()
	local tool = Instance.new("Tool")
	tool.Name = "Fling Stick"
	tool.RequiresHandle = false
	tool.Activated:Connect(function()
		for _,p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.HumanoidRootPart.Velocity = Vector3.new(100, 100, 100)
			end
		end
	end)
	tool.Parent = LocalPlayer.Backpack
end

-- Hide Name
local function HideName()
	for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
		if v:IsA("BillboardGui") or v:IsA("TextLabel") then
			v:Destroy()
		end
	end
end

-- Dropdown + Teleport
local selectedPlayer = nil
local function createDropdown()
	local drop = createButton("Select Player", function()
		local list = ""
		for _,p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then list = list .. p.Name .. "\n" end
		end
		StarterGui:SetCore("SendNotification", {Title="Players", Text=list, Duration=5})
	end)
	
	Mouse.KeyDown:Connect(function(k)
		for _,p in ipairs(Players:GetPlayers()) do
			if k:lower() == p.Name:sub(1,1):lower() then
				selectedPlayer = p
				drop.Text = "Selected: " .. p.Name
			end
		end
	end)
end

local function Teleport()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:PivotTo(selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0))
	end
end

-- Buttons
createButton("Fly", Fly)
createButton("Unfly", Unfly)
createButton("ESP On", function() ESP(true) end)
createButton("ESP Off", function() ESP(false) end)
createButton("Godmode", Godmode)
createButton("Anti Stun", AntiStun)
createButton("Invisible", Invisible)
createButton("Noclip", toggleNoclip)
createButton("Widen Hitbox", WidenHitbox)
createButton("Give Fling Tool", GiveTool)
createButton("Hide Name", HideName)
createDropdown()
createButton("Teleport to Player", Teleport)

-- Key System
local function ShowKeyPrompt()
	local frame = Instance.new("Frame", ScreenGui)
	frame.Position = UDim2.new(0.35, 0, 0.4, 0)
	frame.Size = UDim2.new(0, 250, 0, 100)
	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame.Name = "KeyPrompt"
	
	local textbox = Instance.new("TextBox", frame)
	textbox.Size = UDim2.new(1, -20, 0, 40)
	textbox.Position = UDim2.new(0, 10, 0, 10)
	textbox.PlaceholderText = "Enter Key"
	textbox.Text = ""

	local submit = Instance.new("TextButton", frame)
	submit.Size = UDim2.new(1, -20, 0, 30)
	submit.Position = UDim2.new(0, 10, 0, 60)
	submit.Text = "Submit"

	submit.MouseButton1Click:Connect(function()
		if textbox.Text == "YTBHS01" then
			frame:Destroy()
			MainFrame.Visible = true
		else
			textbox.Text = "Wrong Key!"
		end
	end)
end
ShowKeyPrompt()

-- Auto reload
LocalPlayer.CharacterAdded:Connect(function()
	wait(2)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/datbhs/Furina-hub-beta/main/Furina.lua"))()
end)
