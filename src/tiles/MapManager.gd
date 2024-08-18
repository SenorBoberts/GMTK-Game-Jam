extends Node2D

var tile = preload("res://src/tiles/tile.tscn")
# Global size of the canvas
const CANVAS_SIZE = 3
# Global nodes array
var nodes: Array;
# Number of tiles filled in 
var tiles_filled = 0

enum TILE_TYPES {
	EMPTY, 
	STRAIGHT_DOWN, # 1
	STRAIGHT_ACROSS, # 2
	LEFT_DOWN, # 3
	LEFT_UP, # 4
	RIGHT_DOWN, # 5
	RIGHT_UP, # 6
	GROUND, # 7
} 

const vertical_dict = {
	"NORTH": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.LEFT_DOWN, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.GROUND],
	"SOUTH": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"EAST": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.GROUND],
	"WEST": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND]
}

const horizontal_dict = {
	"NORTH": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"SOUTH": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.GROUND],
	"EAST": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.GROUND],
	"WEST": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND]
}

const left_down_dict = {
	"NORTH": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"SOUTH": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"EAST": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"WEST": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND]
}

const left_up_dict = {
	"NORTH": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.LEFT_DOWN, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.GROUND],
	"SOUTH": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.GROUND],
	"EAST": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"WEST": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND]
}

const right_down_dict = {
	"NORTH": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"SOUTH": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"EAST": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.GROUND],
	"WEST": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.GROUND]
}

const right_up_dict = {
	"NORTH": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.LEFT_DOWN, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.GROUND],
	"SOUTH": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.GROUND],
	"EAST": [TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.GROUND],
	"WEST": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.GROUND]
}

const ground_dict = {
	"NORTH": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"SOUTH": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"EAST": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
	"WEST": [TILE_TYPES.STRAIGHT_DOWN, TILE_TYPES.STRAIGHT_ACROSS, TILE_TYPES.LEFT_DOWN, TILE_TYPES.LEFT_UP, TILE_TYPES.RIGHT_DOWN, TILE_TYPES.RIGHT_UP, TILE_TYPES.GROUND],
}

const VALIDNEIGHBOURS = {
	TILE_TYPES.STRAIGHT_DOWN: vertical_dict,
	TILE_TYPES.STRAIGHT_ACROSS: horizontal_dict,
	TILE_TYPES.LEFT_DOWN: left_down_dict, 
	TILE_TYPES.LEFT_UP: left_up_dict, 
	TILE_TYPES.RIGHT_DOWN: right_down_dict,
	TILE_TYPES.RIGHT_UP: right_up_dict,  
	TILE_TYPES.GROUND: ground_dict
}

func _ready():
	# get empty grid of nulls
	generate_empty_grid()
	# Add entrence and exit
	add_entrance_and_exit()
	# Iterate
	#test_iter()
	iteration()
	# Print Grid
	pretty_print_grid()
	# Turn into tiles
	
func generate_empty_grid():
	for i in CANVAS_SIZE:
		nodes.append([])
		for j in CANVAS_SIZE:
			var curTile = newEmptyTile()
			curTile.trim_edges(i, j)
			curTile.position = Vector2(i * 80, j * 80)
			nodes[i].append(curTile)

func add_entrance_and_exit():
	nodes[0][0].set_type(1)
	nodes[0][0].collapse()
	nodes[0][0].add_tilemap()
	update_nodes(0, 0, 1)
	nodes[CANVAS_SIZE - 1][CANVAS_SIZE - 1].set_type(1)
	nodes[CANVAS_SIZE - 1][CANVAS_SIZE - 1].collapse()
	nodes[CANVAS_SIZE - 1][CANVAS_SIZE - 1].add_tilemap()
	update_nodes(CANVAS_SIZE - 1, CANVAS_SIZE - 1, 1)
	tiles_filled += 2
	
func test_iter():
	var li = 1
	var lj = 0
	var n = nodes[li][lj]
	print(n.possible_states)
	n.collapse()
	update_nodes(li, lj, n.type)
	tiles_filled += 1 
	li = 2
	lj = 0
	n = nodes[li][lj]
	print(n.possible_states)
	#n.collapse()
	#update_nodes(li, lj, n.type)
	#tiles_filled += 1 

func iteration():
	while tiles_filled < CANVAS_SIZE**2:
		var lowest = find_lowest()
		var li = lowest[0]
		var lj = lowest[1]
		print(str(li) + " " + str(lj))
		var n = nodes[li][lj]
		n.collapse()
		n.add_tilemap()
		update_nodes(li, lj, n.type)
		tiles_filled += 1 

func find_lowest():
	var lowest_i = 0
	var lowest_j = 0 
	for i in CANVAS_SIZE:
		for j in CANVAS_SIZE:
			if nodes[i][j].type == 0 and nodes[i][j].states_size < nodes[lowest_i][lowest_j].states_size:
				lowest_i = i 
				lowest_j = j 
	return [lowest_i, lowest_j]

func update_nodes(x, y, t):
	if x - 1 >= 0:
		nodes[x - 1][y].elim(t, "NORTH")
	if x + 1 < CANVAS_SIZE: 
		nodes[x + 1][y].elim(t, "SOUTH")
	if y + 1 < CANVAS_SIZE:
		nodes[x][y + 1].elim(t, "EAST")
	if y - 1 >= 0:
		nodes[x][y - 1].elim(t, "WEST")

func newEmptyTile():
	var curTile = tile.instantiate()
	add_child(curTile)
	return curTile
	
func intersect(a, b):
	var arr = []
	for state in a:
		if state in b:
			arr.append(state)
	return arr
	
func pretty_print_grid():
	for i in CANVAS_SIZE:
		var str = ""
		for j in CANVAS_SIZE:
			str += str(nodes[i][j]) + " "
		print(str) 
