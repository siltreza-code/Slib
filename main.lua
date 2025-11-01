--!nonstrict

if _G.Slib then
	if _G.Slib.GUI then
		_G.Slib.GUI:Destroy()
	end
	if _G.Slib.Script then
		_G.Slib.Script:Destroy()
	end
	_G.Slib = nil
end

_G.Slib = {
	Script = script
}

local wait = task.wait
local spawn = task.spawn
local delay = task.delay

local function Make(class: string, parent: Instance?, properties: {[string]: any}?): Instance?
	local success, result = pcall(function()
		local newInstance = Instance.new(class)

		if parent then
			newInstance.Parent = parent
		end

		if properties then
			for property, value in pairs(properties) do
				newInstance[property] = value
			end
		end

		return newInstance
	end)

	if not success then
		warn("Make() failed:", result)
		return nil
	end

	return result
end

local function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32,126))
	end
	return table.concat(array)
end

local Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			error("Invalid Roblox Service: " .. tostring(name))
		end
	end
})

local CanUI = get_hidden_gui or gethui
local CoreGUI = CanUI() or Services.CoreGui
local UIS = Services.UserInputService
local RS = Services.RunService
local SG = Services.StarterGui
local GS = Services.GuiService
local Lighting = Services.Lighting
local Players = Services.Players

local Slib = {}

function Slib.Init(Name:string, Location:Vector2, Properties: {[string]: any}?)
	local Screen1 = Make("ScreenGui", CoreGUI, {
		Name = randomString(),
		Enabled = true,
		IgnoreGuiInset = true,
		ResetOnSpawn = false})
	_G.Slib.GUI = Screen1
	
	local Frame1 = Make("Frame", Screen1, {
		Position = UDim2.fromOffset(Location.X, Location.Y),
		Name = randomString(),
		Size = UDim2.fromScale(0.3, 0.6),
		BackgroundColor3 = (Properties and Properties.BG) or Color3.fromRGB(72, 72, 72)
	})
	Make("UICorner", Frame1, {Name = randomString(),
		CornerRadius = Properties and Properties.CornerRadius or UDim.new(0.1, 0)})
	Make("UIAspectRatioConstraint", Frame1, {Name = randomString(),
		AspectRatio = 0.75, AspectType = Enum.AspectType.FitWithinMaxSize, DominantAxis = Enum.DominantAxis.Width})
end

return Slib
