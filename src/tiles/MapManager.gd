extends Node2D

var tile = preload("res://src/tiles/tile.tscn")
# Global size of the canvas
const CANVAS_SIZE = 9
# Global nodes array
var nodes: Array;
# Number of tiles filled in 
var tiles_filled = 0

enum TILE_TYPES {
	EMPTY, 
	STRAIGHT_DOWN,
	STRAIGHT_ACROSS, 
	LEFT_DOWN, 
	LEFT_UP, 
	RIGHT_DOWN, 
	RIGHT_UP, 
	GROUND,
} 

# Anchors for the tile types above (N, S, E, W)
const ANCHORS = [
	null, 
	[1, 1, 0, 0], 
	[0, 0, 1, 1], 
	[0, 1, 0, 1], 
	[1, 0, 0, 1], 
	[0, 1, 1, 0],
	[1, 0, 1, 0],
	[1, 1, 1, 1]
]

func _ready():
	# get empty grid of nulls
	generate_empty_grid()
	# Add entrence and exit
	add_entrance_and_exit()
	# Iterate
	iteration()
	# Print Grid
	pretty_print_grid()
	# Turn into tiles
	
func generate_empty_grid():
	for i in CANVAS_SIZE:
		nodes.append([])
		for j in CANVAS_SIZE:
			var curTile = newEmptyTile()
			nodes[i].append(curTile)

func add_entrance_and_exit():
	nodes[0][0].set_type(1)
	nodes[0][0].collapse()
	update_nodes(0, 0, 1)
	nodes[CANVAS_SIZE - 1][CANVAS_SIZE - 1].set_type(1)
	nodes[CANVAS_SIZE - 1][CANVAS_SIZE - 1].collapse()
	update_nodes(CANVAS_SIZE - 1, CANVAS_SIZE - 1, 1)
	tiles_filled += 2

func iteration():
	while tiles_filled < CANVAS_SIZE**2:
		var lowest = find_lowest()
		var li = lowest[0]
		var lj = lowest[1]
		#print(str(li) + " " + str(lj))
		var n = nodes[li][lj]
		n.collapse()
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

# REWRITE THIS SHIT
func update_nodes(x, y, t):
	var a = ANCHORS[t]
	if a[0] == 1 and x - 1 >= 0:
		nodes[x - 1][y].elim(1)
	if a[1] == 1 and x + 1 < CANVAS_SIZE: 
		nodes[x + 1][y].elim(0)
	if a[2] == 1 and y + 1 < CANVAS_SIZE:
		nodes[x][y + 1].elim(2)
	if a[3] == 1 and y - 1 >= 0:
		nodes[x][y - 1].elim(3)
				
func newEmptyTile():
	var curTile = tile.instantiate()
	add_child(curTile)
	return curTile
	
	
func pretty_print_grid():
	for i in CANVAS_SIZE:
		var str = ""
		for j in CANVAS_SIZE:
			str += str(nodes[i][j]) + " "
		print(str) 
