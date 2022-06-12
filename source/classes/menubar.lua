-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics


class("MenuBar").extends()
function MenuBar:init(itemsTable)
	MenuBar.super.init(self)
	self.menuBarConfigurations = itemsTable
	self.menuBar = table.create(#self.menuBarConfigurations, 0)
	self.menuItemSelected = 0

	self:createMenuBar()
end

function MenuBar:createMenuBar()
	local offsetX = -(menuItemPadding/2)
	for i, v in ipairs(self.menuBarConfigurations) do
		obj = MenuItem(v.label, v.options)
		local itemX = ((menuItemPadding) * i) + offsetX
		offsetX = offsetX + obj.labelWidth
		
		obj.labelSprite:add()
		obj.labelSprite:moveTo(itemX, 0)
		table.insert(self.menuBar, obj)	
	end
end

function MenuBar:selectNextMenuItem()
	if self.menuItemSelected ~= 0 then
		self.menuBar[self.menuItemSelected]:toggleItem()
	end
	
	self.menuItemSelected = (self.menuItemSelected%#self.menuBar) + 1
	self.menuBar[self.menuItemSelected]:toggleItem()
end

function MenuBar:selectPreviousMenuItem()
	if self.menuItemSelected ~= 0 then
		self.menuBar[self.menuItemSelected]:toggleItem()
	end
	
	self.menuItemSelected = math.max(math.fmod(self.menuItemSelected - 1, #self.menuBar), 0)
	if self.menuItemSelected == 0 then
		self.menuItemSelected = #self.menuBar
	end
	self.menuBar[self.menuItemSelected]:toggleItem()
end

function MenuBar:resetMenu()
	if self.menuItemSelected ~= 0 then
		self.menuBar[self.menuItemSelected]:toggleItem()
		self.menuItemSelected = 0
	end
end