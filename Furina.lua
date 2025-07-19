-- Furina Hub BETA v3.6 FINAL by shinroblox -- Full Features: Fly (Mobile + PC), ESP, Teleport, Godmode, Anti-Stun, Invisible, Hitbox, Tool Giver, Hide Name, Key System, Auto Reload GUI, Team ESP

--// SERVICES local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local Mouse = LocalPlayer:GetMouse() local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService") local StarterGui = game:GetService("StarterGui") local TweenService = game:GetService("TweenService")

--// GUI INIT local function createMainGui() if game.CoreGui:FindFirstChild("FurinaHubGUI") then game.CoreGui.FurinaHubGUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FurinaHubGUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 500)
MainFrame.BackgroundColor3 = Color3.fromRGB(230, 240, 255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", MainFrame)
UIListLayout.Padding = UDim.new(0, 5)

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

return ScreenGui, MainFrame, createButton

end

--// FLY SYSTEM local flying = false local function Fly() local char = LocalPlayer.Character local hrp = char:WaitForChild("HumanoidRootPart") local bv = Instance.new("BodyVelocity") bv.MaxForce = Vector3.new(1, 1, 1) * 100000 bv.Velocity = Vector3.zero bv.Parent = hrp

flying = true
local speed = 60
RunService:BindToRenderStep("Fly", Enum.RenderPriority.Input.Value, function()
    if not flying then bv:Destroy() return end
    local vel = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then vel += workspace.CurrentCamera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then vel -= workspace.CurrentCamera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then vel -= workspace.CurrentCamera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then vel += workspace.CurrentCamera.CFrame.RightVector end
    bv.Velocity = vel.Magnitude > 0 and vel.Unit * speed or Vector3.zero
end)

end local function Unfly() flying = false RunService:UnbindFromRenderStep("Fly") end

--// ESP local function ESP(toggle) for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character then if toggle then if not player.Character:FindFirstChild("FurinaESP") then local espBox = Instance.new("BillboardGui", player.Character) espBox.Name = "FurinaESP" espBox.Size = UDim2.new(0, 100, 0, 40) espBox.AlwaysOnTop = true

local name = Instance.new("TextLabel", espBox)
                name.Size = UDim2.new(1, 0, 1, 0)
                name.Text = player.Name
                name.BackgroundTransparency = 1
                name.TextScaled = true
                name.TextColor3 = Color3.new(1, 0, 0) -- Red

                if player.Team and player.Team.Name:lower():find("hide") then
                    name.TextColor3 = Color3.new(0, 1, 0) -- Green for hiding
                end
            end
        else
            local old = player.Character:FindFirstChild("FurinaESP")
            if old then old:Destroy() end
        end
    end
end

end

--// TELEPORT local selectedPlayer = nil local function createDropdown(parent) local dropdown = Instance.new("TextButton") dropdown.Size = UDim2.new(1, -10, 0, 40) dropdown.BackgroundColor3 = Color3.fromRGB(240, 240, 240) dropdown.Text = "Select Player" dropdown.Font = Enum.Font.SourceSans dropdown.TextSize = 16 dropdown.Parent = parent

dropdown.MouseButton1Click:Connect(function()
    local list = ""
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            list = list .. player.Name .. "\n"
        end
    end
    StarterGui:SetCore("SendNotification", {Title="Players", Text=list, Duration=5})
end)

Mouse.KeyDown:Connect(function(k)
    for _, player in ipairs(Players:GetPlayers()) do
        if k:lower() == player.Name:sub(1,1):lower() then
            selectedPlayer = player
            dropdown.Text = "Selected: " .. player.Name
        end
    end
end)

end

local function Teleport() if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:PivotTo(selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)) end end

--// GODMODE local function Godmode() local char = LocalPlayer.Character if char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").Name = "1" local new = char:FindFirstChild("1"):Clone() new.Name = "Humanoid" new.Parent = char wait(1) char:FindFirstChild("1"):Destroy() end end

--// INVISIBLE local function Invisible() local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if root then root.Transparency = 1 for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end end end end

--// NOCLIP local noclip = false local function toggleNoclip() noclip = not noclip RunService.Stepped:Connect(function() if noclip and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(11) end end) end

--// HITBOX local function WidenHitbox() for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character then for _, part in ipairs(player.Character:GetChildren()) do if part:IsA("BasePart") then part.Size = Vector3.new(5, 5, 5) part.CanCollide = false end end end end end -- Auto apply hitbox to new players Players.PlayerAdded:Connect(function(plr) plr.CharacterAdded:Connect(function(char) wait(1) for _, part in ipairs(char:GetChildren()) do if part:IsA("BasePart") then part.Size = Vector3.new(5, 5, 5) part.CanCollide = false end end end) end)

--// TOOL GIVE local function GiveTool() local tool = Instance.new("Tool") tool.RequiresHandle = false tool.Name = "Fling Stick" tool.Activated:Connect(function() local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then local otherRoot = player.Character.HumanoidRootPart otherRoot.Velocity = Vector3.new(100,100,100) end end end) tool.Parent = LocalPlayer.Backpack end

--// HIDE NAME local function HideName() for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BillboardGui") or v:IsA("TextLabel") then v:Destroy() end end end

--// GUI & BUTTONS local GUI, MainFrame, createButton = createMainGui() createButton("Fly", Fly) createButton("Unfly", Unfly) createButton("ESP On", function() ESP(true) end) createButton("ESP Off", function() ESP(false) end) createButton("Godmode", Godmode) createButton("Invisible", Invisible) createButton("Noclip", toggleNoclip) createButton("Widen Hitbox", WidenHitbox) createButton("Give Fling Tool", GiveTool) createButton("Hide Name", HideName) createDropdown(MainFrame) createButton("Teleport to Player", Teleport)

--// RELOAD ON DEATH LocalPlayer.CharacterAdded:Connect(function() wait(2) loadstring(game:HttpGet("https://raw.githubusercontent.com/datbhs/Furina-hub-beta/main/furina.lua"))() end)

--// KEY SYSTEM local function ShowKeyPrompt() local frame = Instance.new("Frame", GUI) frame.Position = UDim2.new(0.35, 0, 0.4, 0) frame.Size = UDim2.new(0, 250, 0, 100) frame.BackgroundColor3 = Color3.fromRGB(255,255,255) frame.Name = "KeyPrompt"

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

MainFrame.Visible = false

end ShowKeyPrompt()

