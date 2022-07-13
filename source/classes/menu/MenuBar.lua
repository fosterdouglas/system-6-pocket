-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics


class("MenuBar").extends()
function MenuBar:init(items)
	MenuBar.super.init(self)
	self.menuBarConfigurations = items
	self.menuBar = table.create(#self.menuBarConfigurations, 0)
	self.menuItemIndex = 0

	self:createMenuBar()
end

function MenuBar:createMenuBar()
	local offsetX = -(menuItemPadding/2)
	for i, v in ipairs(self.menuBarConfigurations) do
		local item = MenuItem(v.label)
		local itemX = ((menuItemPadding) * i) + offsetX
		offsetX = offsetX + item.labelWidth
		
		item.labelSprite:add()
		item.labelSprite:moveTo(itemX, 0)
		table.insert(self.menuBar, item)	
	end
end

function MenuBar:createOptionsList()
	self.optionsList = OptionsList(
		self.menuBarConfigurations[self.menuItemIndex].options,
		self.menuBar[self.menuItemIndex].labelSprite.x,
		self.menuBar[self.menuItemIndex].labelSprite.y
	)
end

function MenuBar:removeOptionsList()
	if self.optionsList ~= nil then
		self.optionsList:removeOptionsList()
		self.optionsList = nil
	end
end

function MenuBar:selectNextMenuBarItem()
	if self.menuItemIndex ~= 0 then
		self.menuBar[self.menuItemIndex]:toggleItem()
	end
	
	self.menuItemIndex = (self.menuItemIndex%#self.menuBar) + 1
	self.menuBar[self.menuItemIndex]:toggleItem()
	
	self:removeOptionsList()
	self:createOptionsList()
end

function MenuBar:selectPreviousMenuBarItem()
	if self.menuItemIndex ~= 0 then
		self.menuBar[self.menuItemIndex]:toggleItem()
	end
	
	self.menuItemIndex = math.max(math.fmod(self.menuItemIndex - 1, #self.menuBar), 0)
	if self.menuItemIndex == 0 then
		self.menuItemIndex = #self.menuBar
	end
	self.menuBar[self.menuItemIndex]:toggleItem()
	
	self:removeOptionsList()
	self:createOptionsList()
end

function MenuBar:resetMenuBar()
	if self.menuItemIndex ~= 0 then
		self.menuBar[self.menuItemIndex]:toggleItem()
		self.menuItemIndex = 0
		self:removeOptionsList()
	end
end