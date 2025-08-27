-- IceHub Library
local IceHub = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Local Player
local LocalPlayer = Players.LocalPlayer

-- Colors
IceHub.Colors = {
    Background = Color3.fromRGB(15, 15, 25),
    Primary = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(25, 25, 35),
    Text = Color3.fromRGB(240, 240, 240),
    Success = Color3.fromRGB(0, 255, 127),
    Error = Color3.fromRGB(255, 50, 50),
    Warning = Color3.fromRGB(255, 170, 0)
}

-- Utility Functions
function IceHub:Tween(Object, Properties, Duration, Callback)
    local Tween = TweenService:Create(Object, TweenInfo.new(Duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), Properties)
    Tween:Play()
    if Callback then
        Tween.Completed:Connect(Callback)
    end
    return Tween
end

function IceHub:Notify(Title, Message, Type)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = Title,
        Text = Message,
        Icon = "rbxassetid://" .. (Type == "Success" and "4483345998" or Type == "Error" and "4483345998" or "4483345998"),
        Duration = 5
    })
end

function IceHub:Create(class, properties)
    local object = Instance.new(class)
    for property, value in pairs(properties) do
        object[property] = value
    end
    return object
end

-- UI Creation
function IceHub:CreateWindow(Title)
    local IceHub = {}
    
    -- Main GUI
    local ScreenGui = self:Create("ScreenGui", {
        Name = "IceHub",
        Parent = CoreGui,
        ResetOnSpawn = false
    })
    
    -- Main Container
    local MainFrame = self:Create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = self.Colors.Background,
        BorderSizePixel = 0
    })
    
    local MainCorner = self:Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Header
    local Header = self:Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Colors.Secondary,
        BorderSizePixel = 0
    })
    
    local HeaderCorner = self:Create("UICorner", {
        Parent = Header,
        CornerRadius = UDim.new(0, 12)
    })
    
    local TitleLabel = self:Create("TextLabel", {
        Parent = Header,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = Title,
        TextColor3 = self.Colors.Primary,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local CloseButton = self:Create("TextButton", {
        Parent = Header,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = self.Colors.Error,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    
    local CloseCorner = self:Create("UICorner", {
        Parent = CloseButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Tab System
    local TabContainer = self:Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(0, 100, 1, -50),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = self.Colors.Secondary,
        BorderSizePixel = 0
    })
    
    local TabList = self:Create("UIListLayout", {
        Parent = TabContainer,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 5)
    })
    
    local ContentContainer = self:Create("ScrollingFrame", {
        Parent = MainFrame,
        Size = UDim2.new(1, -110, 1, -50),
        Position = UDim2.new(0, 100, 0, 40),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Colors.Primary
    })
    
    local ContentList = self:Create("UIListLayout", {
        Parent = ContentContainer,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 10)
    })
    
    -- Dragging
    local dragging = false
    local dragInput, mousePos, framePos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Close Function
    CloseButton.MouseButton1Click:Connect(function()
        self:Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.5, function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Tab Functions
    local Tabs = {}
    local CurrentTab = nil
    
    function IceHub:AddTab(Name, Icon)
        local TabButton = self:Create("TextButton", {
            Parent = TabContainer,
            Size = UDim2.new(0, 80, 0, 30),
            BackgroundColor3 = self.Colors.Secondary,
            Text = " " .. Name,
            TextColor3 = self.Colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local TabCorner = self:Create("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 6)
        })
        
        local TabContent = self:Create("ScrollingFrame", {
            Parent = ContentContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false
        })
        
        local TabContentList = self:Create("UIListLayout", {
            Parent = TabContent,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Padding = UDim.new(0, 10)
        })
        
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Visible = false
            end
            TabContent.Visible = true
            CurrentTab = TabContent
            
            -- Update tab buttons
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    self:Tween(btn, {BackgroundColor3 = self.Colors.Secondary}, 0.2)
                end
            end
            self:Tween(TabButton, {BackgroundColor3 = self.Colors.Primary}, 0.2)
        end)
        
        local TabElements = {}
        
        function TabElements:AddButton(Config)
            local Button = self:Create("TextButton", {
                Parent = TabContent,
                Size = UDim2.new(0, 350, 0, 40),
                BackgroundColor3 = self.Colors.Secondary,
                Text = Config.Name,
                TextColor3 = self.Colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                AutoButtonColor = false
            })
            
            local ButtonCorner = self:Create("UICorner", {
                Parent = Button,
                CornerRadius = UDim.new(0, 8)
            })
            
            -- Hover effects
            Button.MouseEnter:Connect(function()
                self:Tween(Button, {BackgroundColor3 = self.Colors.Primary}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                self:Tween(Button, {BackgroundColor3 = self.Colors.Secondary}, 0.2)
            end)
            
            Button.MouseButton1Click:Connect(function()
                self:Tween(Button, {Size = UDim2.new(0, 340, 0, 38)}, 0.1, function()
                    self:Tween(Button, {Size = UDim2.new(0, 350, 0, 40)}, 0.1)
                end)
                Config.Callback()
            end)
            
            return Button
        end
        
        function TabElements:AddToggle(Config)
            local ToggleFrame = self:Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(0, 350, 0, 40),
                BackgroundTransparency = 1
            })
            
            local ToggleButton = self:Create("TextButton", {
                Parent = ToggleFrame,
                Size = UDim2.new(0, 350, 0, 40),
                BackgroundColor3 = self.Colors.Secondary,
                Text = Config.Name,
                TextColor3 = self.Colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                AutoButtonColor = false,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ToggleCorner = self:Create("UICorner", {
                Parent = ToggleButton,
                CornerRadius = UDim.new(0, 8)
            })
            
            local ToggleIndicator = self:Create("Frame", {
                Parent = ToggleButton,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                BackgroundColor3 = Config.Default and self.Colors.Success or self.Colors.Error,
                BorderSizePixel = 0
            })
            
            local IndicatorCorner = self:Create("UICorner", {
                Parent = ToggleIndicator,
                CornerRadius = UDim.new(1, 0)
            })
            
            local Toggled = Config.Default
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                self:Tween(ToggleIndicator, {
                    BackgroundColor3 = Toggled and self.Colors.Success or self.Colors.Error
                }, 0.2)
                Config.Callback(Toggled)
            end)
            
            return ToggleFrame
        end
        
        function TabElements:AddSlider(Config)
            local SliderFrame = self:Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(0, 350, 0, 60),
                BackgroundTransparency = 1
            })
            
            local SliderTitle = self:Create("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = Config.Name,
                TextColor3 = self.Colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local SliderBar = self:Create("Frame", {
                Parent = SliderFrame,
                Size = UDim2.new(1, 0, 0, 5),
                Position = UDim2.new(0, 0, 0, 30),
                BackgroundColor3 = self.Colors.Secondary,
                BorderSizePixel = 0
            })
            
            local BarCorner = self:Create("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(1, 0)
            })
            
            local SliderFill = self:Create("Frame", {
                Parent = SliderBar,
                Size = UDim2.new((Config.Default - Config.Min) / (Config.Max - Config.Min), 0, 1, 0),
                BackgroundColor3 = self.Colors.Primary,
                BorderSizePixel = 0
            })
            
            local FillCorner = self:Create("UICorner", {
                Parent = SliderFill,
                CornerRadius = UDim.new(1, 0)
            })
            
            local ValueLabel = self:Create("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -50, 0, 30),
                BackgroundTransparency = 1,
                Text = tostring(Config.Default),
                TextColor3 = self.Colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham
            })
            
            local function UpdateSlider(Value)
                Value = math.clamp(Value, Config.Min, Config.Max)
                self:Tween(SliderFill, {
                    Size = UDim2.new((Value - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
                }, 0.1)
                ValueLabel.Text = tostring(Value)
                Config.Callback(Value)
            end
            
            SliderBar.MouseButton1Down:Connect(function()
                local Connection
                Connection = UserInputService.InputChanged:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseMovement then
                        local X = math.clamp(Input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
                        local Value = math.floor(Config.Min + (X / SliderBar.AbsoluteSize.X) * (Config.Max - Config.Min))
                        UpdateSlider(Value)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Connection:Disconnect()
                    end
                end)
            end)
            
            return SliderFrame
        end
        
        function TabElements:AddDropdown(Config)
            local DropdownFrame = self:Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(0, 350, 0, 40),
                BackgroundTransparency = 1
            })
            
            local DropdownButton = self:Create("TextButton", {
                Parent = DropdownFrame,
                Size = UDim2.new(0, 350, 0, 40),
                BackgroundColor3 = self.Colors.Secondary,
                Text = Config.Name .. ": " .. Config.Default,
                TextColor3 = self.Colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                AutoButtonColor = false
            })
            
            local DropdownCorner = self:Create("UICorner", {
                Parent = DropdownButton,
                CornerRadius = UDim.new(0, 8)
            })
            
            local DropdownArrow = self:Create("TextLabel", {
                Parent = DropdownButton,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = self.Colors.Text,
                TextSize = 14
            })
            
            local DropdownList = self:Create("ScrollingFrame", {
                Parent = DropdownFrame,
                Size = UDim2.new(0, 350, 0, 0),
                Position = UDim2.new(0, 0, 0, 45),
                BackgroundColor3 = self.Colors.Secondary,
                ScrollBarThickness = 3,
                Visible = false
            })
            
            local ListLayout = self:Create("UIListLayout", {
                Parent = DropdownList
            })
            
            local isOpen = false
            local Selected = Config.Default
            
            local function UpdateDropdown()
                DropdownButton.Text = Config.Name .. ": " .. Selected
                for _, Option in pairs(DropdownList:GetChildren()) do
                    if Option:IsA("TextButton") then
                        Option.BackgroundColor3 = Option.Text == Selected and self.Colors.Primary or self.Colors.Secondary
                    end
                end
            end
            
            for _, Option in pairs(Config.Options) do
                local OptionButton = self:Create("TextButton", {
                    Parent = DropdownList,
                    Size = UDim2.new(0, 350, 0, 30),
                    BackgroundColor3 = Option == Selected and self.Colors.Primary or self.Colors.Secondary,
                    Text = Option,
                    TextColor3 = self.Colors.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false
                })
                
                local OptionCorner = self:Create("UICorner", {
                    Parent = OptionButton,
                    CornerRadius = UDim.new(0, 6)
                })
                
                OptionButton.MouseButton1Click:Connect(function()
                    Selected = Option
                    UpdateDropdown()
                    Config.Callback(Selected)
                    isOpen = false
                    DropdownList.Visible = false
                    self:Tween(DropdownList, {Size = UDim2.new(0, 350, 0, 0)}, 0.2)
                    DropdownArrow.Text = "▼"
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                DropdownList.Visible = isOpen
                if isOpen then
                    self:Tween(DropdownList, {
                        Size = UDim2.new(0, 350, 0, math.min(#Config.Options * 35, 150))
                    }, 0.2)
                    DropdownArrow.Text = "▲"
                else
                    self:Tween(DropdownList, {Size = UDim2.new(0, 350, 0, 0)}, 0.2)
                    DropdownArrow.Text = "▼"
                end
            end)
            
            return DropdownFrame
        end
        
        -- Select first tab
        if #TabContainer:GetChildren() == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        return TabElements
    end
    
    return IceHub
end

return IceHub
