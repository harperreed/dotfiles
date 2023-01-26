local wm = require('window-management')

-- hs.loadSpoon("SpoonInstall")
-- hs.loadSpoon("ReloadConfiguration")
hs.loadSpoon('AClock')
hs.loadSpoon('MouseCircle')
-- hs.loadSpoon('PasswordGenerator')
-- hs.loadSpoon('Emojis')

-- spoon.ReloadConfiguration:start()

-- spoon.SpoonInstall.repos.ShiftIt = {
--   url = "https://github.com/peterklijn/hammerspoon-shiftit",
--   desc = "ShiftIt spoon repository",
--   branch = "master",
-- }

-- spoon.SpoonInstall:andUse("ShiftIt", { repo = "ShiftIt" })
-- spoon.ShiftIt:bindHotkeys({})

spoon.AClock:init({})
-- spoon.AClock:hide()

hyper = {'cmd', 'alt', 'ctrl'}

hs.hotkey.bind(hyper, 'PageUp', function() spoon.AClock:toggleShow() end)
hs.hotkey.bind(hyper, 'PageDown', function() spoon.CountDown:startFor(5) end)

spoon.MouseCircle:bindHotkeys({
  show = { hyper, "d" }
})

-- spoon.PasswordGenerator:bindHotkeys({
--   copy = {{}, "F13"},
--   paste = {{}, "F14"}
-- })

-- spoon.PasswordGenerator.password_style="xkcd"
-- spoon.PasswordGenerator.word_separators="-"

-- spoon.Emojis:bindHotkeys({
--   toggle = {{}, "F15"}
-- })


-- hs.hotkey.bind(hyper, "up", function()
--   wm.windowMaximize(0)
-- end)
-- hs.hotkey.bind(hyper,"right", function()
--   wm.moveWindowToPosition(wm.screenPositions.right)
-- end)
-- hs.hotkey.bind(hyper, "down", function()
--   hs.window.focusedWindow():moveOneScreenEast()
-- end)
-- hs.hotkey.bind(hyper, "down", function()
--   hs.window.focusedWindow():moveOneScreenWest()
-- end)
-- hs.hotkey.bind(hyper, "left", function()
--   wm.moveWindowToPosition(wm.screenPositions.left)
-- end)
hs.hotkey.bind(hyper, "1", function()
  wm.moveWindowToPosition(wm.screenPositions.topLeft)
end)
hs.hotkey.bind(hyper, "2", function()
  wm.moveWindowToPosition(wm.screenPositions.topRight)
end)
hs.hotkey.bind(hyper, "3", function()
  wm.moveWindowToPosition(wm.screenPositions.bottomLeft)
end)
hs.hotkey.bind(hyper, "4", function()
  wm.moveWindowToPosition(wm.screenPositions.bottomRight)
end)
-- hs.hotkey.bind(hyper, "5", function()
--   wm.moveWindowToPosition(wm.screenPositions.top)
-- end)
-- hs.hotkey.bind(hyper, "6", function()
--   wm.moveWindowToPosition(wm.screenPositions.bottom)
-- end)