local AddonName, NS = ...

local CreateFrame = CreateFrame
local LibStub = LibStub

local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local Anchor = {}
NS.Anchor = Anchor

local AnchorFrame = CreateFrame("Frame", AddonName .. "AnchorFrame", UIParent)

function Anchor:StopMovement()
  AnchorFrame:SetMovable(false)
end

function Anchor:StopUnhoverable(frame)
  frame:SetScript("OnEnter", function(f)
    f:SetAlpha(1)
  end)
  frame:SetScript("OnLeave", function(f)
    f:SetAlpha(1)
  end)
end

function Anchor:MakeHoverable(frame)
  frame:SetScript("OnEnter", function(f)
    f:SetAlpha(1)
  end)
  frame:SetScript("OnLeave", function(f)
    f:SetAlpha(0)
  end)
end

function Anchor:MakeUnmovable(frame)
  frame:SetMovable(false)
  frame:RegisterForDrag()
  frame:SetScript("OnDragStart", nil)
  frame:SetScript("OnDragStop", nil)
end

function Anchor:MakeMoveable(frame)
  frame:SetMovable(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(f)
    if NS.db.global.lock == false and frame:IsVisible() and frame:GetAlpha() ~= 0 then
      f:StartMoving()
    end
  end)
  frame:SetScript("OnDragStop", function(f)
    if NS.db.global.lock == false and frame:IsVisible() and frame:GetAlpha() ~= 0 then
      f:StopMovingOrSizing()
      local a, _, b, c, d = f:GetPoint()
      NS.db.global.position[1] = a
      NS.db.global.position[2] = b
      NS.db.global.position[3] = c
      NS.db.global.position[4] = d
    end
  end)
end

function Anchor:ToggleShow(show)
  if show then
    AnchorFrame:Show()
  else
    AnchorFrame:Hide()
  end
end

function Anchor:RemoveControls(frame)
  frame:EnableMouse(false)
  frame:SetScript("OnMouseUp", nil)
end

function Anchor:AddControls(frame)
  frame:EnableMouse(true)
  frame:SetScript("OnMouseUp", function(_, btn)
    if NS.db.global.lock == false and not IsInInstance() and frame:IsVisible() and frame:GetAlpha() ~= 0 then
      if btn == "RightButton" then
        AceConfigDialog:Open(AddonName)
      end
    end
  end)
end

function Anchor:Lock(frame)
  self:RemoveControls(frame)
  self:MakeUnmovable(frame)
  self:ToggleShow(false)
end

function Anchor:Unlock(frame)
  self:AddControls(frame)
  self:MakeMoveable(frame)
  self:ToggleShow(true)
end

function Anchor:Create()
  if not Anchor.frame then
    local bg = AnchorFrame:CreateTexture()
    bg:SetAllPoints(AnchorFrame)
    bg:SetColorTexture(0, 1, 0, 0.2)

    local header = AnchorFrame:CreateFontString(nil, "OVERLAY")
    header:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    header:SetAllPoints(AnchorFrame)
    header:SetFormattedText("drag")
    header:SetJustifyH("CENTER")
    header:SetJustifyV("MIDDLE")
    header:SetPoint("CENTER", bg, "CENTER", 0, 0)

    AnchorFrame:SetPoint(
      NS.db.global.position[1],
      UIParent,
      NS.db.global.position[2],
      NS.db.global.position[3],
      NS.db.global.position[4]
    )
    AnchorFrame:SetWidth(header:GetStringWidth() + 1)
    AnchorFrame:SetHeight(header:GetStringHeight() + 1)
    AnchorFrame:SetClampedToScreen(true)

    if NS.db.global.lock then
      self:Lock(AnchorFrame)
    else
      self:Unlock(AnchorFrame)
    end

    Anchor.frame = AnchorFrame
  end
end
