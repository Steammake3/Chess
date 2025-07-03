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

const directions = [7, 9, -7, -9, 8, 1, -8, -1]

static func calc_dists():
	var retval : Array = []
	for y in range(8):
		for x in range(8):
			var cds = []
			var dNESW = [7-y, 7-x, y, x]
			for i in range(4):
				cds.append(min(dNESW[i], dNESW[i-1]))
			cds.append_array(dNESW)
			retval.append(cds)
	return retval

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
	var possibilities = []
	var legals = []
	if type_of_piece(game.board[index]) == Pieces.Bishop:
		possibilities = [7, 9, -7, -9]
	elif type_of_piece(game.board[index]) == Pieces.Rook:
		possibilities = [8, 1, -8, -1]
	elif type_of_piece(game.board[index]) == Pieces.Queen:
		possibilities = directions.duplicate()
	else: return legals
	
	var distos = calc_dists()
	
	for dir in range(len(possibilities)):
		for extent in range(distos[index][directions.find(possibilities[dir])]):
			var target = index + possibilities[dir] * (extent+1)
			if target in game.pindeces:
				if Board.color_of_piece(game.board[target]) != game.turn:
					legals.append(target)
				break
			legals.append(target)
	
	return legals

static func Easy(x):
	return -(cos(PI * x) - 1) / 2

static func Ease_size(x):
	return -pow(x-0.5, 4)*1.2 + 1.0625
