local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
 
local lp = Players.LocalPlayer
local RANGE = 19
local SPAM_DURATION = 3
local COOLDOWN_TIME = 5
local activeCooldowns = {}
 
local animsToDetect = {
    ["72722244508749"] = false,
    ["77448521277146"] = true,
    ["86096387000557"] = true,
    ["86371356500204"] = true,
    ["86545133269813"] = true,
    ["86709774283672"] = true,
    ["87259391926321"] = true,
    ["89448354637442"] = true,
    ["96959123077498"] = false,
    ["103601716322988"] = true,
    ["108807732150251"] = true,
    ["115194624791339"] = true,
    ["116618003477002"] = true,
    ["119462383658044"] = true,
    ["121255898612475"] = true,
    ["131696603025265"] = true,
    ["133491532453922"] = true,
    ["136007065400978"] = true,
    ["138040001965654"] = true,
    ["140703210927645"] = true,
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
