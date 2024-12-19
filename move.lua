class('Move').extends()

function Move:init(StartPos, EndPos, PieceID)
    self.startpos = StartPos
    self.endpos = EndPos
    self.piece = PieceID
end
