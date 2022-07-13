-- -- -- -- CORELIBS -- -- -- -- 
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/easing"
import "CoreLibs/animator"
import "CoreLibs/graphics"
import "CoreLibs/frameTimer"
import "CoreLibs/math"
import "CoreLibs/object"
import "CoreLibs/animation"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "CoreLibs/utilities/sampler"
import "CoreLibs/keyboard"

-- -- -- -- CONSTANTS -- -- -- -- 
import "lib/lemonade-utilities/_lemonade"
local gfx <const> = playdate.graphics

-- -- -- -- GLOBALS -- -- -- -- 
menuFont = gfx.font.new("assets/fonts/chicago-12")
padFont = gfx.font.new("assets/fonts/new-york-12")
textFont = gfx.font.new("assets/fonts/geneva-9")
menuFontHeight = gfx.font.getHeight(menuFont)
menuBarHeight = menuFontHeight
menuItemPadding = 13
DEBUG = true

-- -- -- -- CLASSES -- -- -- -- 
import "classes/Factory"
import "classes/menu/MenuItem"
import "classes/menu/MenuBar"
import "classes/menu/OptionsList"
import "classes/window"
import "classes/start"
import "classes/icon"
import "classes/Program"
import "classes/Cursor"
import "programs/Finder"
import "programs/Clock"
import "programs/NotePad"
import "programs/Puzzle"

-- -- -- -- BACKGROUND -- -- -- -- 
gfx.sprite.setBackgroundDrawingCallback(
	function(x, y, width, height)
		-- background
		gfx.setPattern({0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA})
		gfx.fillRect(0, 0, kDisplayWidth, kDisplayHeight)
		
		-- menu bar
		gfx.setColor(kWhite)
		gfx.fillRect(0, 0, kDisplayWidth, menuBarHeight)
		
		-- divider
		gfx.setColor(kBlack)
		gfx.drawLine(0, menuBarHeight, kDisplayWidth, menuBarHeight)
		
		-- border
		gfx.image.new('assets/images/border'):draw(0, 0)
	end
)

-- -- -- -- SETUP -- -- -- -- 
import "configuration"

if not DEBUG then
	Start()
end

factory = Factory()
cursor = Cursor()

Icon("assets/images/trash-can", "Trash", 344, 182)
Puzzle()

-- -- -- -- UPDATE -- -- -- -- 
function playdate.update()
	playdate.timer.updateTimers()
	playdate.frameTimer.updateTimers()
	gfx.sprite.update()
	
	-- gfx.drawText()
	
	-- _setImageColor(kCopy)
	-- gfx.setFont(menuFont)
	-- gfx.drawText(kGlyphPlaydate, kDisplayWidth - 35, -1)
end

-- -- -- -- INPUTS -- -- -- -- 
function desktopInputHandlers()
	local inputHandlers = {
		rightButtonDown = function()
			menuBar:selectNextMenuBarItem()
		end,
		leftButtonDown = function()
			menuBar:selectPreviousMenuBarItem()
		end,
	}
	
	playdate.inputHandlers.push(inputHandlers)
end

desktopInputHandlers()

-- -- -- -- DEBUG -- -- -- --
function playdate.keyPressed(key)
	if key == "1" then
	end
end