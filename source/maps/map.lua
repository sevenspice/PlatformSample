---@diagnostic disable: undefined-global
class('Map').extends()
function Map:init(_mapArray, _zindex, _displayWidth, _groudIds)
    self.mapArray     = _mapArray
    self.zindex       = _zindex
    self.displayWidth = _displayWidth
    self.groudIds     = _groudIds
    self.path = "images/spritesheets/tilemap"

    self.x = 0
    self.y = 0

    self.complete = false

    local tilemapImage = playdate.graphics.imagetable.new(self.path)
    self.tilemap = playdate.graphics.tilemap.new()
    self.tilemap:setImageTable(tilemapImage)

    local tileWidth, _ = self.tilemap:getTileSize()
    self.tilemap:setTiles(self.mapArray, (self.displayWidth / tileWidth))

    self.currentSprite = playdate.graphics.sprite.new(self.tilemap)
    self.currentSprite:setCenter(0, 0)
    self.currentSprite:moveTo(self.x, self.y)
    self.currentSprite:setZIndex(self.zindex)
    self.currentSprite:add()
end

function Map:setCollsions(emptyIds)
    if not self.complete then
        -- https://sdk.play.date/2.2.0/Inside%20Playdate.html#f-graphics.sprite.addWallSprites
        local collisions = playdate.graphics.sprite.addWallSprites(self.tilemap, emptyIds)
        for i=1, #collisions do
            collisions[i].collisionResponse = playdate.graphics.sprite.kCollisionTypeFreeze
            collisions[i]:setGroups(self.groudIds)
            collisions[i]:setCollidesWithGroups(self.groudIds)
        end
        self.complete = true
    end
end

