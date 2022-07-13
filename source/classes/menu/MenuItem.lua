-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics


class("MenuItem").extends()
function MenuItem:init(label)
	MenuItem.super.init(self)
	self.labelValue = label
	self.menuOptions = options
	self.isSelected = false
	
	self:createLabel()
end

function MenuItem:createLabel()
	self.labelWidth = menuFont:getTextWidth(self.labelValue)
	self.labelHeight = menuFontHeight
	
	self.labelSprite = gfx.sprite.new()
	self.labelSprite:setCenter(0, 0)
	self.labelSprite:setBounds(self.labelSprite.x, self.labelSprite.y, self.labelWidth + (menuItemPadding), self.labelHeight)
	
	self.labelSprite.update = function()
		self.labelSprite:moveTo(self.labelSprite.x, self.labelSprite.y)
	end
	
	self.labelSprite.draw = function()
		if self.isSelected then
			gfx.setColor(kBlack)
			gfx.fillRect(0, 1, self.labelWidth + (menuItemPadding), menuBarHeight)
		end
		
		_setImageColor(kNXOR)
		gfx.setFont(menuFont)
		gfx.drawText(self.labelValue, (menuItemPadding/2), 0)
	end
end

function MenuItem:toggleItem()
	self.isSelected = not self.isSelected
	self.labelSprite:markDirty()
end