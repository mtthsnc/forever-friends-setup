-- BEGIN FOREVER COMBAT MODE BAGS COMPAT
-- Independent adapter. No CombatMode source files are changed.
do
    local function isBag(name)
        return type(name) == "string" and (
            name == "ContainerFrameCombinedBags"
            or name == "EUI_MainBagFrame"
            or name == "EUI_ReagentBagFrame"
            or name == "EUI_BagsWindowFrame"
            or name:match("^ContainerFrame%d+$") ~= nil
        )
    end
    local bagNames = {"ContainerFrameCombinedBags", "EUI_MainBagFrame", "EUI_ReagentBagFrame", "EUI_BagsWindowFrame"}
    for i = 1, 17 do bagNames[#bagNames + 1] = "ContainerFrame" .. i end
    local function withoutBags(list)
        local result = {}
        for _, name in ipairs(list or {}) do
            if not isBag(name) then result[#result + 1] = name end
        end
        return result
    end
    local function install()
        local cm = _G.CM
        if not (cm and cm.Constants and cm.Constants.FramesToCheck and type(cm.IsUnlockFrameVisible) == "function") then return end
        local previous = _G.ForeverCombatModeBagsCompat
        if previous and previous.namespace == cm and previous.wrapper == cm.IsUnlockFrameVisible then return end
        -- Remove bag entries from the runtime constants only; we handle them
        -- separately so combat never releases the cursor merely for open bags.
        cm.Constants.FramesToCheck = withoutBags(cm.Constants.FramesToCheck)
        local original = cm.IsUnlockFrameVisible
        local function wrapper(...)
            local global = cm.DB and cm.DB.global
            local inCombat = InCombatLockdown()
            if global and global.frameWatching and not inCombat then
                for _, name in ipairs(bagNames) do
                    local frame = _G[name]
                    if frame and frame.IsVisible and frame:IsVisible() then return true end
                end
            end
            -- A user may also have manually added bags to the watchlist. Mask
            -- those entries for this synchronous check, then restore the list.
            -- All other watched windows and OPie handling stay with CombatMode.
            local watchlist = global and global.watchlist
            if inCombat and type(watchlist) == "table" then
                global.watchlist = withoutBags(watchlist)
                local ok, result = pcall(original, ...)
                global.watchlist = watchlist
                if not ok then error(result, 0) end
                return result
            end
            return original(...)
        end
        cm.IsUnlockFrameVisible = wrapper
        _G.ForeverCombatModeBagsCompat = {namespace=cm, wrapper=wrapper, version=1}
    end
    install()
    local events = CreateFrame("Frame")
    events:RegisterEvent("ADDON_LOADED")
    events:RegisterEvent("PLAYER_LOGIN")
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:SetScript("OnEvent", function(_, event, name)
        if event ~= "ADDON_LOADED" or name == "CombatMode" then install() end
    end)
end
-- END FOREVER COMBAT MODE BAGS COMPAT
