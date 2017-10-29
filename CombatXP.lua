CombatXP = {}
CombatXP.name = "CombatXP"

CombatXP.currentXP = GetUnitXP('player')
CombatXP.gained_in_current_combat = 0
 
function CombatXP:Initialize()
    self.inCombat = IsUnitInCombat("player")

    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)

    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_EXPERIENCE_UPDATE, self.onPlayerExperienceGained)

    self.savedVariables = ZO_SavedVars:NewAccountWide("CombatXPPosition", 1, nil, {})

    self:RestorePosition()
end

function CombatXP.onPlayerExperienceGained(event, unitTag, currentExp, maxExp, reason)

    if ( unitTag ~= 'player' ) then return end
       local xp_gained = currentExp - CombatXP.currentXP
       local percent_to_next_level = (currentExp / maxExp) * 100
       local percent_to_next_as_string = string.sub(tostring(percent_to_next_level),0,2) .. "%"
       local current_gain_in_percent = (xp_gained / maxExp) * 100
       local current_gain_in_percent_as_string = string.sub(tostring(current_gain_in_percent),0,4) .. "%"
       CHAT_SYSTEM:AddMessage(tostring(xp_gained) .. " experience gained! " .. percent_to_next_as_string)
       CombatXP.currentXP = currentExp

    if CombatXP.inCombat then 
        CombatXP.gained_in_current_combat = CombatXP.gained_in_current_combat + xp_gained
        CombatXPIndicatorLabel:SetText(tostring("XP gained in last combat: +" .. tostring(CombatXP.gained_in_current_combat)  .. " (" .. current_gain_in_percent_as_string .. ")" .. " \n " .. currentExp .. "/" .. maxExp .. " (" .. percent_to_next_as_string .. ")"))
        CombatXPIndicator:SetHidden(false)
    else
        CombatXP.gained_in_current_combat = 0
        CombatXPIndicator:SetHidden(true)

    end

end
 
function CombatXP.OnAddOnLoaded(event, addonName)
  if addonName == CombatXP.name then
    CombatXP:Initialize()

  end

end

function CombatXP.OnPlayerCombatState(event, inCombat)
  if inCombat ~= CombatXP.inCombat then
    CombatXP.inCombat = inCombat

    if inCombat then
        CHAT_SYSTEM:AddMessage("In Combat Now!")
    else 
        CHAT_SYSTEM:AddMessage("Gained " .. tostring(CombatXP.gained_in_current_combat) .. " in last combat!")
        CombatXP.gained_in_current_combat = 0

    end 

  end
end

function CombatXP.OnIndicatorMoveStop()
  CombatXP.savedVariables.left = CombatXPIndicator:GetLeft()
  CombatXP.savedVariables.top = CombatXPIndicator:GetTop()
end

function CombatXP:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
 
  CombatXPIndicator:ClearAnchors()
  CombatXPIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end
 
function CombatXP:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
 
  CombatXPIndicator:ClearAnchors()
  CombatXPIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

EVENT_MANAGER:RegisterForEvent(CombatXP.name, EVENT_ADD_ON_LOADED, CombatXP.OnAddOnLoaded)



