-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics

class("Cursor").extends(gfx.sprite)
function Cursor:init()
	Cursor.super.init(self)
	
	self.cursorImage = gfx.image.new("assets/images/cursor")
	
	self:setCenter(0, 0)
	self:setZIndex(5000)
	self:setImage(self.cursorImage)
	self:add()
	self:setVisibility(false)
end

function Cursor:update()
	self:moveTo(self.x, self.y)
end

function Cursor:draw()
end

function Cursor:setVisibility(flag)
	self:setVisible(flag)
end

function Cursor:setPosition(x, y)
	self.x = x
	self.y = y
end