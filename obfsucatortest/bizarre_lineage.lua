if script_key == nil or script_key ~= "Yuri(Heart)" then
    game:GetService("Players").LocalPlayer:Kick("Lesbian")
    return
end
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
if getgenv().ayasemiyatongekissazumirisa then
    warn("watch more yuri")
    return
end
getgenv().ayasemiyatongekissazumirisa = true
function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			error("Invalid Service: " .. tostring(name))
		end
	end
})
local UIS = Services.UserInputService
local Players             = cloneref(game:GetService("Players"))
local ReplicatedStorage   = cloneref(game:GetService("ReplicatedStorage"))
local RunService          = cloneref(game:GetService("RunService"))
local TeleportService     = cloneref(game:GetService("TeleportService"))
local HttpService         = cloneref(game:GetService("HttpService"))
local Workspace           = cloneref(game:GetService("Workspace"))
local OrgDestroyHeight    = Workspace.FallenPartsDestroyHeight
local Lighting = cloneref(game:GetService("Lighting"))
local MaterialService = cloneref(game:GetService("MaterialService"))
local VirtualUser = Services.VirtualUser
local LocalPlayer = Players.LocalPlayer
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local player              = Players.LocalPlayer
pcall(function()
    player.PlayerGui["Main Menu"]:Destroy()
    player.PlayerGui.Logo_Loader:Destroy()
end)
ReplicatedStorage.requests.character.spawn:FireServer()
ReplicatedStorage.requests.character_server_client.communicate:FireServer()
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles
local function AddSliderToggle(Config)
    local Toggle = Config.Group:AddToggle(Config.Id, {
        Text = Config.Text,
        Default = Config.DefaultToggle or false
    })
    local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
        Text = Config.Text,
        Default = Config.Default,
        Min = Config.Min,
        Max = Config.Max,
        Rounding = Config.Rounding or 0,
        Compact = true,
        Visible = false
    })
    Toggle:OnChanged(function()
        Slider:SetVisible(Toggle.Value)
    end)
    return Toggle, Slider
end
local function causeLag()
    local connections = {}
    local watchedProps = { Transparency = true, Size = true }
    local count = 0
    for _, desc in ipairs(Workspace:GetDescendants()) do
        if count >= 100 then break end
        for prop in pairs(watchedProps) do
            pcall(function()
                local c = desc:GetPropertyChangedSignal(prop):Connect(function()
                    local _ = desc[prop]
                end)
                table.insert(connections, c)
            end)
        end
        count = count + 1
    end
    task.delay(1, function()
        for _, c in ipairs(connections) do
            pcall(function() c:Disconnect() end)
        end
    end)
end
local yuri = {
    "https://mangadex.org/covers/5311ac6f-3651-43a8-bb9c-b40dea7ab72d/062845cb-4498-4499-a23a-89ecac694ea9.jpg",
    "https://mangadex.org/covers/df01a222-faeb-4952-84ac-d6040815e2dd/ec777628-a5d7-4d5f-92f5-11a8a746427e.jpg",
    "https://cdn.donmai.us/original/dc/0e/__hayafuji_kasane_and_aoyama_meguru_keiyaku_shimai_drawn_by_hijiki_hijikini__dc0e2235f2ca00dcb06aa3db2999bd1f.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/233/thumbnail.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/328/thumbnail.jpg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1339/thumbnail.jpeg",
    "https://db.yurigarden.com/storage/v1/object/public/yuri-garden-store/comics/1268/thumbnail.jpeg",
    "https://dynasty-scans.com/system/releases/000/040/979/001.webp",
    "https://dynasty-scans.com/system/images_images/000/031/460/full/GErfQqXagAA4mk7-orig.webp",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2026/02/01/15/33/44/140636490_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2022/08/15/23/52/23/100515820_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2025/07/22/17/09/45/132989170_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2019/12/01/21/59/30/78092730_p0_master1200.jpg",
    "https://wbkwmsg.rdlriknctsha.hath.network/h/7c58877cf725169151ee98bfe289290e2976b20c-116766-800-1138-wbp/keystamp=1778143500-d7ddc8e912;fileindex=223059010;xres=800/001.webp",
    "https://iztbpmb.oppclkfsktcd.hath.network/h/edeb55ba6927f6a29a4a44fdbadb07b5b41d70b2-101318-800-1131-wbp/keystamp=1778143500-f077e9bb56;fileindex=158044327;xres=800/4_004.webp",
    "https://jjxguov.ijurokhfdith.hath.network/h/b4fd528c209a53219debf57b8b01be1072474c74-81916-583-828-wbp/keystamp=1778143800-242b613e89;fileindex=105058631;xres=800/01.webp",
    "https://nkedtzs.esrevwcpgcmt.hath.network:5475/h/4e62a3f9ea8e1081805071ed6b282097ac5b2e8e-159684-800-1159-wbp/keystamp=1778143800-80eae18d83;fileindex=158318688;xres=800/001.webp",
    "https://xdpkglu.qoakbywdoora.hath.network:60996/h/749e2fad6017fef020f4a459c12d7449726d7a3a-106344-800-1130-wbp/keystamp=1778212200-c51a1aa396;fileindex=157644399;xres=800/001.webp",
    "https://mangadex.org/covers/d0f9e331-e022-4b49-8399-e14091d8b703/6db4b76b-691e-4974-bb34-778fb3a1294e.jpg",
    "https://mangadex.org/covers/8b34f37a-0181-4f0b-8ce3-01217e9a602c/37b25abb-5cdd-453b-aff4-7315bd962712.jpg",
    "https://mangadex.org/covers/73965527-b393-4f65-9bc3-2439ec44935a/8976a8c8-7f06-4a9f-836e-2a0b24071526.jpg",
}
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true 
Library.NotifySide = "Left" 
local Window = Library:CreateWindow({
	Title = "yuri",
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = false,
	UnlockMouseWhileOpen = false,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local isLimitedExecutor = executorDisplayName:lower():find("xeno") ~= nil
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end
local eh_success, err = pcall(function()
local function AddInfo(Window)
    local InfoTab = Window:AddTab("Info")
    local InfoLeft = InfoTab:AddLeftGroupbox("Information")
    local statusText = isLimitedExecutor and "<font color='#FFA500'>Semi-Working</font>" or "<font color='#00FF00'>Working</font>"
    local extraNote = isLimitedExecutor
        and "<b>NOTE:</b> May experiencing bugs for some features!"
        or "All features should works properly!"
    InfoLeft:AddLabel("<b>Executor:</b> " .. executorDisplayName .. "\n<b>Status:</b> " .. statusText .. "\n" .. extraNote, true)
    local InfoRight = InfoTab:AddRightGroupbox("Others")
    InfoRight:AddButton({
        Text = "Join Discord Server",
        Func = function()
            local inviteCode = "b6kxdDtqd"
            local inviteLink = "https://discord.gg/" .. inviteCode
            local success = false
            if request then
                success = pcall(function()
                    request({
                        Url = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"] = "https://discord.com"
                        },
                        Body = HttpService:JSONEncode({
                            cmd = "INVITE_BROWSER",
                            args = { code = inviteCode },
                            nonce = HttpService:GenerateGUID(false)
                        })
                    })
                end)
            end
            if not success and setclipboard then
                setclipboard(inviteLink)
            end
        end,
    })
end
AddInfo(Window)
local ManTab = Window:AddTab("Main")
local ShopTab = Window:AddTab("Shop")
local RaidTab = Window:AddTab("Raid")
local InvTab = Window:AddTab("Inventory")
local SkillTab = Window:AddTab("Skill")
local QTab = Window:AddTab("Quest")
local MiscTab = Window:AddTab("Miscellaneous")
local WHTab = Window:AddTab("Webhook")
local ManGroup = ManTab:AddLeftGroupbox("Main")
local SideGroup = ManTab:AddRightGroupbox("Side")
local ShopGroup = ShopTab:AddLeftGroupbox("Shop")
local RaidShopGroup = ShopTab:AddRightGroupbox("RaidShop")
local RaidGroup = RaidTab:AddLeftGroupbox("Raid")
local VoidGroup = RaidTab:AddRightGroupbox("Void")
local InvGroup = InvTab:AddLeftGroupbox("Inventory")
local StandGroup = InvTab:AddRightGroupbox("Stand")
local SkillGroup = SkillTab:AddLeftGroupbox("Skills")
local QGroup = QTab:AddLeftGroupbox("Quests")
local MiscGroup = MiscTab:AddLeftGroupbox("Miscellaneous")
local PlayerGroup = MiscTab:AddRightGroupbox("Player")
local ServerGroup = MiscTab:AddRightGroupbox("Server")
local WHGroup = WHTab:AddLeftGroupbox("Webhook")
local ConfigTab = Window:AddTab("Config")
local getData             = ReplicatedStorage.requests.miscellaneous:WaitForChild("get_data")
local accessoryData       = getData:InvokeServer("accessory")
local SlotData = player:WaitForChild("PlayerData"):WaitForChild("SlotData")
local Inventory           = SlotData:WaitForChild("Inventory")
local liveFolder    = Workspace:FindFirstChild("Live")
local Shared = {
    range           = 2000,
    shouldVoid             = false,
    vskill              = "X",
    vheal               = "None",
    pauseAutoFarm          = false,
    isPhase2               = false,
    savedPos               = nil,
    voidDelayStartTime     = nil,
    voidDelayCompleted     = false,
    voidConnection         = nil,
    voidCharAddedConnection = nil,
    voidHumanoidDiedConnection = nil,
    iframeConnections      = {},
    iframeSeen             = {},
    healthJumped           = {},
    lastHealth             = {},
    VOID_HEALTH_THRESHOLD   = 100,
    VOID_DELAY              = 2.5,
    isVoiding              = false,
    voidThresholdTriggered = {},
    autoRaidEnabled        = false,
    autoSkill       = false,
    selectedRaid           = "",
    skillsEnabled          = {},
    mobFarmEnabled         = false,
    bossFarmEnabled        = false,
    currentTargetPart,
    selectedMobs = {},
    sendWebhookEnabled = false,
    selectedBosses = {},
    scriptStartTime = tick(),
    RaidTokens = SlotData.RaidTokens,
    Money = SlotData.Money,
    webhookUrl = "",
    raidWebhookHandler,
}
local function getSelectedMobs()
    local list = {}
    for name, active in pairs(Options.MobSelect.Value) do
        if active then table.insert(list, name) end
    end
    return list
end
local function getSelectedBosses()
    local list = {}
    for name, active in pairs(Options.BossSelect.Value) do
        if active then table.insert(list, name) end
    end
    return list
end
local syncHandlers = {}
function syncSystem(key)
    local handler = syncHandlers[key]
    if handler then
        handler()
    end
end
local function isPlayerAlive()
    if not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead
end
local function resolvePosition(target)
    if typeof(target) == "CFrame" then
        return target.Position
    end
    if typeof(target) == "table" and target.x and target.y and target.z then
        return Vector3.new(target.x, target.y, target.z)
    end
    if typeof(target) == "Vector3" then
        return target
    elseif typeof(target) == "Instance" then
        if target:IsA("Model") then
            return target:GetPivot().Position
        elseif target:IsA("BasePart") then
            return target.Position
        end
    end
    return nil
end
local function lookAt(target, part)
    local targetPos = resolvePosition(target)
    local lookPart = part or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
    if lookPart and targetPos then
        lookPart.CFrame = CFrame.lookAt(lookPart.Position, targetPos)
    end
end
local notification = ReplicatedStorage.requests.general.notification
local VOID_NAMES = {"Jotaro", "Kira", "Avdol", "DIO", "Heaven Ascension", "Pucci", "Death 13", "Anasui", "Jolyne"}
local bossList = {"Akira Otoishi", "Yoshikage Kira", "Okuyasu Nijimura PRIME", "Miyamoto Musashi", "Zombie Rudol von Stroheim", "Dr. Bosconovitch"}
local function isVoidTarget(hrpPart)
    if not hrpPart or not hrpPart.Parent then return false end
    local name = hrpPart.Parent.Name
    for _, n in ipairs(VOID_NAMES) do
        if name:lower():match(n:lower()) then return true end
    end
    return false
end
local function resetCharacter()
    local char = player.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end
local function waitForRespawn()
    local oldChar = player.Character
    repeat task.wait(0.5) until player.Character ~= oldChar
    repeat task.wait(0.5) until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    task.wait(0.5)
end
local function waitForNotification(...)
    local patterns = { ... }
    local found = false
    local conn = notification.OnClientEvent:Connect(function(msg)
        for _, pattern in ipairs(patterns) do
            if msg:lower():match(pattern) then
                found = true
                break
            end
        end
    end)
    repeat task.wait(0.3) until found
    conn:Disconnect()
end
local function isGrabbed(npc)
    local npcHrp = npc:FindFirstChild("HumanoidRootPart")
    if not npcHrp then return false end
    return npcHrp:GetAttribute("Grab") ~= nil
end
local function talkToNpc(npcName, dialogues)
    if type(dialogues) ~= "table" then dialogues = {dialogues} end
    local event = ReplicatedStorage.requests.character.dialogue.OnClientEvent
    local attempts = 0
    local MAX_ATTEMPTS = 5
    while attempts < MAX_ATTEMPTS do
        attempts = attempts + 1
        Shared.pauseAutoFarm = true
        local npc
        if Workspace:FindFirstChild("Npcs") then
            npc = Workspace.Npcs:FindFirstChild(npcName)
        end
        if not npc then
            local cache = ReplicatedStorage:FindFirstChild("assets") and ReplicatedStorage.assets:FindFirstChild("npc_cache")
            if cache then npc = cache:FindFirstChild(npcName) end
        end
        if not npc then
            task.wait(0.5)
            continue
        end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            task.wait(0.5)
            continue
        end
        local npcPos = resolvePosition(npc)
        if not npcPos then
            task.wait(0.5)
            continue
        end
        hrp.CFrame = CFrame.new(npcPos + Vector3.new(0, 5, 0))
        task.wait(0.2)
        local allAnswered = true
        for _, msg in ipairs(dialogues) do
            local responded = false
            local conn
            conn = event:Connect(function(replyNpc)
                if replyNpc == npc then
                    responded = true
                end
            end)
            ReplicatedStorage.requests.character.dialogue:FireServer(npc, msg)
            local waitTime = 0
            while not responded and waitTime < 1 do
                task.wait(0.2)
                waitTime = waitTime + 0.2
            end
            conn:Disconnect()
            if not responded then
                allAnswered = false
                break
            end
        end
        if allAnswered then
            Shared.pauseAutoFarm = false
            return true
        end
        task.wait(0.5)
    end
    Shared.pauseAutoFarm = false
    return false
end
local function findTarget()
    if Shared.pauseAutoFarm then return end
    local liveFolder = Workspace:FindFirstChild("Live")
    if Shared.mobFarmEnabled and liveFolder then
        local mobs = getSelectedMobs()
        if #mobs > 0 then
            for _, desc in ipairs(liveFolder:GetDescendants()) do
                if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" and desc.Position.Y >= -480 then
                    local model = desc.Parent
                    for _, mobName in ipairs(mobs) do
                        if model.Name:lower():find(mobName:lower(), 1, true) then
                            local hum = model:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health > 0 then
                                return desc
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    if Shared.bossFarmEnabled and liveFolder then
        local bosses = getSelectedBosses()
        if #bosses > 0 then
            for _, desc in ipairs(liveFolder:GetDescendants()) do
                if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" and desc.Position.Y >= -480 then
                    local model = desc.Parent
                    for _, bossName in ipairs(bosses) do
                        if model.Name:lower():find(bossName:lower(), 1, true) then
                            local hum = model:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health > 0 then
                                return desc
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    if _G.storyTargetName and liveFolder then
        local targetLower = _G.storyTargetName:lower()
        local wantsPrime = targetLower:find("prime", 1, true) ~= nil
        for _, desc in ipairs(liveFolder:GetDescendants()) do
            if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" and desc.Position.Y >= -480 then
                local model = desc.Parent
                local modelName = model.Name:lower()
                if modelName:find(targetLower, 1, true) then
                    local isPrime = modelName:find("prime", 1, true) ~= nil
                    if isPrime == wantsPrime then
                        local hum = model:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            return desc
                        end
                    end
                end
            end
        end
        return nil
    end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local myPos = hrp.Position
    local playerChars = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then playerChars[pl.Character] = true end
    end
    if not liveFolder then return nil end
    local priorityTargets = { {}, {}, {} }
    local ignoreNetherstar = false
    for _, desc in ipairs(liveFolder:GetDescendants()) do
        if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart"
            and desc.Position.Y >= -480
            and not playerChars[desc.Parent]
            and desc.Parent.Name:lower() ~= "server"
            and not desc.Parent.Name:lower():match("hostage")
            and not desc.Parent.Name:lower():match("prisoner grunt")
            and not desc.Parent.Name:lower():match("snark")
            and not desc.Parent.Name:lower():match("vern") then
            local hum = desc.Parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local d = (desc.Position - myPos).Magnitude
                if d <= Shared.range then
                    local parentName = desc.Parent.Name
                    local priority
                    if parentName:match("Netherstar") then
                        priority = 1
                    elseif parentName:match("Heaven Ascension") then
                        priority = 2
                        if hum.Health <= 3300 or hum.MaxHealth == 10000 then
                            ignoreNetherstar = true
                        end
                    else
                        priority = 3
                    end
                    table.insert(priorityTargets[priority], { part = desc, dist = d })
                end
            end
        end
    end
    if ignoreNetherstar then
        priorityTargets[1] = {}
    end
    for priority = 1, 3 do
        local group = priorityTargets[priority]
        if #group > 0 then
            local nearest = group[1]
            for _, entry in ipairs(group) do
                if entry.dist < nearest.dist then
                    nearest = entry
                end
            end
            return nearest.part
        end
    end
    return nil
end
local BODY_VEL_NAME = "a"
local BODY_GYRO_NAME = "b"
local connection, charAddedConnection, humanoidDiedConnection
local bodyVelocity, bodyGyro
local BodyOrigins = {}  
function enableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME or inst.Name == BODY_GYRO_NAME then
            inst:Destroy()
        end
    end
    BodyOrigins = {}
    BodyOrigins[hrp] = hrp.Anchored
    hrp.Anchored = false
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = BODY_VEL_NAME
    bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = hrp
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = BODY_GYRO_NAME
    bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
end
function disableBodyControl(hrp)
    if not hrp then return end
    for _, inst in ipairs(hrp:GetChildren()) do
        if inst.Name == BODY_VEL_NAME or inst.Name == BODY_GYRO_NAME then
            inst:Destroy()
        end
    end
    bodyVelocity = nil
    bodyGyro = nil
    if BodyOrigins and BodyOrigins[hrp] ~= nil then
        hrp.Anchored = BodyOrigins[hrp]
    end
    BodyOrigins = {}
end
local function setupMain()
    local questData = getData:InvokeServer("quest")
    local TOTAL_DISTANCE = 10
    local Clip = true
    local Noclipping
    local Origins = {}  
    local function NoclipLoop()
        if Clip == false and player.Character ~= nil then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= BODY_VEL_NAME then
                    if Origins[part] == nil then
                        Origins[part] = part.CanCollide  
                    end
                    part.CanCollide = false
                end
            end
        end
    end
    local function startNoclip()
        if Clip == false then return end
        Clip = false
        Origins = {}  
        if Noclipping then
            Noclipping:Disconnect()
        end
        Noclipping = RunService.Stepped:Connect(NoclipLoop)
    end
    local function stopNoclip()
        Clip = true
        if Noclipping then
            Noclipping:Disconnect()
            Noclipping = nil
        end
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and Origins[part] ~= nil then
                    part.CanCollide = Origins[part]  
                end
            end
        end
        Origins = {}
    end
    local storyTalkMap = {}
    local ddOk, dialogueData = pcall(require, ReplicatedStorage.modules.client_data.dialogue_data)
    if ddOk and type(dialogueData) == "table" then
        storyTalkMap["Storyline 1"] = { npc = "Receptionist", dialogue = 1 }
        for npcName, npcData in pairs(dialogueData) do
            local greetings = npcData[1]
            if type(greetings) == "table" then
                for _, entry in ipairs(greetings) do
                    if type(entry) == "table" and type(entry.QuestsCompleted) == "table" then
                        for _, completedQuest in ipairs(entry.QuestsCompleted) do
                            local num = completedQuest:match("^[Ss]toryline (%d+)$")
                            if num then
                                local nextQuest = "Storyline " .. (tonumber(num) + 1)
                                if not storyTalkMap[nextQuest] then
                                    local choices = entry.Choices
                                    local firstChoice = (type(choices) == "table" and #choices > 0) and choices[1] or 1
                                    storyTalkMap[nextQuest] = { npc = npcName, dialogue = firstChoice }
                                end
                            end
                        end
                    end
                end
            end
        end
        local count = 0
        for _ in pairs(storyTalkMap) do count = count + 1 end
    end
    local function getDialogueForNpc(questName, npcName)
        local num = questName:match("^[Ss]toryline (%d+)$")
        if not num or not ddOk or type(dialogueData) ~= "table" then return 1 end
        local prevQuest = "Storyline " .. (tonumber(num) - 1)
        local npcData = dialogueData[npcName]
        local greetings = npcData and npcData[1]
        if type(greetings) == "table" then
            for _, entry in ipairs(greetings) do
                if type(entry) == "table" and type(entry.QuestsCompleted) == "table" then
                    for _, completedQuest in ipairs(entry.QuestsCompleted) do
                        if completedQuest:lower() == prevQuest:lower() then
                            local choices = entry.Choices
                            local choice = (type(choices) == "table" and #choices > 0) and choices[1] or 1
                            return choice
                        end
                    end
                end
            end
        end
        return 1
    end
    local mobList = {
    "Delinquent", "Thug", "Okuyasu Nijimura", "Corrupt Police Officer", "Toyohiro",
    "Yakuza", "Mafia Member", "Prison Escapee", "Thief", "Zombie Grunt",
    "Josuke Higashikata", "Boxer", "Boxing Coach", "Vampire", "Cultist",
    "Cultist Leaders", "Zombie", "Rock Human",
    "Samurai", "Samurai Master", "Rogue Rock Human", "Speedwagon Agent",
    "Elder Vampire", "Cyborg", "Zombie Cyborg", "Spin User", "Night Vampire",
    "Hamon Apprentice", "Hamon Master", "Elite Vampire", "Elite Mafia Member"
    }
    local function stopAll(hrp)
        Shared.currentTargetPart = nil
        _G.isAutoTweening = false
        if hrp then
            disableBodyControl(hrp)
            task.wait(0.05)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
            local hum = hrp.Parent:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
            if FARM_POSITION == "Below" then
                hrp.CFrame = hrp.CFrame * CFrame.new(0, TOTAL_DISTANCE + 1000000, 0)
            end
            task.wait(0.3)
        end
    end
    local function onCharacterAdded(character)
        if humanoidDiedConnection then humanoidDiedConnection:Disconnect() humanoidDiedConnection = nil end
        Shared.currentTargetPart = nil
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoidDiedConnection = humanoid.Died:Connect(function()
                stopAll(character:FindFirstChild("HumanoidRootPart"))
            end)
        end
    end
    local FARM_POSITION = "Below"  
    local function getDesiredPosition(hrp, targetModel)
        local targetPos = resolvePosition(targetModel)
        if not targetPos then return nil end
        local offset
        if FARM_POSITION == "Above" then
            offset = Vector3.new(0, TOTAL_DISTANCE, 0)
        elseif FARM_POSITION == "Behind" then
            local targetCFrame = targetModel:IsA("BasePart") and targetModel.CFrame or CFrame.new(targetPos)
            offset = targetCFrame.LookVector * TOTAL_DISTANCE
        else 
            offset = Vector3.new(0, -TOTAL_DISTANCE, 0)
        end
        return targetPos + offset
    end
    local autoTrainEnabled = false
    local autoTrainThread = nil
    local function getTreadmillPrompt()
        local workouts = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Workouts")
        if not workouts then return nil, nil end
        for _, obj in ipairs(workouts:GetChildren()) do
            if obj.Name == "Treadmill" then
                local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt")
                if not prompt then
                    prompt = obj:FindFirstChild("ProximityPrompt", true)
                end
                if prompt then
                    return obj, prompt
                end
            end
        end
        return nil, nil
    end
    local function startAutoTrain()
        if autoTrainThread then return end
        autoTrainThread = task.spawn(function()
            while autoTrainEnabled do
                local expBonus = game:GetService("Players").LocalPlayer.PlayerGui.MainHud.ExpBonus
                if expBonus and not expBonus.Visible then
                    local character = LocalPlayer.Character
                    if not character then
                        task.wait(1)
                        continue
                    end
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then
                        task.wait(1)
                        continue
                    end
                    local treadmillPart, prompt = getTreadmillPrompt()
                    if treadmillPart and prompt then
                        local treadmillPos = resolvePosition(treadmillPart)
                        if treadmillPos then
                            hrp.CFrame = CFrame.new(treadmillPos)
                            task.wait(0.2)
                            pcall(function() fireproximityprompt(prompt) end)
                        else
                            task.wait(1)
                        end
                    else
                        task.wait(1)
                    end
                else
                    task.wait(1)
                end
            end
            autoTrainThread = nil
        end)
    end
    local function stopAutoTrain()
        autoTrainEnabled = false
    end
    ManGroup:AddDropdown('FarmPosition', {
        Text = "Farm Position",
        Values = {"Above", "Below", "Behind"},
        Default = "Below",
        Multi = false,
        Callback = function(Value)
            FARM_POSITION = Value
        end
    })
    ManGroup:AddInput('Distance', {
        Text = "Distance",
        Default = tostring(TOTAL_DISTANCE),
        Placeholder = "Radius",
        Callback = function(Value)
            local number = tonumber(Value)
            if number then
                TOTAL_DISTANCE = number
            end
        end
    })
    ManGroup:AddInput('TargetRange', {
        Text = "Targeting Range",
        Default = tostring(Shared.range),
        Placeholder = "Max distance",
        Callback = function(Value)
            local number = tonumber(Value)
            if number then
                Shared.range = number
            end
        end
    })
    ManGroup:AddDropdown('MobSelect', {
        Text = "Select Mobs to Farm",
        Values = mobList,
        Default = {},
        Multi = true,
    })
    Options.MobSelect:OnChanged(function()
        for name, active in pairs(Options.MobSelect.Value) do
            if active then table.insert(Shared.selectedMobs, name) end
        end
    end)
    ManGroup:AddToggle('ToggleFarmMobs', {
        Text = "Toggle Farm Mobs",
        Default = false,
        Callback = function(val)
            Shared.mobFarmEnabled = val
            if val then
                if Shared.bossFarmEnabled then
                    Shared.bossFarmEnabled = false
                    Toggles.ToggleStoryline:SetValue(false)
                    Toggles.ToggleFarmBosses:SetValue(false)
                end
            end
        end
    })
    ManGroup:AddDropdown('BossSelect', {
        Text = "Select Bosses to Farm",
        Values = bossList,
        Default = {},
        Multi = true,
    })
    Options.BossSelect:OnChanged(function()
        for name, active in pairs(Options.BossSelect.Value) do
            if active then table.insert(Shared.selectedBosses, name) end
        end
    end)
    ManGroup:AddToggle('ToggleFarmBosses', {
        Text = "Toggle Farm Bosses",
        Default = false,
        Callback = function(val)
            Shared.bossFarmEnabled = val
            if val then
                if Shared.mobFarmEnabled then
                    Shared.mobFarmEnabled = false
                    Toggles.ToggleFarmMobs:SetValue(false)
                    Toggles.ToggleStoryline:SetValue(false)
                end
            end
        end
    })
    ManGroup:AddToggle('ToggleStoryline', {
        Text = "Toggle Auto Storyline",
        Default = false,
        Callback = function(val)
            if val then
                task.spawn(function()
                    local lastTalkKey = nil  
                    while Toggles.ToggleStoryline.Value do
                        Toggles.ToggleFarmMobs:SetValue(false)
                        Toggles.ToggleFarmBosses:SetValue(false)
                        local currentQuests = HttpService:JSONDecode(SlotData.CurrentQuests.Value)
                        if not currentQuests then break end
                        local found = false
                        for _, quest in ipairs(currentQuests) do
                            if quest.Name:lower():find("storyline") then
                                local talk = quest.Talk
                                if type(talk) == "table" then
                                    local pendingNpc = nil
                                    for npcName, done in pairs(talk) do
                                        if done == false then
                                            pendingNpc = npcName
                                            break
                                        end
                                    end
                                    if pendingNpc then
                                        local talkKey = quest.Name .. "|" .. pendingNpc
                                        if lastTalkKey == talkKey then
                                        else
                                            local dialogue = getDialogueForNpc(quest.Name, pendingNpc)
                                            _G.storyTargetName = nil
                                            lastTalkKey = talkKey
                                            talkToNpc(pendingNpc, dialogue)
                                        end
                                        found = true
                                    else
                                        if lastTalkKey and lastTalkKey:find(quest.Name, 1, true) then
                                            lastTalkKey = nil
                                        end
                                        local qd = questData[quest.Name]
                                        if qd and qd.Kills then
                                            for enemyName, required in pairs(qd.Kills) do
                                                local current = quest.Kills and quest.Kills[enemyName] or 0
                                                if current < required then
                                                    _G.storyTargetName = enemyName
                                                    found = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                else
                                    local qd = questData[quest.Name]
                                    if qd and qd.Kills then
                                        for enemyName, required in pairs(qd.Kills) do
                                            local current = quest.Kills and quest.Kills[enemyName] or 0
                                            if current < required then
                                                _G.storyTargetName = enemyName
                                                found = true
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if not found then
                            _G.storyTargetName = nil   
                        end
                        task.wait(0.5)
                    end
                    _G.storyTargetName = nil
                end)
            else
                _G.storyTargetName = nil
            end
        end
    })
    ManGroup:AddToggle('AutoFarm', {
        Text = "Auto Farm (Default is Nearest)",
        Default = false,
        Callback = function(value)
            _G.AutoFarm = value
            if value then
                if not charAddedConnection then
                    charAddedConnection = player.CharacterAdded:Connect(onCharacterAdded)
                end
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                enableBodyControl(hrp)
                startNoclip()
                connection = RunService.Heartbeat:Connect(function()
                    if Shared.isVoiding or Shared.pauseAutoFarm then return end
                    if not isPlayerAlive() or not _G.AutoFarm then
                        local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        stopAll(h)
                        return
                    end
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    Shared.currentTargetPart = findTarget()
                    if not Shared.currentTargetPart then return end
                    local targetPos = resolvePosition(Shared.currentTargetPart)
                    if not targetPos then return end
                    local offset = Vector3.zero
                    if FARM_POSITION == "Above" then
                        offset = Vector3.new(0, TOTAL_DISTANCE, 0)
                    elseif FARM_POSITION == "Below" then
                        offset = Vector3.new(0, -TOTAL_DISTANCE, 0)
                    elseif FARM_POSITION == "Behind" then
                        if Shared.currentTargetPart:IsA("BasePart") then
                            offset = Shared.currentTargetPart.CFrame.LookVector * -TOTAL_DISTANCE
                        else
                            offset = Vector3.new(0, 0, -TOTAL_DISTANCE)
                        end
                    else
                        offset = Vector3.new(0, -TOTAL_DISTANCE, 0)
                    end
                    local desiredPos = targetPos + offset
                    local diff = desiredPos - hrp.Position
                    hrp.CFrame = CFrame.new(desiredPos)
                    lookAt(Shared.currentTargetPart, hrp)
                end)
            else
                if connection then connection:Disconnect() connection = nil end
                if charAddedConnection then charAddedConnection:Disconnect() charAddedConnection = nil end
                if humanoidDiedConnection then humanoidDiedConnection:Disconnect() humanoidDiedConnection = nil end
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                stopAll(hrp)
            end
        end
    })
    SideGroup:AddToggle('AutoItems', {
        Text = "Auto Collect Items",
        Default = false,
        Callback = function(state)
            if state then
                task.spawn(function()
                    while Toggles.AutoItems.Value do   
                        for _, child in ipairs(Workspace:GetChildren()) do
                            if not Toggles.AutoItems.Value then break end
                            if child.ClassName == "Model" and child.Name == "Model"  then
                                local prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt then
                                    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                    if root then
                                        root.CFrame = child:GetPivot() * CFrame.new(0, 5, 0)
                                    end
                                    task.wait(0.2)
                                    fireproximityprompt(prompt)
                                end
                            end
                        end
                        task.wait(.1)
                    end
                end)
            end
        end
    })
    SideGroup:AddToggle('AutoTrain', {
        Text = "Auto Train",
        Default = false,
        Callback = function(Value)
            autoTrainEnabled = Value
            if Value then
                startAutoTrain()
            else
                stopAutoTrain()
            end
        end
    })
    SideGroup:AddToggle('AutoMeditation', {
        Text = "Auto Meditation",
        Default = false,
        Callback = function(value)
            _G.AutoMeditation = value
            if value then
                task.spawn(function()
                    while _G.AutoMeditation do
                        local ok, err = pcall(function()
                            talkToNpc("Meditation", "Meditate.")
                            task.wait()
                            talkToNpc("The Self", "Yes.")
                            task.wait(2)
                            local timeout = tick() + 30
                            while _G.AutoMeditation and tick() < timeout do
                                if liveFolder then
                                    for _, child in ipairs(liveFolder:GetChildren()) do
                                        if child.Name:lower():match(player.Name:lower()) and child.Name:lower():match("entity clone") then
                                            local hum = child:FindFirstChildOfClass("Humanoid")
                                            if hum and hum.Health > 0 then
                                                repeat
                                                    task.wait()
                                                until not _G.AutoMeditation or not child.Parent or hum.Health <= 0
                                                return
                                            end
                                        end
                                    end
                                end
                                task.wait(0.175)
                            end
                        end)
                        task.wait(1)
                    end
                end)
            end
        end
    })
end
local function setupSkills()
    local threads = {}
    local autoSummon = false
    local function startLoop(key, fn)
        if threads[key] and threads[key].running then return end
        local loopData = {
            running = true,
            thread = nil
        }
        local loopFunc = function()
            while loopData.running do
                if _G.AutoFarm then
                    local ok, err = xpcall(fn, debug.traceback)
                    if not ok then
                        task.defer(error, err)
                    end
                end
                task.wait(0.1)
            end
        end
        loopData.thread = task.spawn(loopFunc)
        threads[key] = loopData
    end
    local function stopLoop(key)
        local loopData = threads[key]
        if loopData then
            loopData.running = false
            if loopData.thread and coroutine.status(loopData.thread) ~= "dead" then
                task.cancel(loopData.thread)
            end
            threads[key] = nil
        end
    end
    local skillCooldowns = {}
    local standCooldownConnection = nil
    local cachedSkillNames = {}
    local function getSkillNameForKeybind(keybind)
        if cachedSkillNames[keybind] then return cachedSkillNames[keybind] end
        local char = player.Character
        if not char then return nil end
        local standName = char:GetAttribute("SummonedStand")
        if not standName then return nil end
        local ok, skillsData = pcall(function()
            return ReplicatedStorage.requests.miscellaneous:WaitForChild("get_data"):InvokeServer("ability")
        end)
        if not ok or not skillsData then return nil end
        for skillId, skill in pairs(skillsData) do
            if skill.AbilityType == "Stand" and string.split(skillId, ": ")[1] == standName and skill.Keybind == keybind then
                cachedSkillNames[keybind] = skill.Name
                return skill.Name
            end
        end
        return nil
    end
    local function isOnCooldown(keybind)
        local direct = skillCooldowns[keybind]
        if direct then
            local remaining = direct - tick()
            if remaining >= 1 then return true end
        end
        local skillName = getSkillNameForKeybind(keybind)
        if skillName then
            local endTime = skillCooldowns[skillName]
            if endTime then
                local remaining = endTime - tick()
                if remaining >= 1 then return true end
            end
        end
        return false
    end
    local function startCooldownTracking()
        if standCooldownConnection then return end
        local standCooldownRemote = ReplicatedStorage.requests.general:WaitForChild("StandCooldown")
        standCooldownConnection = standCooldownRemote.OnClientEvent:Connect(function(skillName, duration)
            if duration >= 1 then
                skillCooldowns[skillName] = tick() + duration
            end
        end)
    end
    local function stopCooldownTracking()
        if standCooldownConnection then
            standCooldownConnection:Disconnect()
            standCooldownConnection = nil
        end
        skillCooldowns = {}
        cachedSkillNames = {}
    end
    local function fireSkill(key, ...)
        local args = {...}
        local char = player.Character
        if not char then return end
        local controller = char:WaitForChild("client_character_controller", 3)
        if not controller then return end
        local remote = controller:WaitForChild(key, 3)
        if not remote then return end
        if not Shared.currentTargetPart then return end
        if Shared.currentTargetPart.Parent and (
            Shared.currentTargetPart.Parent:FindFirstChild("IFrame") or
            Shared.currentTargetPart.Parent:FindFirstChild("Evasive") or
            Shared.currentTargetPart.Parent:GetAttribute("Invisible") ~= nil or
            Shared.currentTargetPart.Parent:GetAttribute("Blocking") == true or
            -- Dashing: set for the ENTIRE dodge duration (src: Dodge VFX module waits until this is nil)
            Shared.currentTargetPart.Parent:GetAttribute("Dashing") ~= nil or
            -- DodgeDirection: set to "Forward"/"Backwards"/etc. while the dodge is active
            Shared.currentTargetPart.Parent:GetAttribute("DodgeDirection") ~= nil
        ) then return end
        local keybind = args[1] == "Skill" and args[2] or nil
        if keybind and isOnCooldown(keybind) then return end
        remote:FireServer(table.unpack(args))
    end
    local function anySkillEnabled()
        for _, v in pairs(Shared.skillsEnabled) do
            if v then return true end
        end
        return false
    end
    local function runSkillLoop()
        if threads["skills"] then return end
        startLoop("skills", function()
            local shouldFireVoid = false
            local voidConditionMet = false
            if Shared.vskill ~= "None" and Shared.currentTargetPart and Shared.currentTargetPart.Parent then
                if isVoidTarget(Shared.currentTargetPart) and not isGrabbed(Shared.currentTargetPart.Parent) then
                    local hum = Shared.currentTargetPart.Parent:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local currentHP = hum.Health
                        local maxHP = hum.MaxHealth
                        local hpPercent = maxHP > 0 and (currentHP / maxHP * 100) or 0
                        local npcName = Shared.currentTargetPart.Parent.Name
                        if not Shared.voidThresholdTriggered[npcName] and hpPercent <= Shared.VOID_HEALTH_THRESHOLD then
                            Shared.voidThresholdTriggered[npcName] = true
                        end
                        Shared.shouldVoid = Shared.voidThresholdTriggered[npcName] == true
                        if Shared.isPhase2 or Shared.shouldVoid then
                            voidConditionMet = true
                            if not Shared.voidDelayStartTime then
                                Shared.voidDelayStartTime = tick()
                                Shared.voidDelayCompleted = false
                            end
                            local elapsed = tick() - Shared.voidDelayStartTime
                            if Shared.VOID_DELAY == 0 or elapsed >= Shared.VOID_DELAY then
                                Shared.voidDelayCompleted = true
                                shouldFireVoid = true
                            end
                        end
                    end
                end
            end
            if not voidConditionMet then
                Shared.voidDelayStartTime = nil
                Shared.voidDelayCompleted = false
            end
            if shouldFireVoid then
                local voidFired = false
                for i = 1, 15 do
                    if not isOnCooldown(Shared.vskill) then
                        fireSkill("Skill", Shared.vskill, true)
                        voidFired = true
                        task.wait(0.2)
                    else
                        break
                    end
                end
                if voidFired then
                    return
                end
            end
            local function fireUntilCooldown(cooldownKey, remoteType, ...)
                for i = 1, 15 do
                    if not isOnCooldown(cooldownKey) then
                        fireSkill(remoteType, ...)
                        task.wait(0.2)
                    else
                        break
                    end
                end
            end
            if Shared.skillsEnabled["X"] and Shared.vskill ~= "X" and not isOnCooldown("X") then
                fireUntilCooldown("X", "Skill", "X", true)
            end
            if Shared.skillsEnabled["E"] and Shared.vskill ~= "E" and not isOnCooldown("E") then
                fireUntilCooldown("E", "Skill", "E", true)
            end
            if Shared.skillsEnabled["R"] and Shared.vskill ~= "R" and not isOnCooldown("R") then
                fireUntilCooldown("R", "Skill", "R", true)
            end
            if Shared.skillsEnabled["Z"] and Shared.vskill ~= "Z" and not isOnCooldown("Z") then
                fireUntilCooldown("Z", "Skill", "Z", true)
            end
            if Shared.skillsEnabled["C"] and Shared.vskill ~= "C" and not isOnCooldown("C") then
                fireUntilCooldown("C", "Skill", "C", true)
            end
            if Shared.skillsEnabled["V"] and Shared.vskill ~= "V" and not isOnCooldown("V") then
                fireUntilCooldown("V", "Skill", "V", true)
            end
            if Shared.skillsEnabled["M2"] and Shared.vskill ~= "M2" and not isOnCooldown("M2 CD") then
                fireSkill("M2", true, false)
            end
            if Shared.skillsEnabled["M1"] and Shared.vskill ~= "M1" and not isOnCooldown("M1 CD") then
                fireSkill("M1", true, false)
            end
        end)
    end
    local function onToggleSkill(key, enabled)
        Shared.skillsEnabled[key] = enabled
        if enabled then
            startCooldownTracking()
            runSkillLoop()
        else
            if not anySkillEnabled() then
                stopLoop("skills")
                stopCooldownTracking()
            end
        end
    end
    local function autoSummonLoop()
        while autoSummon do
            if _G.AutoFarm then
                local character = player.Character
                if not character or not character.Parent then
                    character = player.CharacterAdded:Wait() or player.Character
                end
                local playerFolder = Workspace:FindFirstChild("Live") and Workspace.Live:FindFirstChild(player.Name)
                if playerFolder then
                    local v = playerFolder:GetAttribute("SummonedStand")
                    if v == nil or v == "" or v == false then
                        local controller = character and character:FindFirstChild("client_character_controller")
                        if controller and controller:FindFirstChild("SummonStand") then
                            pcall(function() controller.SummonStand:FireServer() end)
                        end
                    end
                end
            end
            task.wait(1)
        end
    end
    local skillOptions = { "M1", "M2", "E", "R", "Z", "C", "X", "V" }
    local lastSelectedSkills = {}        
    SkillGroup:AddDropdown('SelectedSkills', {
        Text = "Select Skills",
        Values = skillOptions,
        Default = {},
        Multi = true,
    })
    Options.SelectedSkills:OnChanged(function()
        for skill, active in pairs(Options.SelectedSkills.Value) do
            if active then table.insert(lastSelectedSkills, skill) end
        end
    end)
    syncHandlers["skills"] = function()
        if not Toggles.AutoSkill.Value then
            for _, key in ipairs(skillOptions) do
                if Shared.skillsEnabled[key] then
                    onToggleSkill(key, false)
                end
            end
            return
        end
        local activeSkills = {}
        for skill, isActive in pairs(Options.SelectedSkills.Value) do
            if isActive then table.insert(activeSkills, skill) end
        end
        for _, key in ipairs(activeSkills) do
            onToggleSkill(key, true)
        end
        for _, key in ipairs(skillOptions) do
            if Shared.skillsEnabled[key] and not table.find(activeSkills, key) then
                onToggleSkill(key, false)
            end
        end
    end
    SkillGroup:AddToggle('AutoSkill', {   
        Text = "Auto Skills",
        Default = false,
        Callback = function(state)
            Shared.autoSkill = state
            syncSystem("skills")
        end
    })
    Options.SelectedSkills:OnChanged(function()
        if Shared.autoSkill then
            syncSystem("skills")
        end
    end)
    SkillGroup:AddToggle('SummonStand', {
        Text = "Auto Summon Stand",
        Default = false,
        Callback = function(state)
            autoSummon = state
            if state then
                task.spawn(autoSummonLoop)
            end
        end
    })
end
local function setupRaid()
    local autoRetryActive = false
    local JobId = game.JobId
    local NEAR_DISTANCE = 10
    local max = 1000
    local RAID_OPTIONS = {
        "Muhammad Avdol Raid", "Jotaro Kujo Raid", "Death 13 Raid", "Dio Raid",
        "Prison Escape Raid", "Yoshikage Kira Raid", "DIO Over Heaven Raid"
    }
    local RAID_CONFIGS = {
        ["Muhammad Avdol Raid"] = { npcName = "Muhammad Avdol", pos = Vector3.new(346, 876, 1013) },
        ["Jotaro Kujo Raid"] = { npcName = "Chumbo", pos = Vector3.new(1074, 884, 209) },
        ["Death 13 Raid"] = { npcName = "Death 13 Raid", pos = Vector3.new(829, 885, -145) },
        ["Dio Raid"] = { npcName = "???", pos = Vector3.new(2797, 951, 739) },
        ["Prison Escape Raid"] = { npcName = "Prison Escape Raid", pos = Vector3.new(881, 886, -581) },
        ["Yoshikage Kira Raid"] = { npcName = "Yoshikage Kira", pos = Vector3.new(1037, 876, -652) },
        ["DIO Over Heaven Raid"] = { npcName = "Heaven Ascension DIO", pos = Vector3.new(1005, 1005, 1734) }
    }
    Shared.selectedRaid = Shared.selectedRaid or ""
    local autoRaidLoop = nil
    local function getRaidConfig()
        return RAID_CONFIGS[Shared.selectedRaid]
    end
    local function getHRP()
        local char = player.Character
        return char and char:FindFirstChild("HumanoidRootPart")
    end
    local function teleportTo(pos)
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = CFrame.new(pos)
            task.wait(0.1)
        end
    end
    local function fireRaid()
        local config = getRaidConfig()
        if not config then
            return false
        end
        local dialogue = ReplicatedStorage
            :WaitForChild("requests")
            :WaitForChild("character")
            :WaitForChild("dialogue")
        local npc = Workspace:FindFirstChild("Npcs")
            and Workspace.Npcs:FindFirstChild(config.npcName)
        if not npc then
            return false
        end
        dialogue:FireServer(npc, "Raid.")
        return true
    end
    local function hopToRandomServer()
        local function getAllServers()
            local url = string.format(
                "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
                14890802310
            )
            local res = game:HttpGet(url)
            local decoded = HttpService:JSONDecode(res)
            return decoded and decoded.data or {}
        end
        while true do
            local servers = getAllServers()
            local bestServer, lowestPlayerCount = nil, math.huge
            for _, server in ipairs(servers) do
                if server.id ~= JobId and server.playing < server.maxPlayers then
                    if server.playing < lowestPlayerCount then
                        lowestPlayerCount = server.playing
                        bestServer = server
                    end
                end
            end
            if bestServer then
                TeleportService:TeleportToPlaceInstance(14890802310, bestServer.id, player)
                break
            end
            task.wait(1)
        end
    end
    local function startAutoRaid()
        if autoRaidLoop then return end
        if game.PlaceId ~= 14890802310 then
            return
        end
        autoRaidLoop = task.spawn(function()
            while Shared.autoRaidEnabled do
                local config = getRaidConfig()
                if not config then
                    task.wait(1)
                    continue
                end
                local hrp = getHRP()
                if not hrp then
                    task.wait(1)
                    continue
                end
                local dist = (hrp.Position - config.pos).Magnitude
                if dist > NEAR_DISTANCE then
                    teleportTo(config.pos)
                    task.wait(1)
                end
                task.wait(0.5)
                local fired = fireRaid()
                if not fired then
                    task.wait(2)
                    continue
                end
                task.wait(8)
            end
            autoRaidLoop = nil
        end)
    end
    local function stopAutoRaid()
        if autoRaidLoop then
            task.cancel(autoRaidLoop)
            autoRaidLoop = nil
        end
    end
    local function watchIFrame(npcModel)
        local npcName = npcModel.Name
        if Shared.iframeConnections[npcName] then return end
        Shared.iframeConnections[npcName] = true
        npcModel.ChildAdded:Connect(function(child)
            if child.Name == "IFrame" then
                child.AncestryChanged:Connect(function()
                    if not child.Parent then
                        if Shared.healthJumped[npcName] then
                            Shared.iframeSeen[npcName] = true
                        end
                    end
                end)
            end
        end)
    end
    local function getCurrentRaidSelection()
        return Options.RaidSelected.Value
    end
    syncHandlers["raid"] = function()
        if not Toggles.AutoRaid.Value then
            stopAutoRaid()
            Shared.pauseAutoFarm = false
            Shared.autoRaidEnabled = false
            return
        end
        Shared.autoRaidEnabled = true
        Shared.selectedRaid = Options.RaidSelected.Value
        Shared.pauseAutoFarm = (game.PlaceId == 14890802310)
        startAutoRaid()
    end
    RaidGroup:AddToggle('AutoRaid', {
        Text = "Auto Raid",
        Default = false,
        Callback = function(Value)
            syncSystem("raid")
        end
    })
    RaidGroup:AddDropdown('RaidSelected', {
        Text = "Select Raid",
        Values = RAID_OPTIONS,
        Default = Shared.selectedRaid or "",
        Multi = false,
        Callback = function(Value)
            Shared.selectedRaid = Value
            if Toggles.AutoRaid.Value then
                syncSystem("raid")
            end
        end
    })
    RaidGroup:AddToggle('RetryRaid', {
        Text = "Auto Retry Raid",
        Default = false,
        Callback = function(value)
            autoRetryActive = value
            if value then
                local retryRaid = ReplicatedStorage
                    :WaitForChild("requests")
                    :WaitForChild("character")
                    :WaitForChild("retryraid")
                task.spawn(function()
                    while autoRetryActive and game.PlaceId ~= 14890802310 do 
                        if #Players:GetPlayers() > 1 then
                            hopToRandomServer()
                        end
                        if not findTarget() then
                            local elapsed = 0
                            local noEnemy = true
                            while elapsed < 30 and autoRetryActive do 
                                task.wait(1)
                                elapsed += 1
                                if findTarget() then
                                    noEnemy = false
                                    break
                                end
                            end
                            if noEnemy then
                                if Shared.sendWebhookEnabled then
                                    local sent = false
                                    for _ = 1, 5 do
                                        sent = Shared.raidWebhookHandler()
                                        if sent then break end
                                        task.wait(.5)
                                    end
                                end
                                retryRaid:FireServer()
                            end
                        end
                        task.wait(1)
                    end
                end)
                task.spawn(function()
                    while autoRetryActive do
                        local ok, enabled = pcall(function()
                            return player.PlayerGui.raidcomplete.Enabled
                        end)
                        if ok and enabled then
                            if Shared.sendWebhookEnabled then
                                task.wait(2)
                                local sent = false
                                for _ = 1, 10 do
                                    sent = Shared.raidWebhookHandler()
                                    if sent then break end
                                    task.wait(0.5)
                                end
                            end
                            pcall(function()
                                retryRaid:FireServer()
                            end)
                        end
                        task.wait(1)
                    end
                end)
            end
        end
    })
    RaidGroup:AddToggle('PrisonOptionsToggle', {
        Text = 'Prison Raid Options',
        Default = false,
        Tooltip = 'Show Anasui, Jolyne & Jotaro triggers'
    })
    local PrisonDepBox = RaidGroup:AddDependencyBox()
    PrisonDepBox:AddToggle('AnasuitToggle', {
        Text = "Trigger Anasui (Prison Raid)",
        Default = false,
        Callback = function(value)
            if not value then return end
            task.spawn(function()
                talkToNpc("Anasui", "Okay.")
                Toggles.AnasuitToggle:SetValue(false)
            end)
        end
    })
    PrisonDepBox:AddToggle('JolyneToggle', {
        Text = "Trigger Jolyne (Prison Raid)",
        Default = false,
        Callback = function(value)
            if not value then return end
            task.spawn(function()
                talkToNpc("Jolyne Kujo", "Yes.")
                Toggles.JolyneToggle:SetValue(false)
            end)
        end
    })
    PrisonDepBox:AddToggle('JotaroToggle', {
        Text = "Trigger Jotaro (Prison Raid)",
        Default = false,
        Callback = function(value)
            if not value then return end
            task.spawn(function()
                talkToNpc("Prisoner Conner", "Okay.")
                talkToNpc("Jotaro Kujo, Stone Ocean", "Sure.")
                Toggles.JotaroToggle:SetValue(false)
            end)
        end
    })
    PrisonDepBox:SetupDependencies({
        { Toggles.PrisonOptionsToggle, true }
    })
    VoidGroup:AddInput('VoidHealthThreshold', {
        Text = "Void Health Threshold",
        Default = "100",
        Placeholder = "Health(%) to trigger void",
        Callback = function(Value)
            local number = tonumber(Value)
            if number then
                Shared.VOID_HEALTH_THRESHOLD = number
            end
        end
    })
    VoidGroup:AddInput('VoidDelay', {
        Text = "Void Delay",
        Default = "2.5",
        Placeholder = "Delay void skill",
        Callback = function(Value)
            local number = tonumber(Value)
            if number then
                Shared.VOID_DELAY = number
            end
        end
    })
    VoidGroup:AddDropdown('VoidSkill', {
        Text = "Void Skill",
        Values = {"None", "X", "E", "R", "Z", "C", "V", "M2"},
        Default = "None",
        Multi = false,
        Callback = function(selected)
            Shared.vskill = selected
        end
    })
    VoidGroup:AddToggle('VoidToggle', {
        Text = "Void Toggle",
        Default = false,
        Callback = function(value)
            if value then
                if not Shared.voidCharAddedConnection then
                    Shared.voidCharAddedConnection = player.CharacterAdded:Connect(function(character)
                        if Shared.voidHumanoidDiedConnection then Shared.voidHumanoidDiedConnection:Disconnect() end
                        Shared.isVoiding = false
                        Shared.savedPos = nil
                        Shared.voidThresholdTriggered = {}
                        Shared.healthJumped = {}
                        Shared.iframeSeen = {}
                        Shared.lastHealth = {}
                        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                        if humanoid then
                            Shared.voidHumanoidDiedConnection = humanoid.Died:Connect(function()
                                Shared.isVoiding = false
                                Shared.savedPos = nil
                                local hrp = character:FindFirstChild("HumanoidRootPart")
                                if hrp then disableBodyControl(hrp) end
                            end)
                        end
                    end)
                end
                Shared.voidConnection = RunService.Heartbeat:Connect(function()
                    if not isPlayerAlive() then return end
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local targetHRP = Shared.currentTargetPart
                    if not targetHRP or not targetHRP.Parent then
                        if Shared.isVoiding then
                            disableBodyControl(hrp)
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then humanoid.PlatformStand = false end
                            if Shared.savedPos then hrp.CFrame = CFrame.new(Shared.savedPos) end
                        end
                        Shared.isVoiding = false
                        Shared.isPhase2 = false
                        return
                    end
                    if not isVoidTarget(targetHRP) then
                        if Shared.isVoiding then
                            disableBodyControl(hrp)
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then humanoid.PlatformStand = false end
                            if Shared.savedPos then hrp.CFrame = CFrame.new(Shared.savedPos) end
                        end
                        Shared.isPhase2 = false
                        Shared.isVoiding = false
                        return
                    end
                    watchIFrame(targetHRP.Parent)
                    local npcName = targetHRP.Parent.Name
                    local hum = targetHRP.Parent:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local currentHP = hum.Health
                        local maxHP = hum.MaxHealth
                        local hpPercent = (maxHP > 0 and (currentHP / maxHP * 100)) or 0
                        if not Shared.voidThresholdTriggered[npcName] and hpPercent <= Shared.VOID_HEALTH_THRESHOLD then
                            Shared.voidThresholdTriggered[npcName] = true
                        end
                        Shared.shouldVoid = Shared.voidThresholdTriggered[npcName] == true
                        local prevHP = Shared.lastHealth[npcName]
                        Shared.lastHealth[npcName] = currentHP
                        if prevHP and currentHP > (prevHP + 500) then
                            Shared.healthJumped[npcName] = true
                        end
                    end
                    if Shared.iframeSeen[npcName] and Shared.healthJumped[npcName] then
                        if not Shared.isPhase2 then
                        end
                        Shared.isPhase2 = true
                    end
                    local npcGrabbed = isGrabbed(targetHRP.Parent)
                    if not Shared.isVoiding and npcGrabbed and (Shared.isPhase2 or Shared.shouldVoid) then
                        if hrp.Position.Y > -50 then
                            Shared.savedPos = hrp.Position
                        end
                        Shared.isVoiding = true
                        enableBodyControl(hrp)
                    end
                    if Shared.isVoiding then
                        if npcGrabbed and (Shared.isPhase2 or Shared.shouldVoid) then
                            task.wait(0.2)
                            hrp.CFrame = CFrame.new(0, -470, 0)
                            causeLag()
                        else
                            
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then humanoid.PlatformStand = false end
                            if Shared.savedPos then hrp.CFrame = CFrame.new(Shared.savedPos) end
                            Shared.isVoiding = false
                        end
                    end
                end)
            else
                Shared.isVoiding = false
                Shared.isPhase2 = false
                Shared.savedPos = nil
                Shared.iframeConnections = {}
                Shared.iframeSeen = {}
                Shared.healthJumped = {}
                Shared.lastHealth = {}
                Shared.voidThresholdTriggered = {}
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then disableBodyControl(hrp) end
                end
                if Shared.voidConnection then Shared.voidConnection:Disconnect() Shared.voidConnection = nil end
                if Shared.voidCharAddedConnection then Shared.voidCharAddedConnection:Disconnect() Shared.voidCharAddedConnection = nil end
                if Shared.voidHumanoidDiedConnection then Shared.voidHumanoidDiedConnection:Disconnect() Shared.voidHumanoidDiedConnection = nil end
            end
        end
    })
    task.spawn(function()
        while true do
            if Toggles.VoidToggle and Toggles.VoidToggle.Value then
                local map = Workspace:FindFirstChild("Map")
                if map then
                    for _, obj in ipairs(map:GetDescendants()) do
                        if obj and obj.Parent and obj.Name:lower():find("spawn") then
                            pcall(function() obj:Destroy() end)
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end
local function setupShop()
    local craftRemote = ReplicatedStorage.requests.character:WaitForChild("craft")
    local craftingData = getData:InvokeServer("crafting")
    local allCraftables = {}
    for name, _ in pairs(craftingData) do
        table.insert(allCraftables, name)
    end
    table.sort(allCraftables)
    local selectedCrafts = {}
    local autoCrafting = false
    local function normalArrowLoop()
        while rollerActive.normal do
            repeat task.wait() until not isBusy
            if not rollerActive.normal then break end
            local old = getCurrentStand()
            local oldId = old and old.ID
            ReplicatedStorage.requests.character.use_item:FireServer("Stand Arrow")
            task.wait(0.5)
            local start = tick()
            local newStand
            repeat
                newStand = getCurrentStand()
                if newStand and newStand.ID ~= oldId then break end
                task.wait(0.3)
            until tick() - start > 5
            if newStand and doesStandPass(newStand) then
                stopRoller("normal")
                Library:Notify(("%s obtained! Stopping."):format(
                    newStand.Name .. (newStand.Skin and " ("..newStand.Skin..")" or "")
                ), nil, 3)
                break
            end
            task.wait(0.2)
        end
        rollerActive.normal = false
    end
    local function getPurchaseCount(data, raidName, itemName)
        if not data or not data.Version then return 0 end
        local versionKey = data.Version
        local purchases = data[versionKey] and data[versionKey][raidName]
        return purchases and (purchases[itemName] or 0) or 0
    end
    local RARITY_RANK = {
        Common = 1, Uncommon = 2, Rare = 3, Legendary = 4, Mythical = 5, Secret = 6
    }
    local raidShopPurchases = SlotData:WaitForChild("RaidShopPurchases")
    local raidShopRemote = ReplicatedStorage.requests.character:WaitForChild("raid_shop")
    local raidShopPurchases = game:GetService("Players").LocalPlayer:WaitForChild("PlayerData"):WaitForChild("SlotData"):WaitForChild("RaidShopPurchases")
    local itemData = getData:InvokeServer("item")
    local raidOptions = {
        "Jotaro Kujo",
        "Yoshikage Kira Bites the Dust",
        "Muhammad Avdol",
        "DIO",
        "Heaven Ascension DIO",
        "Death 13",
        "Prison Escape"
    }
    local itemOptions = {
        "Legendary Chest", "Kira's Coat", "Skull Tie", "Lucky Arrow", "Stand Arrow",
        "Serial Killer", "Siphon", "A Quiet Life", "Heaven Ascended Elixir", "Overrule Fate",
        "Heaven's Rule", "Heaven\226\128\153s Fire", "Chain Arm Wraps", "Jotaro's Coat", "True Warrior",
        "Grappler", "Intimidation", "Jotaro's Hat", "Prime Jotaro's Hat", "Powerful",
        "Prime Jotaro's Coat", "Nightmare Soul", "Desperation", "Daycare", "Mr. Downstairs",
        "Heart Headband", "Leech", "Emperor of Time", "The Godfather", "Stop Sign",
        "Retribution", "Shadow Axe", "King of Flames", "Disaster Flames", "Flame Keeper",
        "Flaming Medallion Necklace", "The Magician", "Conjurer", "Motorcycle Tire",
        "Low Level Keycard", "Containment", "Police Cap", "Shiv", "DISC Belt", "Time Resistant"
    }
    local selectedRaids = {}   
    local selectedItems = {}   
    RaidShopGroup:AddDropdown('RaidShopSelected', {
        Text = "Select Raid Shop",
        Values = raidOptions,
        Default = {},
        Multi = true,
        Callback = function(selected)
            selectedRaids = {}
            for name, active in pairs(selected or {}) do
                if active then table.insert(selectedRaids, name) end
            end
        end
    })
    RaidShopGroup:AddDropdown('RaidItemsSelected', {
        Text = "Select Raid Items to Buy",
        Values = itemOptions,
        Default = {},
        Multi = true,
        Callback = function(selected)
            selectedItems = {}
            for name, active in pairs(selected or {}) do
                if active then table.insert(selectedItems, name) end
            end
        end
    })
    RaidShopGroup:AddToggle('Raidshop', {
        Text = "Auto Buy Raid Shop",
        Default = false,
        Callback = function(value)
            if not value then
                autoBuyEnabled = false
                return
            end
            autoBuyEnabled = true
            task.spawn(function()
                local lastVersion = nil
                while autoBuyEnabled do
                    local currentData = HttpService:JSONDecode(raidShopPurchases.Value)
                    if currentData and currentData.Version then
                        if lastVersion ~= currentData.Version then
                            stoppedItems = {}
                            lastVersion = currentData.Version
                        end
                    else
                        currentData = nil
                    end
                    local firedItem = false
                    for _, raidName in ipairs(selectedRaids) do
                        for _, itemName in ipairs(selectedItems) do
                            local key = raidName .. "|" .. itemName
                            if not stoppedItems[key] then
                                local beforeCount = getPurchaseCount(currentData, raidName, itemName)
                                raidShopRemote:FireServer(itemName, raidName)
                                task.wait(0.3)
                                local newData = HttpService:JSONDecode(raidShopPurchases.Value)
                                local afterCount = getPurchaseCount(newData, raidName, itemName)
                                if afterCount <= beforeCount then
                                    stoppedItems[key] = true
                                end
                                firedItem = true
                                break
                            end
                        end
                        if firedItem then break end
                    end
                    if not firedItem then
                        task.wait(1)
                    end
                end
            end)
        end
    })
    ShopGroup:AddDropdown('MinRarity', {
        Text = "Shop Min Rarity",
        Values = {"Common", "Uncommon", "Rare", "Legendary", "Mythical", "Secret"},
        Default = "Legendary",
        Multi = false,
        Callback = function(selected)
            MIN_RARITY = selected
        end
    })
    ShopGroup:AddToggle('Shop', {
        Text = "Auto Buy Shop",
        Default = false,
        Callback = function(value)
            if not value then return end
            task.spawn(function()
                local cashShop = SlotData:WaitForChild("CashShop")
                local cashShopPurchases = SlotData:WaitForChild("CashShopPurchases")
                local cashShopRemote = ReplicatedStorage.requests.character:WaitForChild("cash_shop")
                local function getRarity(itemName)
                    if accessoryData and accessoryData[itemName] then
                        return accessoryData[itemName].Rarity
                    end
                    if itemData and itemData[itemName] then
                        return itemData[itemName].Rarity
                    end
                    return nil
                end
                local function buyEligibleItems()
                    local ok, shopTable = pcall(function()
                        return HttpService:JSONDecode(cashShop.Value)
                    end)
                    if not ok or not shopTable then return end
                    local ok2, purchasedTable = pcall(function()
                        return HttpService:JSONDecode(cashShopPurchases.Value)
                    end)
                    local purchased = (ok2 and purchasedTable) or {}
                    for itemName, itemInfo in pairs(shopTable) do
                        if itemName == "Version" then continue end
                        if not itemInfo or not itemInfo.Stock then continue end
                        local alreadyBought = purchased[itemName] or 0
                        local remaining = itemInfo.Stock - alreadyBought
                        if remaining <= 0 then continue end
                        local rarity = getRarity(itemName)
                        if not rarity then continue end
                        if (RARITY_RANK[rarity] or 0) >= (RARITY_RANK[MIN_RARITY] or 0) then
                            for _ = 1, remaining do
                                cashShopRemote:FireServer(itemName)
                                task.wait(0.3)
                            end
                        end
                    end
                end
                buyEligibleItems()
                cashShop.Changed:Connect(function()
                buyEligibleItems()
                end)
            end)
        end
    })
    ShopGroup:AddDropdown('SelectedCrafts', {
        Text = "Items to Craft",
        Values = allCraftables,
        Default = {},
        Multi = true,
        Callback = function(selected)
            selectedCrafts = {}
            for name, active in pairs(selected or {}) do
                if active then table.insert(selectedCrafts, name) end
            end
        end
    })
    ShopGroup:AddToggle('AutoCraft', {
        Text = "Auto Craft",
        Default = false,
        Callback = function(state)
            autoCrafting = state
            if state then
                task.spawn(function()
                    while autoCrafting do
                        for _, name in ipairs(selectedCrafts) do
                            if not autoCrafting then break end
                            craftRemote:FireServer(name)
                            task.wait(0.175)
                        end
                        task.wait() 
                    end
                end)
            end
        end
    })
end
local function setupInventory()
    local r = ReplicatedStorage.requests.character.use_item
    local EquippedAccessories = SlotData:WaitForChild("EquippedAccessories")
    local equipRemote         = ReplicatedStorage.requests.character:WaitForChild("equip_accessory")
    local sellRemote          = ReplicatedStorage.requests.general:WaitForChild("SellItem")
    local MIN_RARITY = "Legendary"
    local pipBonus = {
        Health             = 2,
        HealthRegeneration = 2,
        Defense            = 0.25,
        Power              = 3,
        PowerRegeneration  = 2,
        Penetration        = 2.5,
        PvEDamage          = 5
    }
    local function applyPips(item, accInfo)
        local stats = {}
        for k, v in pairs(accInfo) do
            if type(v) == "number" then stats[k] = v end
        end
        if item.Pips then
            for _, pip in pairs(item.Pips) do
                if pipBonus[pip] then
                    stats[pip] = (stats[pip] or 0) + pipBonus[pip]
                end
            end
        end
        return stats
    end
    local function deepEqual(a, b, sa, sb)
        sa, sb = sa or {}, sb or {}
        if a == b then return true end
        if type(a) ~= type(b) then return false end
        if type(a) ~= "table" then return a == b end
        if sa[a] and sb[b] then return sa[a] == b and sb[b] == a end
        sa[a] = b; sb[b] = a
        for k, v in pairs(a) do
            if b[k] == nil or not deepEqual(v, b[k], sa, sb) then return false end
        end
        for k in pairs(b) do
            if a[k] == nil then return false end
        end
        return true
    end
    local function scoreItem(item, accInfo)
        local stats = applyPips(item, accInfo)
        local total = 0
        local statCount = 0
        for _, val in pairs(stats) do
            if val > 0 then
                total += val
                statCount += 1
            end
        end
        local pipCount = item.Pips and #item.Pips or 0
        if priorStat and #priorStat > 0 then
            local statName = priorStat[1]
            local v = stats[statName]
            return { primary = v or 0, total = total, statCount = statCount, pipCount = pipCount }
        end
        return { primary = total, total = total, statCount = statCount, pipCount = pipCount }
    end
    local function isBetter(newScore, oldScore)
        if type(newScore) == "table" and type(oldScore) == "table" then
            if newScore.primary ~= oldScore.primary then return newScore.primary > oldScore.primary end
            if newScore.total ~= oldScore.total then return newScore.total > oldScore.total end
            if newScore.statCount ~= oldScore.statCount then return newScore.statCount > oldScore.statCount end
            return newScore.pipCount > oldScore.pipCount
        end
        return newScore > oldScore
    end
    local function getBestPerType(inventory)
        local bestPerType = {}
        for _, item in pairs(inventory) do
            if item.Locked then continue end
            local accInfo = accessoryData[item.Name]
            if not accInfo or not accInfo.AccessoryType then continue end
            local score = scoreItem(item, accInfo)
            if score == nil then continue end
            local slot = accInfo.AccessoryType
            if not bestPerType[slot] or isBetter(score, bestPerType[slot].score) then
                bestPerType[slot] = { item = item, accInfo = accInfo, score = score }
            end
        end
        return bestPerType
    end
    local function unequipAll()
        local equippedNow = HttpService:JSONDecode(EquippedAccessories.Value)
        for slot, item in pairs(equippedNow) do
            local accInfo = accessoryData[item.Name]
            if accInfo then
                equipRemote:FireServer({ Name = item.Name, Original = item, Data = item, New = accInfo })
                task.wait(0.35)
            end
        end
    end
    local RARITY_OPTIONS = {"Common", "Uncommon", "Rare", "Legendary", "Mythical", "Secret"}
    local autoSellEnabled = false
    local autoSellLimit = 300   
    local selectedRarities = {}
    local function autoSell()
        if not autoSellEnabled then return end
        if #selectedRarities == 0 then return end
        local inventory = HttpService:JSONDecode(Inventory.Value)
        local equipped  = HttpService:JSONDecode(EquippedAccessories.Value)
        local totalInventory = #inventory
        if totalInventory <= autoSellLimit then return end  
        local sellCandidates = {}
        for _,itemData in pairs(inventory) do
            if not itemData.Locked then
                local accInfo = accessoryData[itemData.Name]
                if accInfo and accInfo.Rarity then
                    if table.find(selectedRarities, accInfo.Rarity) then
                        local bestPerType = getBestPerType(inventory)
                        local slot = accInfo.AccessoryType
                        local isEquipped = equipped[slot] and deepEqual(equipped[slot], itemData)
                        local isBest = bestPerType[slot] and deepEqual(bestPerType[slot].item, itemData)
                        if not isEquipped and not isBest then
                            local score = scoreItem(itemData, accInfo)  
                            table.insert(sellCandidates, {
                                item = itemData,
                                accInfo = accInfo,
                                score = score
                            })
                        end
                    end
                end
            end
        end
        if #sellCandidates == 0 then return end
        table.sort(sellCandidates, function(a, b)
            if a.score == nil then return true end
            if b.score == nil then return false end
            return isBetter(b.score, a.score)
        end)
        local toSell = {}
        local seen = {}
        for _, candidate in ipairs(sellCandidates) do
            local item = candidate.item
            if item.ID then
                table.insert(toSell, { ID = item.ID, Name = item.Name, Pips = item.Pips, duplicates = 1 })
            else
                local key = item.Name
                if seen[key] then
                    seen[key].duplicates = seen[key].duplicates + 1
                else
                    local entry = { Name = item.Name, Pips = item.Pips, duplicates = 1 }
                    seen[key] = entry
                    table.insert(toSell, entry)
                end
            end
        end
        if #toSell > 0 then
            sellRemote:FireServer(toSell)
        end
    end
    local CHEST_OPTIONS = {
        "Rare Chest",
        "Legendary Chest",
        "Common Chest",
    }
    local autoOpenEnabled = false
    local autoOpenThread = nil
    local selectedChests = {}   
    local isBusy = false
    local busyConnection = ReplicatedStorage.requests.character_server_client.communicate.OnClientEvent:Connect(function(data)
        if data.Player == LocalPlayer then
            isBusy = data.Busy
        end
    end)
    local minStrength = 1
    local minSpeed = 1
    local minSpecialty = 1
    local allowedTraits = {}
    local allowedStands = {}
    local allowedSkins = {}
    local standFolder = ReplicatedStorage.modules.vfx.stands
    local skinFolder  = ReplicatedStorage.assets.models.stands.Skins
    local allStandNames = {}
    for _, f in ipairs(standFolder:GetChildren()) do
        if f:IsA("Folder") then table.insert(allStandNames, f.Name) end
    end
    table.sort(allStandNames)
    local allSkinNames = {}
    for _, m in ipairs(skinFolder:GetChildren()) do
        if m:IsA("Model") then table.insert(allSkinNames, m.Name) end
    end
    table.sort(allSkinNames)
    local allTraits = {
        "Elegant","Feral","Demonic","Transcendent",
        "Methodical","Dominant","Cursed","Rhythmic","Artistic","Suffocating",
        "Determined","Compassionate","Furious","Slugger","Fearful","Durable",
        "Curious","Astute","Predictive","Kind",
        "Erratic","Energetic","Cowardly","Happy","Firm","Arrogant"
    }
    local vfxRandom = ReplicatedStorage.modules.vfx.random
    local vfxToRarity = {
        [vfxRandom["Lucky Arrow Common"]]   = "Common",
        [vfxRandom["Lucky Arrow Rare"]]     = "Rare",
        [vfxRandom["Lucky Arrow Mythical"]] = "Mythical",
    }
    local function getCurrentStand()
        local json = SlotData.Stand.Value
        if not json or json == "" then return nil end
        local ok, data = pcall(HttpService.JSONDecode, HttpService, json)
        return ok and data or nil
    end
    local function doesStandPass(stand)
        if not stand then return false end
        if Toggles.StopOnAnySkin and Toggles.StopOnAnySkin.Value and stand.Skin and stand.Skin ~= "" then
            return true
        end
        local anyFilter = minStrength > 1 or minSpeed > 1 or minSpecialty > 1
            or #allowedTraits > 0 or #allowedStands > 0 or #allowedSkins > 0
        if not anyFilter then return false end
        if minStrength > (stand.Strength or 0) then return false end
        if minSpeed > (stand.Speed or 0) then return false end
        if minSpecialty > (stand.Specialty or 0) then return false end
        if #allowedTraits > 0 and not table.find(allowedTraits, stand.Trait) then return false end
        if #allowedStands > 0 and not table.find(allowedStands, stand.Name) then return false end
        if #allowedSkins > 0 and (not stand.Skin or not table.find(allowedSkins, stand.Skin)) then return false end
        return true
    end
    local rollerActive = { normal = false, lucky = false }
    local vfxConnLucky = nil   
    local function stopRoller(which)
        rollerActive[which] = false
        if which == "normal" then
            Toggles.AutoStandArrow:SetValue(false)
        elseif which == "lucky" then
            Toggles.AutoLuckyArrow:SetValue(false)
        end
    end
    local function luckyArrowLoop()
        local vfxStop = false
        local vfxStopRarity = nil
        if vfxConnLucky then vfxConnLucky:Disconnect() end
        vfxConnLucky = ReplicatedStorage.requests.general.vfx.OnClientEvent:Connect(function(module, data)
            if not rollerActive.lucky then return end
            if data.Character ~= LocalPlayer.Character then return end
            local rarity = vfxToRarity[module]
            if rarity and selectedRarities[rarity] then
                vfxStop = true
                vfxStopRarity = rarity
            end
        end)
        while rollerActive.lucky do
            repeat task.wait() until not isBusy
            if not rollerActive.lucky then break end
            local old = getCurrentStand()
            local oldId = old and old.ID
            ReplicatedStorage.requests.character.use_item:FireServer("Lucky Arrow")
            task.wait(0.5)
            local start = tick()
            local newStand
            repeat
                newStand = getCurrentStand()
                if vfxStop then break end
                if newStand and newStand.ID ~= oldId then break end
                task.wait(0.3)
            until tick() - start > 6
            local stopped = false
            if vfxStop then
                stopRoller("lucky")
                Library:Notify(("%s obtained, stopped...").format(vfxStopRarity), nil, 3)
                stopped = true
            elseif newStand and doesStandPass(newStand) then
                stopRoller("lucky")
                Library:Notify(("%s obtained! Stopping."):format(
                    newStand.Name .. (newStand.Skin and " ("..newStand.Skin..")" or "")
                ), nil, 3)
                stopped = true
            end
            if stopped then break end
            task.wait(0.2)
        end
        if vfxConnLucky then
            vfxConnLucky:Disconnect()
            vfxConnLucky = nil
        end
        rollerActive.lucky = false
    end
    StandGroup:AddDropdown('StopOnSkin', {
        Text = "Stop On Rarity (For Lucky Arrow)",
        Values = {"Common", "Rare", "Mythical"},
        Default = { "Mythical" },
        Multi = true,
        Callback = function(selected)
            selectedRarities = {}
            for _, rarity in ipairs(selected) do
                selectedRarities[rarity] = true
            end
        end
    })
    StandGroup:AddDropdown('MinStrength', {
        Text = "Minimum Strength",
        Values = {1,2,3,4,5},
        Default = 1,
        Multi = false,
    })
    Options.MinStrength:OnChanged(function(Value) minStrength = Value end)
    StandGroup:AddDropdown('MinSpeed', {
        Text = "Minimum Speed",
        Values = {1,2,3,4,5},
        Default = 1,
        Multi = false,
    })
    Options.MinSpeed:OnChanged(function(Value) minSpeed = Value end)
    StandGroup:AddDropdown('MinSpecialty', {
        Text = "Minimum Specialty",
        Values = {1,2,3,4,5},
        Default = 1,
        Multi = false,
    })
    Options.MinSpecialty:OnChanged(function(Value) minSpecialty = Value end)
    StandGroup:AddDropdown('AllowedTraits', {
        Text = "Allowed Traits",
        Values = allTraits,
        Default = {},
        Multi = true,
    })
    Options.AllowedTraits:OnChanged(function()
        local tbl = {}
        for k, v in pairs(Options.AllowedTraits.Value) do
            if v then table.insert(tbl, k) end
        end
        allowedTraits = tbl
    end)
    StandGroup:AddDropdown('AllowedStands', {
        Text = "Stands to Stop At",
        Values = allStandNames,
        Default = {},
        Multi = true,
    })
    Options.AllowedStands:OnChanged(function()
        local tbl = {}
        for k, v in pairs(Options.AllowedStands.Value) do
            if v then table.insert(tbl, k) end
        end
        allowedStands = tbl
    end)
    StandGroup:AddDropdown('AllowedSkins', {
        Text = "Skins to Stop At",
        Values = allSkinNames,
        Default = {},
        Multi = true,
    })
    Options.AllowedSkins:OnChanged(function()
        local tbl = {}
        for k, v in pairs(Options.AllowedSkins.Value) do
            if v then table.insert(tbl, k) end
        end
        allowedSkins = tbl
    end)
    StandGroup:AddToggle('StopOnAnySkin', {
        Text = "Stop on Any Skin",
        Default = false,
    })
    StandGroup:AddToggle('AutoStandArrow', {
        Text = "Auto Stand Arrow",
        Default = false,
        Callback = function(val)
            rollerActive.normal = val
            if val then
                task.spawn(normalArrowLoop)
            end
        end
    })
    StandGroup:AddToggle('AutoLuckyArrow', {
        Text = "Auto Lucky Arrow",
        Default = false,
        Callback = function(val)
            rollerActive.lucky = val
            if val then
                task.spawn(luckyArrowLoop)
            end
        end
    })
    InvGroup:AddDropdown('PriorStat', {
        Text = "Priorities Stat",
        Values = {
            "Health",
            "HealthRegeneration",
            "Defense",
            "Power",
            "PowerRegeneration",
            "Penetration",
            "PvEDamage"
        },
        Default = { "PvEDamage" },
        Multi = true,
        AllowNull = true,
        Callback = function(selected)
            priorStat = {}
            for name, active in pairs(selected or {}) do
                if active then table.insert(priorStat, name) end
            end
        end
    })
    InvGroup:AddDropdown('ChestSelected', {
        Text = "Chests to Open",
        Values = CHEST_OPTIONS,
        Default = {},
        Multi = true,
        Callback = function(selected)
            selectedChests = {}
            for name, active in pairs(selected or {}) do
                if active then table.insert(selectedChests, name) end
            end
        end
    })
    InvGroup:AddToggle('AutoChest', {
        Text = "Auto Open Chests",
        Default = false,
        Callback = function(value)
            autoOpenEnabled = value
            if value then
                if autoOpenThread then return end
                autoOpenThread = task.spawn(function()
                    while autoOpenEnabled do
                        for _, chestName in ipairs(selectedChests) do
                            if not autoOpenEnabled then break end
                            r:FireServer(chestName, { UseAll = true })
                            task.wait(0.3)  
                        end
                        task.wait(1) 
                    end
                    autoOpenThread = nil
                end)
            else
                autoOpenThread = nil
            end
        end
    })
    InvGroup:AddButton({
        Text = "Sell Items",
        Func = function()
            local success, err = pcall(function()
                local inventory = HttpService:JSONDecode(Inventory.Value)
                local equipped  = HttpService:JSONDecode(EquippedAccessories.Value)
                local bestPerType = getBestPerType(inventory)
                local toSell, seen = {}, {}
                for _, item in pairs(inventory) do
                    if item.Locked then continue end
                    local accInfo = accessoryData[item.Name]
                    if not accInfo then continue end
                    local slot = accInfo.AccessoryType
                    if deepEqual(equipped[slot], item) then continue end
                    if bestPerType[slot] and deepEqual(bestPerType[slot].item, item) then continue end
                    if item.ID then
                        table.insert(toSell, { ID = item.ID, Name = item.Name, Pips = item.Pips, duplicates = 1 })
                    else
                        local key = item.Name
                        if seen[key] then
                            seen[key].duplicates += 1
                        else
                            local entry = { Name = item.Name, Pips = item.Pips, duplicates = 1 }
                            seen[key] = entry
                            table.insert(toSell, entry)
                        end
                    end
                end
                if #toSell > 0 then
                    sellRemote:FireServer(toSell)
                end
            end)
            if not success then
                Library:Notify("Sell Items failed: " .. tostring(err), "Error", 5)
            end
        end
    })
    InvGroup:AddButton({
        Text = "Equip Best",
        Func = function()
            local success, err = pcall(function()
                unequipAll()
                local inventory = HttpService:JSONDecode(Inventory.Value)
                local bestPerType = getBestPerType(inventory)
                for slot, best in pairs(bestPerType) do
                    equipRemote:FireServer({
                        Name     = best.item.Name,
                        Original = best.item,
                        Data     = best.item,
                        New      = best.accInfo
                    })
                    task.wait(0.35)
                end
            end)
            if not success then
                Library:Notify("Equip Best failed: " .. tostring(err), "Error", 5)
            end
        end
    })
    InvGroup:AddInput('InvAccessoriesThreshold', {
        Text = "Inv Accessories Threshold",
        Default = "300",
        Placeholder = "Enter number",
        Callback = function(text)
            local num = tonumber(text)
            if num then
                autoSellLimit = num
            end
        end
    })
    InvGroup:AddDropdown('AutoSellRarity', {
        Text = "Rarities to Sell",
        Values = RARITY_OPTIONS,
        Default = {},
        Multi = true,
        Callback = function(selected)
            selectedRarities = {}
            for name, active in pairs(selected or {}) do
                if active then table.insert(selectedRarities, name) end
            end
        end
    })
    InvGroup:AddToggle('AutoSell', {
        Text = "Auto Sell Accessories",
        Default = false,
        Callback = function(value)
            autoSellEnabled = value
            if value then
                if autoSellConnection then autoSellConnection:Disconnect() end
                autoSellConnection = Inventory.Changed:Connect(autoSell)
                autoSell()
            else
                if autoSellConnection then autoSellConnection:Disconnect() end
            end
        end
    })
end
local function setupQuests()
    local running = { main = false, alt = false }
    local questIndex = 1
    local function getNearestBoard(mode)
        mode = mode or "PvP"  
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local boards = Workspace.Map["Mission Boards"][mode]:GetChildren()
        local nearest, nearestDist = nil, math.huge
        for _, board in ipairs(boards) do
            local prompt = board:FindFirstChild("ProximityPrompt")
            if not prompt then continue end
            local boardPos = resolvePosition(board)
            if not boardPos then continue end
            local dist = (boardPos - root.Position).Magnitude
            if dist < nearestDist then
                nearest = board
                nearestDist = dist
            end
        end
        return nearest
    end
    local function joinQueue()
        local joined = false
        local debounce = false
        local leftCooldown = false
        local conn = notification.OnClientEvent:Connect(function(msg)
            if debounce then return end
            debounce = true
            if msg == "Joined PvP Mission Queue." then
                joined = true
            elseif msg == "Left PvP Mission Queue." then
                joined = false
                leftCooldown = true
                task.delay(1.5, function()
                    leftCooldown = false
                end)
            end
            task.wait(0.2)
            debounce = false
        end)
        while not joined do
            if not leftCooldown then
                local board = getNearestBoard()
                if board then
                    local prompt = board:FindFirstChild("ProximityPrompt")
                    local boardPos
                    if board:IsA("BasePart") then
                        boardPos = board.Position
                    elseif board:IsA("Model") and board.PrimaryPart then
                        boardPos = board.PrimaryPart.Position
                    end
                    if boardPos then
                        local char = player.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.CFrame = CFrame.new(boardPos + Vector3.new(0, 3, 0))
                        end
                    end
                    task.wait(0.2)
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                end
            end
            task.wait(0.5)
        end
        conn:Disconnect()
    end
    QGroup:AddToggle('PvPMain', {
        Text = "PvP Queue (Main)",
        Default = false,
        Callback = function(value)
            running.main = value
            if not value then return end
            task.spawn(function()
                while running.main do
                    joinQueue()
                    waitForNotification("Your opponent")    
                    waitForNotification("Complete") 
                end
            end)
        end
    })
    QGroup:AddToggle('PvPAlt', {
        Text = "PvP Queue (Alt)",
        Default = false,
        Callback = function(value)
            running.alt = value
            if not value then return end
            task.spawn(function()
                while running.alt do
                    joinQueue()
                    waitForNotification("Your opponent") 
                    resetCharacter()
                    waitForRespawn()
                end
            end)
        end
    })
    QGroup:AddButton({
        Text = "Teleport to Quest",
        Func = function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local markers = {}
            for _, child in ipairs(Workspace.Effects.questbrick:GetChildren()) do
                if child.Name == "Quest Marker" and child.Enabled then
                    table.insert(markers, child.Parent)
                end
            end
            if #markers == 0 then return end
            if questIndex > #markers then questIndex = 1 end
            local brick = markers[questIndex]
            local brickPos = resolvePosition(brick)
            if brickPos then
                root.CFrame = CFrame.new(brickPos + Vector3.new(0, 4, 0))
            end
            questIndex = questIndex % #markers + 1
        end
    })
end
local function setupMisc()
    local character = player.Character or player.CharacterAdded:Wait()
    local blackScreenGui = nil
    local function enableBlackScreen()
        pcall(function()
            RunService:Set3dRenderingEnabled(false)
        end)
        if blackScreenGui then
            blackScreenGui:Destroy()
        end
        blackScreenGui = Instance.new("ScreenGui")
        blackScreenGui.Name = "d"
        blackScreenGui.ResetOnSpawn = false
        blackScreenGui.IgnoreGuiInset = true
        blackScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local frame = Instance.new("Frame")
        frame.Name = "BlackFrame"
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.Position = UDim2.new(0, 0, 0, 0)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0
        frame.Parent = blackScreenGui
        blackScreenGui.Parent = PlayerGui
    end
    local function disableBlackScreen()
        pcall(function()
            RunService:Set3dRenderingEnabled(true)
        end)
        if blackScreenGui then
            blackScreenGui:Destroy()
            blackScreenGui = nil
        end
        for _, gui in pairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name == "d" then
                gui:Destroy()
            end
        end
    end
    local PlayerData = LocalPlayer:WaitForChild("PlayerData")
    local Achievements = PlayerData:WaitForChild("Achievements")
    if not _G.Settings then
        _G.Settings = {
            Players = { ["Ignore Me"] = false, ["Ignore Others"] = false, ["Ignore Tools"] = false },
            Meshes = { NoMesh = false, NoTexture = false },
            Images = { Invisible = true },
            Explosions = { Smaller = true, Invisible = true },
            Particles = { Invisible = true },
            TextLabels = { LowerQuality = true, Invisible = true },
            MeshParts = { LowerQuality = false, Invisible = false, NoTexture = false, NoMesh = false },
            Other = {
                ["No Camera Effects"] = true,
                ["No Clothes"] = true,
                ["Low Water Graphics"] = true,
                ["No Shadows"] = true,
                ["Low Rendering"] = true,
                ["Low Quality Parts"] = true,
                ["Reset Materials"] = true
            }
        }
    end
    if not _G.Ignore then _G.Ignore = {} end
    local ME = Players.LocalPlayer
    local CanBeEnabled = {"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles"}
    local function PartOfCharacter(Inst)
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= ME and v.Character and Inst:IsDescendantOf(v.Character) then
                return true
            end
        end
        return false
    end
    local function DescendantOfIgnore(Inst)
        for _, v in pairs(_G.Ignore) do
            if Inst:IsDescendantOf(v) then return true end
        end
        return false
    end
    local function CheckIfBad(Inst)
        if not Inst:IsDescendantOf(Players) and (_G.Settings.Players["Ignore Others"] and not PartOfCharacter(Inst) or not _G.Settings.Players["Ignore Others"]) and (_G.Settings.Players["Ignore Me"] and ME.Character and not Inst:IsDescendantOf(ME.Character) or not _G.Settings.Players["Ignore Me"]) and (_G.Settings.Players["Ignore Tools"] and not Inst:IsA("BackpackItem") and not Inst:FindFirstAncestorWhichIsA("BackpackItem") or not _G.Settings.Players["Ignore Tools"]) and (_G.Ignore and not table.find(_G.Ignore, Inst) and not DescendantOfIgnore(Inst) or (not _G.Ignore or type(_G.Ignore) ~= "table" or #_G.Ignore <= 0)) then
            if Inst:IsA("DataModelMesh") then
                if Inst:IsA("SpecialMesh") then
                    if _G.Settings.Meshes.NoMesh then Inst.MeshId = "" end
                    if _G.Settings.Meshes.NoTexture then Inst.TextureId = "" end
                end
                if _G.Settings.Meshes.Destroy then Inst:Destroy() end
            elseif Inst:IsA("FaceInstance") then
                if _G.Settings.Images.Invisible then Inst.Transparency = 1; Inst.Shiny = 1 end
                if _G.Settings.Images.Destroy then Inst:Destroy() end
            elseif Inst:IsA("ShirtGraphic") then
                if _G.Settings.Images.Invisible then Inst.Graphic = "" end
                if _G.Settings.Images.Destroy then Inst:Destroy() end
            elseif table.find(CanBeEnabled, Inst.ClassName) then
                if _G.Settings.Particles and _G.Settings.Particles.Invisible then Inst.Enabled = false end
                if _G.Settings.Particles and _G.Settings.Particles.Destroy then Inst:Destroy() end
            elseif Inst:IsA("PostEffect") and (_G.Settings.Other and _G.Settings.Other["No Camera Effects"]) then
                Inst.Enabled = false
            elseif Inst:IsA("Explosion") then
                if _G.Settings.Explosions.Smaller then Inst.BlastPressure = 1; Inst.BlastRadius = 1 end
                if _G.Settings.Explosions.Invisible then Inst.BlastPressure = 1; Inst.BlastRadius = 1; Inst.Visible = false end
                if _G.Settings.Explosions.Destroy then Inst:Destroy() end
            elseif Inst:IsA("Clothing") or Inst:IsA("SurfaceAppearance") or Inst:IsA("BaseWrap") then
                if _G.Settings.Other["No Clothes"] then Inst:Destroy() end
            elseif Inst:IsA("BasePart") and not Inst:IsA("MeshPart") then
                if _G.Settings.Other["Low Quality Parts"] then Inst.Material = Enum.Material.Plastic; Inst.Reflectance = 0 end
            elseif Inst:IsA("TextLabel") and Inst:IsDescendantOf(Workspace) then
                if _G.Settings.TextLabels.LowerQuality then Inst.Font = Enum.Font.SourceSans; Inst.TextScaled = false; Inst.RichText = false; Inst.TextSize = 14 end
                if _G.Settings.TextLabels.Invisible then Inst.Visible = false end
                if _G.Settings.TextLabels.Destroy then Inst:Destroy() end
            elseif Inst:IsA("Model") then
            elseif Inst:IsA("MeshPart") then
                if _G.Settings.MeshParts.LowerQuality then Inst.RenderFidelity = 2; Inst.Reflectance = 0; Inst.Material = Enum.Material.Plastic end
                if _G.Settings.MeshParts.Invisible then Inst.Transparency = 1; Inst.RenderFidelity = 2; Inst.Reflectance = 0; Inst.Material = Enum.Material.Plastic end
                if _G.Settings.MeshParts.NoTexture then Inst.TextureID = "" end
                if _G.Settings.MeshParts.NoMesh then Inst.MeshId = "" end
                if _G.Settings.MeshParts.Destroy then Inst:Destroy() end
            end
        end
    end
    local npcNames = {}
    if Workspace:FindFirstChild("Npcs") then
        for _, npc in ipairs(Workspace.Npcs:GetChildren()) do
            if npc:IsA("Model") and npc.PrimaryPart then
                table.insert(npcNames, npc.Name)
            end
        end
    end
    local cacheFolder = ReplicatedStorage:FindFirstChild("assets") and ReplicatedStorage.assets:FindFirstChild("npc_cache")
    if cacheFolder then
        for _, npc in ipairs(cacheFolder:GetChildren()) do
            if npc:IsA("Model") and npc.PrimaryPart and not table.find(npcNames, npc.Name) then
                table.insert(npcNames, npc.Name)
            end
        end
    end
    table.sort(npcNames)
    local shopFrames = {}
    local uiMap = {
            ["Cash Shop"]     = PlayerGui["Cash Shop"].cash_shop,
            ["Crafting"]      = PlayerGui.Crafting.holder,
            ["Gang Shop"]     = PlayerGui["Gang Shop"].gang_shop,
            ["Prestige Shop"] = PlayerGui["Prestige Shop"].prestige_shop,
            ["Raid Shop"]     = PlayerGui["Raid Shop"].raid_shop,
            ["Title"]   = PlayerGui.titles.holder
        }
    MiscGroup:AddDropdown('OpenUI', {
        Text = "Open UI",
        Values = {"None", "Cash Shop", "Crafting", "Gang Shop", "Prestige Shop", "Raid Shop", "Title"},
        Default = "None",
        Multi = false,
        Callback = function(selected)
            for _, frame in pairs(uiMap) do
                pcall(function() frame.Visible = false end)
            end
            if selected ~= "None" and uiMap[selected] then
                pcall(function() uiMap[selected].Visible = true end)
            end
        end
    })
    MiscGroup:AddDropdown('NpcSelect', {
        Text = "Select NPC",
        Values = npcNames,
        Default = "",
        Multi = false,
        Callback = function(val) selectedNpc = val end
    })
    MiscGroup:AddButton({
        Text = "Teleport to NPC",
        Func = function()
            if not selectedNpc then return end
            local npc = Workspace.Npcs:FindFirstChild(selectedNpc)
            if not npc and cacheFolder then npc = cacheFolder:FindFirstChild(selectedNpc) end
            if npc and npc.PrimaryPart then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(npc:GetPivot().Position + Vector3.new(0, 5, 0))
                end
            end
        end
    })
    MiscGroup:AddToggle('BoostFps', {
        Text = "FPS Boost",
        Default = false,
        Callback = function(value)
            if not value then return end
            task.spawn(function()
                pcall(function()
                    local effects = Workspace:FindFirstChild("Effects")
                    if effects then
                        print("[FPS Boost] Destroying workspace.Effects")
                        effects:Destroy()
                    else
                        warn("[FPS Boost] workspace.Effects not found")
                    end
                end)
                pcall(function()
                    if _G.Settings.Other["Low Water Graphics"] then
                        local terrain = Workspace:FindFirstChildOfClass("Terrain")
                        if terrain then
                            terrain.WaterWaveSize = 0
                            terrain.WaterWaveSpeed = 0
                            terrain.WaterReflectance = 0
                            terrain.WaterTransparency = 0
                            if sethiddenproperty then sethiddenproperty(terrain, "Decoration", false) end
                        end
                    end
                end)
                pcall(function()
                    if _G.Settings.Other["No Shadows"] then
                        Lighting.GlobalShadows = false
                        Lighting.FogEnd = 9e9
                        Lighting.ShadowSoftness = 0
                        if sethiddenproperty then sethiddenproperty(Lighting, "Technology", 2) end
                    end
                end)
                pcall(function()
                    if _G.Settings.Other["Low Rendering"] then
                        settings().Rendering.QualityLevel = 1
                        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
                    end
                end)
                pcall(function()
                    if _G.Settings.Other["Reset Materials"] then
                        for _, v in pairs(MaterialService:GetChildren()) do
                            v:Destroy()
                        end
                        MaterialService.Use2022Materials = false
                    end
                end)
                for _, v in pairs(game:GetDescendants()) do
                    CheckIfBad(v)
                end
                game.DescendantAdded:Connect(function(v)
                    task.wait(0.1)
                    CheckIfBad(v)
                end)
            end)
        end
    })
    MiscGroup:AddToggle('BlackScreen', {
        Text = "Black Screen",
        Default = false,
        Callback = function(value)
            if value then
                enableBlackScreen()
            else
                disableBlackScreen()
            end
        end
    })
    MiscGroup:AddButton({
        Text = "Redeem All Achievements",
        Func = function()
            local achData = getData:InvokeServer("achievement")
            local progress = HttpService:JSONDecode(Achievements.Value)
            local claimed = progress.Claimed or {}
            for achName, achInfo in pairs(achData) do
                if not claimed[achName] and achInfo.Requirements then
                    local done = true
                    for reqName, reqAmt in pairs(achInfo.Requirements) do
                        if (progress[reqName] or 0) < reqAmt then
                            done = false
                            break
                        end
                    end
                    if done then
                        ReplicatedStorage.requests.character.ClaimAchievement:FireServer(achName)
                        task.wait(0.15) 
                    end
                end
            end
        end
    })
    MiscGroup:AddButton({
        Text = "Redeem All Codes",
        Func = function()
            local codes = {
                "Delay1",
                "Delay2",
                "Delay3",
                "Update1",
                "BizarreLineage1",
                "LikeTheGameForMore1",
                "FavoriteTheGame1",
                "Update2=2027",
                "250kLikes",
                "500kLikes",
                "750LikesforNextCode"
            }
            for _, code in ipairs(codes) do
                pcall(function()
                    ReplicatedStorage.requests.general.redeemcode:FireServer(code)
                end)
                task.wait(0.5)
            end
        end
    })
    AddSliderToggle({ Group = PlayerGroup, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
    local TPW_T, TPW_S = AddSliderToggle({ Group = PlayerGroup, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
    AddSliderToggle({ Group = PlayerGroup, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
    AddSliderToggle({ Group = PlayerGroup, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
    PlayerGroup:AddToggle("Noclip2", { Text = "Noclip" })
    PlayerGroup:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
    AddSliderToggle({ Group = PlayerGroup, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
    AddSliderToggle({ Group = PlayerGroup, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
    AddSliderToggle({ Group = PlayerGroup, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
    AddSliderToggle({ Group = PlayerGroup, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
    PlayerGroup:AddToggle("Fullbright2", { Text = "Fullbright" })
    PlayerGroup:AddToggle("NoFog2", { Text = "No Fog" })
    PlayerGroup:AddToggle("InstantPP2", { Text = "Instant Prompt" })
    ServerGroup:AddToggle("AntiAFK2", { Text = "Anti AFK", Default = true })
    ServerGroup:AddToggle("AntiKick2", { Text = "Anti Kick (Client)" })
    ServerGroup:AddToggle("AutoReconnect2", { Text = "Auto Reconnect" })
    ServerGroup:AddToggle("NoGameplayPaused2", { Text = "No Gameplay Paused" })
    ServerGroup:AddButton({ Text = "Serverhop", Func = function()
        local ok, res = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            ))
        end)
        if not ok or not res or not res.data then
            return
        end
        local currentId = game.JobId
        for _, server in ipairs(res.data) do
            if server.id ~= currentId and server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                return
            end
        end
    end })
    ServerGroup:AddButton({ Text = "Rejoin", Func = function()
        TeleportService:Teleport(game.PlaceId, player)
    end })
    ServerGroup:AddToggle("AutoServerhop2", { Text = "Auto Serverhop" })
    ServerGroup:AddSlider("AutoHopMins2", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
    RunService.Stepped:Connect(function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if Toggles.WS.Value then hum.WalkSpeed = Options.WSValue.Value end
            if Toggles.JP.Value then hum.JumpPower = Options.JPValue.Value; hum.UseJumpPower = true end
            if Toggles.HH.Value then hum.HipHeight = Options.HHValue.Value end
        end
        Workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 196
        if Toggles.FOV.Value then Workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
        if Toggles.Zoom.Value then player.CameraMaxZoomDistance = Options.ZoomValue.Value end
    end)
    local function FuncTPW()
        while Toggles.TPW.Value do
            local delta = RunService.Heartbeat:Wait()
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health > 0 and hum.MoveDirection.Magnitude > 0 then
                char:TranslateBy(hum.MoveDirection * Options.TPWValue.Value * delta * 10)
            end
        end
    end
    Toggles.TPW:OnChanged(function(v)
        if v then task.spawn(FuncTPW) end
    end)
    Toggles.Noclip2:OnChanged(function(v)
        if not v then return end
        task.spawn(function()
            while Toggles.Noclip2.Value do
                RunService.Stepped:Wait()
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end)
    local _knockbackConns = {}
    local function ApplyAntiKB(char)
        if not char then return end
        local root = char:WaitForChild("HumanoidRootPart", 10)
        if root then
            local conn = root.ChildAdded:Connect(function(child)
                if not Toggles.AntiKnockback.Value then return end
                if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
                    child:Destroy()
                end
            end)
            table.insert(_knockbackConns, conn)
        end
    end
    Toggles.AntiKnockback:OnChanged(function(state)
        for _, c in ipairs(_knockbackConns) do if c then c:Disconnect() end end
        table.clear(_knockbackConns)
        if not state then return end
        if player.Character then ApplyAntiKB(player.Character) end
        local charConn = player.CharacterAdded:Connect(function(c) ApplyAntiKB(c) end)
        table.insert(_knockbackConns, charConn)
    end)
    task.spawn(function()
        while true do
            task.wait()
            if Toggles.Fullbright2.Value then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.GlobalShadows = false
            elseif Toggles.OverrideTime.Value then
                Lighting.ClockTime = Options.OverrideTimeValue.Value
            end
            if Toggles.NoFog2.Value then Lighting.FogEnd = 9e9 end
            if Library.Unloaded then break end
        end
    end)
    game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
        if Toggles.InstantPP2 and Toggles.InstantPP2.Value then
            prompt.HoldDuration = 0
        end
    end)
    local function DisableIdled2()
        pcall(function()
            local cons = getconnections or get_signal_cons
            if cons then
                for _, v in ipairs(cons(player.Idled)) do
                    if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end
                end
            end
        end)
    end
    task.spawn(function()
        DisableIdled2()
        while true do
            task.wait(60)
            if Toggles.AntiAFK2 and Toggles.AntiAFK2.Value then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                    task.wait(0.2)
                    VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                end)
            end
        end
    end)
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if not Toggles.AntiKick2.Value then return oldNamecall(self, ...) end
            if getnamecallmethod() == "Kick" and self == player then
                return
            end
            return oldNamecall(self, ...)
        end)
    end)
    local function Func_AutoReconnect2()
        if _G._autoReconnectConn then _G._autoReconnectConn:Disconnect() end
        _G._autoReconnectConn = game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            if not Toggles.AutoReconnect2.Value then return end
            task.delay(2, function()
                pcall(function()
                    local overlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if overlay then
                        local errPrompt = overlay.promptOverlay:FindFirstChild("ErrorPrompt")
                        if errPrompt and errPrompt.Visible then
                            task.wait(5)
                            TeleportService:Teleport(game.PlaceId, player)
                        end
                    end
                end)
            end)
        end)
    end
    Toggles.AutoReconnect2:OnChanged(function(state)
        if state then Func_AutoReconnect2() end
    end)
    Toggles.NoGameplayPaused2:OnChanged(function(state)
        if not state then return end
        task.spawn(function()
            while Toggles.NoGameplayPaused2.Value do
                pcall(function()
                    local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
                    if pauseGui then pauseGui:Destroy() end
                end)
                task.wait(1)
            end
        end)
    end)
    task.spawn(function()
        while true do
            task.wait(60)
            if Toggles.AutoServerhop2 and Toggles.AutoServerhop2.Value then
                local mins = Options.AutoHopMins2.Value
                if mins > 0 then
                    task.wait((mins - 1) * 60)
                end
                if Toggles.AutoServerhop2.Value then
                    local ok, res = pcall(function()
                        return HttpService:JSONDecode(game:HttpGet(
                            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                        ))
                    end)
                    if ok and res and res.data then
                        local currentId = game.JobId
                        for _, server in ipairs(res.data) do
                            if server.id ~= currentId and server.playing < server.maxPlayers then
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                                return
                            end
                        end
                    end
                end
            end
        end
    end)
end
local function setupWebhook()
    local autoBuyEnabled = false
    local stoppedItems = {}  
    local function postToDiscord(title, description)
        if not Shared.webhookUrl or Shared.webhookUrl == "" then
            return
        end
        description = string.sub(description, 1, 4090)
        local payload = {
            username = "Yuri",
            avatar_url = yuri[math.random(1, #yuri)],
            embeds = {{
                title = title,
                description = description,
                color = math.random(0, 16777215),
                thumbnail = { url = yuri[math.random(1, #yuri)] },
                footer = { text = "Bizarre Lineage" }
            }}
        }
        local ok, body = pcall(function() return HttpService:JSONEncode(payload) end)
        if not ok then
            return
        end
        local headers = {["Content-Type"] = "application/json"}
        local reqArgs = { Url = Shared.webhookUrl, Method = "POST", Headers = headers, Body = body }
        local sendOk, sendErr
        if syn and syn.request then
            sendOk, sendErr = pcall(function() return syn.request(reqArgs) end)
        elseif request then
            sendOk, sendErr = pcall(function() return request(reqArgs) end)
        else
            sendOk, sendErr = pcall(function() return HttpService:PostAsync(Shared.webhookUrl, body, Enum.HttpContentType.ApplicationJson) end)
        end
        if sendOk then
        end
    end
    local lastInventory = {}    
    local lastRaidTokens = {}
    local lastMoney = 0
    local isSending = false
    local lastSendTime = 0
    local COOLDOWN = 2
    local raidConnections = {}
    local function startRaidWebhook() end
    local function stopRaidWebhook()
        for _, conn in ipairs(raidConnections) do conn:Disconnect() end
        raidConnections = {}
    end
    local function initRaidSnapshot()
        local invJson = Inventory.Value
        local inventoryItems = HttpService:JSONDecode(invJson)
        lastInventory = {}
        for _, item in ipairs(inventoryItems) do
            local key = item.ID or item.Name
            lastInventory[key] = item.Amount or 1
        end
        local tokensJson = Shared.RaidTokens.Value
        local raidTokens = HttpService:JSONDecode(tokensJson)
        lastRaidTokens = {}
        for k, v in pairs(raidTokens) do lastRaidTokens[k] = v end
        lastMoney = Shared.Money.Value
    end
    local statsWebhookEnabled = false
    local statsWebhookInterval = 60
    local lastStatsSnapshot = {}
    local statsThread = nil
    local function takeStatsSnapshot()
        local rawInv = HttpService:JSONDecode(Inventory.Value)
        local invMap = {}
        for _, item in ipairs(rawInv) do
            local key = item.ID or item.Name
            invMap[key] = { name = item.Name, amount = item.Amount or 1 }
        end
        local rawTokens = HttpService:JSONDecode(Shared.RaidTokens.Value)
        local tokenMap = {}
        for k, v in pairs(rawTokens) do tokenMap[k] = v end
        return { money = Shared.Money.Value, inventory = invMap, tokens = tokenMap }
    end
    Shared.raidWebhookHandler = function()
        if not Shared.sendWebhookEnabled then
            return
        end
        isSending = false 
        local invJson = Inventory.Value
        local inventoryItems = HttpService:JSONDecode(invJson)
        local tokensJson = Shared.RaidTokens.Value
        local raidTokens = HttpService:JSONDecode(tokensJson)
        local moneyValue = Shared.Money.Value
        local rewardChanges = {}
        if moneyValue ~= lastMoney then
            table.insert(rewardChanges, string.format("**Money:** %s (%+d)", moneyValue, moneyValue - lastMoney))
        end
        local currentInv = {}
        for _, item in ipairs(inventoryItems) do
            local key = item.ID or item.Name
            currentInv[key] = item.Amount or 1
        end
        for key, newAmount in pairs(currentInv) do
            local oldAmount = lastInventory[key] or 0
            if newAmount ~= oldAmount then
                local itemName = key
                for _, item in ipairs(inventoryItems) do
                    if (item.ID or item.Name) == key then itemName = item.Name; break end
                end
                table.insert(rewardChanges, string.format("**%s:** %d (%+d)", itemName, newAmount, newAmount - oldAmount))
            end
        end
        for tokenName, newCount in pairs(raidTokens) do
            local oldCount = lastRaidTokens[tokenName] or 0
            if newCount ~= oldCount then
                table.insert(rewardChanges, string.format("**%s:** %d (%+d)", tokenName, newCount, newCount - oldCount))
            end
        end
        local selectedRaidName = Shared.selectedRaid ~= "" and Shared.selectedRaid or "Unknown Raid"
        local rank = "N/A"
        pcall(function()
            rank = player.PlayerGui.raidcomplete.raid.stand_info_holder.list.ScrollingFrame.holder.rating.Text
        end)
        local elapsed = tick() - Shared.scriptStartTime
        local mins = math.floor(elapsed / 60)
        local secs = math.floor(elapsed % 60)
        local lines = {
            string.format("**Raid:** %s", selectedRaidName),
            string.format("**%s**", rank),
            string.format("**Time:** %dm %ds", mins, secs),
            "",
        }
        if #rewardChanges > 0 then
            for _, line in ipairs(rewardChanges) do table.insert(lines, line) end
        else
            table.insert(lines, "*(no reward changes detected)*")
        end
        postToDiscord("Raid Result", table.concat(lines, "\n"))
        lastMoney = moneyValue
        lastInventory = currentInv
        lastRaidTokens = {}
        for k, v in pairs(raidTokens) do lastRaidTokens[k] = v end
        return true
    end
    local function startStatsWebhook()
        if statsThread then return end
        lastStatsSnapshot = takeStatsSnapshot()
        statsThread = task.spawn(function()
            while statsWebhookEnabled do
                task.wait(statsWebhookInterval)
                if not statsWebhookEnabled then break end
                local current = takeStatsSnapshot()
                local changes = {}
                if current.money ~= lastStatsSnapshot.money then
                    table.insert(changes, string.format("**Money:** %d → %d", lastStatsSnapshot.money, current.money))
                end
                for key, newItem in pairs(current.inventory) do
                    local old = lastStatsSnapshot.inventory[key]
                    local oldAmt = old and old.amount or 0
                    if newItem.amount ~= oldAmt then
                        if oldAmt == 0 then
                            table.insert(changes, string.format("**%s:** +%d (new)", newItem.name, newItem.amount))
                        else
                            table.insert(changes, string.format("**%s:** %d → %d", newItem.name, oldAmt, newItem.amount))
                        end
                    end
                end
                for key, oldItem in pairs(lastStatsSnapshot.inventory) do
                    if not current.inventory[key] then
                        table.insert(changes, string.format("**%s:** %d → 0 (gone)", oldItem.name, oldItem.amount))
                    end
                end
                for raid, newCount in pairs(current.tokens) do
                    local oldCount = lastStatsSnapshot.tokens[raid] or 0
                    if newCount ~= oldCount then
                        table.insert(changes, string.format("**%s Tokens:** %d → %d", raid, oldCount, newCount))
                    end
                end
                for raid, oldCount in pairs(lastStatsSnapshot.tokens) do
                    if not current.tokens[raid] then
                        table.insert(changes, string.format("**%s Tokens:** %d → 0 (gone)", raid, oldCount))
                    end
                end
                if #changes > 0 then
                    postToDiscord("Stats Update", table.concat(changes, "\n"))
                    lastStatsSnapshot = current
                end
            end
        end)
    end
    local function stopStatsWebhook()
        if statsThread then
            task.cancel(statsThread)
            statsThread = nil
        end
    end
    WHGroup:AddInput('webhookUrl', {
        Default = '',
        Text = 'Webhook URL',
        Placeholder = 'Enter webhook URL',
        Callback = function(value)
            Shared.webhookUrl = value
        end,
    })
    WHGroup:AddToggle('raidwhtoggle', {
        Text = 'Raid Webhook',
        Default = false,
        Callback = function(value)
            Shared.sendWebhookEnabled = value
            if value then
                initRaidSnapshot()
                startRaidWebhook()
            else
                stopRaidWebhook()
            end
        end,
    })
    WHGroup:AddInput('StatsWebhookInterval', {
        Default = '60',
        Text = 'Stats send Interval',
        Placeholder = 'Seconds',
        Callback = function(val)
            statsWebhookInterval = tonumber(val) or 60
        end
    })
    WHGroup:AddToggle('StatsWebhookEnabled', {
        Text = 'Stats Webhook',
        Default = false,
        Callback = function(val)
            statsWebhookEnabled = val
            if val then
                startStatsWebhook()
            else
                stopStatsWebhook()
            end
        end
    })
end
setupMain()
setupSkills()
setupRaid()
setupShop()
setupInventory()
setupQuests()
setupMisc()
setupWebhook()
task.spawn(function()
    while true do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.Y <= -485 and not Shared.isVoiding then
            if Shared.savedPos then
                hrp.CFrame = CFrame.new(Shared.savedPos)
                task.wait()
            end
        end
        task.wait()
    end
end)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("yuri/bizarre_lineage")
SaveManager:BuildConfigSection(ConfigTab)
ThemeManager:ApplyToTab(ConfigTab)
SaveManager:LoadAutoloadConfig()
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
end)
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 6)
end