--[[--------------------------------------------------------
	-- Beta GUI library by Cat_Stack496 for Love2D --
--]]--------------------------------------------------------

local gui = {}
local path=(... or ""):gsub("%.[^%.]+$", "");path=path~="" and path.."." or ""

-- Load DOM controller module
gui.dom = require(path.."dom.init")
return gui