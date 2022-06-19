-- -- -- -- CONSTANTS -- -- -- -- 
local gfx <const> = playdate.graphics
local startSFX = playdate.sound.sampleplayer.new("assets/audio/lc-startup-sfx")
local blackScreenLength = 20
local happyMacLength = 120

class("Start").extends(gfx.sprite)
function Start:init(endedCallback)
	Start.super.init(self)
	self.startImage = gfx.image.new('assets/images/happy-mac')
	
	self.sequenceTimer = playdate.frameTimer.new(120)
	self.sequenceTimer.updateCallback = function(timer)
		if timer.frame == blackScreenLength then
			self:markDirty()
			startSFX:play(1)
		elseif timer.frame == happyMacLength then
			self:markDirty()
		end
	end
	self.sequenceTimer.timerEndedCallback = function(timer)
		self:removeScreen()
	end
	
	self:setZIndex(1000)
	self:setBounds(0, 0, kDisplayWidth, kDisplayHeight)
	self:add()
end

function Start:update()
end

function Start:draw()
	if self.sequenceTimer.frame < blackScreenLength then	
		gfx.setColor(kBlack)
		gfx.fillRect(0, 0, kDisplayWidth, kDisplayHeight)
	elseif self.sequenceTimer.frame < happyMacLength then
		gfx.setPattern({0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA})
		gfx.fillRect(0, 0, kDisplayWidth, kDisplayHeight)
		
		_setImageColor(kCopy)
		self.startImage:drawCentered(kDisplayWidth/2, kDisplayHeight/2)
	end
end

function Start:removeScreen()
	self:remove()
	self = nil
end

