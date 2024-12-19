local gfx <const> = playdate.graphics

class('Piece').extends(gfx.sprite)

--[[ an explanation for movementRange
    
{North, South, West, East, DiagonalNW, DiagonalNE, DiagonalSE, DiagonalSW}

]]

function Piece:init(initPiece, setx, sety)
    Piece.super.init(self)
    self:setImage(pieces_spritesheet[initPiece])
    self.id = nil
    self.shadow = gfx.sprite.new(shadowSprite)
    self.shadow:add()
    self.shadow:setCenter(1, 1.5)
    self.piecetype = initPiece
    self.shadow:setVisible(false)
    self.piece_coords = {setx, sety}
    self.isSelected = false
    self:moveTo( (setx * TILE_SIZE), (sety * TILE_SIZE))
    self:moveBy(offset[1], offset[2])
    self:setCenter(1, 1.15)
    self:setCollideRect( 2, 30, 26, 26)
    self:setZIndex(sety)
end

function Piece:update()
    if playdate.buttonJustPressed("A") then
        if self.isSelected == false then
            if self.piece_coords[1] == coords[1] and self.piece_coords[2] == coords[2] then
                self.isSelected = true
                isAPieceSelected = true
                self.shadow:setVisible(true)
                self:setCollideRect( 2, 45, 26, 26)
                movementRange, selectedPiecePosition = self:CheckForObstacles()
                selectedPieceID = self.id
            end
        else
            self.isSelected = false
            isAPieceSelected = false
            self.shadow:setVisible(false)
            self:moveTo( (coords[1] * TILE_SIZE) + offset[1], (coords[2] * TILE_SIZE) + offset[2])
            self.piece_coords[1] = coords[1]
            self.piece_coords[2] = coords[2]
            self:setCollideRect( 2, 30, 26, 26)
            self:setZIndex(coords[2])
            movementRange = {0, 0, 0, 0, 0, 0, 0, 0}
            selectedPiecePosition = {0, 0}
        end
   end

   if self.isSelected then
        self:moveTo( (coords[1] * TILE_SIZE) + offset[1], (coords[2] * TILE_SIZE) + offset[2] - 15 )
        self.shadow:moveTo( (coords[1] * TILE_SIZE) + offset[1], (coords[2] * TILE_SIZE)) -- i hate recentering sprites!
        self.shadow:setZIndex(coords[2] - 1)
   end
end

function Piece:CheckForObstacles()
    
    local range = {0, 0, 0, 0, 0, 0, 0, 0}
    local currentPosition = self.piece_coords

    if self.piecetype == PieceType.PAWN then
       self:PawnCheck(range)
    elseif self.piecetype == PieceType.KNIGHT then

    elseif self.piecetype == PieceType.BISHOP then
        self:CheckBishop(range)

    elseif self.piecetype == PieceType.ROOK then
        self:RookCheck(range)

    elseif self.piecetype == PieceType.QUEEN then

    elseif self.piecetype == PieceType.KNIGHT then

    end

    return range, currentPosition
end

function Piece:PawnCheck(range)
     --North
    if #self.querySpritesAtPoint( ((coords[1]) * TILE_SIZE) + offset[1] - 15 , ((coords[2]) * TILE_SIZE) + offset[2] - 45) > 0 then
        range[1] = coords[2]
    else
        range[1] = coords[2] - 1
    end
    --south
    if #self.querySpritesAtPoint( ((coords[1]) * TILE_SIZE) + offset[1] - 15 , ((coords[2]) * TILE_SIZE) + offset[2] + 15) > 0 then
        range[2] = coords[2]
    else
        range[2] = coords[2] + 1
    end
    --west
    if #self.querySpritesAtPoint( ((coords[1]) * TILE_SIZE) + offset[1] - 45 , ((coords[2]) * TILE_SIZE) + offset[2] - 15) > 0 then
        range[3] = coords[1]
    else
        range[3] = coords[1] - 1
    end
    --east
    if #self.querySpritesAtPoint( ((coords[1]) * TILE_SIZE) + offset[1] + 15 , ((coords[2]) * TILE_SIZE) + offset[2] - 15) > 0 then
        range[4] = coords[1]
    else
        range[4] = coords[1] + 1
    end
end

function Piece:RookCheck(range)
    --North
    for i = coords[2], 1, -1 do
        if #self.querySpritesAtPoint( ((coords[1]) * TILE_SIZE) + offset[1] -15 , ((i) * TILE_SIZE) + offset[2] - 45) > 0 then
            range[1] = i
            break
        else
            range[1] = 1
        end
    end 

    --South
    for i = coords[2], levelDimensions[1], 1 do
        if #self.querySpritesAtPoint( ((coords[1]) * TILE_SIZE) + offset[1] - 15 , ((i) * TILE_SIZE) + offset[2] + 15) > 0 then
            range[2] = i
            break
        else
            range[2] = levelDimensions[2]
            
        end
    end 

    --west
    for i = coords[1], 1, -1 do
        if #self.querySpritesAtPoint( ((i) * TILE_SIZE) + offset[1] - 45 , ((coords[2]) * TILE_SIZE) + offset[2] - 15) > 0 then
            range[3] = i
            break
        else
            range[3] = 1
        end
    end 

    --East
    for i = coords[1], levelDimensions[1], 1 do
        if #self.querySpritesAtPoint( ((i) * TILE_SIZE) + offset[1] + 15 , ((coords[2]) * TILE_SIZE) + offset[2] - 15) > 0 then
            range[4] = i
            break
        else
            range[4] = levelDimensions[1]
        end
    end 
end

function Piece:CheckBishop(range)
    --Northwest

    --Northeast

    --Southwest

    --Southeast
end