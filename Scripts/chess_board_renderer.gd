@tool
extends Node2D

@export var tile_size := 30;
@export var motion := 0.829;
@export_color_no_alpha var light = Color.WHITE
@export_color_no_alpha var dark = Color.DARK_GREEN

const WK = preload("res://Pieces/white/king.png")
const WQ = preload("res://Pieces/white/queen.png")
const WB = preload("res://Pieces/white/bishop.png")
const WN = preload("res://Pieces/white/knight.png")
const WR = preload("res://Pieces/white/rook.png")
const WP = preload("res://Pieces/white/pawn.png")
#Now the black pieces
const BK = preload("res://Pieces/black/king.png")
const BQ = preload("res://Pieces/black/queen.png")
const BB = preload("res://Pieces/black/bishop.png")
const BN = preload("res://Pieces/black/knight.png")
const BR = preload("res://Pieces/black/rook.png")
const BP = preload("res://Pieces/black/pawn.png")

const PressStart2P = preload("res://PressStart2P-Regular.ttf")

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

const texture_mapping = {
	Pieces.WKing : WK,
	Pieces.WQueen : WQ,
	Pieces.WBishop : WB,
	Pieces.WKnight : WN,
	Pieces.WRook : WR,
	Pieces.WPawn : WP, #Now the black pieces
	Pieces.BKing : BK,
	Pieces.BQueen : BQ,
	Pieces.BBishop : BB,
	Pieces.BKnight : BN,
	Pieces.BRook : BR,
	Pieces.BPawn : BP
}

var game : GameState
var selsq : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game = GameState.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")

func _draw() -> void:
	var posi = get_index_of_mouse(get_global_mouse_position())
	var to_draw = game.board
	draw_board()
	draw_pieces(to_draw)
	if (posi+1): draw_chess_sq(Board.index2vec(posi).x, Board.index2vec(posi).y, tile_size, 0, Color(1, 0, 0, 0.4))
	if (selsq+1): draw_chess_sq(Board.index2vec(selsq).x, Board.index2vec(selsq).y, tile_size, 0, Color(1, 0.6, 0, 0.4))
	var z = str(posi) if posi>=0 else "Nope"
	draw_string(PressStart2P, Vector2(-900, 350), z, 0, -1, 60, Color.ORANGE)
	draw_multiline_string(PressStart2P, Vector2(650, 0), (" Black" if game.turn else " White") + "\nto play", 1, -1, 60, 2, Color.WEB_PURPLE)
	
	for i in game.pindeces:
		draw_chess_sq(Board.index2vec(i).x, Board.index2vec(i).y, tile_size, 0, Color(0.5, 0, 0.2, 0.4))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func draw_board():
	var _debug = ["a", "b", "c", "d", "e", "f", "g", "h"]
	var offset = 4 * tile_size
	for i in range(8):
		for j in range(8):
			draw_chess_sq(i,j,tile_size,offset,light if (i+j)%2 else dark)
			#draw_string(ThemeDB.fallback_font, Vector2(i*tile_size-offset*motion, -j*tile_size+offset*motion), debug[i]+str(j+1), 0, -1, 32, Color.YELLOW)
			draw_string(PressStart2P, Vector2(i*tile_size-offset*motion, -j*tile_size+offset*motion), str(i+8*j), 0, -1, 32, Color.YELLOW)

func draw_pieces(pieces):
	var offset = 4 * tile_size
	for i in range(8):
		for j in range(8):
			if pieces[8*j+i] == Pieces.None: continue
			draw_texture_rect(texture_mapping[pieces[8*j+i]], Rect2(Vector2(i*tile_size-offset, -(j+1)*tile_size+offset), Vector2(tile_size, tile_size)), false)

func draw_chess_sq(x,y,sz,offset,col):
	draw_rect(Rect2(Vector2(x*sz-offset, -y*sz+offset), Vector2(sz, -sz)), col)

func _input(event):
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				var pos = get_index_of_mouse(get_global_mouse_position())
				if selsq == -1:
					if Board.color_of_piece(game.board[pos]) == game.turn:
						selsq = pos
				elif pos==-1:
					selsq = -1
				elif pos==selsq:
					selsq = -1
				elif selsq != pos:
					if Board.color_of_piece(game.board[selsq]) == game.turn and Board.color_of_piece(game.board[pos]) != game.turn:
						game.playmove(selsq, pos, false)
						selsq = -1
					elif Board.color_of_piece(game.board[pos]) == game.turn:
						selsq = pos

func get_index_of_mouse(pos):
	var mx = int(floor(pos.x/tile_size+4))
	var my = int(floor(-pos.y/tile_size+4))
	if mx in range(8) and my in range(8):
		return my*8+mx
	return -1
