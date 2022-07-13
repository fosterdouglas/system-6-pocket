-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics

class("NotePad").extends("Program")
function NotePad:init()
	NotePad.super.init(self)
	
	self.programWindow = Window("Note Pad", nil, 205, 205, false)
	self.programWindow:displayWindow(8, 25)

	self.programWindow:setActive()
	-- table.insert(factory.programList, self.programWindow)
	
	self:createInputHandlers()
	self:pushInputHandlers(self.inputHandlers)
	
	self.textContent = "Keep up to eight pages of notes in the Note Pad. Click on the dog-ear to turn to the next following page. Click in the lower left corner to turn to the next previous page"
	
	self:setCenter(0, 0)
	self:setBounds(
		self.programWindow.x, 
		self.programWindow.y, 
		self.programWindow.width - 18,
		self.programWindow.height
	)
	self:add()
	self.programActive = true
end

function NotePad:update()
	self:setZIndex(self.programWindow:getZIndex()) -- this is dumb
end

-- somehow move this into Window ??
function NotePad:draw()
	gfx.setImageDrawMode("fillBlack")
	gfx.setFont(padFont)
	
	gfx.drawTextInRect(
		self.textContent, 
		9, 
		menuBarHeight + 11, 
		self.width - 9, 
		self.height)
end

-- TODO: this needs to be handled more sustainably, to push/pop as programs are active/not
function NotePad:createInputHandlers()
	self.inputHandlers = {
		AButtonDown = function()
			playdate.keyboard.show(self.textContent)
			
			playdate.keyboard.textChangedCallback = function()
				self.textContent = playdate.keyboard.text
				
				-- TODO: use this to deal with * and _ issues
				-- self.lastCharacter = string.sub(playdate.keyboard.text, #playdate.keyboard.text)
				
				self:markDirty()
			end
		end,
	}
	
	playdate.inputHandlers.push(self.inputHandlers)
end

-- Recurring functions needed for each class (Program depends on these)

function NotePad:getWidth()
	return self.programWindow.width
end

function NotePad:getHeight()
	return self.programWindow.height
end

function NotePad:updateDraws()
	self.programWindow:markDirty()
	
	if self.programActive then
		self.programWindow:setActive()
	else
		self.programWindow:setInactive()
	end
end

function NotePad:beforeDestroy()
	self.programWindow:setClosing(true)
end

function NotePad:destroy()
	self.programWindow:remove()
	self:popInputHandlers()
end