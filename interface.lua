local _, NS = ...

local Anchor = NS.Anchor
local Button = NS.Button

local Interface = {}
NS.Interface = Interface

function Interface:Create()
  Anchor:Create()

  if Anchor.frame then
    Button:Create(Anchor.frame)
  end
end
