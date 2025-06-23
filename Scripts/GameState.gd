class_name GameState extends Node

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

var board : PackedByteArray = []
var turn : int = 0
var pindeces : PackedByteArray = [] #Indices where pieces exist
var enpassant_index : int = -1 #-1 if none
var cancastle : int = 15 #0bABCD - AB White king and queenside respectively, CD are for Black

func _init(fen : String):
	var parts = fen.split(" ") #Get Fields
	
	board = Board.fen_loader(parts[0]) #Get Board
	
	turn = int(parts[1] == "b") #Whose turn
	#Next is castling rights
	if parts[2] == "-":
		cancastle = 0
	else: #This is just bitwise stuff, 
		cancastle = (int(parts[2].contains("K")) << 3) | \
		(int(parts[2].contains("Q")) << 2) | \
		(int(parts[2].contains("k")) << 1) | \
		int(parts[2].contains("q"))
	#Now for EN PASSANT
	if parts[3] == "-": enpassant_index = -1
	else:
		enpassant_index = "abcdefgh".find(parts[3][0])*8+int(parts[3][1])-1
	#Piece Indices
	for i in range(64):
		if board[i] != Pieces.None: pindeces.append(i)

func playmove(start,end, isenpassant):
	if not isenpassant:
		if end not in pindeces: pindeces.append(end)
		board[end] = board[start]
		board[start] = Pieces.None
		pindeces.remove_at(pindeces.find(start))
	turn = 1 - turn

func dupe():
	var new1 : GameState = GameState.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
	new1.board = self.board
	new1.turn = self.turn
	new1.pindeces = self.pindeces
	new1.enpassant_index = self.enpassant_index
	new1.cancastle = self.cancastle
	return new1
