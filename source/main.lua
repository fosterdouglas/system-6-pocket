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


-- -- -- -- CONSTANTS -- -- -- -- 
import "lib/_utilities"
local gfx <const> = playdate.graphics

-- -- -- -- GLOBALS -- -- -- -- 
menuFont = gfx.font.new("assets/fonts/chicago-9")
menuFontHeight = gfx.font.getHeight(menuFont)
menuBarHeight = menuFontHeight
menuItemPadding = 14

-- -- -- -- CLASSES -- -- -- -- 
import "classes/menuitem"
import "classes/menubar"

-- -- -- -- BACKGROUND -- -- -- -- 
gfx.sprite.setBackgroundDrawingCallback(
	function(x, y, width, height)
		-- Background
		gfx.setPattern({0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA})
		gfx.fillRect(0, 0, kDisplayWidth, kDisplayHeight)
		
		-- Menu Bar
		gfx.setColor(kWhite)
		gfx.fillRect(0, 0, kDisplayWidth, menuBarHeight)
		
		-- Divider
		gfx.setColor(kBlack)
		gfx.drawLine(0, menuBarHeight, kDisplayWidth, menuBarHeight)
	end
)

-- -- -- -- SETUP -- -- -- -- 
menu = MenuBar(
	{
		{ 
			label = "◊", 
			options = {}
		},
		{
			label = "File", 
			options = {}
		},
		{
			label = "Edit", 
			options = {}
		},
		{
			label = "View",
			options = {}
		},
		{
			label = "Special",
			options = {}
		}
	}
)

-- -- -- -- UPDATE -- -- -- -- 
function playdate.update()
	playdate.timer.updateTimers()
	playdate.frameTimer.updateTimers()
	gfx.sprite.update()
	
	-- _setImageColor(kCopy)
	-- gfx.setFont(menuFont)
	-- gfx.drawText(kGlyphPlaydate, kDisplayWidth - 35, -1)
end

-- -- -- -- INPUTS -- -- -- -- 
function playdate.rightButtonDown()
	menu:selectNextMenuItem()
end

function playdate.leftButtonDown()
	menu:selectPreviousMenuItem()
end

function playdate.BButtonDown()
	menu:resetMenu()
end

	-- -- -- -- DEBUG -- -- -- --
function playdate.keyPressed(key)
	if key == "1" then
	end
end