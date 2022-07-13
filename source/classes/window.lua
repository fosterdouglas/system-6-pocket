-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics


class("Window").extends(gfx.sprite)
function Window:init(title, text, width, height, footer)
	Window.super.init(self)
	
	if width ~= nil then
		self.width = width
	else
		self.width = 300
	end
	
	if height ~= nil then
		self.height = height
	else
		self.height = 120
	end

	if title ~= nil then
		self.titleDisplay = true
		self.titleValue = title
		self.titleWidth = menuFont:getTextWidth(self.titleValue)
	else
		self.titleDisplay = false
	end

	self.footer = footer
	
	self.isActive = false
	self.isClosing = false
	
	self:setZIndex(100)
	self:setCenter(0, 0)
	
	if text ~= nil then
		self.text = text
		self.leftPadding = 10
		self.rightPadding = 10
		
		self.innerWidth = self.width - 3
		
		-- Get the cell with the most text
		self.largestHeight = 0
		for i,v in ipairs(self.text) do
			local width, height = gfx.getTextSizeForMaxWidth(v, (self.innerWidth - self.leftPadding - self.rightPadding), 0, textFont)

			if height > self.largestHeight then
				self.largestHeight = height
			end
		end
		
		self.listView = playdate.ui.gridview.new(0, self.largestHeight)
		self.listView:setNumberOfColumns(1)
		self.listView:setNumberOfRows(#self.text)
		self.listView:setCellPadding(self.leftPadding, self.rightPadding, 2, 5)
		self.listView:setContentInset(0, 0, 13, 0)
		
		self.height = (self.largestHeight) + 13 + (menuBarHeight*2) + 2 + 5
		
		if self.height > 150 then
			self.height = 120
			self.footer = true
			-- some other stuff here to deal with scrolling
		end
		
		self.innerHeight = self.height - 3 - menuBarHeight
	end
	
	self:setBounds(self.x, self.y, self.width, self.height)
end

function Window:update()
	self:moveTo(self.x, self.y)
end

function Window:draw()
	self:drawFrame()
	
	if self.titleDisplay then
		self:drawTitleBar()
		self:drawCloseButton()
	end
	
	if self.text then
		self:drawContent()
		self.listView:drawInRect(0, menuBarHeight, self.innerWidth + 1, self.innerHeight + 1)
	end
	
	if self.footer then
		self:drawFooter()
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

-- TODO: change this to drawScrollBars or something
function Window:drawFooter()
	-- footer separator
	gfx.fillRect(1, self.height - menuBarHeight + 1, self.width - 3, menuBarHeight - 3)
	
	gfx.setColor(kBlack)
	gfx.drawLine(1, self.height - menuBarHeight, self.width - 3, self.height - menuBarHeight)
end

function Window:drawCloseButton()
	local closeButtonX = 9
	local closeButtonY = 4
	local closeButtonSize = 11 
	
	if self.isActive then
		gfx.setColor(kWhite)
		gfx.fillRect(closeButtonX - 1, closeButtonY, closeButtonSize + 2, closeButtonSize)
		
		gfx.setColor(kBlack)
		gfx.setStrokeLocation(kInside)
		gfx.drawRect(closeButtonX, closeButtonY, closeButtonSize, closeButtonSize)
	end
	
	if self.isClosing then
		gfx.drawLine(closeButtonX + 1, closeButtonY + 5, closeButtonX + 3, closeButtonY + 5)
		gfx.drawLine(closeButtonX + 7, closeButtonY + 5, closeButtonX + 10, closeButtonY + 5)
		gfx.drawLine(closeButtonX + 5, closeButtonY + 1, closeButtonX + 5, closeButtonY + 3)
		gfx.drawLine(closeButtonX + 5, closeButtonY + 7, closeButtonX + 5, closeButtonY + 10)
		
		gfx.drawPixel(closeButtonX + 2, closeButtonY + 2)
		gfx.drawPixel(closeButtonX + 3, closeButtonY + 3)
		gfx.drawPixel(closeButtonX + 8, closeButtonY + 2)
		gfx.drawPixel(closeButtonX + 7, closeButtonY + 3)
		gfx.drawPixel(closeButtonX + 2, closeButtonY + 8)
		gfx.drawPixel(closeButtonX + 3, closeButtonY + 7)
		gfx.drawPixel(closeButtonX + 7, closeButtonY + 7)
		gfx.drawPixel(closeButtonX + 8, closeButtonY + 8)
	end
end

function Window:drawContent()
	local text = self.text
	function self.listView:drawCell(section, row, column, selected, x, y, width, height)
		gfx.setFont(textFont)
		gfx.drawTextInRect(text[row], x, y, width, height)
	end
	
	self.listView:addHorizontalDividerAbove(1, 2)
	self.listView:setHorizontalDividerHeight(1)
	function self.listView:drawHorizontalDivider(x, y, width, height)
		gfx.setColor(kBlack)
		gfx.setLineWidth(1)
		gfx.drawLine(x + 1, y, x + width + 1, y)
	end
end

function Window:displayWindow(x, y)
	self:moveTo(x, y)
	self:add()
end

function Window:setActive()
	self.isActive = true
	self:setZIndex(100)
	self:markDirty()
end

function Window:setInactive()
	self.isActive = false
	self:setZIndex(self:getZIndex() - 1)
	self:markDirty()
end

function Window:setTitleDisplay(flag)
	self.titleDisplay = flag
	self:markDirty()
end

function Window:setClosing(flag)
	self.isClosing = flag
	self:markDirty()
end

function Window:removeWindow(index)	
	self:remove()
	self = nil
end

