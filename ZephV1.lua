--========================================================
-- ZEPH X | COMPLETE CLIENT HUB
-- One LocalScript | Mobile + PC | Purple / Black UI
-- Place in StarterPlayer > StarterPlayerScripts
-- Built for your own Roblox experience.
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("ZephXHub")
if oldGui then oldGui:Destroy() end

local C = {
    bg = Color3.fromRGB(15, 13, 22),
    panel = Color3.fromRGB(27, 23, 39),
    panel2 = Color3.fromRGB(40, 31, 57),
    purple = Color3.fromRGB(174, 87, 255),
    light = Color3.fromRGB(216, 179, 255),
    white = Color3.fromRGB(247, 242, 255),
    muted = Color3.fromRGB(166, 153, 186),
    green = Color3.fromRGB(117, 255, 180),
    red = Color3.fromRGB(255, 110, 140),
}
local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local function tw(obj, props, duration)
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end
local function corner(obj, radius)
    local x = Instance.new("UICorner") x.CornerRadius = UDim.new(0, radius or 10) x.Parent = obj return x
end
local function outline(obj, color, thickness, transparency)
    local x = Instance.new("UIStroke") x.Color = color or C.purple x.Thickness = thickness or 1.3 x.Transparency = transparency or 0.12 x.Parent = obj return x
end
local function label(parent, text, size, pos, font, color, textSize)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1 x.Text = text x.Size = size x.Position = pos
    x.Font = font or Enum.Font.GothamMedium x.TextColor3 = color or C.white
    x.TextSize = textSize or 12 x.TextWrapped = true x.Parent = parent
    return x
end
local function button(parent, text, size, pos, fontSize)
    local x = Instance.new("TextButton")
    x.Text = text x.Size = size x.Position = pos x.BackgroundColor3 = C.panel2
    x.TextColor3 = C.white x.Font = Enum.Font.GothamBold x.TextSize = fontSize or 12
    x.AutoButtonColor = false x.Parent = parent corner(x, 8) outline(x, C.purple, 1, 0.3)
    x.Activated:Connect(function() tw(x, {BackgroundColor3 = Color3.fromRGB(76, 48, 104)}, 0.1) task.delay(0.12, function() if x.Parent then tw(x, {BackgroundColor3 = C.panel2}, 0.18) end end) end)
    return x
end
local function makeDraggable(panel, handle)
    local active, startInput, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            active = true startInput = input.Position startPos = panel.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then active = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - startInput
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "ZephXHub" gui.ResetOnSpawn = false gui.IgnoreGuiInset = false gui.DisplayOrder = 100 gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling gui.Parent = playerGui

local state = {
    speed = 16, jump = 50, sprint = false, noclip = false, fullbright = false,
    bloom = false, blur = false, esp = false, fov = 70, firstPerson = false,
    accent = 1, glow = 1.3, animSpeed = 1, notifications = true,
    stopwatchRunning = false, stopwatchStart = 0, stopwatchElapsed = 0,
    expanded = false, minimized = false, compact = false,
}
local accents = {
    Color3.fromRGB(174,87,255), Color3.fromRGB(55,160,255), Color3.fromRGB(255,78,160),
    Color3.fromRGB(70,235,180), Color3.fromRGB(255,160,60), Color3.fromRGB(255,90,90)
}
local function accent() return accents[state.accent] or C.purple end
local function notify(msg)
    if not state.notifications or not gui.Parent then return end
    local n = Instance.new("TextLabel")
    n.BackgroundColor3 = C.panel n.TextColor3 = C.white n.Font = Enum.Font.GothamMedium n.TextSize = 11
    n.Text = msg n.Size = UDim2.fromOffset(220, 34) n.Position = UDim2.new(0.5, -110, 0, 18)
    n.BackgroundTransparency = 0.08 n.Parent = gui corner(n, 9) outline(n, accent(), 1.4, 0.1)
    n.TextWrapped = true
    tw(n, {Position = UDim2.new(0.5, -110, 0, 28)}, 0.2)
    task.delay(1.8, function() if n.Parent then tw(n, {TextTransparency=1, BackgroundTransparency=1}, 0.2) task.delay(0.22, function() if n.Parent then n:Destroy() end end) end end)
end

-- Loading card
local loading = Instance.new("Frame")
loading.AnchorPoint = Vector2.new(0.5,0.5) loading.Position = UDim2.fromScale(0.5,0.5) loading.Size = UDim2.fromOffset(245,102)
loading.BackgroundColor3 = C.bg loading.Parent = gui corner(loading,14) outline(loading, accent(), 2, 0)
local loadTitle = label(loading,"Z E P H   X",UDim2.new(1,0,0,35),UDim2.fromOffset(0,10),Enum.Font.GothamBlack,C.light,19)
local loadSub = label(loading,"STARTING CLIENT HUB...",UDim2.new(1,0,0,18),UDim2.fromOffset(0,46),Enum.Font.GothamMedium,C.muted,9)
local loadTrack = Instance.new("Frame") loadTrack.Position=UDim2.fromOffset(18,77) loadTrack.Size=UDim2.new(1,-36,0,5) loadTrack.BackgroundColor3=C.panel2 loadTrack.Parent=loading corner(loadTrack,4)
local loadFill = Instance.new("Frame") loadFill.Size=UDim2.fromScale(0,1) loadFill.BackgroundColor3=accent() loadFill.Parent=loadTrack corner(loadFill,4)
tw(loadFill,{Size=UDim2.fromScale(1,1)},0.75)

-- Main window
local hub = Instance.new("Frame")
hub.Name="MainHub" hub.AnchorPoint=Vector2.new(0.5,0.5) hub.Position=UDim2.fromScale(0.5,0.52)
hub.Size=UDim2.fromOffset(340,390) hub.BackgroundColor3=C.bg hub.Visible=false hub.Parent=gui corner(hub,16)
local hubStroke=outline(hub,accent(),2,0.04)
local header=Instance.new("Frame") header.Size=UDim2.new(1,0,0,44) header.BackgroundColor3=C.panel header.Parent=hub corner(header,14)
local headerCover=Instance.new("Frame") headerCover.Position=UDim2.new(0,0,1,-12) headerCover.Size=UDim2.new(1,0,0,12) headerCover.BackgroundColor3=C.panel headerCover.BorderSizePixel=0 headerCover.Parent=header
local title=label(header,"ZEPH X",UDim2.new(0,135,1,0),UDim2.fromOffset(12,0),Enum.Font.GothamBlack,C.light,18) title.TextXAlignment=Enum.TextXAlignment.Left
local plus=button(header,"+",UDim2.fromOffset(30,29),UDim2.new(1,-105,0,7),21)
local minimize=button(header,"—",UDim2.fromOffset(30,29),UDim2.new(1,-70,0,7),15)
local close=button(header,"×",UDim2.fromOffset(30,29),UDim2.new(1,-35,0,7),18)
makeDraggable(hub,header)
local subtitle=label(hub,"FUTURISTIC CLIENT CONTROL PANEL",UDim2.new(1,-20,0,18),UDim2.fromOffset(10,48),Enum.Font.GothamMedium,C.muted,9)
subtitle.TextXAlignment=Enum.TextXAlignment.Left

local tabBar=Instance.new("ScrollingFrame") tabBar.Name="Tabs" tabBar.Position=UDim2.fromOffset(9,70) tabBar.Size=UDim2.new(1,-18,0,35)
tabBar.BackgroundTransparency=1 tabBar.BorderSizePixel=0 tabBar.ScrollBarThickness=2 tabBar.ScrollingDirection=Enum.ScrollingDirection.X tabBar.CanvasSize=UDim2.fromOffset(0,0) tabBar.Parent=hub
local tabLayout=Instance.new("UIListLayout") tabLayout.FillDirection=Enum.FillDirection.Horizontal tabLayout.Padding=UDim.new(0,5) tabLayout.SortOrder=Enum.SortOrder.LayoutOrder tabLayout.Parent=tabBar
local content=Instance.new("ScrollingFrame") content.Name="Content" content.Position=UDim2.fromOffset(10,111) content.Size=UDim2.new(1,-20,1,-121)
content.BackgroundColor3=Color3.fromRGB(21,18,30) content.BorderSizePixel=0 content.ScrollBarThickness=3 content.ScrollBarImageColor3=accent() content.CanvasSize=UDim2.fromOffset(0,0) content.Parent=hub corner(content,10)
local contentPadding=Instance.new("UIPadding") contentPadding.PaddingTop=UDim.new(0,8) contentPadding.PaddingLeft=UDim.new(0,8) contentPadding.PaddingRight=UDim.new(0,8) contentPadding.PaddingBottom=UDim.new(0,8) contentPadding.Parent=content
local contentLayout=Instance.new("UIListLayout") contentLayout.Padding=UDim.new(0,7) contentLayout.SortOrder=Enum.SortOrder.LayoutOrder contentLayout.Parent=content
contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() content.CanvasSize=UDim2.fromOffset(0,contentLayout.AbsoluteContentSize.Y+18) end)
local tabs = {}
local activeTab = nil
local function clearContent() for _,v in ipairs(content:GetChildren()) do if v:IsA("GuiObject") and v~=contentPadding and v~=contentLayout then v:Destroy() end end end
local function addSection(text)
    local s=label(content,text,UDim2.new(1,-6,0,22),UDim2.new(),Enum.Font.GothamBlack,accent(),11) s.TextXAlignment=Enum.TextXAlignment.Left s.LayoutOrder=#content:GetChildren() return s
end
local function addRow(titleText, description)
    local row=Instance.new("Frame") row.Size=UDim2.new(1,-5,0,48) row.BackgroundColor3=C.panel row.Parent=content corner(row,9)
    local t=label(row,titleText,UDim2.new(0.59,0,0,20),UDim2.fromOffset(9,4),Enum.Font.GothamBold,C.white,11) t.TextXAlignment=Enum.TextXAlignment.Left
    local d=label(row,description or "",UDim2.new(0.59,0,0,16),UDim2.fromOffset(9,25),Enum.Font.GothamMedium,C.muted,9) d.TextXAlignment=Enum.TextXAlignment.Left
    return row
end
local function addToggle(titleText, description, initial, callback)
    local row=addRow(titleText,description)
    local b=button(row,initial and "ON" or "OFF",UDim2.fromOffset(58,28),UDim2.new(1,-68,0.5,-14),10)
    local on=initial
    local function draw() b.Text=on and "ON" or "OFF" b.BackgroundColor3=on and Color3.fromRGB(58,38,81) or C.panel2 end
    b.Activated:Connect(function() on=not on draw() callback(on) end)
    draw()
    return b
end
local function addAction(titleText, description, actionText, callback)
    local row=addRow(titleText,description)
    local b=button(row,actionText,UDim2.fromOffset(74,28),UDim2.new(1,-84,0.5,-14),10)
    b.Activated:Connect(callback)
    return b
end
local function addStepper(titleText, description, initial, minimum, maximum, step, callback)
    local row=addRow(titleText,description)
    local val=initial
    local valueLabel=label(row,tostring(val),UDim2.fromOffset(36,25),UDim2.new(1,-116,0.5,-12),Enum.Font.GothamBold,C.light,11)
    local minus=button(row,"−",UDim2.fromOffset(27,27),UDim2.new(1,-80,0.5,-13),15)
    local plusB=button(row,"+",UDim2.fromOffset(27,27),UDim2.new(1,-43,0.5,-13),15)
    local function set(v) val=math.clamp(v,minimum,maximum) valueLabel.Text=tostring(val) callback(val) end
    minus.Activated:Connect(function() set(val-step) end) plusB.Activated:Connect(function() set(val+step) end)
    return {set=set, get=function() return val end}
end
local function addSlider(titleText, description, initial, minimum, maximum, step, callback)
    local row=addRow(titleText,description) row.Size=UDim2.new(1,-5,0,66)
    local valueLabel=label(row,tostring(initial),UDim2.fromOffset(40,20),UDim2.new(1,-49,0,4),Enum.Font.GothamBold,C.light,11)
    local track=Instance.new("Frame") track.Position=UDim2.fromOffset(10,43) track.Size=UDim2.new(1,-20,0,6) track.BackgroundColor3=C.panel2 track.Parent=row corner(track,4)
    local fill=Instance.new("Frame") fill.Size=UDim2.new((initial-minimum)/(maximum-minimum),0,1,0) fill.BackgroundColor3=accent() fill.Parent=track corner(fill,4)
    local knob=Instance.new("TextButton") knob.Text="" knob.Size=UDim2.fromOffset(14,14) knob.AnchorPoint=Vector2.new(0.5,0.5) knob.Position=UDim2.new((initial-minimum)/(maximum-minimum),0,0.5,0) knob.BackgroundColor3=C.light knob.Parent=track knob.AutoButtonColor=false corner(knob,7)
    local val=initial
    local function set(v)
        val=math.clamp(math.floor(v/step+0.5)*step,minimum,maximum)
        local alpha=(val-minimum)/(maximum-minimum)
        valueLabel.Text=tostring(val) fill.Size=UDim2.new(alpha,0,1,0) knob.Position=UDim2.new(alpha,0,0.5,0) callback(val)
    end
    local sliding=false
    local function inputAt(pos)
        local alpha=math.clamp((pos.X-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
        set(minimum+alpha*(maximum-minimum))
    end
    knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true inputAt(i.Position) end end)
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true inputAt(i.Position) end end)
    UserInputService.InputChanged:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then inputAt(i.Position) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end end)
    return {set=set,get=function() return val end}
end

-- Character helpers
local function getCharacter() return player.Character end
local function getHumanoid()
    local ch=getCharacter()
    return ch and ch:FindFirstChildOfClass("Humanoid")
end
local function applyMovement()
    local h=getHumanoid()
    if h then h.WalkSpeed=state.sprint and math.max(state.speed,24) or state.speed h.UseJumpPower=true h.JumpPower=state.jump end
end
player.CharacterAdded:Connect(function()
    task.wait(0.6) applyMovement()
    if state.noclip then notify("Noclip enabled locally") end
end)

-- Local visual effects
local bloomEffect=Lighting:FindFirstChild("ZephX_Bloom") or Instance.new("BloomEffect") bloomEffect.Name="ZephX_Bloom" bloomEffect.Intensity=0.65 bloomEffect.Size=24 bloomEffect.Threshold=1.1
local blurEffect=Lighting:FindFirstChild("ZephX_Blur") or Instance.new("BlurEffect") blurEffect.Name="ZephX_Blur" blurEffect.Size=8
local espFolder=Instance.new("Folder") espFolder.Name="ZephX_LocalHighlights" espFolder.Parent=gui
local highlights={}
local function clearESP() for _,h in pairs(highlights) do if h and h.Parent then h:Destroy() end end highlights={} end
local function refreshESP()
    clearESP()
    if not state.esp then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player and p.Character then
            local h=Instance.new("Highlight") h.Name="ZephXHighlight" h.Adornee=p.Character h.FillColor=accent() h.OutlineColor=C.light h.FillTransparency=0.72 h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop h.Parent=espFolder
            highlights[p]=h
        end
    end
end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(0.5) refreshESP() end) end)
Players.PlayerRemoving:Connect(function() refreshESP() end)

local function resetCamera()
    local h=getHumanoid()
    if h then Workspace.CurrentCamera.CameraSubject=h end
    if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView=state.fov end
    player.CameraMode=Enum.CameraMode.Classic
    state.firstPerson=false
end

local function buildTab(tabName)
    clearContent()
    activeTab=tabName
    for name,b in pairs(tabs) do b.BackgroundColor3=(name==tabName) and Color3.fromRGB(66,42,92) or C.panel2 end
    if tabName=="PLAYER" then
        addSection("MOVEMENT CONTROLS")
        addSlider("Walk speed","Normal movement speed",state.speed,8,80,1,function(v) state.speed=v applyMovement() end)
        addSlider("Jump power","Jump height control",state.jump,0,150,5,function(v) state.jump=v applyMovement() end)
        addToggle("Sprint boost","Temporarily uses at least 24 speed",state.sprint,function(v) state.sprint=v applyMovement() notify(v and "Sprint enabled" or "Sprint disabled") end)
        addAction("Heal character","Restore health to maximum","HEAL",function() local h=getHumanoid() if h then h.Health=h.MaxHealth notify("Health restored") else notify("Character not ready") end end)
        addAction("Sit / stand","Toggle your character posture","TOGGLE",function() local h=getHumanoid() if h then h.Sit=not h.Sit end end)
        addAction("Reset movement","Restore default speed and jump","RESET",function() state.speed=16 state.jump=50 state.sprint=false applyMovement() buildTab("PLAYER") notify("Movement reset") end)
        addToggle("Noclip (own game)","Local character collision toggle",state.noclip,function(v) state.noclip=v notify(v and "Local noclip enabled" or "Local noclip disabled") end)
    elseif tabName=="VISUALS" then
        addSection("LOCAL LIGHTING")
        addToggle("Fullbright","Brightens your local view",state.fullbright,function(v) state.fullbright=v if v then Lighting.Brightness=3 Lighting.ClockTime=14 Lighting.GlobalShadows=false else Lighting.Brightness=1 Lighting.ClockTime=14 Lighting.GlobalShadows=true end end)
        addSlider("Brightness","Local lighting brightness",math.floor(Lighting.Brightness*10)/10,0,5,0.5,function(v) if not state.fullbright then Lighting.Brightness=v end end)
        addSlider("Clock time","Change local sky time",math.floor(Lighting.ClockTime),0,24,1,function(v) Lighting.ClockTime=v end)
        addToggle("Bloom glow","Soft light glow effect",state.bloom,function(v) state.bloom=v bloomEffect.Enabled=v if v then bloomEffect.Parent=Lighting end end)
        addToggle("Blur effect","Small cinematic blur",state.blur,function(v) state.blur=v blurEffect.Enabled=v if v then blurEffect.Parent=Lighting end end)
        addToggle("Player highlight ESP","Highlight characters in your own game",state.esp,function(v) state.esp=v refreshESP() end)
        addAction("Reset local visuals","Restore common lighting values","RESET",function() state.fullbright=false state.bloom=false state.blur=false state.esp=false Lighting.Brightness=1 Lighting.ClockTime=14 Lighting.GlobalShadows=true bloomEffect.Enabled=false blurEffect.Enabled=false clearESP() buildTab("VISUALS") end)
    elseif tabName=="CAMERA" then
        addSection("CAMERA CONTROLS")
        addSlider("Field of view","Camera angle",state.fov,50,100,1,function(v) state.fov=v if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView=v end end)
        addSlider("Max zoom distance","Third-person zoom limit",player.CameraMaxZoomDistance,10,100,5,function(v) player.CameraMaxZoomDistance=v end)
        addToggle("First-person mode","Lock camera to first person",state.firstPerson,function(v) state.firstPerson=v if v then player.CameraMode=Enum.CameraMode.LockFirstPerson else player.CameraMode=Enum.CameraMode.Classic end end)
        addAction("Third-person","Return to classic camera","SET",function() state.firstPerson=false player.CameraMode=Enum.CameraMode.Classic player.CameraMinZoomDistance=0.5 player.CameraMaxZoomDistance=12 end)
        addAction("Reset camera","Restore camera FOV and mode","RESET",function() state.fov=70 if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView=70 end player.CameraMode=Enum.CameraMode.Classic player.CameraMinZoomDistance=0.5 player.CameraMaxZoomDistance=12 state.firstPerson=false buildTab("CAMERA") end)
    elseif tabName=="GRAPHICS" then
        addSection("HUB APPEARANCE")
        addToggle("Compact mode","Make the hub smaller",state.compact,function(v) state.compact=v tw(hub,{Size=v and UDim2.fromOffset(300,350) or UDim2.fromOffset(340,390)},0.25) end)
        addSlider("Panel transparency","Adjust hub background",0,0,70,5,function(v) hub.BackgroundTransparency=v/100 end)
        addStepper("Accent color","Cycle through neon colors",state.accent,1,#accents,1,function(v) state.accent=v hubStroke.Color=accent() content.ScrollBarImageColor3=accent() for _,tb in pairs(tabs) do outline(tb,accent(),1,0.2) end loadFill.BackgroundColor3=accent() notify("Accent changed") end)
        addSlider("Glow intensity","Adjust outline thickness",1,1,4,0.5,function(v) state.glow=v hubStroke.Thickness=v end)
        addSlider("Animation speed","UI animation duration scale",1,0.5,2,0.1,function(v) state.animSpeed=v end)
        addAction("Restore hub size","Return to standard panel size","RESET",function() state.compact=false hub.BackgroundTransparency=0 hub.Size=UDim2.fromOffset(340,390) state.glow=1.3 hubStroke.Thickness=1.3 buildTab("GRAPHICS") end)
    elseif tabName=="SETTINGS" then
        addSection("INTERFACE SETTINGS")
        addToggle("Notifications","Show small status messages",state.notifications,function(v) state.notifications=v end)
        addAction("Minimize hub","Hide the panel to a small Z button","MINIMIZE",function() state.minimized=true tw(hub,{Size=UDim2.fromOffset(0,0)},0.22) task.delay(0.24,function() if hub.Parent then hub.Visible=false miniRestore.Visible=true end end) end)
        addAction("Show loading screen","Replay the startup animation","SHOW",function() loading.Visible=true loading.BackgroundTransparency=0 loadFill.Size=UDim2.new(0,0,1,0) tw(loadFill,{Size=UDim2.fromScale(1,1)},0.75) task.delay(1,function() if loading.Parent then loading.Visible=false end end) end)
        addAction("Reset UI size","Restore standard panel dimensions","RESET",function() hub.Size=UDim2.fromOffset(340,390) hub.BackgroundTransparency=0 state.compact=false buildTab("SETTINGS") end)
        addAction("Close ZEPH X","Remove this interface","CLOSE",function() gui:Destroy() end)
    elseif tabName=="TOOLS" then
        addSection("LIVE INFORMATION")
        local healthRow=addRow("Health","Current / maximum health")
        local healthValue=label(healthRow,"--",UDim2.fromOffset(95,25),UDim2.new(1,-105,0.5,-12),Enum.Font.GothamBold,C.light,11)
        local posRow=addRow("Position","Your character coordinates")
        local posValue=label(posRow,"--",UDim2.new(0.55,0,0,30),UDim2.new(0.43,0,0.5,-15),Enum.Font.GothamMedium,C.light,9)
        local gravRow=addRow("Workspace gravity","Local property display / adjustment")
        local gravValue=label(gravRow,tostring(math.floor(Workspace.Gravity)),UDim2.fromOffset(40,24),UDim2.new(1,-116,0.5,-12),Enum.Font.GothamBold,C.light,11)
        local gravMinus=button(gravRow,"−",UDim2.fromOffset(27,27),UDim2.new(1,-80,0.5,-13),15)
        local gravPlus=button(gravRow,"+",UDim2.fromOffset(27,27),UDim2.new(1,-43,0.5,-13),15)
        gravMinus.Activated:Connect(function() Workspace.Gravity=math.max(0,Workspace.Gravity-10) gravValue.Text=tostring(math.floor(Workspace.Gravity)) end)
        gravPlus.Activated:Connect(function() Workspace.Gravity=math.min(500,Workspace.Gravity+10) gravValue.Text=tostring(math.floor(Workspace.Gravity)) end)
        addAction("Copy position to notification","Read current character coordinates","SHOW",function() local ch=getCharacter() local root=ch and ch:FindFirstChild("HumanoidRootPart") if root then notify(string.format("X %.1f | Y %.1f | Z %.1f",root.Position.X,root.Position.Y,root.Position.Z)) end end)
        addAction("Reset character","Respawn your own character","RESET",function() local h=getHumanoid() if h then h.Health=0 end end)
        task.spawn(function()
            while content.Parent and activeTab=="TOOLS" and gui.Parent do
                local h=getHumanoid() local ch=getCharacter() local root=ch and ch:FindFirstChild("HumanoidRootPart")
                if healthValue.Parent and h then healthValue.Text=math.floor(h.Health).." / "..math.floor(h.MaxHealth) end
                if posValue.Parent and root then posValue.Text=string.format("%.0f, %.0f, %.0f",root.Position.X,root.Position.Y,root.Position.Z) end
                task.wait(0.4)
            end
        end)
    end
end

local tabNames={"PLAYER","VISUALS","CAMERA","GRAPHICS","SETTINGS","TOOLS"}
for i,name in ipairs(tabNames) do
    local b=button(tabBar,name,UDim2.fromOffset(78,30),UDim2.new(),10)
    b.LayoutOrder=i tabs[name]=b
    b.Activated:Connect(function() buildTab(name) end)
end
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tabBar.CanvasSize=UDim2.fromOffset(tabLayout.AbsoluteContentSize.X+8,0) end)

-- Floating widgets
local widgetLayer=Instance.new("Frame") widgetLayer.Name="FloatingWidgets" widgetLayer.BackgroundTransparency=1 widgetLayer.Size=UDim2.fromScale(1,1) widgetLayer.Parent=gui
local widgets={}
local function makeWidget(name,titleText,x,y,h)
    local f=Instance.new("Frame") f.Name=name f.Position=UDim2.fromOffset(x,y) f.Size=UDim2.fromOffset(154,h or 94) f.BackgroundColor3=C.bg f.Visible=false f.Parent=widgetLayer corner(f,12) outline(f,accent(),1.5,0.06)
    local top=Instance.new("Frame") top.Size=UDim2.new(1,0,0,27) top.BackgroundColor3=C.panel top.Parent=f corner(top,11)
    local cover=Instance.new("Frame") cover.Position=UDim2.new(0,0,1,-8) cover.Size=UDim2.new(1,0,0,8) cover.BackgroundColor3=C.panel cover.BorderSizePixel=0 cover.Parent=top
    local t=label(top,titleText,UDim2.new(1,-12,1,0),UDim2.fromOffset(8,0),Enum.Font.GothamBlack,C.light,10) t.TextXAlignment=Enum.TextXAlignment.Left
    local val=label(f,"--",UDim2.new(1,-10,0,28),UDim2.fromOffset(5,32),Enum.Font.GothamBlack,C.white,19)
    local sub=label(f,"LIVE",UDim2.new(1,-10,0,15),UDim2.fromOffset(5,60),Enum.Font.GothamMedium,C.muted,8)
    makeDraggable(f,top)
    widgets[name]={frame=f,value=val,detail=sub,top=top}
    return widgets[name]
end
local pingW=makeWidget("PingWidget","PING",12,75,88)
local fpsW=makeWidget("FPSWidget","FPS",176,75,88)
local playersW=makeWidget("PlayersWidget","PLAYERS",12,174,88)
local timerW=makeWidget("TimerWidget","TIMESTOP",176,174,111)
local timerToggle=button(timerW.frame,"START",UDim2.new(0,62,0,23),UDim2.fromOffset(7,82),9)
local timerReset=button(timerW.frame,"RESET",UDim2.new(0,62,0,23),UDim2.fromOffset(84,82),9)
local miniRestore=button(gui,"Z",UDim2.fromOffset(42,42),UDim2.new(1,-55,0,105),18)
miniRestore.Visible=false miniRestore.BackgroundColor3=C.bg outline(miniRestore,accent(),2,0)
local function setExpanded(on)
    if state.expanded==on then return end state.expanded=on
    if on then
        hub.Visible=false miniRestore.Visible=true
        local targets={UDim2.new(0,12,0,75),UDim2.new(0,176,0,75),UDim2.new(0,12,0,174),UDim2.new(0,176,0,174)}
        local i=0
        for _,w in ipairs({pingW,fpsW,playersW,timerW}) do i+=1 w.frame.Visible=true w.frame.Size=UDim2.fromOffset(26,26) w.frame.Position=UDim2.new(0.5,-13,0.5,-13) tw(w.frame,{Size=UDim2.fromOffset(154,w==timerW and 111 or 88),Position=targets[i]},0.4) end
    else
        miniRestore.Visible=false
        for _,w in pairs(widgets) do tw(w.frame,{Size=UDim2.fromOffset(20,20)},0.2) end
        hub.Visible=true hub.Size=UDim2.fromOffset(0,0) tw(hub,{Size=state.compact and UDim2.fromOffset(300,350) or UDim2.fromOffset(340,390)},0.35)
        task.delay(0.22,function() if not state.expanded then for _,w in pairs(widgets) do w.frame.Visible=false w.frame.Size=UDim2.fromOffset(154,w==timerW and 111 or 88) end end end)
    end
end
plus.Activated:Connect(function() if state.minimized then state.minimized=false miniRestore.Visible=false end setExpanded(true) end)
miniRestore.Activated:Connect(function() if state.expanded then setExpanded(false) elseif state.minimized then state.minimized=false miniRestore.Visible=false hub.Visible=true hub.Size=UDim2.fromOffset(0,0) tw(hub,{Size=state.compact and UDim2.fromOffset(300,350) or UDim2.fromOffset(340,390)},0.35) end end)
minimize.Activated:Connect(function() if state.expanded then setExpanded(false) end state.minimized=true hub.Visible=false miniRestore.Visible=true end)
close.Activated:Connect(function() gui:Destroy() end)

local function formatTime(sec)
    local m=math.floor(sec/60) local s=math.floor(sec%60) local tenth=math.floor((sec%1)*10)
    return string.format("%02d:%02d.%d",m,s,tenth)
end
timerToggle.Activated:Connect(function()
    if state.stopwatchRunning then state.stopwatchElapsed=os.clock()-state.stopwatchStart state.stopwatchRunning=false timerToggle.Text="START" timerW.detail.Text="STOPPED"
    else state.stopwatchStart=os.clock()-state.stopwatchElapsed state.stopwatchRunning=true timerToggle.Text="STOP" timerW.detail.Text="COUNTING" end
end)
timerReset.Activated:Connect(function() state.stopwatchRunning=false state.stopwatchElapsed=0 state.stopwatchStart=os.clock() timerToggle.Text="START" timerW.value.Text="00:00.0" timerW.detail.Text="RESET" end)

local frameCount, frameElapsed=0,0
RunService.RenderStepped:Connect(function(dt)
    frameCount+=1 frameElapsed+=dt
    if frameElapsed>=0.5 then
        local fps=math.floor(frameCount/frameElapsed+0.5) frameCount=0 frameElapsed=0
        fpsW.value.Text=tostring(fps) fpsW.detail.Text="CLIENT FPS"
    end
    if state.stopwatchRunning then timerW.value.Text=formatTime(os.clock()-state.stopwatchStart) end
    if state.noclip then
        local ch=getCharacter()
        if ch then for _,part in ipairs(ch:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide=false end end end
    end
end)
local function readPing()
    local ok,value=pcall(function()
        local network=Stats:FindFirstChild("Network")
        local server=network and network:FindFirstChild("ServerStatsItem")
        local item=server and server:FindFirstChild("Data Ping")
        return item and item:GetValue() or nil
    end)
    if ok and type(value)=="number" then return math.floor(value+0.5) end
end
task.spawn(function()
    while gui.Parent do
        local ping=readPing()
        pingW.value.Text=ping and (tostring(ping).." ms") or "--"
        pingW.detail.Text=ping and "NETWORK LATENCY" or "PING UNAVAILABLE"
        local count=#Players:GetPlayers()
        playersW.value.Text=tostring(count)
        playersW.detail.Text="PLAYERS IN SERVER"
        task.wait(1.2)
    end
end)

-- Keep visuals updated if players respawn; all effects remain local.
player.CharacterAdded:Connect(function() task.wait(0.6) applyMovement() refreshESP() end)
-- Initial state
buildTab("PLAYER")
task.delay(0.85,function()
    if not gui.Parent then return end
    tw(loading,{BackgroundTransparency=1},0.2)
    task.wait(0.22)
    if loading.Parent then loading:Destroy() end
    hub.Visible=true hub.Size=UDim2.fromOffset(0,0)
    tw(hub,{Size=UDim2.fromOffset(340,390)},0.4)
    notify("ZEPH X ready")
end)
print("ZEPH X | Complete client hub loaded")
