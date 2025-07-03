@tool
extends Node2D

@export var tile_size := 140;
@export var motion := 0.854;
@export var speed : int = 1.5;
@export_color_no_alpha var light = Color("97bbd7")
@export_color_no_alpha var dark = Color("3f7247")

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
const legal = preload("res://Pieces/legal.png")

const PressStart2P = preload("res://PressStart2P-Regular.ttf")

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

const texture_mapping = {
	9 : WK,
	10 : WQ,
	11 : WB,
	12 : WR,
	13 : WN,
	14 : WP, #Now the black pieces
	17 : BK,
	18 : BQ,
	19 : BB,
	20 : BR,
	21 : BN,
	22 : BP
}

var game : GameState
var selsq : int = -1
var moving : float = -1
var current_move := [-1, -1, false]
var moving_piece : int = Pieces.Pawn | Pieces.Black

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game = GameState.new("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
	#game = GameState.new("5R1k/4B3/8/8/1q6/8/7K/8 w - - 0 1")

func _draw() -> void:
	var posi = get_index_of_mouse(get_global_mouse_position())
	var to_draw : PackedByteArray = game.dupe().board
	if moving > -1:
		moving_piece = game.board[current_move[0]]
		to_draw[current_move[0]] = Pieces.None
		if moving >= 0.9:
			to_draw[current_move[1]] = Pieces.None
	
	draw_board()
	
	if (posi+1): draw_chess_sq(Board.index2vec(posi).x, Board.index2vec(posi).y, tile_size, 0, Color(1, 0, 0, 0.4))
	if (selsq+1): draw_chess_sq(Board.index2vec(selsq).x, Board.index2vec(selsq).y, tile_size, 0, Color(1, 0.6, 0, 0.4))
	
	var z = Board.index2pgn(posi) if posi>=0 else "Nope"
	draw_string(PressStart2P, Vector2(-900, 350), z, 0, -1, 60, Color.ORANGE)
	draw_multiline_string(PressStart2P, Vector2(650, 0), (" Black" if game.turn else " White") + "\nto play", 1, -1, 60, 2, Color.WEB_PURPLE)
	
	for i in game.pindeces:
		draw_chess_sq(Board.index2vec(i).x, Board.index2vec(i).y, tile_size, 0, Color(0.5, 0, 0.2, 0.4))
	
	if selsq != -1:
		for move in Board.legal_sliding(game, selsq): 
			var p = Board.index2vec(move)
			draw_chess_sq(p.x,p.y,tile_size,0,Color(0, 0.9, 0, 0.7))
	
	draw_pieces(to_draw)
	
	if moving >= 1:
		moving = -1
		game.playmove(current_move[0], current_move[1], current_move[2])
	elif moving > -1:
		var p = lerp(Board.index2vec(current_move[0]), Board.index2vec(current_move[1]), Board.Easy(moving))
		draw_texture_rect(texture_mapping[moving_piece], Rect2(Vector2(p.x*tile_size, -(p.y+1)*tile_size), Vector2(tile_size, tile_size)*Board.Ease_size(moving)), false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moving += delta*speed
	if moving < 0: moving = -1
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
			if pieces[8*j+i] in texture_mapping.keys():
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
						current_move = [selsq, pos, false]
						moving = 0.01
						#game.playmove(selsq, pos, false)
						selsq = -1
					elif Board.color_of_piece(game.board[pos]) == game.turn:
						selsq = pos

func get_index_of_mouse(pos):
	var mx = int(floor(pos.x/tile_size+4))
	var my = int(floor(-pos.y/tile_size+4))
	if mx in range(8) and my in range(8):
		return my*8+mx
	return -1
