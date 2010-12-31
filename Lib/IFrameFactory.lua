
--[[
  Embedded Library Stub
]]

local libName, libMajor, libMinor, libMetatable = "IFrameFactory", "1.0", 0, {
  __call = function(self, major) self[major] = self[major] or { }; return self[major] end
}

if (getglobal(libName) == nil) then
  setglobal(libName, setmetatable({ }, libMetatable))
end

local lib = getglobal(libName)(libMajor)
if (lib.libVersion and lib.libVersion >= libMinor) then
  return
end

lib.libVersion = libMinor

--[[
  The AddOn
]]

lib.Registry = lib.Registry or { }

function lib:Register(group, name, iface)
  self.Registry[group] = self.Registry[group] or { }
  self.Registry[group][name] = { Interface = iface, Objects = { { }, { } } }
end

function lib:Create(group, name)
  local Info = self.Registry[group][name]
  local frame = table.remove(Info.Objects[1]) or Info.Interface:Create()

  Info.Objects[2][frame] = frame

  frame:ClearAllPoints()
  frame:Show()

  return frame
end

function lib:Destroy(group, name, frame)
  local Info = self.Registry[group][name]
  frame = Info.Interface:Destroy(frame)

  Info.Objects[2][frame] = nil
  table.insert(Info.Objects[1], frame)

  frame:Hide()
end

function lib:Clear(group, name)
  local Info = self.Registry[group][name]

  for _, frame in pairs(Info.Objects[2]) do
    lib:Destroy(group, name, frame)
  end
end

