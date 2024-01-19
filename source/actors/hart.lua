import "actors/actor"
---@diagnostic disable: undefined-global
class('Hart').extends(Actor)
function Hart:init(_stageRect, _zindex, _groupIds)
    Hart.super.init(self, _stageRect, _zindex, _groupIds)
    self.states = {
        idle = 1;
    }

    self.idleFrametime = 200
    self.idlePath = "images/spritesheets/" .. self.className:lower() .. "/idle"
end

function Hart:idle()
    if not (self.state == self.states.idle) then

        if self.currentSprite then
            self.currentSprite:remove()
        end

        self.currentImagetable = playdate.graphics.imagetable.new(self.idlePath)
        self.currentLoop = playdate.graphics.animation.loop.new(self.idleFrametime, self.currentImagetable, true)
        self:commonSpriteSettings()
    end

    self.currentSprite.update = function()
        self.currentSprite:setImage(self.currentLoop:image())
        if not self.currentLoop:isValid() then
            self.currentSprite:remove()
        end
    end

    self.currentSprite:add()

    self.state = self.states.idle
end

function Hart:collideWithPlayer(_player)
    -- https://sdk.play.date/2.1.1/Inside%20Playdate.html#m-graphics.sprite.alphaCollision
    if _player.currentSprite:alphaCollision(self.currentSprite) then
        self.currentSprite:remove()
    end
end
