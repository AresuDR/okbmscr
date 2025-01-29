local function V9pX3(s)
    return string.char(((s * 17) % 256) + 33)
end

local function encodeString(str)
    local encoded = ""
    for i = 1, #str do
        encoded = encoded .. V9pX3(str:byte(i))
    end
    return encoded
end

local gH9T2 = {encodeString("Q1wX3"), encodeString("P9lM2"), encodeString("M7nT8"), encodeString("X5zR6")}
local tJ29L = game:GetService("ReplicatedStorage")
local kP8xQ = tJ29L:WaitForChild(encodeString("NoxStuffButReplicatedStorage"))
local nM3cZ = kP8xQ:WaitForChild(encodeString("Events"))
local Y2kYV = nM3cZ:WaitForChild(encodeString("CheckQuests"))

local function RfX94()
    for vH9GvT, dV7aU in ipairs(gH9T2) do
        Y2kYV:FireServer(dV7aU)
    end
end

local function Wp3T7()
    while true do
        RfX94()
        wait(math.random(0.9, 1.1))
    end
end

local qT2xY = {
    encodeString("X1cT3"), encodeString("Y4bM5"), encodeString("Z7nQ2"), encodeString("K9pL8"),
    encodeString("W6vG1"), encodeString("J8rX4"), encodeString("L3mY7")
}

local function Lp9W3()
    while true do
        for cM2xT, eP7vQ in pairs(game:GetDescendants()) do
            if eP7vQ:IsA("Part") and table.find(qT2xY, eP7vQ.Name) and eP7vQ:FindFirstChild(encodeString("ClickDetector")) then
                pcall(function()
                    fireclickdetector(eP7vQ.ClickDetector)
                end)
            end
        end
        wait(math.random(0.75, 0.85))
    end
end

local function noiseFunction()
    local garbage = 0
    for i = 1, math.random(100, 200) do
        garbage = garbage + math.random() * i
    end
    return garbage
end

coroutine.wrap(Wp3T7)()
coroutine.wrap(Lp9W3)()
noiseFunction()
