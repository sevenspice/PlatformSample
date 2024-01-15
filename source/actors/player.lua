import "actors/actor"
---@diagnostic disable: undefined-global
class('Player').extends(Actor)
function Player:init(_stageRect, _zindex, _groupIds, _jumpPower, _speed)
    Player.super.init(self, _stageRect, _zindex, _groupIds)
    self.states = {
        idle = 1;
        walk = 2;
    }

    self.directions = {
        right = 1;
        left  = 2;
    }

    self.direction = self.directions.right

    self.idleFrametime = 200
    self.walkFrametime = 200
    self.walkPath = "images/spritesheets/" .. self.className:lower() .. "/walk"

    self.jumpping = false
    self.dropping = false

    self.jumpReimitHeight = 0
    self.jumpPower = _jumpPower or 4
    self.speed = _speed or 5
end

function Player:turnLeft()
    self.direction = self.directions.left
end

function Player:turnRight()
    self.direction = self.directions.right
end

function Player:lowestPoint()
    local _, spriteHeight = self.currentSprite:getSize()
    self.jumpReimitHeight = (spriteHeight * 2.5)
    return self.stageRect.height - spriteHeight
end

function Player:jump()
    local maxHeight = self.floorPosition - self.jumpReimitHeight

    if not self.jumpping then
        self.jumpping = true
    end

    if self.jumpping then

        if not self.dropping then
            self.y = self.y - self.jumpPower
        else
            local y = self.y + self.jumpPower
            local _, _, _, count = self.currentSprite:checkCollisions(self.x, y)
            if count <= 0 then
                self.y = self.y + self.jumpPower
            else
                self.dropping = false
                self.jumpping = false
            end
        end

        if self.y <= maxHeight then
            self.dropping = true
            self.y = maxHeight
        end
    end
end

function Player:drop()
    self.y = self.y + self.jumpPower
end

function Player:isFloorPresent()
    local y = self.y + self.jumpPower
    local _, _, _, count = self.currentSprite:checkCollisions(self.x, y)
    if count > 0 then
        return true
    end
    return false
end

function Player:pushBlock(_blocks)
    local _, _, collsitions, count = self.currentSprite:checkCollisions(self.x, self.y)
    for i=1, count do
        local collision = collsitions[i]
        for j=1, #_blocks do
            local block = _blocks[j]
            if collision.other == block.currentSprite then
                local _, _, _, count = block.currentSprite:checkCollisions(self.x, self.y)
                if count > 0 then
                    if self.direction == self.directions.left then
                        block.x = block.x - 1
                    else
                        block.x = block.x + 1
                    end

                    block:move(true)
                end
            end
        end
    end
end

function Player:waitMove()
    self:drop()
    self:idle()
    self:move()
end

function Player:jumpMove()
    self:jump()
    self:move()
end

function Player:rightMove(_block)
    self.x = self.x + self.speed
    self:turnRight()
    self:walk()

    if _block then
        self:pushBlock(_block)
    end

    self:move()
    if not self:isFloorPresent() then
        self:drop()
    end
end

function Player:leftMove(_block)
    self.x = self.x - self.speed
    self:turnLeft()
    self:walk()

    if _block then
        self:pushBlock(_block)
    end

    self:move()
    if not self:isFloorPresent() then
        self:drop()
    end
end

function Player:rightJumpMove(_speed)
    self.x = self.x + self.speed
    self:turnRight()
    self:walk()
    self:move()
    self:jump()
end

function Player:leftJumpMove(_speed)
    self.x = self.x - self.speed
    self:turnLeft()
    self:walk()
    self:move()
    self:jump()
end

function Player:idle()
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

function Player:walk()
    if not (self.state == self.states.walk) then

        if self.currentSprite then
            self.currentSprite:remove()
        end

        self.currentImagetable = playdate.graphics.imagetable.new(self.walkPath)
        self.currentLoop = playdate.graphics.animation.loop.new(self.walkFrametime, self.currentImagetable, true)
        self.currentSprite = playdate.graphics.sprite.new(self.currentLoop:image())
        self:commonSpriteSettings()

        self.currentSprite.collisionResponse = playdate.graphics.sprite.kCollisionTypeFreeze
    end

    self.currentSprite.update = function()
        self.currentSprite:setImage(self.currentLoop:image())
        if self.direction == self.directions.left then
            self.currentSprite:setImageFlip("flipX")
        end

        if not self.currentLoop:isValid() then
            self.currentSprite:remove()
        end
    end

    self.currentSprite:add()

    self.state = self.states.walk
end
