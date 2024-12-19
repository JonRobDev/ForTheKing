import "CoreLibs/animation"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/math"

local gfx = playdate.graphics
local anim = gfx.animation.loop
local img = gfx.image
local imgTbl = gfx.imagetable

-- OBJECTS
import "levelgen"
import "cursor"
import "move"

-- STATIC
TILE_SIZE = 30
PIECETYPE = {
    PAWN = 1,
    KNIGHT = 2,
    BISHOP = 3,
    ROOK = 4,
    QUEEN = 5,
    KING = 6
}

-- GLOBALS
moveCnt = 0
score = 0

levelDimensions = nil
offset = {0, 0}
piecesTable = {}
moveStack = {}

pieces_spritesheet = gfx.imagetable.new("sprites/temp/chess-chars")
shadowSprite = img.new("sprites/temp/shadow")
isAPieceSelected = false
tilesprite = gfx.sprite.new()
--

local test_tilemap = imgTbl.new("sprites/temp/wall-placeholder")
local cursor = Cursor()

function gfx.setBackgroundDrawingCallback()
	DrawBoard("levels/testlevel.json")
end

local function loadGame(path)
	playdate.display.setRefreshRate(24)
	gfx.setBackgroundColor(gfx.kColorBlack)
	gfx.clear(gfx.kColorBlack)
	gfx.setBackgroundDrawingCallback()

    GenerateWalls(levelmap, path, test_tilemap)
	gfx.sprite.addWallSprites(levelmap, {0, 18, 19, 20}, offset[1], offset[2])
	tilesprite:setTilemap(levelmap)
	tilesprite:setZIndex(0)
	tilesprite:setCenter(0,0)
	tilesprite:moveTo(offset[1], offset[2])
	tilesprite:add()
	SpawnPieces(path)
end

local function updateGame()

end

local function drawGame()
    playdate.drawFPS(0,0)
    gfx.sprite.update()
end

function playdate.update()
    updateGame()
	drawGame()
end