import "actors/actor"
---@diagnostic disable: undefined-global
class('Block').extends(Actor)
function Block:init(_stageRect, _zindex, _groupIds, _weight)
    Block.super.init(self, _stageRect, _zindex, _groupIds)
    self.states = {
        idle = 1;
    }

    self.idleFrametime = 200
    self.weight = _weight or 5
end

function Block:dropMove()
    self.y = self.y + self.weight
    self:move()
end

function Block:idle()
    if not (self.state == self.states.idle) then

        if self.currentSprite then
            self.currentSprite:remove()
        end

        self.currentImagetable = playdate.graphics.imagetable.new(self.idlePath)
        self.currentLoop = playdate.graphics.animation.loop.new(self.idleFrametime, self.currentImagetable, true)
        self.currentSprite = playdate.graphics.sprite.new(self.currentLoop:image())

        self:commonSpriteSettings()
        self.currentSprite.collisionResponse = playdate.graphics.sprite.kCollisionTypeFreeze
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
