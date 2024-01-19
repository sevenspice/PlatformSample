---@diagnostic disable: undefined-global
class('Actor').extends()
function Actor:init(_stageRect, _zindex, _groupIds)
    self.zindex    = _zindex
    self.stageRect = _stageRect
    self.groupIds  = _groupIds
    self.currentImagetable = nil
    self.currentLoop = nil
    self.currentSprite = nil
    self.state = 0
    self.x = 0
    self.y = 0
    self.floorPosition = 0
end

function Actor:commonSpriteSettings()
    if self.currentSprite then
        self.currentSprite:remove()
    end

    self.currentSprite = playdate.graphics.sprite.new(self.currentLoop:image())
    self.currentSprite:setCenter(0, 0)
    self.currentSprite:setZIndex(self.zindex)
    self.currentSprite:setGroups(self.groupIds)
    self.currentSprite:setCollidesWithGroups(self.groupIds)
    -- https://sdk.play.date/2.1.1/Inside%20Playdate.html#m-graphics.sprite.setCollideRect
    self.currentSprite:setCollideRect(0, 0, self.currentSprite:getSize())
    self.currentSprite.collisionResponse = playdate.graphics.sprite.kCollisionTypeFreeze

    self.currentSprite:moveTo(self.x, self.y)
end

function Actor:move(_ignore)
    local cx, cy, _, count = self.currentSprite:checkCollisions(self.x, self.y)
    if count > 0 then
        if not _ignore then
            self.currentSprite:moveTo(cx, cy)
            self.x = cx
            self.y = cy
            self.floorPosition = cy -- Keep floor coordinates.
        end
    else
        self.currentSprite:moveTo(self.x, self.y)
    end
end

function Actor:setPosition(_cellx, _celly)
    local spriteWidth, spriteHeight = self.currentSprite:getSize()
    self.x = _cellx * spriteWidth
    self.y = _celly * spriteHeight
    self.currentSprite:moveTo(self.x, self.y)
end
