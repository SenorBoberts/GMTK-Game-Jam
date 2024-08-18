extends "res://src/tiles/MapManager.gd"

const NUM_STATES = 8 
var type : TILE_TYPES;
var possible_states: Array;
var states_size: int; 
var scaling = 4;

const tile_maps = {
	TILE_TYPES.STRAIGHT_DOWN: preload("res://src/tiles/maps/straight_down.tscn"),
	TILE_TYPES.STRAIGHT_ACROSS: preload("res://src/tiles/maps/straight_across.tscn"),
	TILE_TYPES.LEFT_DOWN: preload("res://src/tiles/maps/left_down.tscn"),
	TILE_TYPES.LEFT_UP: preload("res://src/tiles/maps/left_up.tscn"),
	TILE_TYPES.RIGHT_DOWN: preload("res://src/tiles/maps/right_down.tscn"),
	TILE_TYPES.RIGHT_UP:  preload("res://src/tiles/maps/right_up.tscn"),
	TILE_TYPES.GROUND:  preload("res://src/tiles/maps/ground.tscn")
}

func _ready():
	type = TILE_TYPES.EMPTY
	possible_states = all_states()
	
func all_states():
	var arr = []
	for i in range(1, NUM_STATES):
		arr.append(i)
	states_size = arr.size()
	return arr

func trim_edges(i, j):
	if j == 0:
		possible_states.erase(TILE_TYPES.STRAIGHT_ACROSS)
		possible_states.erase(TILE_TYPES.LEFT_DOWN)
		possible_states.erase(TILE_TYPES.LEFT_UP)
	if j == CANVAS_SIZE - 1:
		possible_states.erase(TILE_TYPES.STRAIGHT_ACROSS)
		possible_states.erase(TILE_TYPES.RIGHT_UP)
		possible_states.erase(TILE_TYPES.RIGHT_DOWN)
	if i == 0:
		possible_states.erase(TILE_TYPES.STRAIGHT_DOWN)
		possible_states.erase(TILE_TYPES.LEFT_UP)
		possible_states.erase(TILE_TYPES.RIGHT_UP)
	if i == CANVAS_SIZE - 1:
		possible_states.erase(TILE_TYPES.STRAIGHT_DOWN)
		possible_states.erase(TILE_TYPES.LEFT_DOWN)
		possible_states.erase(TILE_TYPES.RIGHT_DOWN)
	print(str(i) + " " + str(j) + " " + str(possible_states))

func elim(type, direction):
	var a = VALIDNEIGHBOURS[type][direction]
	#print("Updating")
	#print("Starting" + str(possible_states))
	#print("WITH" + str (a))
	possible_states = intersect(a, possible_states)
	#print(possible_states)

func collapse():
	if possible_states.size() == 1:
		type = 7
		possible_states = []
		states_size = 1000
	elif type == 0:
		# collapse randomly 
		var toss = randi() % possible_states.size() - 1 
		type = possible_states[toss]
		possible_states = [] 
		states_size = 1000
	else: 
		# collapse to t
		possible_states = []
		states_size = 1000
		print("collapsed to " + str(type))
		
func add_tilemap():
		var tm = tile_maps[type].instantiate()
		scale = Vector2(scale.x / 8, scale.y / 8)
		add_child(tm)
	
func set_type(t):
	type = t

func _to_string():
	return str(type)
