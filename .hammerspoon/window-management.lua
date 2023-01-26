local This = {}

-- To easily layout windows on the screen, we use hs.grid to create a 4x4 grid.
-- If you want to use a more detailed grid, simply change its dimension here
local X_GRID_SIZE = 8
local Y_GRID_SIZE = 4

local X_HALF_GRID_SIZE = X_GRID_SIZE / 3
local Y_HALF_GRID_SIZE = Y_GRID_SIZE / 3

-- Set the grid size and add a few pixels of margin
-- Also, don't animate window changes... That's too slow
hs.grid.setGrid(X_GRID_SIZE .. 'x' .. Y_GRID_SIZE)
hs.grid.setMargins({5, 5})
hs.window.animationDuration = 0

-- Defining screen positions
local screenPositions       = {}
-- screenPositions.left        = {x = 0,              y = 0,              w = X_HALF_GRID_SIZE, h = Y_GRID_SIZE     }
-- screenPositions.right       = {x = X_HALF_GRID_SIZE, y = 0,              w = HALF_GRID_SIZE, h = GRID_SIZE     }
-- screenPositions.top         = {x = 0,              y = 0,              w = GRID_SIZE,      h = HALF_GRID_SIZE}
-- screenPositions.bottom      = {x = 0,              y = Y_HALF_GRID_SIZE, w = GRID_SIZE,      h = HALF_GRID_SIZE}

screenPositions.topLeft     = {x = 0,              y = 0,              w = X_HALF_GRID_SIZE, h = Y_HALF_GRID_SIZE}
screenPositions.topRight    = {x = X_HALF_GRID_SIZE, y = 0,              w = X_HALF_GRID_SIZE, h = Y_HALF_GRID_SIZE}
screenPositions.bottomLeft  = {x = 0,              y = Y_HALF_GRID_SIZE, w = X_HALF_GRID_SIZE, h = Y_HALF_GRID_SIZE}
screenPositions.bottomRight = {x = X_HALF_GRID_SIZE, y = Y_HALF_GRID_SIZE, w = X_HALF_GRID_SIZE, h = Y_HALF_GRID_SIZE}

This.screenPositions = screenPositions

-- This function will move either the specified or the focuesd
-- window to the requested screen position
function This.moveWindowToPosition(cell, window)
  if window == nil then
    window = hs.window.focusedWindow()
  end
  if window then
    local screen = window:screen()
    hs.grid.set(window, cell, screen)
  end
end

-- This function will move either the specified or the focused
-- window to the center of the sreen and let it fill up the
-- entire screen.
function This.windowMaximize(factor, window)
   if window == nil then
      window = hs.window.focusedWindow()
   end
   if window then
      window:maximize()
   end
end

return This
