local AddonName, NS = ...

local CreateFrame = CreateFrame
local LibStub = LibStub

local Anchor = {}
NS.Anchor = Anchor

local AnchorFrame = CreateFrame("Frame", AddonName .. "AnchorFrame", UIParent)

function Anchor:StopMovement()
  AnchorFrame:SetMovable(false)
end

function Anchor:StopHover()
  AnchorFrame:SetScript("OnEnter", function(f)
    f:SetAlpha(1)
  end)
  AnchorFrame:SetScript("OnLeave", function(f)
    f:SetAlpha(1)
  end)
end

function Anchor:MakeHoverable()
  AnchorFrame:SetScript("OnEnter", function(f)
    f:SetAlpha(1)
  end)
  AnchorFrame:SetScript("OnLeave", function(f)
    f:SetAlpha(0)
  end)
end

function Anchor:MakeMoveable()
  AnchorFrame:SetMovable(true)
  AnchorFrame:RegisterForDrag("LeftButton")
  AnchorFrame:SetScript("OnDragStart", function(f)
    if NS.db.global.lock == false then
      f:StartMoving()
    end
  end)
  AnchorFrame:SetScript("OnDragStop", function(f)
    if NS.db.global.lock == false then
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

function Anchor:Lock()
  self:StopMovement()
  self:ToggleShow(false)
end

function Anchor:Unlock()
  self:MakeMoveable()
  self:ToggleShow(true)
end

function Anchor:AddControls()
  AnchorFrame:EnableMouse(true)
  AnchorFrame:SetScript("OnMouseUp", function(_, btn)
    if NS.db.global.lock == false then
      if btn == "RightButton" then
        LibStub("AceConfigDialog-3.0"):Open(AddonName)
      end
    end
  end)

  if NS.db.global.lock then
    self:StopMovement()
  else
    self:MakeMoveable()
  end
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
      self:ToggleShow(false)
    else
      self:ToggleShow(NS.db.global.button)
    end

    self:AddControls()

    Anchor.frame = AnchorFrame
  end
end
