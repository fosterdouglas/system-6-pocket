-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics

class("Finder").extends(gfx.sprite)
function Finder:init(title)
	Finder.super.init(self)
	self.programWindow = Window(300, 120, title)
	
	if #programList > 0 then
		local previousX = programList[#programList].x 
		local previousY = programList[#programList].y
		self.programWindow:displayWindow(previousX + (menuBarHeight * 2), previousX + (menuBarHeight * 2))
	else
		self.programWindow:displayWindow(25, 25)
	end
	
	self.programWindow:setActive()
	table.insert(programList, self.programWindow)
end