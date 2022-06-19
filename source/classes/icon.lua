-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics
local textPadding = 3
local lineHeight = 12

class("Icon").extends(gfx.sprite)
function Icon:init(image, text, x, y)
	Icon.super.init(self)
	
	self.text = text
	gfx.setFont(textFont)
	
	self.iconImage = gfx.image.new(image)
	self.height = self.iconImage.height + lineHeight
	print(self.height)
	self.width = math.max(self.iconImage.width, textFont:getTextWidth(self.text) + (textPadding * 2))
	
	self.isSelected = false
	self:add()
	self:setBounds(0, 0, self.width, self.height)
	self:setCenter(0, 0)
	self:moveTo(x, y)
end

function Icon:update()
end

function Icon:draw()
	
	if self.isSelected then
		_setImageColor(kWhite)
		self.iconImage:drawFaded((self.width - self.iconImage.width)/2, 0, 0.25, kDitherS)
	else
		_setImageColor(kCopy)
		self.iconImage:draw((self.width - self.iconImage.width)/2, 0)
	end
	
	gfx.setColor(kWhite)
	print(self.iconImage.height)
	gfx.fillRect(0, self.iconImage.height, self.width, (textFont:getHeight() - 2) + textPadding*2)
	
	_setImageColor(kBlack)
	gfx.setFont(textFont)
	gfx.drawText(self.text, textPadding, self.iconImage.height - 1)
end

function Icon:setSelected()
	self.isSelected = true
	self:markDirty()
end