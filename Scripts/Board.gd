class_name Board extends CanvasItem

var ts = 0

enum Pieces {
	None = 0,
	WKing = 1,
	WQueen = 2,
	WBishop = 3,
	WRook = 4,
	WKnight = 5,
	WPawn = 6,
	BKing = 9,
	BQueen = 10,
	BBishop = 11,
	BRook = 12,
	BKnight = 13,
	BPawn = 14
}

const fen_key = {
	"K" : Pieces.WKing,
	"Q" : Pieces.WQueen,
	"B" : Pieces.WBishop,
	"R" : Pieces.WRook,
	"N" : Pieces.WKnight,
	"P" : Pieces.WPawn, #Transition to black pieces
	"k" : Pieces.BKing,
	"q" : Pieces.BQueen,
	"b" : Pieces.BBishop,
	"r" : Pieces.BRook,
	"n" : Pieces.BKnight,
	"p" : Pieces.BPawn
}

static func fen_loader(fen):
	var board = Array()
	var lines = fen.split("/")
	for line in lines:
		var newline = PackedByteArray()
		for char_ in line:
			if char_.is_valid_int():
				for i in range(int(char_)): newline.append(Pieces.None)
			else:
				newline.append(fen_key[char_])
		board.append(newline)
	board.reverse()
	var f : PackedByteArray = []
	for t in board: f.append_array(t)
	return f
	
func get_index_of_mouse(pos, ts):
	var mx = int(floor(pos.x/ts+4))
	var my = int(floor(-pos.y/ts+4))
	if mx in range(8) and my in range(8):
		return my*8+mx
	return -1
