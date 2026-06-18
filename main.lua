-- ============================================================
-- FH-cxh UI Library
-- DNA Background + Rainbow Border + Liquid Glass Theme
-- ============================================================

local FH_cxh = {};
FH_cxh.__index = FH_cxh;

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Lighting = game:GetService("Lighting");
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
	self.Theme = config.Theme or {};
	for k, v in pairs(THEME) do
		if self.Theme[k] == nil then self.Theme[k] = v; end;
	end;

	self.CurrentTheme = "dark"; -- dark or glass
	self.Tabs = {};
	self.ActiveTab = nil;

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
	shadow.Size = UDim2.new(1, 40, 1, 40);
	shadow.Position = UDim2.new(0, -20, 0, -20);
	shadow.BackgroundTransparency = 1;
	shadow.Image = "rbxassetid://5554236805";
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0);
	shadow.ImageTransparency = 0.6;
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
	self.TitleBar.Position = UDim2.new(0, 0, 0, 0);
	self.TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35);
	self.TitleBar.BackgroundTransparency = 0.3;
	self.TitleBar.BorderSizePixel = 0;
	self.TitleBar.ZIndex = 10;
	self.TitleBar.Parent = self.Window;

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
	local title = Instance.new("TextLabel");
	title.Size = UDim2.new(0, 160, 1, 0);
	title.Position = UDim2.new(0, 40, 0, 0);
	title.BackgroundTransparency = 1;
	title.Text = self.Name;
	title.Font = Enum.Font.SourceSansBold;
	title.TextSize = 15;
	title.TextColor3 = self.Theme.Text;
	title.TextXAlignment = Enum.TextXAlignment.Left;
	title.ZIndex = 11;
	title.Parent = self.TitleBar;

	-- 主题切换按钮
	local themeBtn = Instance.new("TextButton");
	themeBtn.Size = UDim2.new(0, 28, 0, 28);
	themeBtn.Position = UDim2.new(1, -116, 0, 5);
	themeBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255);
	themeBtn.BackgroundTransparency = 0.3;
	themeBtn.Text = "G";
	themeBtn.Font = Enum.Font.SourceSansBold;
	themeBtn.TextSize = 12;
	themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
	themeBtn.ZIndex = 11;
	themeBtn.Parent = self.TitleBar;
	Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, 7);

	themeBtn.MouseEnter:Connect(function()
		TweenService:Create(themeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play();
	end);
	themeBtn.MouseLeave:Connect(function()
		TweenService:Create(themeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.3}):Play();
	end);
	themeBtn.MouseButton1Click:Connect(function()
		self:SwitchTheme();
	end);

	-- 最小化按钮
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

	minBtn.MouseEnter:Connect(function()
		TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play();
	end);
	minBtn.MouseLeave:Connect(function()
		TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.3}):Play();
	end);

	-- 关闭按钮
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

	closeBtn.MouseEnter:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play();
	end);
	closeBtn.MouseLeave:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.3}):Play();
	end);
	closeBtn.MouseButton1Click:Connect(function()
		self:Destroy();
	end);
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
	local dragStart = nil;
	local startPos = nil;

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

	tabBtn.MouseButton1Click:Connect(function()
		self:SelectTab(tab);
	end);

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

-- ========== 主题切换 ==========
function FH_cxh:SwitchTheme()
	if self.CurrentTheme == "dark" then
		self:_applyGlassTheme();
	else
		self:_applyDarkTheme();
	end;
end;

function FH_cxh:_applyGlassTheme()
	self.CurrentTheme = "glass";

	-- 模糊效果
	if not self.BlurEffect then
		self.BlurEffect = Instance.new("BlurEffect");
		self.BlurEffect.Size = 0;
		self.BlurEffect.Parent = Lighting;
	end;
	TweenService:Create(self.BlurEffect, TweenInfo.new(0.5), {Size=18}):Play();

	-- 窗口变液态玻璃
	TweenService:Create(self.Window, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.75
	}):Play();

	-- 标题栏变玻璃
	TweenService:Create(self.TitleBar, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.7
	}):Play();

	-- 侧边栏变玻璃
	TweenService:Create(self.Sidebar, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.75
	}):Play();

	-- 更新标签按钮颜色
	for _, t in ipairs(self.Tabs) do
		if self.ActiveTab == t then
			TweenService:Create(t.Button, TweenInfo.new(0.3), {
				BackgroundColor3 = Color3.fromRGB(100, 180, 255),
				BackgroundTransparency = 0.3
			}):Play();
		else
			TweenService:Create(t.Button, TweenInfo.new(0.3), {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.6
			}):Play();
		end;
		TweenService:Create(t.Button, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(30, 30, 50)}):Play();
	end;

	-- 更新文字颜色
	for _, lbl in ipairs(self.Content:GetDescendants()) do
		if lbl:IsA("TextLabel") then
			TweenService:Create(lbl, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(30, 30, 50)}):Play();
		end;
	end;

	-- DNA 颜色变淡蓝
	self.DNA:SetColors(
		Color3.fromRGB(100, 180, 255),
		Color3.fromRGB(180, 130, 255),
		Color3.fromRGB(200, 200, 255)
	);

	-- 描边变淡
	self.Border:SetThickness(2);
end;

function FH_cxh:_applyDarkTheme()
	self.CurrentTheme = "dark";

	-- 移除模糊
	if self.BlurEffect then
		TweenService:Create(self.BlurEffect, TweenInfo.new(0.5), {Size=0}):Play();
		task.delay(0.5, function()
			if self.BlurEffect and self.BlurEffect.Parent then
				self.BlurEffect:Destroy();
			end;
			self.BlurEffect = nil;
		end);
	end;

	-- 恢复深色
	TweenService:Create(self.Window, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(15, 15, 25),
		BackgroundTransparency = 0.05
	}):Play();

	TweenService:Create(self.TitleBar, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(20, 20, 35),
		BackgroundTransparency = 0.3
	}):Play();

	TweenService:Create(self.Sidebar, TweenInfo.new(0.5), {
		BackgroundColor3 = Color3.fromRGB(20, 20, 35),
		BackgroundTransparency = 0.5
	}):Play();

	-- 恢复标签颜色
	for _, t in ipairs(self.Tabs) do
		if self.ActiveTab == t then
			TweenService:Create(t.Button, TweenInfo.new(0.3), {
				BackgroundColor3 = self.Theme.Accent,
				BackgroundTransparency = 0
			}):Play();
			TweenService:Create(t.Button, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255,255,255)}):Play();
		else
			TweenService:Create(t.Button, TweenInfo.new(0.3), {
				BackgroundColor3 = self.Theme.Card,
				BackgroundTransparency = 0.3
			}):Play();
			TweenService:Create(t.Button, TweenInfo.new(0.3), {TextColor3 = self.Theme.TextDim}):Play();
		end;
	end;

	-- 恢复文字
	for _, lbl in ipairs(self.Content:GetDescendants()) do
		if lbl:IsA("TextLabel") then
			TweenService:Create(lbl, TweenInfo.new(0.3), {TextColor3 = self.Theme.Text}):Play();
		end;
	end;

	-- DNA 恢复原色
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
	if self.BlurEffect and self.BlurEffect.Parent then self.BlurEffect:Destroy(); end;
	if self.Gui then self.Gui:Destroy(); end;
end;

return FH_cxh;
