class_name Board extends CanvasItem

enum Pieces {
	None = 0,
	King = 1,
	Queen = 2,
	Bishop = 3,
	Rook = 4,
	Knight = 5,
	Pawn = 6,
	
	White = 8,
	Black = 16
}

const fen_key = {
	"K" : (Pieces.White | Pieces.King),
	"Q" : (Pieces.White | Pieces.Queen),
	"B" : (Pieces.White | Pieces.Bishop),
	"N" : (Pieces.White | Pieces.Knight),
	"R" : (Pieces.White | Pieces.Rook),
	"P" : (Pieces.White | Pieces.Pawn), #Transition to black pieces
	"k" : (Pieces.Black | Pieces.King),
	"q" : (Pieces.Black | Pieces.Queen),
	"b" : (Pieces.Black | Pieces.Bishop),
	"n" : (Pieces.Black | Pieces.Knight),
	"r" : (Pieces.Black | Pieces.Rook),
	"p" : (Pieces.Black | Pieces.Pawn)
}

const dists : PackedInt32Array = [0x1c0fc0, 0x380f81, 0x540f42, 0x700f03,
0x8c0ec4, 0xa80e85, 0xc40e46, 0xe00e07,
0x188dc8, 0x389d89, 0x549d4a, 0x709d0b,
0x8c9ccc, 0xa89c8d, 0xc49c4e, 0xc01c0f,
0x150bd0, 0x351b91, 0x552b52, 0x712b13,
0x8d2ad4, 0xa92a95, 0xa4aa56, 0xa02a17,
0x1189d8, 0x319999, 0x51a95a, 0x71b91b,
0x8db8dc, 0x89389d, 0x84b85e, 0x80381f,
0xe07e0, 0x2e17a1, 0x4e2762, 0x6e3723,
0x6dc6e4, 0x6946a5, 0x64c666, 0x604627,
0xa85e8, 0x2a95a9, 0x4aa56a, 0x4a352b,
0x49c4ec, 0x4954ad, 0x44d46e, 0x40542f,
0x703f0, 0x2713b1, 0x26a372, 0x263333,
0x25c2f4, 0x2552b5, 0x24e276, 0x206237,
0x381f8, 0x311b9, 0x2a17a, 0x2313b,
0x1c0fc, 0x150bd, 0xe07e, 0x703f]

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
	
static func color_of_piece(peice):
	if peice == 0: #No peice
		return -1
	if (peice >> 4) & 1: #Black Peice
		return 1
	return 0 #White peice

static func type_of_piece(piece):
	return piece & 7

static func index2vec(index):
	return Vector2(index%8-4, int(index/8)-4)

static func index2pgn(index):
	return "abcdefgh"[index%8] + str(index/8+1)

static func legal_sliding(game : GameState, index):
	const slide_vecs = [1,-8, -1, 8, 9, -7, -9, 7]
	var possibilities = []
	var legals = []
	if type_of_piece(game.board[index]) == Pieces.Rook:
		possibilities = slide_vecs.slice(0, 4) 
	elif type_of_piece(game.board[index]) == Pieces.Bishop:
		possibilities = slide_vecs.slice(4, 8)
	elif type_of_piece(game.board[index]) == Pieces.Queen:
		possibilities = slide_vecs.duplicate()
	
	for i in possibilities:
		for extent in range(9):
			pass

static func Easy(x):
	return -(cos(PI * x) - 1) / 2

static func Ease_size(x):
	return -pow(x-0.5, 4) + 1.0625
