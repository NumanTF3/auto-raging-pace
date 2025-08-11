local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
 
local lp = Players.LocalPlayer
local RANGE = 19
local SPAM_DURATION = 3
local COOLDOWN_TIME = 5
local activeCooldowns = {}
 
local animsToDetect = {
    ["116618003477002"] = true,
    ["119462383658044"] = true,
    ["131696603025265"] = true,
    ["121255898612475"] = true,
    ["133491532453922"] = true,
    ["103601716322988"] = true,
    ["86371356500204"] = true,
    ["72722244508749"] = false,
    ["87259391926321"] = true,
    ["96959123077498"] = false,
    ["86709774283672"] = true,
    ["77448521277146"] = true,
}
 
local function fireRagingPace()
    local args = { "UseActorAbility", "RagingPace" }
    ReplicatedStorage:WaitForChild("Modules")
        :WaitForChild("Network")
        :WaitForChild("RemoteEvent")
        :FireServer(unpack(args))
end
 
local function isAnimationMatching(anim)
    local id = tostring(anim.Animation and anim.Animation.AnimationId or "")
    local numId = id:match("%d+")
    return animsToDetect[numId] or false
end
 
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local myChar = lp.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local dist = (targetHRP.Position - myChar.HumanoidRootPart.Position).Magnitude
                if dist <= RANGE and (not activeCooldowns[player] or tick() - activeCooldowns[player] >= COOLDOWN_TIME) then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                            if isAnimationMatching(track) then
                                activeCooldowns[player] = tick()
                                task.spawn(function()
                                    local startTime = tick()
                                    while tick() - startTime < SPAM_DURATION do
                                        fireRagingPace()
                                        task.wait(0.05)
                                    end
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)
