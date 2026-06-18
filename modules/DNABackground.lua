-- ============================================================
-- FH-cxh DNA Background Module
-- 飘动的 DNA 双螺旋背景动画
-- ============================================================

local DNABackground = {};

local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");

-- 默认配置
local DEFAULT_CONFIG = {
	HelixCount = 2;           -- DNA 链条数量
	PointsPerHelix = 24;      -- 每链节点数
	Amplitude = 80;           -- 波浪幅度
	Frequency = 0.15;         -- 波浪频率
	Speed = 1.2;              -- 飘动速度
	LineThickness = 2.5;      -- 线条粗细
	DotSize = 6;              -- 节点圆点大小
	ColorA = Color3.fromRGB(0, 255, 255);    -- 链条A颜色 (青)
	ColorB = Color3.fromRGB(255, 0, 255);    -- 链条B颜色 (紫)
	ConnectionColor = Color3.fromRGB(255, 255, 255); -- 连接线颜色
	ConnectionTransparency = 0.7;
};

function DNABackground.new(parent, config)
	config = config or {};
	for k, v in pairs(DEFAULT_CONFIG) do
		if config[k] == nil then config[k] = v; end;
	end;
	
	local self = setmetatable({}, {__index = DNABackground});
	self.Parent = parent;
	self.Config = config;
	self.Connections = {};
	self.Running = false;
	self.Frame = nil;
	self.Helixes = {};
	
	self:_createContainer();
	self:_createHelixes();
	
	return self;
end;

function DNABackground:_createContainer()
	self.Frame = Instance.new("Frame");
	self.Frame.Name = "DNABackground";
	self.Frame.Size = UDim2.new(1, 0, 1, 0);
	self.Frame.BackgroundTransparency = 1;
	self.Frame.BorderSizePixel = 0;
	self.Frame.ClipsDescendants = true;
	self.Frame.ZIndex = 0;
	self.Frame.Parent = self.Parent;
end;

function DNABackground:_createHelixes()
	for h = 1, self.Config.HelixCount do
		local helix = {
			pointsA = {};
			pointsB = {};
			connections = {};
			dots = {};
			offset = (h - 1) * (math.pi / self.Config.HelixCount);
		};
		
		for i = 1, self.Config.PointsPerHelix do
			-- 链条A的点
			local dotA = Instance.new("Frame");
			dotA.Size = UDim2.new(0, self.Config.DotSize, 0, self.Config.DotSize);
			dotA.BackgroundColor3 = self.Config.ColorA;
			dotA.BackgroundTransparency = 0.3;
			dotA.BorderSizePixel = 0;
			dotA.ZIndex = 1;
			dotA.Parent = self.Frame;
			Instance.new("UICorner", dotA).CornerRadius = UDim.new(1, 0);
			
			-- 链条B的点
			local dotB = Instance.new("Frame");
			dotB.Size = UDim2.new(0, self.Config.DotSize, 0, self.Config.DotSize);
			dotB.BackgroundColor3 = self.Config.ColorB;
			dotB.BackgroundTransparency = 0.3;
			dotB.BorderSizePixel = 0;
			dotB.ZIndex = 1;
			dotB.Parent = self.Frame;
			Instance.new("UICorner", dotB).CornerRadius = UDim.new(1, 0);
			
			-- 连接线
			local line = Instance.new("Frame");
			line.Size = UDim2.new(0, 1, 0, 1);
			line.BackgroundColor3 = self.Config.ConnectionColor;
			line.BackgroundTransparency = self.Config.ConnectionTransparency;
			line.BorderSizePixel = 0;
			line.ZIndex = 0;
			line.Parent = self.Frame;
			
			table.insert(helix.pointsA, dotA);
			table.insert(helix.pointsB, dotB);
			table.insert(helix.connections, line);
		end;
		
		self.Helixes[h] = helix;
	end;
end;

function DNABackground:Start()
	if self.Running then return; end;
	self.Running = true;
	
	local conn = RunService.RenderStepped:Connect(function()
		if not self.Running then return; end;
		self:_update();
	end);
	
	table.insert(self.Connections, conn);
end;

function DNABackground:_update()
	local t = tick() * self.Config.Speed;
	local absSize = self.Frame.AbsoluteSize;
	local centerX = absSize.X / 2;
	local centerY = absSize.Y / 2;
	local spacingY = absSize.Y / (self.Config.PointsPerHelix + 2);
	
	for _, helix in ipairs(self.Helixes) do
		for i, dotA in ipairs(helix.pointsA) do
			local dotB = helix.pointsB[i];
			local line = helix.connections[i];
			
			local y = (i - 1) * spacingY + spacingY;
			local phase = t + (i * self.Config.Frequency) + helix.offset;
			
			-- 链条A位置 (正弦波)
			local xA = centerX + math.sin(phase) * self.Config.Amplitude;
			-- 链条B位置 (余弦波，与A相差90度)
			local xB = centerX + math.sin(phase + math.pi) * self.Config.Amplitude;
			
			-- 更新点位置
			dotA.Position = UDim2.new(0, xA - self.Config.DotSize/2, 0, y - self.Config.DotSize/2);
			dotB.Position = UDim2.new(0, xB - self.Config.DotSize/2, 0, y - self.Config.DotSize/2);
			
			-- 更新连接线
			local lineX = math.min(xA, xB);
			local lineWidth = math.abs(xB - xA);
			line.Position = UDim2.new(0, lineX, 0, y);
			line.Size = UDim2.new(0, lineWidth, 0, self.Config.LineThickness);
			
			-- 呼吸效果
			local breath = 0.3 + math.sin(t * 2 + i * 0.3) * 0.2;
			dotA.BackgroundTransparency = breath;
			dotB.BackgroundTransparency = breath;
			line.BackgroundTransparency = self.Config.ConnectionTransparency + math.sin(t + i) * 0.15;
		end;
	end;
end;

function DNABackground:Stop()
	self.Running = false;
	for _, conn in ipairs(self.Connections) do
		conn:Disconnect();
	end;
	self.Connections = {};
end;

function DNABackground:Destroy()
	self:Stop();
	if self.Frame then
		self.Frame:Destroy();
	end;
end;

function DNABackground:SetColors(colorA, colorB, connectionColor)
	self.Config.ColorA = colorA or self.Config.ColorA;
	self.Config.ColorB = colorB or self.Config.ColorB;
	self.Config.ConnectionColor = connectionColor or self.Config.ConnectionColor;
	
	for _, helix in ipairs(self.Helixes) do
		for _, dot in ipairs(helix.pointsA) do
			dot.BackgroundColor3 = self.Config.ColorA;
		end;
		for _, dot in ipairs(helix.pointsB) do
			dot.BackgroundColor3 = self.Config.ColorB;
		end;
		for _, line in ipairs(helix.connections) do
			line.BackgroundColor3 = self.Config.ConnectionColor;
		end;
	end;
end;

return DNABackground;
