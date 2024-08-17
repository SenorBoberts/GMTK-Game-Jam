extends "res://src/tiles/MapManager.gd"

const NUM_STATES = 8 
var type : TILE_TYPES;
var possible_states: Array;
var states_size: int; 

func _ready():
	type = TILE_TYPES.EMPTY
	possible_states = all_states()
	
func all_states():
	var arr = []
	for i in range(1, NUM_STATES):
		arr.append(i)
	states_size = arr.size()
	return arr

#REWRITE THIS SHIT
func elim(direction):
	for t in range(1, possible_states.size()):
		var a2 = ANCHORS[t]
		if direction == 0 and a2[0] != 1:
			possible_states.erase(t)
			states_size -= 1
		if direction == 1 and a2[1] != 1:
			possible_states.erase(t)
			states_size -= 1
		if direction == 2 and a2[3] != 1:
			possible_states.erase(t)
			states_size -= 1
		if direction == 3 and a2[2] != 1:
			possible_states.erase(t)
			states_size -= 1
		

func collapse():
	if type == 0:
		# collapse randomly 
		var toss = randi() % possible_states.size()
		type = possible_states[toss]
		possible_states = [] 
		states_size = 1000
	else: 
		# collapse to t
		possible_states = []
		states_size = 1000
		print("collapsed to " + str(type))
	
func set_type(t):
	type = t

func _to_string():
	return str(type)
