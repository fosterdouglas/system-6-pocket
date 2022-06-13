-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics


class("Window").extends(gfx.sprite)
function Window:init(width, height, title)
	Window.super.init(self)

	if title ~= nil then
		self.titleDisplay = true
		self.titleValue = title
		self.titleWidth = menuFont:getTextWidth(self.titleValue)
	else
		self.titleDisplay = false
	end
	
	self.isActive = false
	
	self:setOpaque(true)
	self:setCenter(0, 0)
	self:setBounds(self.x, self.y, width, height)
end

function Window:update()
	self:moveTo(self.x, self.y)
end

function Window:draw()
	self:drawFrame()
	
	if self.titleDisplay then
		self:drawTitleBar()
	end
end

function Window:drawFrame()
	-- shadow
	gfx.setColor(kBlack)
	gfx.fillRect(2, 2, self.width, self.height)
	
	-- background
	gfx.setColor(kWhite)
	gfx.fillRect(0, 0, self.width - 1, self.height - 1)
	
	-- border
	gfx.setColor(kBlack)
	gfx.drawRect(0, 0, self.width - 1, self.height - 1)
end

function Window:drawTitleBar()
	-- title bar separator
	gfx.drawLine(0, menuBarHeight, self.width, menuBarHeight)
	
	if self.isActive then
		-- selection lines
		for i = 1, 6 do
			gfx.drawLine(2, 2 + (2 * i), self.width - 4, 2 + (2 * i))
		end
		
		-- close button
		gfx.setColor(kWhite)
		gfx.fillRect(8, 4, 13, 11)
		
		gfx.setColor(kBlack)
		gfx.drawRect(9, 4, 11, 11)
	end
	
	-- title
	if self.titleValue ~= nil then
		gfx.setColor(kWhite)
		gfx.fillRect((self.width/2) - (self.titleWidth/2) - 5, 4, self.titleWidth + 9, 11)
		
		gfx.setFont(menuFont)
		_setImageColor(kCopy)
		gfx.drawTextAligned(self.titleValue, (self.width/2) - 1, 1, kCenter) 
	end
end

function Window:displayWindow(x, y)
	self:moveTo(x, y)
	self:add()
end

function Window:setActive()
	self.isActive = true
end

function Window:setInactive()
	self.isActive = false
end

function Window:setTitleDisplay(flag)
	self.titleDisplay = flag
	self:markDirty()
end

function Window:removeWindow()
	self:remove()
	self = nil
end