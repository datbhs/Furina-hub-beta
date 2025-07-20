-- Furina Hub 3.7 FULL by shinroblox -- Features: Fly (PC/Mobile), ESP, Teleport, Godmode, Anti-Stun, Invisible, Hitbox (white-transparent), Tool Giver, Hide Name, Key System, Auto Reload

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local Mouse = LocalPlayer:GetMouse() local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService") local StarterGui = game:GetService("StarterGui")
-- Fling khi người khác chạm vào mình
local function FlingOnTouch()
	LocalPlayer.CharacterAdded:Connect(function(char)
		wait(1)
		local hrp = char:WaitForChild("HumanoidRootPart")
		for _,v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Touched:Connect(function(hit)
					local other = hit.Parent
					local h = other and other:FindFirstChild("Humanoid")
					if h and other ~= char then
						local hrp2 = other:FindFirstChild("HumanoidRootPart")
						if hrp2 then
							hrp2.Velocity = Vector3.new(500,500,500)
						end
					end
				end)
			end
		end
	end)
end

-- Gọi hàm này để bật Fling On Touch
FlingOnTouch()
-- Destroy previous GUI if exists if game.CoreGui:FindFirstChild("FurinaHubGUI") then game.CoreGui.FurinaHubGUI:Destroy() end

-- GUI local ScreenGui = Instance.new("ScreenGui", game.CoreGui) ScreenGui.Name = "FurinaHubGUI"

local ToggleBtn = Instance.new("TextButton", ScreenGui) ToggleBtn.Size = UDim2.new(0, 120, 0, 40) ToggleBtn.Position = UDim2.new(0, 10, 0, 10) ToggleBtn.Text = "Toggle Hub" ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 220, 255) ToggleBtn.TextSize = 16

local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0) MainFrame.Size = UDim2.new(0, 350, 0, 500) MainFrame.BackgroundColor3 = Color3.fromRGB(230, 240, 255) MainFrame.Visible = false MainFrame.Active = true MainFrame.Draggable = true

local Scrolling = Instance.new("ScrollingFrame", MainFrame) Scrolling.Size = UDim2.new(1, 0, 1, 0) Scrolling.CanvasSize = UDim2.new(0, 0, 3, 0) Scrolling.ScrollBarThickness = 8 Scrolling.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", Scrolling) UIListLayout.Padding = UDim.new(0, 5)

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local function createButton(text, callback) local btn = Instance.new("TextButton") btn.Size = UDim2.new(1, -10, 0, 40) btn.BackgroundColor3 = Color3.fromRGB(200, 220, 255) btn.Text = text btn.Font = Enum.Font.SourceSansBold btn.TextSize = 18 btn.Parent = Scrolling btn.MouseButton1Click:Connect(callback) return btn end

-- Fly System (Mobile/PC) local flying = false local function Fly() local char = LocalPlayer.Character local hrp = char:FindFirstChild("HumanoidRootPart") if not hrp then return end local bv = Instance.new("BodyVelocity", hrp) bv.Name = "FurinaFly" bv.MaxForce = Vector3.new(1,1,1)*1e5 bv.Velocity = Vector3.zero flying = true RunService.RenderStepped:Connect(function() if flying and hrp then local cam = workspace.CurrentCamera.CFrame local move = Vector3.zero if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end bv.Velocity = move * 70 end end) end

local function Unfly() flying = false local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp and hrp:FindFirstChild("FurinaFly") then hrp.FurinaFly:Destroy() end end

-- ESP local function ESP(on) for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then if on then if not p.Character:FindFirstChild("FurinaESP") then local bb = Instance.new("BillboardGui", p.Character) bb.Name = "FurinaESP" bb.Size = UDim2.new(0,100,0,40) bb.AlwaysOnTop = true local text = Instance.new("TextLabel", bb) text.Size = UDim2.new(1,0,1,0) text.Text = p.Name text.TextColor3 = Color3.new(1,0,0) text.BackgroundTransparency = 1 text.TextScaled = true end else local old = p.Character:FindFirstChild("FurinaESP") if old then old:Destroy() end end end end end

-- Teleport local selected = nil local function PlayerListDropdown() local drop = createButton("Select Player", function() local names = "" for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then names = names..p.Name.."\n" end end StarterGui:SetCore("SendNotification", {Title="Players", Text=names, Duration=5}) end)

Mouse.KeyDown:Connect(function(k)
    for _,p in ipairs(Players:GetPlayers()) do
        if k:lower() == p.Name:sub(1,1):lower() then
            selected = p
            drop.Text = "Selected: "..p.Name
        end
    end
end)

end

local function Teleport() if selected and selected.Character and selected.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:PivotTo(selected.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0)) end end

-- More features will continue in part 2 -- Use update_textdoc to append part 2, 3, 4...

-- ESP Toggle Function
local function ESP(toggle)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if toggle then
				if not player.Character:FindFirstChild("FurinaESP") then
					local esp = Instance.new("BillboardGui", player.Character)
					esp.Name = "FurinaESP"
					esp.Size = UDim2.new(0,100,0,40)
					esp.AlwaysOnTop = true
					local name = Instance.new("TextLabel", esp)
					name.Size = UDim2.new(1,0,1,0)
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

-- GODMODE Function
local function Godmode()
	local char = LocalPlayer.Character
	if char then
		local humanoid = char:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			humanoid.Name = "1"
			local clone = humanoid:Clone()
			clone.Name = "Humanoid"
			clone.Parent = char
			wait(1)
			humanoid:Destroy()
		end
	end
end

-- Anti Ragdoll / Stun
local function AntiStun()
	local char = LocalPlayer.Character
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BoolValue") and (v.Name:lower():find("stun") or v.Name:lower():find("ragdoll")) then
			v:Destroy()
		end
	end
end

-- Invisibility
local function Invisible()
	for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") then
			v.Transparency = 1
		end
	end
end

-- Hitbox (White Transparent, No Collision)
local function WidenHitbox()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			for _,part in ipairs(p.Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.Size = Vector3.new(7, 7, 7)
					part.Material = Enum.Material.ForceField
					part.Transparency = 0.6
					part.CanCollide = false
				end
			end
		end
	end
end

-- Tool Giver (Fling Tool)
local function GiveTool()
	local tool = Instance.new("Tool")
	tool.Name = "Fling Stick"
	tool.RequiresHandle = false
	tool.Activated:Connect(function()
		for _,p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.HumanoidRootPart.Velocity = Vector3.new(100,100,100)
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

-- Dropdown + Teleport
local selectedPlayer = nil
local function createDropdown()
	local drop = createButton("Select Player", function()
		local list = ""
		for _,p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				list = list .. p.Name .. "\n"
			end
		end
		StarterGui:SetCore("SendNotification", {Title="Players", Text=list, Duration=6})
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
		LocalPlayer.Character:PivotTo(selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(3,0,0))
	end
end

-- Add buttons to GUI
createButton("Fly", Fly)
createButton("Unfly", Unfly)
createButton("ESP ON", function() ESP(true) end)
createButton("ESP OFF", function() ESP(false) end)
createButton("Godmode", Godmode)
createButton("Anti-Stun", AntiStun)
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
	frame.Size = UDim2.new(0, 250, 0, 120)
	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame.Name = "KeyPrompt"

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Text = "Enter Access Key"
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 20
	title.TextColor3 = Color3.fromRGB(0, 0, 0)

	local textbox = Instance.new("TextBox", frame)
	textbox.Size = UDim2.new(1, -20, 0, 35)
	textbox.Position = UDim2.new(0, 10, 0, 35)
	textbox.PlaceholderText = "Enter Key..."
	textbox.Font = Enum.Font.SourceSans
	textbox.Text = ""

	local submit = Instance.new("TextButton", frame)
	submit.Size = UDim2.new(1, -20, 0, 30)
	submit.Position = UDim2.new(0, 10, 0, 80)
	submit.Text = "Submit"
	submit.BackgroundColor3 = Color3.fromRGB(180, 220, 255)

	submit.MouseButton1Click:Connect(function()
		if textbox.Text == "YTBHS01" then
			frame:Destroy()
			MainFrame.Visible = true
		else
			textbox.Text = "WRONG KEY!"
		end
	end)
end

-- Show key prompt on start
ShowKeyPrompt()

-- Auto-reload when character respawns
LocalPlayer.CharacterAdded:Connect(function()
	wait(2)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/datbhs/Furina-hub-beta/main/furina.lua"))()
end
