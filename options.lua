local AddonName, NS = ...

local next = next
local LibStub = LibStub

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

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
    lock = {
      name = "Lock into place",
      desc = "Turning this feature on hides the anchor bar",
      type = "toggle",
      width = "double",
      order = 1,
      set = function(_, val)
        NS.db.global.lock = val
        if val then
          Anchor:Lock(Anchor.frame)
        else
          Anchor:Unlock(Anchor.frame)
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
      Anchor:Lock(Anchor.frame)
    else
      NS.db.global.lock = false
      Anchor:Unlock(Anchor.frame)
    end
  else
    AceConfigDialog:Open(AddonName)
  end
end

function Options:Setup()
  AceConfig:RegisterOptionsTable(AddonName, NS.AceConfig)
  AceConfigDialog:AddToBlizOptions(AddonName, AddonName)

  SLASH_RB1 = "/reloadbutton"
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
