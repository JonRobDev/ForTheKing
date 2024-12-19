local gfx = playdate.graphics
local anim = gfx.animation.loop
local img = gfx.image
local imgTbl = gfx.imagetable

import "piece"

local Board = nil

local debugTileCheck = imgTbl.new("sprites/DEBUG/tile-check")
local checkTable = {}

-- honestly i just couldn't find a better place for this
-- This is gonna be responsible for doing a collision check based on tile coordinates
function CheckForValidMove(coords)
    local count = gfx.querySpritesAtPoint( coords[1] * TILE_SIZE + offset[1], coords[2] * TILE_SIZE + offset[2] )
    if count > 0 then
        local checkSprite = gfx.sprite.new(debugTileCheck[2])
        checkTable[#checkTable + 1] = checkSprite
        checkSprite:add()
        checkSprite:moveTo(coords[1] * TILE_SIZE + offset[1], coords[2] * TILE_SIZE + offset[2])

        return false
    else
        local checkSprite = gfx.sprite.new(debugTileCheck[1])
        checkTable[#checkTable + 1] = checkSprite
        checkSprite:add()
        checkSprite:moveTo(coords[1] * TILE_SIZE + offset[1], coords[2] * TILE_SIZE + offset[2])

        return true
    end
end

function ClearTileChecks()
    for i = 1, #checkTable, 1 do
        checkTable[1]:remove()
    end
    checkTable = {}
end

function GenerateWalls(LevelTilemap, path, tilemapSheet)
    local JSONTable = GetJSONData(path)
    local levelarray = {}

    for i = 1, #JSONTable.walls, 1 do
        levelarray[i] = JSONTable.walls[i]
    end

    LevelTilemap:setImageTable(tilemapSheet)
    LevelTilemap:setTiles(levelarray, JSONTable.dimensions[1])
end

function GetJSONData(path)
    local levelData = nil

    local file = playdate.file.open(path)
    if file then
        local size = playdate.file.getSize(path)
        levelData = file:read(size)
        file:close()

        if not levelData then
            print("OOPS... WE FUCKED UP SOMEWHERE... INVALID DATA FROM " .. path)
            return nil
        end
    end

    local JSONTable = json.decode(levelData)

    if not JSONTable then
        print("OOPS... WE FUCKED UP SOMEWHERE... DATA FROM " .. path .. " FAILED TO PARSE")
        return nil
    end

    return JSONTable
end

function ClearLevel(tilemap)
    if piecesTable ~= nil then
        for i = 1, #piecesTable, 1 do
            piecesTable[i]:clearCollideRect()
            piecesTable[i].shadow:remove()
            piecesTable[i].shadow = nil
            piecesTable[i]:remove()
            piecesTable[i] = nil
            print("it should be working")
        end
    else
        print("it's empty you dipshit")
    end

    Board = nil
    tilesprite:clearCollideRect()
    tilemap:setTiles({0, 0}, 1)
    gfx.sprite.addWallSprites(tilemap, {0, 18, 19, 20}, offset[1], offset[2])
    gfx.sprite.removeAll()
    gfx.clear(gfx.kColorBlack)
end

function DrawBoard(path)
    local JSONTable = GetJSONData(path)

    levelDimensions = JSONTable.dimensions
    Board = img.new(levelDimensions[1] * TILE_SIZE, levelDimensions[2] * TILE_SIZE)

    gfx.pushContext(Board)

	 --Array[2] = Y, Array[1] = X

	for i = 0, levelDimensions[2], 1 do
		if i % 2 == 1 then
			for j = 0, levelDimensions[1], 1 do
				if j % 2 == 1 then
					gfx.setColor(gfx.kColorBlack)
                	gfx.fillRect(0 + (TILE_SIZE * j), 0 + (TILE_SIZE * i), TILE_SIZE, TILE_SIZE)
				else
					gfx.setColor(gfx.kColorWhite)
                	gfx.fillRect(0 + (TILE_SIZE * j), 0 + (TILE_SIZE * i), TILE_SIZE, TILE_SIZE)
				end
			end
		else
			for j = 0, levelDimensions[1], 1 do
				if j % 2 == 1 then
					gfx.setColor(gfx.kColorWhite)
                	gfx.fillRect(0 + (TILE_SIZE * j), 0 + (TILE_SIZE * i), TILE_SIZE, TILE_SIZE)
				else
					gfx.setColor(gfx.kColorBlack)
                	gfx.fillRect(0 + (TILE_SIZE * j), 0 + (TILE_SIZE * i), TILE_SIZE, TILE_SIZE)
				end
			end
		end
	end

	gfx.setColor(gfx.kColorWhite)
	gfx.drawRect(0, 0, levelDimensions[1] * TILE_SIZE, levelDimensions [2] * TILE_SIZE)

    gfx.popContext()

	local bg = gfx.sprite.new(Board)
    bg:setZIndex(-1)
	bg:moveTo( 200, 120 )
	bg:add()

	offset = { (400 - (levelDimensions[1] * TILE_SIZE) ) /2 , (240 - (levelDimensions[2] * TILE_SIZE) ) /2 }
end

function SpawnPieces(path)
    local JSONTable = GetJSONData(path)

    if JSONTable ~= nil then
        local pawnTable = JSONTable.pawns[1]
        local knightTable = JSONTable.knights[1]
        local bishopTable = JSONTable.bishops[1]
        local rookTable = JSONTable.rooks[1]
        local queenTable = JSONTable.queens[1]
        local kingTable = JSONTable.king[1]

        if pawnTable ~= nil then
            
            for i = 1, #pawnTable.coords, 1 do
                local newPawn = Piece(PieceType.PAWN, pawnTable.coords[i][1], pawnTable.coords[i][2])
                newPawn:add()
                piecesTable[#piecesTable+1] = newPawn
                newPawn.id = #piecesTable
            end
        else
            print("it's empty bub")
        end
        if knightTable ~= nil then
            for i = 1, #knightTable.coords, 1 do
                local newKnight = Piece(PieceType.KNIGHT, knightTable.coords[i][1], knightTable.coords[i][2])
                newKnight:add()
                piecesTable[#piecesTable+1] = newKnight
                newKnight.id = #piecesTable
            end
        end
        if bishopTable ~= nil then
            for i = 1, #bishopTable.coords, 1 do
                local newBishop = Piece(PieceType.BISHOP, bishopTable.coords[i][1], bishopTable.coords[i][2])
                newBishop:add()
                piecesTable[#piecesTable+1] = newBishop
                newBishop.id = #piecesTable
            end
        end
        if rookTable ~= nil then
            for i = 1, #rookTable.coords, 1 do
                local newRook = Piece(PieceType.ROOK, rookTable.coords[i][1], rookTable.coords[i][2])
                newRook:add()
                piecesTable[#piecesTable+1] = newRook
                newRook.id = #piecesTable
            end
        end
        if queenTable ~= nil then
            for i = 1, #queenTable.coords, 1 do
                local newQueen = Piece(PieceType.QUEEN, queenTable.coords[i][1], queenTable.coords[i][2])
                newQueen:add()
                piecesTable[#piecesTable+1] = newQueen
                newQueen.id = #piecesTable
            end
        end
        if kingTable ~= nil then
            -- THERE CAN ONLY BE ONE!
            local newKing = Piece(PieceType.KING, kingTable.coords[1][1], kingTable.coords[1][2])
            newKing:add()
            piecesTable[#piecesTable+1] = newKing
            newKing.id = #piecesTable
        end
    end
end