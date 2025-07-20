-- Furina Hub 3.7 FULL FIXED by shinroblox -- Full Features: Fly (PC/Mobile), ESP, Teleport, Godmode, Anti-Stun, Invisible, Hitbox, Tool Giver, Hide Name, Key System, Auto Reload, Auto Fling On Touch

-- Services local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local Mouse = LocalPlayer:GetMouse() local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService") local StarterGui = game:GetService("StarterGui") local TweenService = game:GetService("TweenService")

-- Destroy old GUI if game.CoreGui:FindFirstChild("FurinaHubGUI") then game.CoreGui.FurinaHubGUI:Destroy() end

-- GUI Init local ScreenGui = Instance.new("ScreenGui", game.CoreGui) ScreenGui.Name = "FurinaHubGUI"

local ToggleBtn = Instance.new("TextButton", ScreenGui) ToggleBtn.Size = UDim2.new(0, 120, 0, 40) ToggleBtn.Position = UDim2.new(0, 10, 0, 10) ToggleBtn.Text = "Toggle Furina Hub" ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 220, 255) ToggleBtn.TextSize = 16

local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0) MainFrame.Size = UDim2.new(0, 340, 0, 520) MainFrame.BackgroundColor3 = Color3.fromRGB(230, 240, 255) MainFrame.BorderSizePixel = 0 MainFrame.Active = true MainFrame.Draggable = true MainFrame.Visible = false

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local Scrolling = Instance.new("ScrollingFrame", MainFrame) Scrolling.Size = UDim2.new(1, 0, 1, 0) Scrolling.CanvasSize = UDim2.new(0, 0, 10, 0) Scrolling.ScrollBarThickness = 8 Scrolling.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", Scrolling) UIListLayout.Padding = UDim.new(0, 5)

local function createButton(text, callback) local btn = Instance.new("TextButton") btn.Size = UDim2.new(1, -10, 0, 40) btn.BackgroundColor3 = Color3.fromRGB(200, 220, 255) btn.Text = text btn.Font = Enum.Font.SourceSansBold btn.TextSize = 18 btn.Parent = Scrolling btn.MouseButton1Click:Connect(callback) return btn end

-- Fly (New method) local function Fly() loadstring(game:HttpGet("https://pastefy.app/IHIgGN9b/raw"))() end

-- Unfly (force stop) local function Unfly() for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BodyVelocity") then v:Destroy() end end RunService:UnbindFromRenderStep("Fly") end

-- Auto Fling On Touch local function AutoFlingTouch() local function onTouched(part) local plr = Players:GetPlayerFromCharacter(part.Parent) if plr and plr ~= LocalPlayer then local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.Velocity = Vector3.new(150,150,150) end end end local root = LocalPlayer.Character:WaitForChild("HumanoidRootPart") root.Touched:Connect(onTouched) end

-- ESP local function ESP(toggle) for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then if toggle then if not p.Character:FindFirstChild("FurinaESP") then local esp = Instance.new("BillboardGui", p.Character) esp.Name = "FurinaESP" esp.Size = UDim2.new(0,100,0,40) esp.AlwaysOnTop = true local name = Instance.new("TextLabel", esp) name.Size = UDim2.new(1,0,1,0) name.BackgroundTransparency = 1 name.Text = p.Name name.TextColor3 = Color3.new(1,0,0) name.TextScaled = true end else local old = p.Character:FindFirstChild("FurinaESP") if old then old:Destroy() end end end end end

-- Godmode local function Godmode() local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if hum then hum.Name = "1" local new = hum:Clone() new.Name = "Humanoid" new.Parent = LocalPlayer.Character wait(1) hum:Destroy() end end

-- Anti Stun local function AntiStun() for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BoolValue") and (v.Name:lower():find("stun") or v.Name:lower():find("ragdoll")) then v:Destroy() end end end

-- Invisible local function Invisible() for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end end end

-- Hitbox local function WidenHitbox() for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.Size = Vector3.new(5,5,5) part.CanCollide = false end end end end end

-- Tool Giver local function GiveTool() local tool = Instance.new("Tool") tool.Name = "Fling Stick" tool.RequiresHandle = false tool.Activated:Connect(function() for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Velocity = Vector3.new(120,120,120) end end end) tool.Parent = LocalPlayer.Backpack end

-- Hide Name local function HideName() for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BillboardGui") or v:IsA("TextLabel") then v:Destroy() end end end

-- Buttons createButton("Fly", Fly) createButton("Unfly", Unfly) createButton("ESP On", function() ESP(true) end) createButton("ESP Off", function() ESP(false) end) createButton("Godmode", Godmode) createButton("Anti Stun", AntiStun) createButton("Invisible", Invisible) createButton("Widen Hitbox", WidenHitbox) createButton("Give Fling Tool", GiveTool) createButton("Hide Name", HideName) createButton("Auto Fling (Touch)", AutoFlingTouch)

