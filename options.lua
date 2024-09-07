local AddonName, NS = ...

local LibStub = LibStub
local next = next

---@type ReloadButton
local ReloadButton = NS.ReloadButton
local ReloadButtonFrame = NS.ReloadButton.frame

local Anchor = NS.Anchor
local Button = NS.Button

local Options = {}
NS.Options = Options

NS.AceConfig = {
  name = AddonName,
  type = "group",
  args = {
    button = {
      name = "Enable a physical button to push",
      type = "toggle",
      width = "double",
      order = 1,
      set = function(_, val)
        NS.db.global.button = val
        Button:ToggleShow(val == true)
        Anchor:ToggleShow(val == true)
      end,
      get = function(_)
        return NS.db.global.button
      end,
    },
    lock = {
      name = "Lock the position",
      desc = "Turning this feature on hides the anchor bar",
      type = "toggle",
      width = "double",
      order = 2,
      disabled = function(_)
        return NS.db.global.button == false
      end,
      set = function(_, val)
        NS.db.global.lock = val
        if val then
          Anchor:Lock()
        else
          Anchor:Unlock()
        end
      end,
      get = function(_)
        return NS.db.global.lock
      end,
    },
  },
}

function Options:SlashCommands(message)
  if message == "toggle lock" then
    if NS.db.global.lock == false then
      NS.db.global.lock = true
    else
      NS.db.global.lock = false
    end
  else
    LibStub("AceConfigDialog-3.0"):Open(AddonName)
  end
end

function Options:Setup()
  LibStub("AceConfig-3.0"):RegisterOptionsTable(AddonName, NS.AceConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(AddonName, AddonName)

  SLASH_RB1 = AddonName
  SLASH_RB2 = "/rb"

  function SlashCmdList.RB(message)
    self:SlashCommands(message)
  end
end

function ReloadButton:ADDON_LOADED(addon)
  if addon == AddonName then
    ReloadButtonFrame:UnregisterEvent("ADDON_LOADED")

    ReloadButtonDB = ReloadButtonDB and next(ReloadButtonDB) ~= nil and ReloadButtonDB or {}

    -- Copy any settings from default if they don't exist in current profile
    NS.CopyDefaults(NS.DefaultDatabase, ReloadButtonDB)

    -- Reference to active db profile
    -- Always use this directly or reference will be invalid
    NS.db = ReloadButtonDB

    -- Remove table values no longer found in default settings
    NS.CleanupDB(ReloadButtonDB, NS.DefaultDatabase)

    Options:Setup()
  end
end
ReloadButtonFrame:RegisterEvent("ADDON_LOADED")
