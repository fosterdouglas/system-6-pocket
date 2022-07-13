-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics
local listViewItemHeight = menuBarHeight
local listViewItemPadding = menuItemPadding
local selectionAnimating = nil

class("OptionsList").extends(gfx.sprite)
function OptionsList:init(options, x, y)
	OptionsList.super.init(self)
	self.optionsList = options
	self.optionsListX = x
	self.optionsListY = y + listViewItemHeight
	self.optionsListBackground = nil
	
	self.optionsListHeight = #self.optionsList * listViewItemHeight + 2

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
			gfx.fillRect(x + 1, y, width - 3, height)
			_setImageColor(kWhite)
		else
			_setImageColor(kBlack)
		end
		
		gfx.setFont(menuFont)
		gfx.drawTextInRect(options[row].label, x + listViewItemPadding, y, width, height)
		
		-- Blink on selection
		if selected and selectionAnimating then
			gfx.setColor(kWhite)
			gfx.fillRect(x + 1, y, width - 3, height)
		end
		
		-- Dither out options that are unavailable to select
		if not options[row].enabled then
			local yPos
			if row == 1 then
				-- Adjust for an issue with the top row
				yPos = y + 1
			else
				yPos = y
			end
			
			gfx.setColor(kWhite)
			gfx.setDitherPattern(0.5, kDitherB2)
			gfx.fillRect(x + 1, yPos, width - 3, height)
		end
	end

	self.optionsListBackground = Window(nil, nil, self.optionsListWidth, self.optionsListHeight, false)
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
	self.inputHandlers = {
		upButtonDown = function()
			self:setEmptyRow()
			
			self.listView:selectPreviousRow(true)
		end,
		downButtonDown = function()
			self.listView:selectNextRow(true)
		end,
		AButtonDown = function()
			local selection = self.listView:getSelectedRow()
			
			-- If a row is selected, initiate its program and close menu
			if selection ~= nil and self.optionsList[selection].program ~= nil then
				
				-- First, animate the selected row
				self.selectionTimer = playdate.frameTimer.new(9)
				self.selectionTimer.updateCallback = function(timer)
					if timer.frame == timer.duration*(1/3) or timer.frame == timer.duration*(2/3) or timer.frame == timer.duration then
						selectionAnimating = true
						self:markDirty()
					else
						selectionAnimating = false
						self:markDirty()
					end
				end
				
				self.selectionTimer.timerEndedCallback = function(timer)
					selectionAnimating = false
					menuBar:resetMenuBar()
					self.optionsList[selection].program()
				end
			end			
		end,
		BButtonDown = function()
			menuBar:resetMenuBar()
		end
	}
	
	playdate.inputHandlers.push(self.inputHandlers)
end

function OptionsList:setEmptyRow()
	local selection = self.listView:getSelectedRow()
	
	-- If no row is selected, select the first item
	if selection == nil then
		self.listView:setSelectedRow(1)
	end
end

function OptionsList:removeInputHandlers()
	playdate.inputHandlers.pop()
end