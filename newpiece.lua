local gfx <const> = playdate.graphics
local anim = gfx.animation.loop

import "move"

class('Piece').extends(gfx.sprite)

local shadow = gfx.sprite.new(shadowSprite)
shadow:setCenter(1, 1.5)

function Piece:init(type, x, y)
    Piece.super.init(self)

    self.isSelected = false
    self.id = nil
    self.piece_type = type
    self.coords = {x, y}
    self.validMoves = {
        left = {},
        right = {},
        up = {},
        down = {},
        upleft = {},
        upright = {},
        downleft = {},
        downright = {},
    }

    shadow:add()
    
    self:setImage(pieces_spritesheet[type])
    self:moveTo(x * TILE_SIZE + offset[1], y * TILE_SIZE + offset[2])
    self:setZIndex(y)
    self:setCollideRect( 2, 30, 26, 26)
end

function Piece:update()
    if playdate.buttonJustPressed("A") then
        if self.isSelected == false then
            if self.piece_coords[1] == coords[1] and self.piece_coords[2] == coords[2] then
                self.isSelected = true
                isAPieceSelected = true
                shadow:setVisible(true)
                self:setCollideRect( 2, 45, 26, 26)
                self:CheckForObstacles()
                selectedPieceID = self.id
            end
        else
            self.isSelected = false
            isAPieceSelected = false
            shadow:setVisible(false)
            self:moveTo( (coords[1] * TILE_SIZE) + offset[1], (coords[2] * TILE_SIZE) + offset[2])
            self.coords[1] = coords[1]
            self.coords[2] = coords[2]
            self:setCollideRect( 2, 30, 26, 26)
            self:setZIndex(coords[2])
            movementRange = {0, 0, 0, 0, 0, 0, 0, 0}
            selectedPiecePosition = {0, 0}
        end
   end

    if self.isSelected then
        self:moveTo( (coords[1] * TILE_SIZE) + offset[1], (coords[2] * TILE_SIZE) + offset[2] - 15 )
        shadow:moveTo( (coords[1] * TILE_SIZE) + offset[1], (coords[2] * TILE_SIZE)) -- i hate recentering sprites!
        shadow:setZIndex(coords[2] - 1)
   end
end

function Piece:ObstacleCheck()
    if self.piecetype == PieceType.PAWN then
        self:PawnCheck()
     elseif self.piecetype == PieceType.KNIGHT then
 
     elseif self.piecetype == PieceType.BISHOP then
         self:CheckBishop()
 
     elseif self.piecetype == PieceType.ROOK then
         self:RookCheck()
 
     elseif self.piecetype == PieceType.QUEEN then
 
     elseif self.piecetype == PieceType.KNIGHT then
 
     end
end

function Piece:PawnCheck()
    local x, y = self.coords[1], self.coords[2]

    local left = self.validMoves.left
    local right = self.validMoves.right
    local up = self.validMoves.up
    local down = self.validMoves.down
    
    if CheckForValidMove({x + 1, y}) == true then right[#right + 1] = {x + 1, y} end
    if CheckForValidMove({x - 1, y}) == true then left[#left + 1] = {x - 1, y} end
    if CheckForValidMove({x, y - 1}) == true then up[#up + 1] = {x, y} end
    if CheckForValidMove({x, y + 1}) == true then down[#down + 1] = {x + 1, y} end
end

function Piece:RookCheck(range)
    local x, y = self.coords[1], self.coords[2]
    local i = 1
    local left = self.validMoves.left
    local right = self.validMoves.right
    local up = self.validMoves.up
    local down = self.validMoves.down

    while i < x do
        if CheckForValidMove({x - i, y}) == true then 
            left[#left + 1] = {x - i, y}
            i += 1
        else
            left[#left + 1] = {x - (i - 1), y}
            break
        end
    end

    i = x + 1
    while i <= levelDimensions[1] do
        if CheckForValidMove({i, y}) == true then 
            right[#right + 1] = {i, y}
            i += 1
        else
            right[#right + 1] = {i - 1, y}
            break
        end
    end

    i = 1
    while i < y do
        if CheckForValidMove({x, y - 1}) == true then 
            up[#up + 1] = {x, y - 1}
            i += 1
        else
            up[#ip + 1] = {x, y - (i - 1)}
            break
        end
    end

    i = y + 1
    while i <= levelDimensions[2] do
        if CheckForValidMove({x, i}) == true then 
            down[#down + 1] = {x, i}
            i += 1
        else
            down[#down + 1] = {x, i - 1}
            break
        end
    end
end