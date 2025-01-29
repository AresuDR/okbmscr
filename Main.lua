local function ObfuscateChar(c)
    return string.char(((c * 31) % 256) + 47)
end

local function EncodeStr(inputStr)
    local encoded = ""
    for i = 1, #inputStr do
        encoded = encoded .. ObfuscateChar(inputStr:byte(i))
    end
    return encoded
end

local obfuscatedServices = {
    EncodeStr("ServiceA"), EncodeStr("ServiceB"), EncodeStr("ServiceC"), EncodeStr("ServiceD")
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HiddenStorage = ReplicatedStorage:WaitForChild(EncodeStr("HiddenContainer"))
local EventContainer = HiddenStorage:WaitForChild(EncodeStr("Triggers"))
local QuestTrigger = EventContainer:WaitForChild(EncodeStr("QuestSignal"))

local function FireTriggers()
    for _, service in ipairs(obfuscatedServices) do
        QuestTrigger:FireServer(service)
    end
end

local function TriggerLoop()
    while true do
        FireTriggers()
        wait(math.random(0.85, 1.15))
    end
end

local hiddenObjects = {
    EncodeStr("ObjectA"), EncodeStr("ObjectB"), EncodeStr("ObjectC"), EncodeStr("ObjectD")
}

local function SearchAndActivate()
    while true do
        for _, object in pairs(game:GetDescendants()) do
            if object:IsA("Part") and table.find(hiddenObjects, object.Name) and object:FindFirstChild(EncodeStr("ClickHandler")) then
                pcall(function()
                    fireclickdetector(object.ClickHandler)
                end)
            end
        end
        wait(math.random(0.7, 0.9))
    end
end

local function RandomNoise()
    local junk = 0
    for _ = 1, math.random(120, 250) do
        junk = junk + math.random() * math.random(1, 100)
    end
    return junk
end

coroutine.wrap(TriggerLoop)()
coroutine.wrap(SearchAndActivate)()
RandomNoise()

local function MaskString(s)
    return string.char(((s * 29) % 256) + 53)
end

local VirtualInput = Instance.new(MaskString("InputHandler"))
local UserInput = game:GetService(MaskString("UserHandler"))
local HookRegistry = {}

local function ValidateText(T)
    if type(T) ~= "string" then return false end
    return (string.split(T, "\0"))[1]
end

local function ArgProcessor(self, ...)
    return self, {...}
end

local function SecureServiceCall(...)
    local OriginalService
    OriginalService = function(...)
        local self, Index = ...
        local Response = OriginalService(...)
        if type(Index) == "string" and ValidateText(Index) == MaskString("InputHandler") then
            error(("'%s' is not a valid Service name"):format(ValidateText(Index)))
            return
        end
        return Response
    end
end

local PreviousFindService = hookfunction(game.FindService, function(...)
    local self, Index = ...
    local Response = PreviousFindService(...)
    if type(Index) == "string" and ValidateText(Index) == MaskString("InputHandler") then
        return
    end
    return Response
end)

SecureServiceCall(game.GetService)
SecureServiceCall(game.getService)
SecureServiceCall(game.service)

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(...)
    local self, Arguments = ArgProcessor(...)
    local Method = getnamecallmethod()
    if typeof(self) == "Instance" and self == game and Method:lower():match("service") and ValidateText(Arguments[1]) == MaskString("InputHandler") then
        if Method == "FindService" then return end
        local Success, Error = pcall(function()
            setnamecallmethod(Method)
            game[Method](game, MaskString("InvalidHandler"))
        end)
        if not Error:match("is not a valid member") then
            error(Error:replace(MaskString("InvalidHandler"), MaskString("InputHandler")))
            return
        end
    end
    return OldNamecall(...)
end)

local OldWindowHook
OldWindowHook = hookmetamethod(UserInput.WindowFocused, "__index", function(...)
    local self, Index = ...
    local Response = OldWindowHook(...)
    if type(Response) ~= "function" and (tostring(self):find("WindowFocused") or tostring(self):find("WindowFocusReleased")) and not table.find(HookRegistry, Response) then
        table.insert(HookRegistry, Response)
        if Index:lower() == "wait" then
            local HookWait
            HookWait = hookfunction(Response, function(...)
                local instance = ...
                if instance == self then
                    instance = Instance.new("BindableEvent").Event
                end
                return HookWait(instance)
            end)
        elseif Index:lower() == "connect" then
            local HookConnect
            HookConnect = hookfunction(Response, function(...)
                local instance, Func = ...
                if instance == self then
                    Func = function() return end
                end
                return HookConnect(instance, Func)
            end)
        end
    end
    return Response
end)

for _, conn in next, getconnections(UserInput.WindowFocusReleased) do
    conn:Disable()
end
for _, conn in next, getconnections(UserInput.WindowFocused) do
    conn:Disable()
end

if not iswindowactive() and not getgenv().WindowFocused then
    firesignal(UserInput.WindowFocused)
    getgenv().WindowFocused = true
end

while true do
    VirtualInput:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
    task.wait(Random.new():NextNumber(10, 180))
end
