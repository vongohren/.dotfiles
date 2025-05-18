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

-- Custom key combination detector for j+k+l+cmd
local keyCombo = {
  cmd = false,
  j = false,
  k = false,
  l = false
}

local function checkKeyCombo()
  if keyCombo.cmd and keyCombo.j and keyCombo.k and keyCombo.l then
    -- Use alert instead of notification
    hs.alert.show("Hello World - Key Combo Detected!", 3)
  end
end

-- Simple test function to show key presses
hs.hotkey.bind({}, "f12", function()
  hs.notify.new({title="Test", informativeText="Press keys to see debug info"}):send()
end)

local keyWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, function(event)
  local keyCode = event:getKeyCode()
  local flags = event:getFlags()
  local keyDown = event:getType() == hs.eventtap.event.types.keyDown
  local keyName = hs.keycodes.map[keyCode] or tostring(keyCode)
  
  -- Debug notification for key presses
  if keyDown then
    hs.notify.new({title="Key Pressed", informativeText="Key: " .. keyName}):send()
  end
  
  -- Map key codes to our tracked keys
  if keyCode == hs.keycodes.map.j then
    keyCombo.j = keyDown
  elseif keyCode == hs.keycodes.map.k then
    keyCombo.k = keyDown
  elseif keyCode == hs.keycodes.map.l then
    keyCombo.l = keyDown
  end
  
  -- Check cmd modifier
  keyCombo.cmd = flags.cmd
  
  -- Print debug status
  print("Keys: cmd=" .. tostring(keyCombo.cmd) .. 
        ", j=" .. tostring(keyCombo.j) .. 
        ", k=" .. tostring(keyCombo.k) .. 
        ", l=" .. tostring(keyCombo.l))
  
  -- Check if our combo is active
  checkKeyCombo()
  
  return false -- Don't prevent the event from propagating
end)

-- Start watching for key events
keyWatcher:start()

-- Simple alternative approach using individual hotkeys
hs.hotkey.bind({"cmd"}, "j", function()
  -- Start a timer to check for the other keys
  local checkOtherKeys = hs.timer.doAfter(0.5, function()
    local keyboard = hs.eventtap.checkKeyboardModifiers()
    -- Use accessibility API to check if k and l are currently pressed
    if hs.eventtap.checkKeyboardModifiers().cmd then
      hs.eventtap.keyStroke({}, "k", 0)
      hs.timer.doAfter(0.1, function()
        if hs.eventtap.checkKeyboardModifiers().cmd then
          hs.eventtap.keyStroke({}, "l", 0)
          hs.timer.doAfter(0.1, function()
            hs.alert.show("Combo detected!", 3)
          end)
        end
      end)
    end
  end)
end)

-- Direct simple test - just press this hotkey to see if Hammerspoon is responding
hs.hotkey.bind({"ctrl"}, "t", function()
  hs.alert.show("Hammerspoon Test", 3)
end)

-- ALTERNATIVE 1: Menu bar item that can be clicked
local menubar = hs.menubar.new()
if menubar then
  menubar:setTitle("HS")
  menubar:setMenu({
    {title = "Show Alert", fn = function() 
      hs.alert.show("Hello World via Menu", 3)
    end},
    {title = "Launch Bitwarden Search", fn = launch_bitwarden_search}
  })
end

-- ALTERNATIVE 2: Function that can be called from the console
function test_notification()
  hs.alert.show("Console Test", 3)
end
-- You can run this in Hammerspoon console by typing: test_notification()

-- ALTERNATIVE 3: Function that runs at a specific interval
local function timed_check()
  -- This will show a notification every hour
  hs.alert.show("Hourly check", 3)
end
local timer = hs.timer.doEvery(3600, timed_check)

-- ALTERNATIVE 4: Use a very uncommon key combination
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "f15", function()
  hs.alert.show("Rare Key Combo", 3)
end)

-- ALTERNATIVE 5: Listen for specific screen changes
local screenWatcher = hs.screen.watcher.new(function()
  hs.alert.show("Screen configuration changed", 3)
end)
screenWatcher:start()

-- Print a message in the console to confirm loading
print("Hammerspoon init.lua fully loaded with all alternatives")

-- NOTIFICATION TROUBLESHOOTING SECTION
-- 1. Try different notification styles
function test_notification_styles()
  -- Standard notification
  hs.notify.new({title="Test 1", informativeText="Standard notification"}):send()
  
  -- With sound
  hs.timer.doAfter(1, function()
    hs.notify.new({title="Test 2", informativeText="Notification with sound", 
                  soundName="Submarine"}):send()
  end)
  
  -- With higher priority and sticky
  hs.timer.doAfter(2, function()
    local n = hs.notify.new({title="Test 3", 
                           informativeText="High priority sticky notification"})
    n:setPriority(10):setSticky(true):send()
  end)
  
  -- Visual alternative using alert
  hs.timer.doAfter(3, function()
    hs.alert.show("This is an on-screen alert", 5)
  end)
  
  -- Visual alternative using large text
  hs.timer.doAfter(4, function()
    local screen = hs.screen.mainScreen()
    local rect = screen:frame()
    local text = hs.drawing.text(rect, "LARGE VISIBLE TEXT")
    text:setTextSize(40)
    text:setTextColor({red=1, green=0, blue=0, alpha=1})
    text:show()
    hs.timer.doAfter(3, function() text:delete() end)
  end)
end

-- Create a menu item specifically for testing notifications
local notifTestMenu = hs.menubar.new()
if notifTestMenu then
  notifTestMenu:setTitle("Test")
  notifTestMenu:setMenu({
    {title = "Test All Notification Methods", fn = test_notification_styles},
    {title = "-"}, -- Separator
    {title = "Check Notification Settings", fn = function()
      hs.execute("open 'x-apple.systempreferences:com.apple.preference.notifications'")
    end}
  })
end