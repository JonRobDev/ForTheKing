local gfx = playdate.graphics
local anim = gfx.animation.loop
local imgTbl = gfx.imagetable

class('Cursor').extends(gfx.sprite)

local cursor_spritesheet = imgTbl.new("cursor")
local cursor_anim = gfx.animation.loop.new(50, cursor_spritesheet, true)

function Cursor:init()
    Cursor.super.init(self)
    self.coords = {1, 1}
    self:setImage(cursor_anim:image())
end

function Cursor:Move_NoPiece()
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