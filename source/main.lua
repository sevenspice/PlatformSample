if not import then import = require end

import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/animation"

import "maps/map"
import "actors/player"
import "actors/hart"
import "actors/block"

local function clearDisplay()
    playdate.graphics.clear()
    playdate.graphics.setBackgroundColor(playdate.graphics.kColorBlack)
end

local groups = {
    collision = 1,
    item = 2
}

local mapArray = {
--  0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23  24
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  -- 0
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  -- 1
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  -- 2
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  -- 3
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  -- 4
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  -- 5
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1  ,1,  -- 6
    12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 1,  1,  1,  1,  1,  1,  1,  1,  -- 7
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  12, 12, 12, 1,  1,  1,  1,  1,  1,  -- 8
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  12, 12, 1,  1,  1,  1,  1,  -- 9
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  -- 10
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  -- 11
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  12, 12, 12, 12, 12, 1,  12, 12, 12, 12, -- 12
    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, -- 13
    12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, -- 14
}
local mapEmptyIds = { 1 }

local playerGroupIds = { groups.collision }
local mapGroupIds    = { groups.collision }
local hartGroupIds   = { groups.item }
local blockGroupIds  = { groups.collision }

local mapIndex = -1
local playerIndex = 1
local hartIndex   = 1
local blockIndex  = 1

local stageRect = playdate.geometry.rect.new(0, 0, playdate.display.getWidth(), playdate.display.getHeight())
local map = Map(mapArray, mapIndex, stageRect.width, mapGroupIds)

local player = Player(stageRect, playerIndex, playerGroupIds)
player:idle()
player.y = player:lowestPoint()
player:setPosition(0, 14)

local hart = Hart(stageRect, hartIndex, hartGroupIds)
hart:idle()
hart:setPosition(1, 6)

local block_1 = Block(stageRect, blockIndex, blockGroupIds)
block_1:idle()
block_1:setPosition(21, 11)

local block_2 = Block(stageRect, 1, blockGroupIds)
block_2:idle()
block_2:setPosition(18, 11)

local blocks = { block_1, block_2 }

function playdate.update()
    clearDisplay()

    -- https://sdk.play.date/2.1.1/Inside%20Playdate.html#f-graphics.sprite.update
    playdate.graphics.sprite.update()

    map:setCollsions(mapEmptyIds)

    if playdate.buttonIsPressed(playdate.kButtonRight) and playdate.buttonIsPressed(playdate.kButtonA) then
        player:rightJumpMove()
    elseif playdate.buttonIsPressed(playdate.kButtonLeft) and playdate.buttonIsPressed(playdate.kButtonA) then
        player:leftJumpMove()
    elseif playdate.buttonIsPressed(playdate.kButtonRight) then
        player:rightMove(blocks)
    elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
        player:leftMove(blocks)
    elseif playdate.buttonIsPressed(playdate.kButtonA) then
        player:jumpMove()
    else
        player:waitMove()
    end

    block_1:dropMove()
    block_2:dropMove()

    hart:collideWithPlayer(player)
end
