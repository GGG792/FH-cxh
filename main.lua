-- ============================================================
-- FH-cxh Liquid Glass UI
-- iOS 26 Liquid Glass 风格 - 纯液态玻璃主题
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

-- ========== 创建窗口 ==========
function FH_cxh.new(config)
	config = config or {};
	local self = setmetatable({}, FH_cxh);
	self.Name = config.Name or "FH-cxh";
	self.Tabs = {};
	self.ActiveTab = nil;
	self.GlassElements = {};
	self.Connections = {};

	self:_createWindow();
	self:_createDNA();
	self:_createGlassBorder();
	self:_createTitleBar();
	self:_createSidebar();
	self:_createContentArea();
	self:_makeDraggable();
	self:_startGlassAnimation();

	return self;
end;

function FH_cxh:_createWindow()
	self.Gui = Instance.new("ScreenGui");
	self.Gui.Name = "FH_cxh_" .. self.Name;
	self.Gui.Parent = LocalPlayer.PlayerGui;
	self.Gui.ResetOnSpawn = false;
	self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
	self.Gui.IgnoreGuiInset = true;

	-- 主窗口 - 液态玻璃主体
	self.Window = Instance.new("Frame");
	self.Window.Name = "MainWindow";
	self.Window.Size = UDim2.new(0, 520, 0, 340);
	self.Window.Position = UDim2.new(0.5, -260, 0.5, -170);
	self.Window.BackgroundColor3 = Color3.fromRGB(35, 35, 50);
	self.Window.BackgroundTransparency = 0.25;
	self.Window.BorderSizePixel = 0;
	self.Window.ClipsDescendants = true;
	self.Window.Parent = self.Gui;

	-- 大圆角
	local corner = Instance.new("UICorner");
	corner.CornerRadius = UDim.new(0, 24);
	corner.Parent = self.Window;

	-- 全局模糊
	self.GlassBlur = Instance.new("BlurEffect");
	self.GlassBlur.Size = 20;
	self.GlassBlur.Parent = Lighting;

	-- 内层光泽（模拟光线折射）
	self.InnerGlow = Instance.new("Frame");
	self.InnerGlow.Name = "InnerGlow";
	self.InnerGlow.Size = UDim2.new(1, 0, 0.6, 0);
	self.InnerGlow.Position = UDim2.new(0, 0, 0, 0);
	self.InnerGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	self.InnerGlow.BackgroundTransparency = 0.94;
	self.InnerGlow.BorderSizePixel = 0;
	self.InnerGlow.ZIndex = 1;
	self.InnerGlow.Parent = self.Window;
	Instance.new("UICorner", self.InnerGlow).CornerRadius = UDim.new(0, 24);

	-- 顶部高光（iOS 标志性顶部反光）
	self.TopHighlight = Instance.new("Frame");
	self.TopHighlight.Name = "TopHighlight";
	self.TopHighlight.Size = UDim2.new(0.6, 0, 0, 2);
	self.TopHighlight.Position = UDim2.new(0.2, 0, 0, 1);
	self.TopHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	self.TopHighlight.BackgroundTransparency = 0.5;
	self.TopHighlight.BorderSizePixel = 0;
	self.TopHighlight.ZIndex = 2;
	self.TopHighlight.Parent = self.Window;
	Instance.new("UICorner", self.TopHighlight).CornerRadius = UDim.new(0, 1);

	-- 底部微光
	self.BottomGlow = Instance.new("Frame");
	self.BottomGlow.Name = "BottomGlow";
	self.BottomGlow.Size = UDim2.new(1, 0, 0.3, 0);
	self.BottomGlow.Position = UDim2.new(0, 0, 0.7, 0);
	self.BottomGlow.BackgroundColor3 = Color3.fromRGB(100, 150, 255);
	self.BottomGlow.BackgroundTransparency = 0.97;
	self.BottomGlow.BorderSizePixel = 0;
	self.BottomGlow.ZIndex = 1;
	self.BottomGlow.Parent = self.Window;
	Instance.new("UICorner", self.BottomGlow).CornerRadius = UDim.new(0, 24);

	-- 外发光（玻璃边缘折射）
	self.OuterGlow = Instance.new("ImageLabel");
	self.OuterGlow.Name = "OuterGlow";
	self.OuterGlow.Size = UDim2.new(1, 20, 1, 20);
	self.OuterGlow.Position = UDim2.new(0, -10, 0, -10);
	self.OuterGlow.BackgroundTransparency = 1;
	self.OuterGlow.Image = "rbxassetid://5554236805";
	self.OuterGlow.ImageColor3 = Color3.fromRGB(120, 180, 255);
	self.OuterGlow.ImageTransparency = 0.75;
	self.OuterGlow.ScaleType = Enum.ScaleType.Slice;
	self.OuterGlow.SliceCenter = Rect.new(23, 23, 277, 277);
	self.OuterGlow.ZIndex = -1;
	self.OuterGlow.Parent = self.Window;
end;

function FH_cxh:_createDNA()
	self.DNA = DNABackground.new(self.Window, {
		HelixCount = 2;
		PointsPerHelix = 18;
		Amplitude = 50;
		Speed = 0.6;
		TiltAngle = 25;
		ColorA = Color3.fromRGB(100, 180, 255);
		ColorB = Color3.fromRGB(180, 140, 255);
		ConnectionColor = Color3.fromRGB(200, 200, 230);
		ConnectionTransparency = 0.8;
	});
	self.DNA:Start();
end;

function FH_cxh:_createGlassBorder()
	-- 圆角炫彩边框 - 使用4个圆角Frame拼接
	self.BorderParts = {};
	local thickness = 3;
	local radius = 24;

	-- 上边框
	local top = Instance.new("Frame");
	top.Size = UDim2.new(1, -radius*2, 0, thickness);
	top.Position = UDim2.new(0, radius, 0, 0);
	top.BorderSizePixel = 0;
	top.ZIndex = 100;
	top.Parent = self.Window;
	table.insert(self.BorderParts, top);

	-- 下边框
	local bottom = Instance.new("Frame");
	bottom.Size = UDim2.new(1, -radius*2, 0, thickness);
	bottom.Position = UDim2.new(0, radius, 1, -thickness);
	bottom.BorderSizePixel = 0;
	bottom.ZIndex = 100;
	bottom.Parent = self.Window;
	table.insert(self.BorderParts, bottom);

	-- 左边框
	local left = Instance.new("Frame");
	left.Size = UDim2.new(0, thickness, 1, -radius*2);
	left.Position = UDim2.new(0, 0, 0, radius);
	left.BorderSizePixel = 0;
	left.ZIndex = 100;
	left.Parent = self.Window;
	table.insert(self.BorderParts, left);

	-- 右边框
	local right = Instance.new("Frame");
	right.Size = UDim2.new(0, thickness, 1, -radius*2);
	right.Position = UDim2.new(1, -thickness, 0, radius);
	right.BorderSizePixel = 0;
	right.ZIndex = 100;
	right.Parent = self.Window;
	table.insert(self.BorderParts, right);

	-- 左上角圆弧
	local tl = Instance.new("Frame");
	tl.Size = UDim2.new(0, radius, 0, radius);
	tl.Position = UDim2.new(0, 0, 0, 0);
	tl.BorderSizePixel = 0;
	tl.ZIndex = 100;
	tl.Parent = self.Window;
	table.insert(self.BorderParts, tl);

	-- 右上角圆弧
	local tr = Instance.new("Frame");
	tr.Size = UDim2.new(0, radius, 0, radius);
	tr.Position = UDim2.new(1, -radius, 0, 0);
	tr.BorderSizePixel = 0;
	tr.ZIndex = 100;
	tr.Parent = self.Window;
	table.insert(self.BorderParts, tr);

	-- 左下角圆弧
	local bl = Instance.new("Frame");
	bl.Size = UDim2.new(0, radius, 0, radius);
	bl.Position = UDim2.new(0, 0, 1, -radius);
	bl.BorderSizePixel = 0;
	bl.ZIndex = 100;
	bl.Parent = self.Window;
	table.insert(self.BorderParts, bl);

	-- 右下角圆弧
	local br = Instance.new("Frame");
	br.Size = UDim2.new(0, radius, 0, radius);
	br.Position = UDim2.new(1, -radius, 1, -radius);
	br.BorderSizePixel = 0;
	br.ZIndex = 100;
	br.Parent = self.Window;
	table.insert(self.BorderParts, br);
end;

function FH_cxh:_createTitleBar()
	self.TitleBar = Instance.new("Frame");
	self.TitleBar.Name = "TitleBar";
	self.TitleBar.Size = UDim2.new(1, -12, 0, 38);
	self.TitleBar.Position = UDim2.new(0, 6, 0, 6);
	self.TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70);
	self.TitleBar.BackgroundTransparency = 0.4;
	self.TitleBar.BorderSizePixel = 0;
	self.TitleBar.ZIndex = 10;
	self.TitleBar.Parent = self.Window;
	Instance.new("UICorner", self.TitleBar).CornerRadius = UDim.new(0, 16);

	-- 标题栏内发光
	local titleGlow = Instance.new("Frame");
	titleGlow.Size = UDim2.new(1, -4, 0.5, 0);
	titleGlow.Position = UDim2.new(0, 2, 0, 1);
	titleGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	titleGlow.BackgroundTransparency = 0.92;
	titleGlow.BorderSizePixel = 0;
	titleGlow.ZIndex = 11;
	titleGlow.Parent = self.TitleBar;
	Instance.new("UICorner", titleGlow).CornerRadius = UDim.new(0, 14);

	-- Logo
	local logo = Instance.new("Frame");
	logo.Size = UDim2.new(0, 22, 0, 22);
	logo.Position = UDim2.new(0, 10, 0, 8);
	logo.BackgroundColor3 = Color3.fromRGB(100, 180, 255);
	logo.BackgroundTransparency = 0.3;
	logo.BorderSizePixel = 0;
	logo.ZIndex = 12;
	logo.Parent = self.TitleBar;
	Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 7);

	local logoText = Instance.new("TextLabel");
	logoText.Size = UDim2.new(1, 0, 1, 0);
	logoText.BackgroundTransparency = 1;
	logoText.Text = "FH";
	logoText.Font = Enum.Font.SourceSansBold;
	logoText.TextSize = 12;
	logoText.TextColor3 = Color3.fromRGB(255, 255, 255);
	logoText.ZIndex = 13;
	logoText.Parent = logo;

	-- 标题
	self.TitleLabel = Instance.new("TextLabel");
	self.TitleLabel.Size = UDim2.new(0, 150, 1, 0);
	self.TitleLabel.Position = UDim2.new(0, 38, 0, 0);
	self.TitleLabel.BackgroundTransparency = 1;
	self.TitleLabel.Text = self.Name;
	self.TitleLabel.Font = Enum.Font.SourceSansBold;
	self.TitleLabel.TextSize = 14;
	self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
	self.TitleLabel.TextTransparency = 0.15;
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left;
	self.TitleLabel.ZIndex = 12;
	self.TitleLabel.Parent = self.TitleBar;

	-- 关闭按钮
	local closeBtn = Instance.new("TextButton");
	closeBtn.Size = UDim2.new(0, 26, 0, 26);
	closeBtn.Position = UDim2.new(1, -36, 0, 6);
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80);
	closeBtn.BackgroundTransparency = 0.4;
	closeBtn.Text = "";
	closeBtn.BorderSizePixel = 0;
	closeBtn.ZIndex = 12;
	closeBtn.Parent = self.TitleBar;
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8);

	-- 关闭按钮内发光
	local closeGlow = Instance.new("Frame");
	closeGlow.Size = UDim2.new(1, -4, 0.5, 0);
	closeGlow.Position = UDim2.new(0, 2, 0, 1);
	closeGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	closeGlow.BackgroundTransparency = 0.85;
	closeGlow.BorderSizePixel = 0;
	closeGlow.ZIndex = 13;
	closeGlow.Parent = closeBtn;
	Instance.new("UICorner", closeGlow).CornerRadius = UDim.new(0, 6);

	closeBtn.MouseEnter:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.15}):Play();
	end);
	closeBtn.MouseLeave:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency=0.4}):Play();
	end);
	closeBtn.MouseButton1Click:Connect(function()
		self:Destroy();
	end);
end;

function FH_cxh:_createSidebar()
	self.Sidebar = Instance.new("Frame");
	self.Sidebar.Name = "Sidebar";
	self.Sidebar.Size = UDim2.new(0, 120, 1, -56);
	self.Sidebar.Position = UDim2.new(0, 6, 0, 50);
	self.Sidebar.BackgroundColor3 = Color3.fromRGB(45, 45, 65);
	self.Sidebar.BackgroundTransparency = 0.45;
	self.Sidebar.BorderSizePixel = 0;
	self.Sidebar.ZIndex = 5;
	self.Sidebar.Parent = self.Window;
	Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 14);

	-- 侧边栏内发光
	local sideGlow = Instance.new("Frame");
	sideGlow.Size = UDim2.new(1, -4, 0.4, 0);
	sideGlow.Position = UDim2.new(0, 2, 0, 1);
	sideGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	sideGlow.BackgroundTransparency = 0.94;
	sideGlow.BorderSizePixel = 0;
	sideGlow.ZIndex = 6;
	sideGlow.Parent = self.Sidebar;
	Instance.new("UICorner", sideGlow).CornerRadius = UDim.new(0, 12);
end;

function FH_cxh:_createContentArea()
	self.Content = Instance.new("Frame");
	self.Content.Name = "Content";
	self.Content.Size = UDim2.new(1, -138, 1, -56);
	self.Content.Position = UDim2.new(0, 132, 0, 50);
	self.Content.BackgroundTransparency = 1;
	self.Content.BorderSizePixel = 0;
	self.Content.ZIndex = 5;
	self.Content.Parent = self.Window;

	local welcome = Instance.new("TextLabel");
	welcome.Size = UDim2.new(1, -20, 0, 28);
	welcome.Position = UDim2.new(0, 10, 0, 12);
	welcome.BackgroundTransparency = 1;
	welcome.Text = "Welcome";
	welcome.Font = Enum.Font.SourceSansBold;
	welcome.TextSize = 18;
	welcome.TextColor3 = Color3.fromRGB(255, 255, 255);
	welcome.TextTransparency = 0.2;
	welcome.TextXAlignment = Enum.TextXAlignment.Left;
	welcome.ZIndex = 6;
	welcome.Parent = self.Content;

	local sub = Instance.new("TextLabel");
	sub.Size = UDim2.new(1, -20, 0, 14);
	sub.Position = UDim2.new(0, 10, 0, 40);
	sub.BackgroundTransparency = 1;
	sub.Text = "Select a tab";
	sub.Font = Enum.Font.SourceSans;
	sub.TextSize = 12;
	sub.TextColor3 = Color3.fromRGB(200, 200, 230);
	sub.TextTransparency = 0.3;
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

-- ========== 炫彩边框动画 ==========
function FH_cxh:_startGlassAnimation()
	-- 炫彩边框颜色循环
	local conn = RunService.RenderStepped:Connect(function()
		local t = tick() * 1.5;
		for i, part in ipairs(self.BorderParts) do
			local hue = ((t + i * 0.125) % 1);
			local color = Color3.fromHSV(hue, 0.7, 1);
			part.BackgroundColor3 = color;
			part.BackgroundTransparency = 0.15 + math.sin(t * 2 + i) * 0.1;
		end;

		-- 内层光泽呼吸
		if self.InnerGlow then
			self.InnerGlow.BackgroundTransparency = 0.92 + math.sin(t * 0.8) * 0.04;
		end;

		-- 底部微光呼吸
		if self.BottomGlow then
			self.BottomGlow.BackgroundTransparency = 0.96 + math.sin(t * 0.6 + 1) * 0.02;
		end;

		-- 外发光颜色变化
		if self.OuterGlow then
			local outerHue = (t * 0.3) % 1;
			self.OuterGlow.ImageColor3 = Color3.fromHSV(outerHue, 0.4, 1);
			self.OuterGlow.ImageTransparency = 0.7 + math.sin(t) * 0.1;
		end;

		-- 顶部高光闪烁
		if self.TopHighlight then
			self.TopHighlight.BackgroundTransparency = 0.45 + math.sin(t * 1.5) * 0.15;
		end;
	end);
	table.insert(self.Connections, conn);

	-- 鼠标移动时的光线反射
	local reflectConn = UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			pcall(function()
				local pos = input.Position;
				local absPos = self.Window.AbsolutePosition;
				local absSize = self.Window.AbsoluteSize;
				local relX = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1);
				local relY = math.clamp((pos.Y - absPos.Y) / absSize.Y, 0, 1);

				-- 内层光泽随鼠标移动
				if self.InnerGlow then
					self.InnerGlow.Size = UDim2.new(1, 0, 0.4 + relY * 0.3, 0);
					self.InnerGlow.BackgroundTransparency = 0.9 + relY * 0.08;
				end;

				-- 顶部高光跟随
				if self.TopHighlight then
					self.TopHighlight.Position = UDim2.new(0.15 + relX * 0.1, 0, 0, 1);
					self.TopHighlight.Size = UDim2.new(0.5 + relX * 0.15, 0, 0, 2);
				end;

				-- 外发光颜色微调
				if self.OuterGlow then
					local hue = relX * 0.2;
					self.OuterGlow.ImageColor3 = Color3.fromHSV(hue, 0.35, 1);
				end;
			end);
		end;
	end);
	table.insert(self.Connections, reflectConn);
end;

-- ========== 标签页 ==========
function FH_cxh:AddTab(name, icon)
	local tabBtn = Instance.new("TextButton");
	tabBtn.Size = UDim2.new(1, -10, 0, 30);
	tabBtn.Position = UDim2.new(0, 5, 0, 6 + (#self.Tabs * 36));
	tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 85);
	tabBtn.BackgroundTransparency = 0.5;
	tabBtn.Text = "  " .. (icon or "") .. " " .. name;
	tabBtn.Font = Enum.Font.SourceSansBold;
	tabBtn.TextSize = 12;
	tabBtn.TextColor3 = Color3.fromRGB(200, 200, 220);
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left;
	tabBtn.ZIndex = 7;
	tabBtn.Parent = self.Sidebar;
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10);

	-- 按钮内发光
	local btnGlow = Instance.new("Frame");
	btnGlow.Size = UDim2.new(1, -4, 0.5, 0);
	btnGlow.Position = UDim2.new(0, 2, 0, 1);
	btnGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	btnGlow.BackgroundTransparency = 0.93;
	btnGlow.BorderSizePixel = 0;
	btnGlow.ZIndex = 8;
	btnGlow.Parent = tabBtn;
	Instance.new("UICorner", btnGlow).CornerRadius = UDim.new(0, 8);

	local tabContent = Instance.new("Frame");
	tabContent.Size = UDim2.new(1, 0, 1, 0);
	tabContent.BackgroundTransparency = 1;
	tabContent.Visible = false;
	tabContent.ZIndex = 6;
	tabContent.Parent = self.Content;

	local tab = {Button = tabBtn; Content = tabContent; Name = name; Glow = btnGlow};

	tabBtn.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(80, 80, 110),
				BackgroundTransparency = 0.35
			}):Play();
			TweenService:Create(btnGlow, TweenInfo.new(0.2), {BackgroundTransparency=0.88}):Play();
		end;
	end);

	tabBtn.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(60, 60, 85),
				BackgroundTransparency = 0.5
			}):Play();
			TweenService:Create(btnGlow, TweenInfo.new(0.2), {BackgroundTransparency=0.93}):Play();
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
		TweenService:Create(t.Button, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(60, 60, 85),
			BackgroundTransparency = 0.5,
			TextColor3 = Color3.fromRGB(200, 200, 220)
		}):Play();
		TweenService:Create(t.Glow, TweenInfo.new(0.2), {BackgroundTransparency=0.93}):Play();
	end;

	tab.Content.Visible = true;
	TweenService:Create(tab.Button, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(80, 160, 255),
		BackgroundTransparency = 0.25,
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play();
	TweenService:Create(tab.Glow, TweenInfo.new(0.2), {BackgroundTransparency=0.85}):Play();
	self.ActiveTab = tab;
end;

-- ========== 销毁 ==========
function FH_cxh:Destroy()
	for _, conn in ipairs(self.Connections) do
		conn:Disconnect();
	end;
	if self.DNA then self.DNA:Destroy(); end;
	if self.GlassBlur and self.GlassBlur.Parent then self.GlassBlur:Destroy(); end;
	if self.Gui then self.Gui:Destroy(); end;
end;

return FH_cxh;
