-- ============================================================
-- FH-cxh DNA Background Module
-- 斜向飘动的 DNA 双螺旋背景动画
-- ============================================================

local DNABackground = {};

local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");

local DEFAULT_CONFIG = {
	HelixCount = 2;
	PointsPerHelix = 28;
	Amplitude = 90;
	Frequency = 0.12;
	Speed = 1.0;
	LineThickness = 2;
	DotSize = 5;
	ColorA = Color3.fromRGB(0, 255, 255);
	ColorB = Color3.fromRGB(255, 0, 255);
	ConnectionColor = Color3.fromRGB(255, 255, 255);
	ConnectionTransparency = 0.75;
	TiltAngle = 25;       -- 倾斜角度（度）
	DriftSpeed = 0.3;      -- 整体漂移速度
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
			offset = (h - 1) * (math.pi / self.Config.HelixCount);
			xOffset = (h - 1) * 120 - 60;
		};

		for i = 1, self.Config.PointsPerHelix do
			local dotA = Instance.new("Frame");
			dotA.Size = UDim2.new(0, self.Config.DotSize, 0, self.Config.DotSize);
			dotA.BackgroundColor3 = self.Config.ColorA;
			dotA.BackgroundTransparency = 0.4;
			dotA.BorderSizePixel = 0;
			dotA.ZIndex = 1;
			dotA.Parent = self.Frame;
			Instance.new("UICorner", dotA).CornerRadius = UDim.new(1, 0);

			local dotB = Instance.new("Frame");
			dotB.Size = UDim2.new(0, self.Config.DotSize, 0, self.Config.DotSize);
			dotB.BackgroundColor3 = self.Config.ColorB;
			dotB.BackgroundTransparency = 0.4;
			dotB.BorderSizePixel = 0;
			dotB.ZIndex = 1;
			dotB.Parent = self.Frame;
			Instance.new("UICorner", dotB).CornerRadius = UDim.new(1, 0);

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

	-- 倾斜参数
	local tiltRad = math.rad(self.Config.TiltAngle);
	local cosTilt = math.cos(tiltRad);
	local sinTilt = math.sin(tiltRad);

	-- 整体漂移（斜向移动）
	local driftX = math.sin(t * self.Config.DriftSpeed) * 40;
	local driftY = math.cos(t * self.Config.DriftSpeed * 0.7) * 30;

	-- 扩展范围让 DNA 填满倾斜后的屏幕
	local totalPoints = self.Config.PointsPerHelix + 10;
	local spacingY = (absSize.Y * 1.8) / totalPoints;

	for _, helix in ipairs(self.Helixes) do
		for i, dotA in ipairs(helix.pointsA) do
			local dotB = helix.pointsB[i];
			local line = helix.connections[i];

			-- 基础 Y 位置（扩展范围，从屏幕外开始）
			local baseY = (i - 5) * spacingY - absSize.Y * 0.4;
			local baseX = helix.xOffset;

			-- 波浪相位
			local phase = t + (i * self.Config.Frequency) + helix.offset;

			-- 链条A的波浪偏移
			local waveA = math.sin(phase) * self.Config.Amplitude;
			-- 链条B的波浪偏移（反相）
			local waveB = math.sin(phase + math.pi) * self.Config.Amplitude;

			-- 应用倾斜旋转
			local rawAx = baseX + waveA;
			local rawAy = baseY;
			local rawBx = baseX + waveB;
			local rawBy = baseY;

			-- 旋转 + 漂移
			local xA = (rawAx * cosTilt - rawAy * sinTilt) + centerX + driftX;
			local yA = (rawAx * sinTilt + rawAy * cosTilt) + centerY + driftY;
			local xB = (rawBx * cosTilt - rawBy * sinTilt) + centerX + driftX;
			local yB = (rawBx * sinTilt + rawBy * cosTilt) + centerY + driftY;

			-- 更新位置
			dotA.Position = UDim2.new(0, xA - self.Config.DotSize/2, 0, yA - self.Config.DotSize/2);
			dotB.Position = UDim2.new(0, xB - self.Config.DotSize/2, 0, yB - self.Config.DotSize/2);

			-- 连接线
			local lineX = math.min(xA, xB);
			local lineWidth = math.abs(xB - xA);
			local lineY = (yA + yB) / 2;
			line.Position = UDim2.new(0, lineX, 0, lineY);
			line.Size = UDim2.new(0, math.max(1, lineWidth), 0, self.Config.LineThickness);

			-- 呼吸 + 深度效果
			local depth = math.sin(phase) * 0.5 + 0.5;
			local breath = 0.2 + depth * 0.4 + math.sin(t * 2 + i * 0.3) * 0.1;
			dotA.BackgroundTransparency = breath;
			dotB.BackgroundTransparency = breath;
			line.BackgroundTransparency = self.Config.ConnectionTransparency + depth * 0.15;

			-- 深度大小变化
			local scale = 0.7 + depth * 0.6;
			local ds = self.Config.DotSize * scale;
			dotA.Size = UDim2.new(0, ds, 0, ds);
			dotB.Size = UDim2.new(0, ds, 0, ds);
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
