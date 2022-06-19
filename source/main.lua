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

-- -- -- -- CONSTANTS -- -- -- -- 
import "lib/lemonade-utilities/_lemonade"
local gfx <const> = playdate.graphics

-- -- -- -- GLOBALS -- -- -- -- 
menuFont = gfx.font.new("assets/fonts/chicago-9")
textFont = gfx.font.new("assets/fonts/geneva-7")
menuFontHeight = gfx.font.getHeight(menuFont)
menuBarHeight = menuFontHeight
menuItemPadding = 13
programList = {}
DEBUG = false

-- -- -- -- CLASSES -- -- -- -- 
import "classes/menuitem"
import "classes/menubar"
import "classes/optionslist"
import "classes/window"
import "classes/start"
import "classes/icon"
import "programs/finder"

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

Icon("assets/images/trash-can", "Trash", 344, 182)

-- -- -- -- UPDATE -- -- -- -- 
function playdate.update()
	playdate.timer.updateTimers()
	playdate.frameTimer.updateTimers()
	gfx.sprite.update()
	
	-- gfx.drawRect(50, 50, 50, 20)
	
	-- _setImageColor(kCopy)
	-- gfx.setFont(menuFont)
	-- gfx.drawText(kGlyphPlaydate, kDisplayWidth - 35, -1)
end

-- -- -- -- INPUTS -- -- -- -- 
function playdate.rightButtonDown()
	menuBar:selectNextMenuBarItem()
end

function playdate.leftButtonDown()
	menuBar:selectPreviousMenuBarItem()
end

function playdate.BButtonDown()
	
end

function playdate.upButtonDown()
	local prevIndex = math.max(math.fmod(getActiveWindowIndex() - 1, #programList), 0)
	if prevIndex == 0 then
		prevIndex = #programList
	end
	
	setAllWindowsInactive()
	programList[prevIndex]:setActive()
end

function playdate.downButtonDown()
	local nextIndex = (getActiveWindowIndex()) % (#programList) + 1
	
	setAllWindowsInactive()
	programList[nextIndex]:setActive()
end

-- -- -- -- DEBUG -- -- -- --
function playdate.keyPressed(key)
	if key == "1" then
	end
end