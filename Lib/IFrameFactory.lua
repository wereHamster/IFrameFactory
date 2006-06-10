
--[[
	Embedded Library Stub
]]

local libName, libMajor, libMinor = "IFrameFactory", "1.0", tonumber(string.sub("$Revision$", 12, -3))

local libMetatable = {
	__call = function(stub, major, minor)
		if (minor) then
			stub[major] = { }
			stub[major].libVersion = minor
		end
		return stub[major]
	end,
}

if (getglobal(libName) == nil) then
	setglobal(libName, setmetatable({ }, libMetatable))
end

local stub = getglobal(libName)

local lib = stub(libMajor)
if (lib == nil) then
	lib = stub(libMajor, libMinor)
elseif (lib.libVersion >= libMinor) then
	return
else
	lib.libVersion = libMinor
end

--[[
	The AddOn
]]

function lib:Register(addon, class, iface)
	if (self.Registry == nil) then
		self.Registry = { }
		self.Registry[addon] = { }
	elseif (self.Registry[addon] == nil) then
		self.Registry[addon] = { }
	end
	
	local Info = {
		Interface = iface,
		Count = 0,
		List = { },
	}
	self.Registry[addon][class] = Info
end

function lib:Create(addon, class)
	local Info = self.Registry[addon][class]
	
	local frame = table.remove(Info.List)
	if (frame == nil) then
		local name = string.format("IFrameFactory__"..addon..class.."__%05d__", Info.Count)
		Info.Count = Info.Count + 1
		frame = Info.Interface:Create(name)
		frame:ClearAllPoints()
	end
	
	frame:SetParent(UIParent)
	frame:Show()
	
	return frame
end

function lib:Destroy(addon, class, frame)
	local Info = self.Registry[addon][class]
	
	frame = Info.Interface:Destroy(frame)
	
	frame:ClearAllPoints()
	frame:SetParent(UIParent)
	frame:Hide()
	
	table.insert(Info.List, frame)
end
