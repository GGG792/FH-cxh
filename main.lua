-- ============================================================
-- FH-cxh UI Library
-- Dark Theme + iOS Liquid Glass Theme
-- ============================================================

local FH_cxh = {};
FH_cxh.__index = FH_cxh;

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;

local DNABackground = loadstring(game:HttpGet("https://raw.githubusercontent.com/GGG792/FH-cxh/main/modules/DNABackground.lua"))();
local RainbowBorder = loadstring(game:HttpGet("https://raw.githubusercontent.com/GGG792/FH-cxh/main/modules/RainbowBorder.lua"))();

local THEME = {
	Background = Color3.fromRGB(15, 15, 25);
	Card = Color3.fromRGB(25, 25, 40);
	CardHover = Color3.fromRGB(35, 35, 55);
	Text = Color3.fromRGB(240, 240, 255);
	TextDim = Color3.fromRGB(150, 150, 180);
	Accent = Color3.fromRGB(100, 200, 255);
	CornerRadius = UDim.new(0, 16);
	WindowSize = {Width = 520, Height = 340};
};

-- ========== 创建窗口 ==========
function FH_cxh.new(config)
	config = config or {};
	local self = setmetatable({}, FH_cxh);
	self.Name = config.Name or "FH-cxh";
	self.Theme = {};
	for k, v in pairs(THEME) do self.Theme[k] = v; end;
	if config.Theme then
		for k, v in pairs(config.Theme) do self.Theme[k] = v; end;
	end;

	self.CurrentTheme = "dark";
	self.Tabs = {};
	self.ActiveTab = nil;
	self.IsGlass = false;
	self.GlassElements = {};

	self:_createWindow();
	self:_createDNA();
	self:_createBorder();
	self:_createTitleBar();
	self:_createSidebar();
	self:_createContentArea();
	self:_makeDraggable();

	return self;
end;

function FH_cxh:_createWindow()
	self.Gui = Instance.new("ScreenGui");
	self.Gui.Name = "FH_cxh_" .. self.Name;
	self.Gui.Parent = LocalPlayer.PlayerGui;
	self.Gui.ResetOnSpawn = false;
	self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
	self.Gui.IgnoreGuiInset = true;

	-- 主窗口
	self.Window = Instance.new("Frame");
	self.Window.Name = "MainWindow";
	self.Window.Size = UDim2.new(0, self.Theme.WindowSize.Width, 0, self.Theme.WindowSize.Height);
	self.Window.Position = UDim2.new(0.5, -self.Theme.WindowSize.Width/2, 0.5, -self.Theme.WindowSize.Height/2);
	self.Window.BackgroundColor3 = self.Theme.Background;
	self.Window.BackgroundTransparency = 0.05;
	self.Window.BorderSizePixel = 0;
	self.Window.ClipsDescendants = true;
	self.Window.Parent = self.Gui;
	Instance.new("UICorner", self.Window).CornerRadius = self.Theme.CornerRadius;

	-- 阴影
	local shadow = Instance.new("ImageLabel");
	shadow.Size = UDim2.new(1, 50, 1, 50);
	shadow.Position = UDim2.new(0, -25, 0, -25);
	shadow.BackgroundTransparency = 1;
	shadow.Image = "rbxassetid://5554236805";
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0);
	shadow.ImageTransparency = 0.5;
	shadow.ScaleType = Enum.ScaleType.Slice;
	shadow.SliceCenter = Rect.new(23, 23, 277, 277);
	shadow.ZIndex = -1;
	shadow.Parent = self.Window;
end;

function FH_cxh:_createDNA()
	self.DNA = DNABackground.new(self.Window, {
		HelixCount = 2;
		PointsPerHelix = 20;
		Amplitude = 60;
		Speed = 0.8;
		TiltAngle = 25;
		ColorA = Color3.fromRGB(0, 200, 255);
		ColorB = Color3.fromRGB(255, 50, 200);
	});
	self.DNA:Start();
end;

function FH_cxh:_createBorder()
	self.Border = RainbowBorder.new(self.Window, {
		Thickness = 3;
		Speed = 1.2;
		CornerRadius = self.Theme.CornerRadius;
	});
	self.Border:Start();
end;

function FH_cxh:_createTitleBar()
	self.TitleBar = Instance.new("Frame");
	self.TitleBar.Name = "TitleBar";
	self.TitleBar.Size = UDim2.new(1, 0, 0, 38);
	self.TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35);
	self.TitleBar.BackgroundTransparency = 0.3;
	self.TitleBar.BorderSizePixel = 0;
	self.TitleBar.ZIndex = 10;
	self.TitleBar.Parent = self.Window;
	Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 16);

	-- 底部线
	local line = Instance.new("Frame");
	line.Size = UDim2.new(1, 0, 0, 1);
	line.Position = UDim2.new(0, 0, 1, -1);
	line.BackgroundColor3 = Color3.fromRGB(80, 80, 120);
	line.BackgroundTransparency = 0.5;
	line.BorderSizePixel = 0;
	line.ZIndex = 10;
	line.Parent = self.TitleBar;

	-- Logo
	local logo = Instance.new("Frame");
	logo.Size = UDim2.new(0, 24, 0, 24);
	logo.Position = UDim2.new(0, 10, 0, 7);
	logo.BackgroundColor3 = self.Theme.Accent;
	logo.BorderSizePixel = 0;
	logo.ZIndex = 11;
	logo.Parent = self.TitleBar;
	Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 7);

	local logoText = Instance.new("TextLabel");
	logoText.Size = UDim2.new(1, 0, 1, 0);
	logoText.BackgroundTransparency = 1;
	logoText.Text = "FH";
	logoText.Font = Enum.Font.SourceSansBold;
	logoText.TextSize = 13;
	logoText.TextColor3 = Color3.fromRGB(255, 255, 255);
	logoText.ZIndex = 12;
	logoText.Parent = logo;

	-- 标题
	self.TitleLabel = Instance.new("TextLabel");
	self.TitleLabel.Size = UDim2.new(0, 160, 1, 0);
	self.TitleLabel.Position = UDim2.new(0, 40, 0, 0);
	self.TitleLabel.BackgroundTransparency = 1;
	self.TitleLabel.Text = self.Name;
	self.TitleLabel.Font = Enum.Font.SourceSansBold;
	self.TitleLabel.TextSize = 15;
	self.TitleLabel.TextColor3 = self.Theme.Text;
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left;
	self.TitleLabel.ZIndex = 11;
	self.TitleLabel.Parent = self.TitleBar;

	-- 液态玻璃切换按钮
	local glassBtn = Instance.new("TextButton");
	glassBtn.Size = UDim2.new(0, 28, 0, 28);
	glassBtn.Position = UDim2.new(1, -116, 0, 5);
	glassBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255);
	glassBtn.BackgroundTransparency = 0.3;
	glassBtn.Text = "G";
	glassBtn.Font = Enum.Font.SourceSansBold;
	glassBtn.TextSize = 12;
	glassBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
	glassBtn.ZIndex = 11;
	glassBtn.Parent = self.TitleBar;
	Instance.new("UICorner", glassBtn).CornerRadius = UDim.new(0, 7);

	glassBtn.MouseEnter:Connect(function()
		TweenService:Create(glassBtn, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play();
	end);
	glassBtn.MouseLeave:Connect(function()
		TweenService:Create(glassBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.3}):Play();
	end);
	glassBtn.MouseButton1Click:Connect(function()
		self:SwitchTheme();
	end);

	-- 最小化
	local minBtn = Instance.new("TextButton");
	minBtn.Size = UDim2.new(0, 28, 0, 28);
	minBtn.Position = UDim2.new(1, -82, 0, 5);
	minBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0);
	minBtn.BackgroundTransparency = 0.3;
	minBtn.Text = "-";
	minBtn.Font = Enum.Font.SourceSansBold;
	minBtn.TextSize = 16;
	minBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
	minBtn.ZIndex = 11;
	minBtn.Parent = self.TitleBar;
	Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 7);
	minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play(); end);
	minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.3}):Play(); end);

	-- 关闭
	local closeBtn = Instance.new("TextButton");
	closeBtn.Size = UDim2.new(0, 28, 0, 28);
	closeBtn.Position = UDim2.new(1, -48, 0, 5);
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 71, 87);
	closeBtn.BackgroundTransparency = 0.3;
	closeBtn.Text = "X";
	closeBtn.Font = Enum.Font.SourceSansBold;
	closeBtn.TextSize = 12;
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
	closeBtn.ZIndex = 11;
	closeBtn.Parent = self.TitleBar;
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7);
	closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play(); end);
	closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.3}):Play(); end);
	closeBtn.MouseButton1Click:Connect(function() self:Destroy(); end);
end;

function FH_cxh:_createSidebar()
	self.Sidebar = Instance.new("Frame");
	self.Sidebar.Name = "Sidebar";
	self.Sidebar.Size = UDim2.new(0, 130, 1, -38);
	self.Sidebar.Position = UDim2.new(0, 0, 0, 38);
	self.Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 35);
	self.Sidebar.BackgroundTransparency = 0.5;
	self.Sidebar.BorderSizePixel = 0;
	self.Sidebar.ZIndex = 5;
	self.Sidebar.Parent = self.Window;

	local line = Instance.new("Frame");
	line.Size = UDim2.new(0, 1, 1, 0);
	line.Position = UDim2.new(1, -1, 0, 0);
	line.BackgroundColor3 = Color3.fromRGB(80, 80, 120);
	line.BackgroundTransparency = 0.5;
	line.BorderSizePixel = 0;
	line.ZIndex = 5;
	line.Parent = self.Sidebar;
end;

function FH_cxh:_createContentArea()
	self.Content = Instance.new("Frame");
	self.Content.Name = "Content";
	self.Content.Size = UDim2.new(1, -130, 1, -38);
	self.Content.Position = UDim2.new(0, 130, 0, 38);
	self.Content.BackgroundTransparency = 1;
	self.Content.BorderSizePixel = 0;
	self.Content.ZIndex = 5;
	self.Content.Parent = self.Window;

	local welcome = Instance.new("TextLabel");
	welcome.Size = UDim2.new(1, -30, 0, 32);
	welcome.Position = UDim2.new(0, 15, 0, 15);
	welcome.BackgroundTransparency = 1;
	welcome.Text = "Welcome to " .. self.Name;
	welcome.Font = Enum.Font.SourceSansBold;
	welcome.TextSize = 20;
	welcome.TextColor3 = self.Theme.Text;
	welcome.TextXAlignment = Enum.TextXAlignment.Left;
	welcome.ZIndex = 6;
	welcome.Parent = self.Content;

	local sub = Instance.new("TextLabel");
	sub.Size = UDim2.new(1, -30, 0, 16);
	sub.Position = UDim2.new(0, 15, 0, 48);
	sub.BackgroundTransparency = 1;
	sub.Text = "Select a tab to get started."
	sub.Font = Enum.Font.SourceSans;
	sub.TextSize = 12;
	sub.TextColor3 = self.Theme.TextDim;
	sub.TextXAlignment = Enum.TextXAlignment.Left;
	sub.ZIndex = 6;
	sub.Parent = self.Content;
end;

function FH_cxh:_makeDraggable()
	local dragging = false;
	local dragStart, startPos;

	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true;
			dragStart = input.Position;
			startPos = self.Window.Position;
		end;
	end);

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart;
			self.Window.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			);
		end;
	end);

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false;
		end;
	end);
end;

-- ========== 标签页 ==========
function FH_cxh:AddTab(name, icon)
	local tabBtn = Instance.new("TextButton");
	tabBtn.Size = UDim2.new(1, -12, 0, 32);
	tabBtn.Position = UDim2.new(0, 6, 0, 6 + (#self.Tabs * 38));
	tabBtn.BackgroundColor3 = self.Theme.Card;
	tabBtn.BackgroundTransparency = 0.3;
	tabBtn.Text = "  " .. (icon or "") .. " " .. name;
	tabBtn.Font = Enum.Font.SourceSansBold;
	tabBtn.TextSize = 12;
	tabBtn.TextColor3 = self.Theme.TextDim;
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left;
	tabBtn.ZIndex = 6;
	tabBtn.Parent = self.Sidebar;
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8);

	local tabContent = Instance.new("Frame");
	tabContent.Size = UDim2.new(1, 0, 1, 0);
	tabContent.BackgroundTransparency = 1;
	tabContent.Visible = false;
	tabContent.ZIndex = 6;
	tabContent.Parent = self.Content;

	local tab = {Button = tabBtn; Content = tabContent; Name = name};

	tabBtn.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3=self.Theme.CardHover, TextColor3=self.Theme.Text}):Play();
		end;
	end);
	tabBtn.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3=self.Theme.Card, TextColor3=self.Theme.TextDim}):Play();
		end;
	end);
	tabBtn.MouseButton1Click:Connect(function() self:SelectTab(tab); end);

	table.insert(self.Tabs, tab);
	if #self.Tabs == 1 then self:SelectTab(tab); end;
	return tabContent;
end;

function FH_cxh:SelectTab(tab)
	for _, t in ipairs(self.Tabs) do
		t.Content.Visible = false;
		TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundColor3=self.Theme.Card, TextColor3=self.Theme.TextDim}):Play();
	end;
	tab.Content.Visible = true;
	TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundColor3=self.Theme.Accent, TextColor3=Color3.fromRGB(255,255,255)}):Play();
	self.ActiveTab = tab;
end;

-- ============================================================
-- iOS Liquid Glass 主题
-- ============================================================
function FH_cxh:SwitchTheme()
	if self.CurrentTheme == "dark" then
		self:_applyLiquidGlass();
	else
		self:_applyDarkTheme();
	end;
end;

function FH_cxh:_applyLiquidGlass()
	self.CurrentTheme = "glass";
	self.IsGlass = true;

	-- ===== 全局模糊 =====
	if not self.GlassBlur then
		self.GlassBlur = Instance.new("BlurEffect");
		self.GlassBlur.Size = 0;
		self.GlassBlur.Parent = Lighting;
	end;
	TweenService:Create(self.GlassBlur, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size=24}):Play();

	-- ===== 窗口：液态玻璃主体 =====
	-- 深色半透明底（模拟 iOS 深色模式下的玻璃）
	TweenService:Create(self.Window, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
		BackgroundColor3 = Color3.fromRGB(30, 30, 40),
		BackgroundTransparency = 0.15
	}):Play();

	-- 内层玻璃光泽（模拟光线折射）
	local innerGlow = Instance.new("Frame");
	innerGlow.Name = "GlassInnerGlow";
	innerGlow.Size = UDim2.new(1, 0, 0.5, 0);
	innerGlow.Position = UDim2.new(0, 0, 0, 0);
	innerGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	innerGlow.BackgroundTransparency = 0.95;
	innerGlow.BorderSizePixel = 0;
	innerGlow.ZIndex = 1;
	innerGlow.Parent = self.Window;
	Instance.new("UICorner", innerGlow).CornerRadius = UDim.new(0, 16);
	table.insert(self.GlassElements, innerGlow);

	-- 顶部高光条（iOS Liquid Glass 标志性顶部反光）
	local topHighlight = Instance.new("Frame");
	topHighlight.Name = "GlassTopHighlight";
	topHighlight.Size = UDim2.new(0.7, 0, 0, 1);
	topHighlight.Position = UDim2.new(0.15, 0, 0, 0);
	topHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	topHighlight.BackgroundTransparency = 0.6;
	topHighlight.BorderSizePixel = 0;
	topHighlight.ZIndex = 2;
	topHighlight.Parent = self.Window;
	Instance.new("UICorner", topHighlight).CornerRadius = UDim.new(0, 16);
	table.insert(self.GlassElements, topHighlight);

	-- 边缘光晕（模拟玻璃边缘折射）
	local edgeGlow = Instance.new("ImageLabel");
	edgeGlow.Name = "GlassEdgeGlow";
	edgeGlow.Size = UDim2.new(1, 4, 1, 4);
	edgeGlow.Position = UDim2.new(0, -2, 0, -2);
	edgeGlow.BackgroundTransparency = 1;
	edgeGlow.Image = "rbxassetid://5554236805";
	edgeGlow.ImageColor3 = Color3.fromRGB(150, 200, 255);
	edgeGlow.ImageTransparency = 0.7;
	edgeGlow.ScaleType = Enum.ScaleType.Slice;
	edgeGlow.SliceCenter = Rect.new(23, 23, 277, 277);
	edgeGlow.ZIndex = 2;
	edgeGlow.Parent = self.Window;
	table.insert(self.GlassElements, edgeGlow);

	-- ===== 动态光线反射（随设备移动变化） =====
	local reflectConn;
	reflectConn = UserInputService.InputChanged:Connect(function(input)
		if not self.IsGlass then reflectConn:Disconnect(); return; end;
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			pcall(function()
				local pos = input.Position;
				local absPos = self.Window.AbsolutePosition;
				local absSize = self.Window.AbsoluteSize;
				-- 计算鼠标相对窗口的位置 (0~1)
				local relX = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1);
				local relY = math.clamp((pos.Y - absPos.Y) / absSize.Y, 0, 1);

				-- 内层光泽跟随鼠标
				innerGlow.Position = UDim2.new(0, 0, 0, 0);
				innerGlow.Size = UDim2.new(1, 0, 0.3 + relY * 0.4, 0);
				innerGlow.BackgroundTransparency = 0.92 + relY * 0.06;

				-- 边缘光晕颜色随位置变化
				local hue = relX * 0.15;
				edgeGlow.ImageColor3 = Color3.fromHSV(hue, 0.3, 1);
				edgeGlow.ImageTransparency = 0.65 + relY * 0.15;

				-- 顶部高光位置微调
				topHighlight.Position = UDim2.new(0.1 + relX * 0.2, 0, 0, 0);
				topHighlight.Size = UDim2.new(0.6 + relX * 0.2, 0, 0, 1);
				topHighlight.BackgroundTransparency = 0.5 + relY * 0.2;
			end);
		end;
	end);
	table.insert(self.GlassElements, {type="conn", value=reflectConn});

	-- ===== 标题栏：iOS 导航栏风格 =====
	TweenService:Create(self.TitleBar, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(40, 40, 55),
		BackgroundTransparency = 0.35
	}):Play();

	-- 标题栏底部：iOS 风格的细线分隔
	for _, child in ipairs(self.TitleBar:GetChildren()) do
		if child:IsA("Frame") and child.Name ~= "GlassInnerGlow" then
			TweenService:Create(child, TweenInfo.new(0.5), {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.85
			}):Play();
		end;
	end;

	-- 标题文字：iOS 风格半透明白色
	TweenService:Create(self.TitleLabel, TweenInfo.new(0.5), {
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextTransparency = 0.1
	}):Play();

	-- ===== 侧边栏：iOS Control Center 风格 =====
	TweenService:Create(self.Sidebar, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(35, 35, 50),
		BackgroundTransparency = 0.4
	}):Play();

	-- 侧边栏分隔线
	for _, child in ipairs(self.Sidebar:GetChildren()) do
		if child:IsA("Frame") then
			TweenService:Create(child, TweenInfo.new(0.5), {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.88
			}):Play();
		end;
	end;

	-- ===== 标签按钮：iOS 圆形胶囊按钮风格 =====
	for _, t in ipairs(self.Tabs) do
		local isActive = (self.ActiveTab == t);

		-- iOS 风格的磨砂玻璃按钮
		TweenService:Create(t.Button, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
			BackgroundColor3 = isActive and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(50, 50, 70),
			BackgroundTransparency = isActive and 0.25 or 0.4,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextTransparency = isActive and 0 or 0.15
		}):Play();

		-- 按钮内发光（iOS 按钮内部光泽）
		local btnGlow = Instance.new("Frame");
		btnGlow.Name = "GlassBtnGlow";
		btnGlow.Size = UDim2.new(1, -4, 0.5, 0);
		btnGlow.Position = UDim2.new(0, 2, 0, 1);
		btnGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		btnGlow.BackgroundTransparency = 0.92;
		btnGlow.BorderSizePixel = 0;
		btnGlow.ZIndex = 7;
		btnGlow.Parent = t.Button;
		Instance.new("UICorner", btnGlow).CornerRadius = UDim.new(0, 7);
		table.insert(self.GlassElements, btnGlow);

		-- 更新 hover 效果
		t.Button.MouseEnter:Connect(function()
			if self.IsGlass and self.ActiveTab ~= t then
				TweenService:Create(t.Button, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(70, 70, 100),
					BackgroundTransparency = 0.3
				}):Play();
				TweenService:Create(btnGlow, TweenInfo.new(0.2), {BackgroundTransparency=0.88}):Play();
			end;
		end);
		t.Button.MouseLeave:Connect(function()
			if self.IsGlass and self.ActiveTab ~= t then
				TweenService:Create(t.Button, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(50, 50, 70),
					BackgroundTransparency = 0.4
				}):Play();
				TweenService:Create(btnGlow, TweenInfo.new(0.2), {BackgroundTransparency=0.92}):Play();
			end;
		end);
	end;

	-- ===== 内容区域文字 =====
	for _, lbl in ipairs(self.Content:GetDescendants()) do
		if lbl:IsA("TextLabel") then
			TweenService:Create(lbl, TweenInfo.new(0.4), {
				TextColor3 = Color3.fromRGB(220, 220, 240),
				TextTransparency = 0.05
			}):Play();
		end;
	end;

	-- ===== DNA 颜色调柔和 =====
	self.DNA:SetColors(
		Color3.fromRGB(80, 160, 255),
		Color3.fromRGB(160, 120, 255),
		Color3.fromRGB(180, 180, 220)
	);

	-- ===== 描边变柔和 =====
	self.Border:SetThickness(2);
end;

function FH_cxh:_applyDarkTheme()
	self.CurrentTheme = "dark";
	self.IsGlass = false;

	-- 移除模糊
	if self.GlassBlur then
		TweenService:Create(self.GlassBlur, TweenInfo.new(0.5), {Size=0}):Play();
		task.delay(0.6, function()
			if self.GlassBlur and self.GlassBlur.Parent then
				self.GlassBlur:Destroy();
			end;
			self.GlassBlur = nil;
		end);
	end;

	-- 移除所有玻璃元素
	for _, elem in ipairs(self.GlassElements) do
		pcall(function()
			if type(elem) == "table" and elem.type == "conn" then
				elem.value:Disconnect();
			elseif typeof(elem) == "Instance" then
				TweenService:Create(elem, TweenInfo.new(0.3), {BackgroundTransparency=1, ImageTransparency=1}):Play();
				task.delay(0.4, function() elem:Destroy(); end);
			end;
		end);
	end;
	self.GlassElements = {};

	-- 恢复深色
	TweenService:Create(self.Window, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(15, 15, 25),
		BackgroundTransparency = 0.05
	}):Play();

	TweenService:Create(self.TitleBar, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(20, 20, 35),
		BackgroundTransparency = 0.3
	}):Play();

	TweenService:Create(self.TitleLabel, TweenInfo.new(0.5), {
		TextColor3 = self.Theme.Text,
		TextTransparency = 0
	}):Play();

	-- 标题栏线
	for _, child in ipairs(self.TitleBar:GetChildren()) do
		if child:IsA("Frame") then
			TweenService:Create(child, TweenInfo.new(0.5), {
				BackgroundColor3 = Color3.fromRGB(80, 80, 120),
				BackgroundTransparency = 0.5
			}):Play();
		end;
	end;

	TweenService:Create(self.Sidebar, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(20, 20, 35),
		BackgroundTransparency = 0.5
	}):Play();

	for _, child in ipairs(self.Sidebar:GetChildren()) do
		if child:IsA("Frame") then
			TweenService:Create(child, TweenInfo.new(0.5), {
				BackgroundColor3 = Color3.fromRGB(80, 80, 120),
				BackgroundTransparency = 0.5
			}):Play();
		end;
	end;

	-- 恢复标签
	for _, t in ipairs(self.Tabs) do
		-- 移除按钮光泽
		for _, child in ipairs(t.Button:GetChildren()) do
			if child.Name == "GlassBtnGlow" then
				child:Destroy();
			end;
		end;

		if self.ActiveTab == t then
			TweenService:Create(t.Button, TweenInfo.new(0.3), {
				BackgroundColor3 = self.Theme.Accent,
				BackgroundTransparency = 0,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTransparency = 0
			}):Play();
		else
			TweenService:Create(t.Button, TweenInfo.new(0.3), {
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.3,
				TextColor3 = self.Theme.TextDim,
				TextTransparency = 0
			}):Play();
		end;
	end;

	-- 恢复文字
	for _, lbl in ipairs(self.Content:GetDescendants()) do
		if lbl:IsA("TextLabel") then
			TweenService:Create(lbl, TweenInfo.new(0.3), {
				TextColor3 = self.Theme.Text,
				TextTransparency = 0
			}):Play();
		end;
	end;

	-- DNA 恢复
	self.DNA:SetColors(
		Color3.fromRGB(0, 200, 255),
		Color3.fromRGB(255, 50, 200),
		Color3.fromRGB(255, 255, 255)
	);

	self.Border:SetThickness(3);
end;

-- ========== 销毁 ==========
function FH_cxh:Destroy()
	if self.DNA then self.DNA:Destroy(); end;
	if self.Border then self.Border:Destroy(); end;
	if self.GlassBlur and self.GlassBlur.Parent then self.GlassBlur:Destroy(); end;
	for _, elem in ipairs(self.GlassElements) do
		pcall(function()
			if type(elem) == "table" and elem.type == "conn" then
				elem.value:Disconnect();
			elseif typeof(elem) == "Instance" then
				elem:Destroy();
			end;
		end);
	end;
	if self.Gui then self.Gui:Destroy(); end;
end;

return FH_cxh;
