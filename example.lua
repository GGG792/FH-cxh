-- ============================================================
-- FH-cxh UI 使用示例
-- ============================================================

local FH_cxh = loadstring(game:HttpGet("https://raw.githubusercontent.com/GGG792/FH-cxh/main/main.lua"))();

-- 创建窗口
local ui = FH_cxh.new({
	Name = "My Script";
	Theme = {
		Accent = Color3.fromRGB(100, 200, 255);
		WindowSize = {Width = 700, Height = 450};
	};
});

-- 添加标签页
local tab1 = ui:AddTab("Home", "H");
local tab2 = ui:AddTab("Settings", "S");
local tab3 = ui:AddTab("About", "A");

-- 在标签页里添加内容
local label = Instance.new("TextLabel");
label.Size = UDim2.new(1, -20, 0, 30);
label.Position = UDim2.new(0, 10, 0, 10);
label.BackgroundTransparency = 1;
label.Text = "This is Home tab";
label.Font = Enum.Font.SourceSansBold;
label.TextSize = 16;
label.TextColor3 = Color3.fromRGB(240, 240, 255);
label.Parent = tab1;
