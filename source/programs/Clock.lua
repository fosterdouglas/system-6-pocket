-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics

class("Clock").extends("Program")
function Clock:init()
	Clock.super.init(self)
	
	self:setZIndex(1000) -- change this eventually
	self:setOpaque(true)
	self:setCenter(0, 0)
	
	self.currentTime = playdate.getTime()
	self.deltaSecond = 0
	
	self.width = 133
	self.height = 22

	self:setBounds(self.x, self.y, self.width, self.height)
end

function Clock:update()
	self:moveTo(self.x, self.y)
	
	self.currentTime = playdate.getTime()
	
	if self.currentTime.second ~= self.deltaSecond then
		self.deltaSecond = self.currentTime.second
		
		self:markDirty()
	end
end

function Clock:draw()
	self:drawFrame()
	self:drawTime()
end

function Clock:drawFrame()
	-- shadow
	gfx.setColor(kBlack)
	gfx.fillRect(2, 2, self.width, self.height)
	
	-- background
	gfx.setColor(kWhite)
	gfx.fillRect(0, 0, self.width - 2, self.height - 2)
	
	-- border
	gfx.setColor(kBlack)
	gfx.drawRect(0, 0, self.width - 2, self.height - 2)
end

function Clock:drawTime()
	local hour = self:formatTime(self.currentTime.hour)
	local minute = self:formatTime(self.currentTime.minute)
	local second = self:formatTime(self.currentTime.second)
	
	gfx.setFont(menuFont)
	gfx.drawTextAligned(hour .. ':' .. minute .. ':' .. second, self.width/2, 2, kCenter)
end

function Clock:formatTime(number)
	if number < 10 then
		return 0 .. number
	else
		return number
	end
end

function Clock:displayClock(x, y)
	self:moveTo(x, y)
	self:add()
end

function Clock:removeClock()
	self:remove()
end