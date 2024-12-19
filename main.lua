import "CoreLibs/animation"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/math"

-- OBJECT CLASSES
import "levelgen"

TILE_SIZE = 30
PieceType =  {
    PAWN = 1,
    KNIGHT = 2,
    BISHOP = 3,
    ROOK = 4,
    QUEEN = 5,
    KING = 6
}

local gfx = playdate.graphics
local anim = gfx.animation.loop
local img = gfx.image
local imgTbl = gfx.imagetable

score = 0
moveCounter = 0

local levelmap = gfx.tilemap.new() 

pieces_spritesheet = gfx.imagetable.new("sprites/temp/chess-chars")
isAPieceSelected = false

levelDimensions = nil --levelgen will fill this in don't worry your sweet little head 
coords = {1, 1}
offset = {0, 0}
piecesTable = {}
selectedPieceID = nil
local cursor_spritesheet = imgTbl.new("cursor")
local cursor_anim = gfx.animation.loop.new(50, cursor_spritesheet, true)
local cursor = gfx.sprite.new()

shadowSprite = img.new("sprites/temp/shadow")

local test_tilemap = imgTbl.new("sprites/temp/wall-placeholder")
tilesprite = gfx.sprite.new()


function gfx.setBackgroundDrawingCallback()
	DrawBoard("levels/testlevel.json")
end

local function Cursor_NoPiece()
	cursor:setImage(cursor_anim:image())

	if playdate.buttonJustPressed(playdate.kButtonUp) then
		if coords[2] <= 1 then
			coords[2] = levelDimensions[2]
		else
			coords[2] -= 1
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		if coords[2] >= levelDimensions[2] then
			coords[2] = 1
		else
			coords[2] += 1
		end
	end

	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		if coords[1] <= 1  then
			coords[1] = levelDimensions[1]
		else
			coords[1] -= 1
		end
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		if coords[1] >= levelDimensions[1] then
			coords[1] = 1
		else
			coords[1] += 1
		end
	end

	cursor:moveTo(coords[1] * TILE_SIZE + offset[1], coords[2] * TILE_SIZE + offset[2])
end

local function Cursor_WithPiece()
	cursor:setImage(cursor_anim:image())

	if piecesTable[selectedPieceID].piecetype == PieceType.PAWN or piecesTable[selectedPieceID].piecetype == PieceType.ROOK then
		if selectedPiecePosition[1] == coords[1] then
			if playdate.buttonJustPressed(playdate.kButtonUp) then
				if coords[2] <= movementRange[1] or coords[2] <= 1 then
					--do nothing
				else
					coords[2] -= 1
				end
			elseif playdate.buttonJustPressed(playdate.kButtonDown) then
				if coords[2] >= movementRange[2] or coords[2] >= levelDimensions[2] then
					--do nothing
				else
					coords[2] += 1
				end
			end
		end

		if selectedPiecePosition[2] == coords[2] then
			if playdate.buttonJustPressed(playdate.kButtonLeft) then
				if coords[1] <= movementRange[3] or coords[1] <= 1 then
					--do nothing
				else
					coords[1] -= 1
				end
		elseif playdate.buttonJustPressed(playdate.kButtonRight) then
			if coords[1] >= movementRange[4] or coords[1] >= levelDimensions[1] then
				--do nothing
			else
				coords[1] += 1
			end
		end
		end
	elseif piecesTable[selectedPieceID].piecetype == PieceType.BISHOP then
		 
	end

	cursor:moveTo(coords[1] * TILE_SIZE + offset[1], coords[2] * TILE_SIZE + offset[2])
end


local function loadGame(path)
	playdate.display.setRefreshRate(24)
	gfx.setBackgroundColor(gfx.kColorBlack)
	gfx.clear(gfx.kColorBlack)
	gfx.setBackgroundDrawingCallback()

	cursor:setImage(cursor_anim:image())
	cursor:add()
	cursor:setZIndex(1)
	cursor:moveTo(coords[1] * TILE_SIZE + offset[1], coords[2] * TILE_SIZE + offset[2])
	cursor:setCenter(31/32, 31/32)

	--ClearLevel()
	GenerateWalls(levelmap, path, test_tilemap)
	gfx.sprite.addWallSprites(levelmap, {0, 18, 19, 20}, offset[1], offset[2])
	tilesprite:setTilemap(levelmap)
	tilesprite:setZIndex(0)
	tilesprite:setCenter(0,0)
	tilesprite:moveTo(offset[1], offset[2])
	tilesprite:add()
	SpawnPieces(path)
	print(#piecesTable)


end

local function updateGame()
	if isAPieceSelected then
		Cursor_WithPiece()
	else
		Cursor_NoPiece()
	end

	if playdate.buttonJustPressed(playdate.kButtonB) then
		ClearLevel(levelmap)
	end
end

local function drawGame()
	
	gfx.sprite.update()
end

loadGame("levels/testlevel.json")

-- PLAYDATE CALLS HERE

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0,0) -- FPS widget
end 