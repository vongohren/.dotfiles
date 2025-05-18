hs.hotkey.bind({"cmd", "alt"}, "w", function()
    -- Using alert instead of notification
    hs.alert.show("Hello World", 3)
end)

-- file: ~/.hammerspoon/init.lua
-- https://www.hammerspoon.org/
--
-- Bring Bitwarden to front and focus on the search field
-- Required accessability to be enabled in Hammerspoon & System preferences
function launch_bitwarden_search()
    hs.application.launchOrFocus("Bitwarden")
    local app = hs.appfinder.appFromName("Bitwarden")
    if (app ~= nil) then
        local activated = app:activate(true)
        if (activated) then
            -- for Dock icon mode
            app:selectMenuItem({"View", "Search vault"})
            -- for menubar item mode
            hs.eventtap.keyStroke({"cmd"}, "f")
        else
            hs.alert.show("😕 Unable to activate Bitwarden app", 3)
        end
    else
        hs.alert.show("😕 Bitwarden app not found", 3)
    end
end
hs.hotkey.bind({"cmd", "shift"}, 'l', launch_bitwarden_search)
