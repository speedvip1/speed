-- Library جديدة وجميلة مع Example
local Library = {}

-- وظائف المساعدة
function Library:Create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- إنشاء نافذة رئيسية
function Library:CreateWindow(title, config)
    config = config or {}
    local accentColor = config.AccentColor or Color3.fromRGB(0, 170, 255)
    
    local ScreenGui = self:Create("ScreenGui", {
        Name = "UILibrary",
        ResetOnSpawn = false
    })
    
    local MainFrame = self:Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        ClipsDescendants = true
    })
    
    local UICorner = self:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    local TopBar = self:Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        Parent = MainFrame
    })
    
    local Title = self:Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        BackgroundTransparency = 1,
        Text = title or "UI Library",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    local CloseButton = self:Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 100, 100),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = TopBar
    })
    
    local TabsHolder = self:Create("Frame", {
        Name = "TabsHolder",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local UIListLayout = self:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = TabsHolder
    })
    
    local PagesHolder = self:Create("Frame", {
        Name = "PagesHolder",
        Size = UDim2.new(1, -20, 1, -70),
        Position = UDim2.new(0, 10, 0, 80),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    -- إضافة تأثير السحب للنافذة
    local dragToggle = nil
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
    
    -- وظيفة إغلاق النافذة
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local tabs = {}
    local pages = {}
    
    function tabs:CreateTab(name)
        local tabButton = self:Create("TextButton", {
            Name = name .. "Tab",
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = TabsHolder
        })
        
        local tabUICorner = self:Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = tabButton
        })
        
        local tabPage = self:Create("ScrollingFrame", {
            Name = name .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = PagesHolder
        })
        
        local tabUIList = self:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = tabPage
        })
        
        tabUIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabPage.CanvasSize = UDim2.new(0, 0, 0, tabUIList.AbsoluteContentSize.Y + 10)
        end)
        
        table.insert(pages, tabPage)
        
        tabButton.MouseButton1Click:Connect(function()
            for _, page in ipairs(pages) do
                page.Visible = false
            end
            tabPage.Visible = true
            
            for _, btn in ipairs(TabsHolder:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                end
            end
            tabButton.BackgroundColor3 = accentColor
        end)
        
        local tabElements = {}
        
        function tabElements:CreateSection(title)
            local section = self:Create("Frame", {
                Name = title .. "Section",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                LayoutOrder = #tabPage:GetChildren(),
                Parent = tabPage
            })
            
            local sectionUICorner = self:Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = section
            })
            
            local sectionTitle = self:Create("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = title,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = section
            })
            
            local sectionElements = {}
            
            function sectionElements:AddButton(name, callback)
                local button = self:Create("TextButton", {
                    Name = name .. "Button",
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, 45),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                    Text = name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = section
                })
                
                local buttonUICorner = self:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = button
                })
                
                button.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                section.Size = UDim2.new(1, 0, 0, section.Size.Y.Offset + 40)
            end
            
            function sectionElements:AddToggle(name, default, callback)
                local toggle = self:Create("Frame", {
                    Name = name .. "Toggle",
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, 45),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                    Parent = section
                })
                
                local toggleUICorner = self:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = toggle
                })
                
                local toggleLabel = self:Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggle
                })
                
                local toggleButton = self:Create("TextButton", {
                    Name = "ToggleButton",
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(0.8, 0, 0.5, -10),
                    BackgroundColor3 = default and accentColor or Color3.fromRGB(80, 80, 85),
                    Text = "",
                    Parent = toggle
                })
                
                local toggleButtonUICorner = self:Create("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = toggleButton
                })
                
                local toggled = default
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    toggleButton.BackgroundColor3 = toggled and accentColor or Color3.fromRGB(80, 80, 85)
                    callback(toggled)
                end)
                
                section.Size = UDim2.new(1, 0, 0, section.Size.Y.Offset + 40)
                
                return {
                    Set = function(value)
                        toggled = value
                        toggleButton.BackgroundColor3 = toggled and accentColor or Color3.fromRGB(80, 80, 85)
                    end
                }
            end
            
            function sectionElements:AddSlider(name, min, max, default, callback)
                local slider = self:Create("Frame", {
                    Name = name .. "Slider",
                    Size = UDim2.new(1, -20, 0, 50),
                    Position = UDim2.new(0, 10, 0, 45),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                    Parent = section
                })
                
                local sliderUICorner = self:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = slider
                })
                
                local sliderLabel = self:Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = name .. ": " .. default,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = slider
                })
                
                local sliderTrack = self:Create("Frame", {
                    Name = "Track",
                    Size = UDim2.new(1, -20, 0, 5),
                    Position = UDim2.new(0, 10, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(80, 80, 85),
                    Parent = slider
                })
                
                local sliderTrackUICorner = self:Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderTrack
                })
                
                local sliderFill = self:Create("Frame", {
                    Name = "Fill",
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = accentColor,
                    Parent = sliderTrack
                })
                
                local sliderFillUICorner = self:Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderFill
                })
                
                local sliding = false
                local value = default
                
                local function updateSlider(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    sliderFill.Size = pos
                    value = math.floor(min + (max - min) * pos.X.Scale)
                    sliderLabel.Text = name .. ": " .. value
                    callback(value)
                end
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        updateSlider(input)
                    end
                end)
                
                sliderTrack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
                        updateSlider(input)
                    end
                end)
                
                section.Size = UDim2.new(1, 0, 0, section.Size.Y.Offset + 60)
                
                return {
                    Set = function(newValue)
                        value = math.clamp(newValue, min, max)
                        sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                        sliderLabel.Text = name .. ": " .. value
                    end
                }
            end
            
            return sectionElements
        end
        
        -- تفعيل أول تبويب تلقائياً
        if #pages == 1 then
            tabPage.Visible = true
            tabButton.BackgroundColor3 = accentColor
        end
        
        return tabElements
    end
    
    ScreenGui.Parent = game:GetService("CoreGui")
    
    return tabs
end

return Library
