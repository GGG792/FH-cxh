-- ============================================================
-- FH-cxh UI Library
-- 正式版 - 高大上圆角UI框架
-- ============================================================

local FH_cxh = {};
FH_cxh.__index = FH_cxh;

-- 服务
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;

-- 模块
local DNABackground = loadstring(game:HttpGet("https://raw.githubusercontent.com/GGG792/FH-cxh/main/modules/DNABackground.lua"))();
local RainbowBorder = loadstring(game:HttpGet("https://raw.githubusercontent.com/GGG792/FH-cxh/main/modules/RainbowBorder.lua"))();

-- 默认主题
local THEME = {
	Background = Color3.fromRGB(15, 15, 25);
	Card = Color3.fromRGB(25, 25, 40);
	CardHover = Color3.fromRGB(35, 35, 55);
	Text = Color3.fromRGB(240, 240, 255);
	TextDim = Color3.fromRGB(150, 150, 180);
	Accent = Color3.fromRGB(100, 200, 255);
	CornerRadius = UDim.new(0, 16);
	WindowSize = {Width = 700, Height = 450};
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
	-- ScreenGui
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
	
	-- 圆角
	local corner = Instance.new("UICorner");
	corner.CornerRadius = self.Theme.CornerRadius;
	corner.Parent = self.Window;
	
	-- 阴影
	local shadow = Instance.new("ImageLabel");
	shadow.Name = "Shadow";
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
	-- 标题栏背景
	self.TitleBar = Instance.new("Frame");
	self.TitleBar.Name = "TitleBar";
	self.TitleBar.Size = UDim2.new(1, 0, 0, 44);
	self.TitleBar.Position = UDim2.new(0, 0, 0, 0);
	self.TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35);
	self.TitleBar.BackgroundTransparency = 0.3;
	self.TitleBar.BorderSizePixel = 0;
	self.TitleBar.ZIndex = 10;
	self.TitleBar.Parent = self.Window;
	
	-- 标题栏底部线
	local line = Instance.new("Frame");
	line.Size = UDim2.new(1, 0, 0, 1);
	line.Position = UDim2.new(0, 0, 1, -1);
	line.BackgroundColor3 = Color3.fromRGB(80, 80, 120);
	line.BackgroundTransparency = 0.5;
	line.BorderSizePixel = 0;
	line.ZIndex = 10;
	line.Parent = self.TitleBar;
	
	-- Logo 图标
	local logo = Instance.new("Frame");
	logo.Size = UDim2.new(0, 28, 0, 28);
	logo.Position = UDim2.new(0, 12, 0, 8);
	logo.BackgroundColor3 = self.Theme.Accent;
	logo.BorderSizePixel = 0;
	logo.ZIndex = 11;
	logo.Parent = self.TitleBar;
	Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 8);
	
	-- Logo 文字
	local logoText = Instance.new("TextLabel");
	logoText.Size = UDim2.new(1, 0, 1, 0);
	logoText.BackgroundTransparency = 1;
	logoText.Text = "FH";
	logoText.Font = Enum.Font.SourceSansBold;
	logoText.TextSize = 16;
	logoText.TextColor3 = Color3.fromRGB(255, 255, 255);
	logoText.ZIndex = 12;
	logoText.Parent = logo;
	
	-- 标题文字
	local title = Instance.new("TextLabel");
	title.Size = UDim2.new(0, 200, 1, 0);
	title.Position = UDim2.new(0, 48, 0, 0);
	title.BackgroundTransparency = 1;
	title.Text = self.Name;
	title.Font = Enum.Font.SourceSansBold;
	title.TextSize = 18;
	title.TextColor3 = self.Theme.Text;
	title.TextXAlignment = Enum.TextXAlignment.Left;
	title.ZIndex = 11;
	title.Parent = self.TitleBar;
	
	-- 关闭按钮
	local closeBtn = Instance.new("TextButton");
	closeBtn.Size = UDim2.new(0, 32, 0, 32);
	closeBtn.Position = UDim2.new(1, -40, 0, 6);
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 71, 87);
	closeBtn.BackgroundTransparency = 0.3;
	closeBtn.Text = "X";
	closeBtn.Font = Enum.Font.SourceSansBold;
	closeBtn.TextSize = 14;
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
	closeBtn.ZIndex = 11;
	closeBtn.Parent = self.TitleBar;
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8);
	
	closeBtn.MouseEnter:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play();
	end);
	closeBtn.MouseLeave:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.3}):Play();
	end);
	closeBtn.MouseButton1Click:Connect(function()
		self:Destroy();
	end);
	
	-- 最小化按钮
	local minBtn = Instance.new("TextButton");
	minBtn.Size = UDim2.new(0, 32, 0, 32);
	minBtn.Position = UDim2.new(1, -78, 0, 6);
	minBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0);
	minBtn.BackgroundTransparency = 0.3;
	minBtn.Text = "-";
	minBtn.Font = Enum.Font.SourceSansBold;
	minBtn.TextSize = 18;
	minBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
	minBtn.ZIndex = 11;
	minBtn.Parent = self.TitleBar;
	Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8);
	
	minBtn.MouseEnter:Connect(function()
		TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundTransparency=0}):Play();
	end);
	minBtn.MouseLeave:Connect(function()
		TweenService:Create(minBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.3}):Play();
	end);
end;

function FH_cxh:_createSidebar()
	-- 侧边栏
	self.Sidebar = Instance.new("Frame");
	self.Sidebar.Name = "Sidebar";
	self.Sidebar.Size = UDim2.new(0, 160, 1, -44);
	self.Sidebar.Position = UDim2.new(0, 0, 0, 44);
	self.Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 35);
	self.Sidebar.BackgroundTransparency = 0.5;
	self.Sidebar.BorderSizePixel = 0;
	self.Sidebar.ZIndex = 5;
	self.Sidebar.Parent = self.Window;
	
	-- 侧边栏右边线
	local line = Instance.new("Frame");
	line.Size = UDim2.new(0, 1, 1, 0);
	line.Position = UDim2.new(1, -1, 0, 0);
	line.BackgroundColor3 = Color3.fromRGB(80, 80, 120);
	line.BackgroundTransparency = 0.5;
	line.BorderSizePixel = 0;
	line.ZIndex = 5;
	line.Parent = self.Sidebar;
	
	self.Tabs = {};
	self.ActiveTab = nil;
end;

function FH_cxh:_createContentArea()
	-- 内容区域
	self.Content = Instance.new("Frame");
	self.Content.Name = "Content";
	self.Content.Size = UDim2.new(1, -160, 1, -44);
	self.Content.Position = UDim2.new(0, 160, 0, 44);
	self.Content.BackgroundTransparency = 1;
	self.Content.BorderSizePixel = 0;
	self.Content.ZIndex = 5;
	self.Content.Parent = self.Window;
	
	-- 欢迎文字
	local welcome = Instance.new("TextLabel");
	welcome.Size = UDim2.new(1, -40, 0, 40);
	welcome.Position = UDim2.new(0, 20, 0, 20);
	welcome.BackgroundTransparency = 1;
	welcome.Text = "Welcome to " .. self.Name;
	welcome.Font = Enum.Font.SourceSansBold;
	welcome.TextSize = 24;
	welcome.TextColor3 = self.Theme.Text;
	welcome.TextXAlignment = Enum.TextXAlignment.Left;
	welcome.ZIndex = 6;
	welcome.Parent = self.Content;
	
	local sub = Instance.new("TextLabel");
	sub.Size = UDim2.new(1, -40, 0, 20);
	sub.Position = UDim2.new(0, 20, 0, 60);
	sub.BackgroundTransparency = 1;
	sub.Text = "Select a tab from the sidebar to get started.";
	sub.Font = Enum.Font.SourceSans;
	sub.TextSize = 14;
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

-- ========== 添加标签页 ==========
function FH_cxh:AddTab(name, icon)
	local tabBtn = Instance.new("TextButton");
	tabBtn.Size = UDim2.new(1, -16, 0, 36);
	tabBtn.Position = UDim2.new(0, 8, 0, 8 + (#self.Tabs * 42));
	tabBtn.BackgroundColor3 = self.Theme.Card;
	tabBtn.BackgroundTransparency = 0.3;
	tabBtn.Text = "  " .. (icon or "") .. " " .. name;
	tabBtn.Font = Enum.Font.SourceSansBold;
	tabBtn.TextSize = 14;
	tabBtn.TextColor3 = self.Theme.TextDim;
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left;
	tabBtn.ZIndex = 6;
	tabBtn.Parent = self.Sidebar;
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10);
	
	local tabContent = Instance.new("Frame");
	tabContent.Size = UDim2.new(1, 0, 1, 0);
	tabContent.BackgroundTransparency = 1;
	tabContent.Visible = false;
	tabContent.ZIndex = 6;
	tabContent.Parent = self.Content;
	
	local tab = {
		Button = tabBtn;
		Content = tabContent;
		Name = name;
	};
	
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
	
	if #self.Tabs == 1 then
		self:SelectTab(tab);
	end;
	
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

-- ========== 销毁 ==========
function FH_cxh:Destroy()
	if self.DNA then self.DNA:Destroy(); end;
	if self.Border then self.Border:Destroy(); end;
	if self.Gui then self.Gui:Destroy(); end;
end;

-- ========== 返回库 ==========
return FH_cxh;
