local _, NS = ...

local CreateFrame = CreateFrame

---@class PositionArray
---@field[1] string
---@field[2] string
---@field[3] number
---@field[4] number

---@class MapTable : table
---@field enabled boolean

---@class GlobalTable : table
---@field lock boolean
---@field position PositionArray
---@field debug boolean

---@class DBTable : table
---@field global GlobalTable

---@class ReloadButton
---@field ADDON_LOADED function
---@field PLAYER_LOGIN function
---@field SlashCommands function
---@field frame Frame
---@field db DBTable

---@type ReloadButton
---@diagnostic disable-next-line: missing-fields
local ReloadButton = {}
NS.ReloadButton = ReloadButton

local ReloadButtonFrame = CreateFrame("Frame", "ReloadButtonFrame")
ReloadButtonFrame:SetScript("OnEvent", function(_, event, ...)
  if ReloadButton[event] then
    ReloadButton[event](ReloadButton, ...)
  end
end)
NS.ReloadButton.frame = ReloadButtonFrame

NS.DefaultDatabase = {
  global = {
    lock = false,
    position = {
      "CENTER",
      "CENTER",
      0,
      0,
    },
    debug = false,
  },
}
