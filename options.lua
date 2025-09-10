local AddonName, NS = ...

local next = next

---@type ReloadButton
local ReloadButton = NS.ReloadButton
local ReloadButtonFrame = NS.ReloadButton.frame

local Anchor = NS.Anchor

local Options = {}
NS.Options = Options

function Options:SlashCommands(message)
  if message == "toggle lock" then
    if NS.db.lock == false then
      NS.db.lock = true
      Anchor:Lock(Anchor.frame)
    else
      NS.db.lock = false
      Anchor:Unlock(Anchor.frame)
    end
  else
    Settings.OpenToCategory(NS.settingsCategory:GetID())
  end
end

local function OnSettingChanged(_setting, _value)
  local _key = _setting:GetVariable()
  ReloadButtonDB[_key] = _value

  if _key == "Lock" then
    if _value then
      Anchor:Lock(Anchor.frame)
    else
      Anchor:Unlock(Anchor.frame)
    end
  end
end

function Options:Setup()
  local category = Settings.RegisterVerticalLayoutCategory(AddonName)
  Settings.RegisterAddOnCategory(category)
  NS.settingsCategory = category

  do
    local key = "lock"
    local defaultValue = NS.DefaultDatabase[key]

    local setting = Settings.RegisterAddOnSetting(category, "Lock", key, ReloadButtonDB, "boolean", defaultValue)
    setting.name = "Lock"
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Lock the button into place."
    Settings.CreateCheckbox(category, setting, tooltip)
  end

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
