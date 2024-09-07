local _, NS = ...

---@type ReloadButton
local ReloadButton = NS.ReloadButton
local ReloadButtonFrame = NS.ReloadButton.frame

local Interface = NS.Interface

function ReloadButton:PLAYER_LOGIN()
  ReloadButtonFrame:UnregisterEvent("PLAYER_LOGIN")

  Interface:Create()
end
ReloadButtonFrame:RegisterEvent("PLAYER_LOGIN")
