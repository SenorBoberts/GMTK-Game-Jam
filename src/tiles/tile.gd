extends "res://src/tiles/MapManager.gd"

const NUM_STATES = 8
# array holding the achor values for each direction
# UP, DOWN, LEFT, RIGHT 
var achors = [0, 0, 0, 0];
var type : TILE_TYPES;
var possible_states: Array;

func _ready():
	type = TILE_TYPES.EMPTY
	possible_states = all_states()
	
func all_states():
	var arr = []
	for i in range(1, NUM_STATES):
		arr.append(i)
	return arr

func elim(direction):
	for t in range(1, possible_states.size()):
		var a2 = ANCHORS[t]
		if direction == 0 and a2[0] != 1:
			possible_states.erase(t)
		if direction == 1 and a2[1] != 1:
			possible_states.erase(t)
		if direction == 2 and a2[3] != 1:
			possible_states.erase(t)
		if direction == 3 and a2[2] != 1:
			possible_states.erase(t)	
		

func collapse():
	if type == 0:
		# collapse randomly 
		var toss = randi() % possible_states.size()
		type = possible_states[toss]
		possible_states = [] 
	else: 
		# collapse to t
		possible_states = []
		print("collapsed to " + str(type))
	
func set_type(t):
	type = t

func _to_string():
	return str(type)
