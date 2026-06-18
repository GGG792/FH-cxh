-- ============================================================
-- FH-cxh Rainbow Border Module
-- 七彩描边动画
-- ============================================================

local RainbowBorder = {};

local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");

function RainbowBorder.new(parent, config)
	config = config or {};
	local self = setmetatable({}, {__index = RainbowBorder});
	
	self.Parent = parent;
	self.Thickness = config.Thickness or 3;
	self.Speed = config.Speed or 1.5;
	self.CornerRadius = config.CornerRadius or UDim.new(0, 16);
	self.Connections = {};
	self.Running = false;
	
	self:_createBorders();
	
	return self;
end;

function RainbowBorder:_createBorders()
	-- 创建4个边框条（上、下、左、右）
	self.Borders = {};
	
	-- 上边框
	local top = Instance.new("Frame");
	top.Name = "RainbowTop";
	top.Size = UDim2.new(1, 0, 0, self.Thickness);
	top.Position = UDim2.new(0, 0, 0, 0);
	top.BorderSizePixel = 0;
	top.ZIndex = 100;
	top.Parent = self.Parent;
	
	-- 下边框
	local bottom = Instance.new("Frame");
	bottom.Name = "RainbowBottom";
	bottom.Size = UDim2.new(1, 0, 0, self.Thickness);
	bottom.Position = UDim2.new(0, 0, 1, -self.Thickness);
	bottom.BorderSizePixel = 0;
	bottom.ZIndex = 100;
	bottom.Parent = self.Parent;
	
	-- 左边框
	local left = Instance.new("Frame");
	left.Name = "RainbowLeft";
	left.Size = UDim2.new(0, self.Thickness, 1, -self.Thickness * 2);
	left.Position = UDim2.new(0, 0, 0, self.Thickness);
	left.BorderSizePixel = 0;
	left.ZIndex = 100;
	left.Parent = self.Parent;
	
	-- 右边框
	local right = Instance.new("Frame");
	right.Name = "RainbowRight";
	right.Size = UDim2.new(0, self.Thickness, 1, -self.Thickness * 2);
	right.Position = UDim2.new(1, -self.Thickness, 0, self.Thickness);
	right.BorderSizePixel = 0;
	right.ZIndex = 100;
	right.Parent = self.Parent;
	
	self.Borders = {top, bottom, left, right};
	
	-- 添加圆角
	for _, border in ipairs(self.Borders) do
		local corner = Instance.new("UICorner");
		corner.CornerRadius = self.CornerRadius;
		corner.Parent = border;
	end;
end;

function RainbowBorder:Start()
	if self.Running then return; end;
	self.Running = true;
	
	local conn = RunService.RenderStepped:Connect(function()
		if not self.Running then return; end;
		self:_update();
	end);
	
	table.insert(self.Connections, conn);
end;

function RainbowBorder:_update()
	local t = tick() * self.Speed;
	
	for i, border in ipairs(self.Borders) do
		local hue = ((t + i * 0.25) % 1);
		local color = Color3.fromHSV(hue, 0.9, 1);
		border.BackgroundColor3 = color;
		border.BackgroundTransparency = 0.1 + math.sin(t * 3 + i) * 0.05;
	end;
end;

function RainbowBorder:Stop()
	self.Running = false;
	for _, conn in ipairs(self.Connections) do
		conn:Disconnect();
	end;
	self.Connections = {};
end;

function RainbowBorder:Destroy()
	self:Stop();
	for _, border in ipairs(self.Borders) do
		border:Destroy();
	end;
end;

function RainbowBorder:SetThickness(thickness)
	self.Thickness = thickness;
	self.Borders[1].Size = UDim2.new(1, 0, 0, thickness);
	self.Borders[2].Size = UDim2.new(1, 0, 0, thickness);
	self.Borders[2].Position = UDim2.new(0, 0, 1, -thickness);
	self.Borders[3].Size = UDim2.new(0, thickness, 1, -thickness * 2);
	self.Borders[4].Size = UDim2.new(0, thickness, 1, -thickness * 2);
	self.Borders[4].Position = UDim2.new(1, -thickness, 0, thickness);
end;

return RainbowBorder;
