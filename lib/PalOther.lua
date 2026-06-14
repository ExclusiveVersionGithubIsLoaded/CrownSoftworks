local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/idkThisOne/Library.lua"))()

do -- Example
    local Window = Library:Window({
        Logo = "123748867365417",
        FadeSpeed = 0.15,
        PagePadding = 19,
        --Size = UDim2.new(0, 681, 0, 481)
    })

    local Pages = {
        ["One"] = Window:Page({Icon = "109391165290124", Search = true}),
        ["Two"] = Window:Page({Icon = "72974659157165", Search = false}),
        ["_"] = Window:Seperator(),
        ["Three"] = Window:Page({Icon = "109391165290124", Search = true}),
        ["Four"] = Window:Page({Icon = "129960652808688", Search = true}),
        ["__"] = Window:Seperator(),
        ["Five"] = Window:Page({Icon = "112887626955824", Search = true}),
        ["Six"] = Window:Page({Icon = "72974659157165", Search = false}),
        ["Seven"] = Window:Page({Icon = "82402610527668", Search = true}),
        ["Eight"] = Window:Page({Icon = "72974659157165", Search = true}),
        ["Nine"] = Window:Page({Icon = "82402610527668", Search = true}),
    } do -- First Tab 
        local AimbotSubpage = Pages["One"]:SubPage({Name = "Aimbot"})
        local SilentSubpage = Pages["One"]:SubPage({Name = "Silent"})

        do  -- Aimbot Subpage 
            local AimbotSection = AimbotSubpage:Section({Name = "Aimbot", Side = "Left"})

            do -- Aimbot section
                local Toggle = AimbotSection:Toggle({
                    Name = "Enable", 
                    Flag = "Enable", 
                    Default = false,
                    Callback = function(Value)
                        print(Value)
                    end
                })

                Toggle:Keybind({
                    Name = "Keybind",
                    Flag = "Keybind",
                    Default = Enum.KeyCode.X,
                    Mode = "Toggle",
                    Callback = function(Value)
                        print(Value)
                    end
                })

                Toggle:Colorpicker({
                    Name = "Colorpicker", 
                    Flag = "Colorpicker", 
                    Default = Color3.fromRGB(255, 255, 255), 
                    Callback = function(Value, Alpha)
                        print(Value, Alpha)
                    end
                })

                AimbotSection:Button({
                    Name = "Button",
                    Callback = function()
                        print("Button")
                    end
                })

                AimbotSection:Button({
                    Name = "Button",
                    Callback = function()
                        print("Button")
                    end
                }):SubButton({
                    Name = "SubButton",
                    Callback = function()
                        print("SubButton")
                    end
                })

                AimbotSection:Slider({
                    Name = "Slider", 
                    Flag = "Slider", 
                    Min = 0, 
                    Default = 0, 
                    Max = 100, 
                    Suffix = "%", 
                    Decimals = 1, 
                    Callback = function(Value)
                        print(Value)
                    end
                })

                AimbotSection:Dropdown({
                    Name = "Dropdown", 
                    Flag = "Dropdown", 
                    Items = { "One", "Two", "Three", "Four" }, 
                    Multi = false,
                    MaxSize = 50,
                    Callback = function(Value)
                        print(Value)
                    end
                })

                AimbotSection:Dropdown({
                    Name = "Multi Dropdown", 
                    Flag = "Multi Dropdown", 
                    Items = { "One", "Two", "Three", "Four" }, 
                    Multi = true,
                    MaxSize = 75,
                    Callback = function(Value)
                        print(Value)
                    end
                })

                local ColorpickerLabel = AimbotSection:Label("Colorpicker", "Left")

                ColorpickerLabel:Colorpicker({ 
                    Name = "Colorpicker", 
                    Flag = "Colorpicker", 
                    Default = Color3.fromRGB(255, 255, 255), 
                    Callback = function(Value, Alpha)
                        print(Value, Alpha)
                    end
                })

                ColorpickerLabel:Colorpicker({ 
                    Name = "Colorpicker", 
                    Flag = "Colorpicker", 
                    Default = Library.Theme.Accent, 
                    Callback = function(Value, Alpha)
                        print(Value, Alpha)
                    end
                })

                AimbotSection:Keybind({
                    Name = "Keybind",
                    Flag = "Keybind",
                    Default = Enum.KeyCode.C,
                    Mode = "Toggle",
                    Callback = function(Value)
                        print(Value)
                    end
                })

                AimbotSection:Textbox({
                    Name = "Textbox",
                    Flag = "Textbox",
                    Placeholder = "Placeholder",
                    Default = "Input",
                    Callback = function(Value)
                        print(Value)
                    end
                })
            end
        end
    end

    do -- Sixth tab (settings)
        local SettingsSubtab = Pages["Six"]:SubPage({Name = "Settings"}) do 

        local ThemingSection = SettingsSubtab:Section({Name = "Theming", Side = "Right"}) do 
                for Index, Value in Library.Theme do
                    ThemingSection:Label(Index, "Left"):Colorpicker({
                        Name = Index,
                        Flag = "Theme" .. Index,
                        Default = Value,
                        Callback = function(Value)
                            Library.Theme[Index] = Value
                            Library:ChangeTheme(Index, Value)
                        end
                    })
                end
            end
        end

        local ConfigsSection = SettingsSubtab:Section({Name = "Configs", Side = "Left"}) do 
            local ConfigName
            local ConfigSelected 

            local ConfigsDropdown = ConfigsSection:Dropdown({
                Name = "Configs", 
                Flag = "ConfigsList", 
                Items = { }, 
                Multi = false,
                MaxSize = 85,
                Callback = function(Value)
                    ConfigSelected = Value
                end
            })

            ConfigsSection:Textbox({
                Name = "Config Name",
                Default = "",
                Flag = "ConfigName",
                Placeholder = "...",
                Callback = function(Value)
                    ConfigName = Value
                end
            })

            ConfigsSection:Button({
                Name = "Load Config",
                Callback = function()
                    if ConfigSelected then
                        Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))

                        Library:Thread(function()
                            task.wait(0.1)

                            for Index, Value in Library.Theme do 
                                Library.Theme[Index] = Library.Flags["Theme"..Index].Color
                                Library:ChangeTheme(Index, Library.Flags["Theme"..Index].Color)
                            end    
                        end)

                        Library:Notification("Success", "Loaded config " .. ConfigSelected, 5)
                    else
                        return
                    end
                end
            }):SubButton({
                Name = "Save Config",
                Callback = function()
                    if ConfigName then
                        Library:SaveConfig(ConfigSelected)
                    else
                        return
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Create Config",
                Callback = function()
                    if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                        writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())

                        Library:RefreshConfigsList(ConfigsDropdown)
                    else
                        Library:Notification("Error", "Config already exists", 3)
                        return
                    end
                end
            }):SubButton({
                Name = "Delete Config",
                Callback = function()
                    if ConfigSelected then
                        Library:DeleteConfig(ConfigSelected)

                        Library:RefreshConfigsList(ConfigsDropdown)
                    else
                        return
                    end
                end
            })

            Library:RefreshConfigsList(ConfigsDropdown)
        end
    end
end

Library:Notification("Notification test", "Test", 5)
