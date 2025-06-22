class_name GameState extends Node

var board : PackedByteArray = []
var turn = 0
var pindeces = [] #Indices where pieces exist
var enpassant_index = -1 #-1 if none
var cancastle : int = 15 #0bABCD - AB White king and queenside respectively, CD are for Black
