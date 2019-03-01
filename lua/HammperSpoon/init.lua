
-- Window Control
-- Move window like Magnet
-- http://magnet.crowdcafe.com/

local leftDockOffset = 45

hs.hotkey.bind({"ctrl", "alt"},"u", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = 0 + leftDockOffset
    f.y = 0
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"i", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = max.w / 2 + leftDockOffset
    f.y = 0
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"j", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = 0 + leftDockOffset
    f.y = max.h / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"k", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = max.w / 2 + leftDockOffset
    f.y = max.h / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = 0 + leftDockOffset
    f.y = 0
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = max.w / 2 + leftDockOffset
    f.y = 0
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"up", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = 0 + leftDockOffset
    f.y = 0
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"down", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = 0 + leftDockOffset
    f.y = max.h / 2
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"return", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = 0 + leftDockOffset
    f.y = 0
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"d", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = 0 + leftDockOffset
    f.y = 0
    f.w = max.w / 3
    f.h = max.h 
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"f", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = max.w / 3 + leftDockOffset
    f.y = 0
    f.w = max.w / 3
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"g", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = max.w - max.w / 3 + leftDockOffset
    f.y = 0
    f.w = max.w / 3
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"e", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = 0 + leftDockOffset
    f.y = 0
    f.w = max.w - max.w / 3
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({"ctrl", "alt"},"t", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()

    f.x = max.w - max.w / 3 + leftDockOffset
    f.y = 0
    f.w = max.w / 3
    f.h = max.h
    win:setFrame(f)
end)

-- Sizeup like move window to next screen
-- hs.hotkey.bind({"ctrl", "shift"},"right", function()
--     hs.window.focusedWindow():focusWindowEast()
-- end)

-- hs.hotkey.bind({"ctrl", "shift"},"left", function()
--     hs.window.focusedWindow():focusWindowWest()
-- end)


-- Sound Control
hs.hotkey.bind({"ctrl"},"f10", function()
    local muted = hs.audiodevice.defaultOutputDevice():muted()
    hs.audiodevice.defaultOutputDevice():setMuted(not muted)
end)

hs.hotkey.bind({"ctrl"},"f11", function()
    local value = hs.audiodevice.defaultOutputDevice():volume()
    value = value - 6.25
    hs.audiodevice.defaultOutputDevice():setVolume(value)
end)

hs.hotkey.bind({"ctrl"},"f12", function()
    local value = hs.audiodevice.defaultOutputDevice():volume()
    value = value + 6.25
    hs.audiodevice.defaultOutputDevice():setVolume(value)
end)

