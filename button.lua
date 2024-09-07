local AddonName, NS = ...

local CreateFrame = CreateFrame

local Button = {}
NS.Button = Button

local ButtonFrame = CreateFrame("Button", AddonName .. "ButtonFrame", UIParent, "UIPanelButtonTemplate")

function Button:ToggleShow(show)
  if show then
    ButtonFrame:Show()
  else
    ButtonFrame:Hide()
  end
end

function Button:AddControls()
  ButtonFrame:SetScript("OnClick", function()
    ReloadUI()
  end)
end

function Button:Create(anchor)
  if not Button.frame then
    ButtonFrame:SetPoint("TOP", anchor, "BOTTOM", 0, 0)
    ButtonFrame:SetText("Reload")
    ButtonFrame:SetWidth(85)
    ButtonFrame:SetHeight(25)

    self:ToggleShow(NS.db.global.button)
    self:AddControls()

    Button.frame = ButtonFrame
  end
end
