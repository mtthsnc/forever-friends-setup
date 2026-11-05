-- BEGIN FOREVER UI LAYOUT FIXES
-- Standalone adapter; also bootstrapped by the existing setup addon for /reload.
do
    if not (_G.ForeverUILayoutFixes and _G.ForeverUILayoutFixes.version == 2) then
        local state = {version=2}
        _G.ForeverUILayoutFixes = state
        local hookedBoxes = setmetatable({}, {__mode="k"})
        local hookedCasts = setmetatable({}, {__mode="k"})
        local glassBusy, castBusy, queued = false, false, false
        local castPlate, castWidth, castClip
        local queue

        local function hookScript(frame, event, callback)
            -- Glass embeds AceHook into its edit box, shadowing the widget's
            -- HookScript with AceHook's differently shaped method. Use the
            -- native widget implementation instead of calling that mixin.
            local mt = getmetatable(frame)
            local index = type(mt) == "table" and mt.__index
            local native = type(index) == "table" and index.HookScript
            if native then native(frame, event, callback)
            else frame:HookScript(event, callback) end
        end

        local function locked(frame)
            return InCombatLockdown() and frame.IsProtected and frame:IsProtected()
        end
        local function samePoint(frame, point, parent, relativePoint, x, y)
            if frame:GetNumPoints() ~= 1 then return false end
            local p, relative, rp, dx, dy = frame:GetPoint(1)
            return p == point and relative == parent and rp == relativePoint and dx == x and dy == y
        end
        local function repairGlass()
            if glassBusy then return end
            local core, box = _G.Glass, _G.ChatFrame1EditBox
            local profile = core and core.db and core.db.profile
            local container = _G.GlassFrame
            if not (profile and box and container and not locked(box)) then return end
            -- Preserve ABOVE/BELOW and offsets chosen in Glass. Never infer
            -- coordinates from a new character's still-loading native chat frame.
            local anchor = profile.editBoxAnchor or {}
            local above = anchor.position == "ABOVE"
            local point, relativePoint = above and "BOTTOMLEFT" or "TOPLEFT", above and "TOPLEFT" or "BOTTOMLEFT"
            local y = type(anchor.yOfs) == "number" and anchor.yOfs or (above and 5 or -5)
            local width = container:GetWidth() - 16
            if width <= 0 then return end
            glassBusy = true
            local ok, err = pcall(function()
                if not samePoint(box, point, container, relativePoint, 8, y) then
                    box:ClearAllPoints()
                    box:SetPoint(point, container, relativePoint, 8, y)
                end
                if box:GetWidth() ~= width then box:SetWidth(width) end
            end)
            glassBusy = false
            if not ok then error(err, 0) end
        end

        local function repairCast()
            if castBusy or not castPlate or not castWidth then return end
            local frame = _G.PlayerCastingBarFrame or _G.CastingBarFrame
            if not frame or locked(frame) or locked(castPlate) then return end
            if EditModeManagerFrame and EditModeManagerFrame:IsShown() then return end
            castBusy = true
            local ok, err = pcall(function()
                -- The clipping parent and bar use the same scale and a direct
                -- parent-relative anchor, so native Edit Mode scale/anchor updates
                -- cannot leave the castbar offset from the camera-following plate.
                if not castClip or castClip:GetParent() ~= castPlate then
                    castClip = CreateFrame("Frame", nil, castPlate)
                    castClip:SetClipsChildren(true)
                    castClip:SetPoint("BOTTOM", castPlate, "TOP", 0, -16)
                end
                if castClip:GetWidth() ~= castWidth then castClip:SetWidth(castWidth) end
                local height = PersonalWorldPlateTheme and PersonalWorldPlateTheme.castHeight or 10
                if castClip:GetHeight() ~= height + 48 then castClip:SetHeight(height + 48) end
                if frame:GetParent() ~= castClip then frame:SetParent(castClip) end
                if frame.SetIgnoreParentScale and (not hookedCasts[frame]
                    or (frame.IsIgnoringParentScale and frame:IsIgnoringParentScale())) then
                    frame:SetIgnoreParentScale(false)
                end
                if frame:GetScale() ~= 1 then frame:SetScale(1) end
                if frame:GetFrameStrata() ~= castPlate:GetFrameStrata() then frame:SetFrameStrata(castPlate:GetFrameStrata()) end
                if frame:GetFrameLevel() ~= castPlate:GetFrameLevel() + 5 then frame:SetFrameLevel(castPlate:GetFrameLevel() + 5) end
                if not hookedCasts[frame] or frame:GetHeight() ~= height then
                    if PersonalWorldPlateTheme then PersonalWorldPlateTheme:Cast(frame)
                    else frame:SetHeight(height) end
                end
                if not samePoint(frame, "BOTTOM", castClip, "BOTTOM", 0, 19) then
                    frame:ClearAllPoints()
                    frame:SetPoint("BOTTOM", castClip, "BOTTOM", 0, 19)
                end
                if frame:GetWidth() ~= castWidth then frame:SetWidth(castWidth) end
                if not hookedCasts[frame] then
                    hookedCasts[frame] = true
                    local function relayout()
                        if not castBusy then queue() end
                    end
                    for _, method in ipairs({"SetPoint", "ClearAllPoints", "SetParent", "SetScale", "SetIgnoreParentScale", "SetSize", "SetWidth", "SetHeight"}) do
                        if frame[method] then hooksecurefunc(frame, method, relayout) end
                    end
                    hookScript(frame, "OnShow", relayout)
                end
            end)
            castBusy = false
            if not ok then error(err, 0) end
        end

        local function install()
            local box, container = _G.ChatFrame1EditBox, _G.GlassFrame
            if _G.Glass and _G.Glass.db and container and box and not hookedBoxes[box] then
                hookedBoxes[box] = true
                local function relayout()
                    if not glassBusy then queue() end
                end
                for _, method in ipairs({"SetPoint", "ClearAllPoints", "SetWidth", "SetSize"}) do
                    if box[method] then hooksecurefunc(box, method, relayout) end
                end
                hookScript(box, "OnShow", relayout)
                hookScript(box, "OnEditFocusGained", relayout)
                hookScript(container, "OnSizeChanged", relayout)
            end
            repairGlass()
            local cast = _G.PersonalWorldPlateCastBar
            -- PWP 0.8.2+ owns its castbar and deliberately suppresses the stock
            -- bar. Its version marker distinguishes it from the legacy native
            -- attachment this adapter repairs. Never replace its Update method.
            if cast and cast.version then
                castPlate, castWidth = nil, nil
                return
            end
            if cast and cast.Update ~= state.castUpdate then
                -- The addon driver calls this method every 0.1 seconds. Unlike
                -- its original blanket combat return, repair safe, unprotected
                -- frames immediately and leave protected frames until safe.
                state.castUpdate = function(_, plate, width)
                    if castPlate ~= plate then castClip = nil end
                    castPlate, castWidth = plate, width
                    repairCast()
                end
                cast.Update = state.castUpdate
            end
            repairCast()
        end
        queue = function()
            if queued then return end
            queued = true
            C_Timer.After(0, function() queued = false; install() end)
        end
        local events = CreateFrame("Frame")
        for _, event in ipairs({"ADDON_LOADED", "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "UPDATE_CHAT_WINDOWS", "UI_SCALE_CHANGED", "DISPLAY_SIZE_CHANGED", "PLAYER_REGEN_ENABLED"}) do
            events:RegisterEvent(event)
        end
        events:SetScript("OnEvent", function(_, event, addon)
            if event ~= "ADDON_LOADED" or addon == "Glass" or addon == "PersonalWorldPlate" then queue() end
        end)
        if EditModeManagerFrame then hookScript(EditModeManagerFrame, "OnHide", queue) end
        state.repairGlass, state.repairCast, state.install = repairGlass, repairCast, install
        queue()
    end
end
-- END FOREVER UI LAYOUT FIXES
