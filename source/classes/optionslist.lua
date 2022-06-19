-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics
local listViewItemHeight = menuBarHeight
local listViewItemPadding = menuItemPadding

class("OptionsList").extends(gfx.sprite)
function OptionsList:init(options, x, y)
	OptionsList.super.init(self)
	self.optionsList = options
	self.optionsListX = x
	self.optionsListY = y + listViewItemHeight
	self.optionsListBackground = nil
	
	
	self.optionsListHeight = #self.optionsList * listViewItemHeight

	-- Get the longest string in our options list
	self.stringList = table.create(#self.optionsList, 0)
	for i,v in ipairs(self.optionsList) do
		local string = v.label
		table.insert(self.stringList, string)
	end
	
	table.sort(self.stringList, function(a,b) return #a<#b end) -- TODO: add this sorting to _utilities!
	
	self.maxStringWidth = menuFont:getTextWidth(self.stringList[#self.stringList])
	self.optionsListWidth = self.maxStringWidth + listViewItemPadding + 5
	
	self.listView = playdate.ui.gridview.new(self.optionsListWidth, listViewItemHeight)
	self.listView:setNumberOfColumns(1)
	self.listView:setNumberOfRows(#self.optionsList)
	self.listView:setSelection(0)
	-- self.listView:addHorizontalDividerAbove(1, 2) --TODO: add this functionality maybe later
	
	local options = self.optionsList
	function self.listView:drawCell(section, row, column, selected, x, y, width, height)
		if selected then
			
			
			gfx.setColor(kBlack)
			gfx.fillRect(x, y, width, height)
			_setImageColor(kWhite)
		else
			_setImageColor(kBlack)
		end
		
		gfx.setFont(menuFont)
		gfx.drawTextInRect(options[row].label, x + listViewItemPadding, y, width, height)
	end

	self.optionsListBackground = Window(self.optionsListWidth, self.optionsListHeight)
	self.optionsListBackground:displayWindow(self.optionsListX, self.optionsListY)
	
	self:setBounds(self.optionsListX, self.optionsListY, self.optionsListWidth, self.optionsListHeight)
	
	self:createInputHandlers()
	self:setZIndex(200)
	self:add()
end

function OptionsList:update()
	if self.listView.needsDisplay then
		self:markDirty()
	end
end

function OptionsList:draw()
	self.listView:drawInRect(0, 0, self.optionsListWidth, self.optionsListHeight)
end

function OptionsList:removeOptionsList()
	self.optionsListBackground:removeWindow()
	self.optionsListBackground = nil
	self.listView = nil
	self:removeInputHandlers()
	self:remove()
end

function OptionsList:createInputHandlers()
	local inputHandlers = {
		upButtonDown = function()
			self.listView:selectPreviousRow()
		end,
		downButtonDown = function()
			self.listView:selectNextRow()
		end,
		AButtonUp = function()
			local selection = self.listView:getSelectedRow()
			
			-- If a row is selected, initiate its program and close menu
			if selection ~= nil and self.optionsList[selection].program ~= nil then
				self.optionsList[selection].program()
				menuBar:resetMenuBar()
			end
			
			-- If no row is selected, select the first item
			if selection == nil then
				self.listView:setSelectedRow(1)
			end
				
		end,
		BButtonUp = function()
			menuBar:resetMenuBar()
		end
	}
	
	playdate.inputHandlers.push(inputHandlers)
end

function OptionsList:removeInputHandlers()
	playdate.inputHandlers.pop()
end