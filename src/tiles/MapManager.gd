extends Node2D

var tile = preload("res://src/tiles/tile.tscn")
# Global size of the canvas
const CANVAS_SIZE = 9
# Global nodes array
var nodes: Array;

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
	# add random grounds
	#add_random_tiles()
	# print progress
	pretty_print_grid()
	
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

func update_nodes(x, y, t):
	var a = ANCHORS[t]
	if a[0] == 1 and x - 1 >= 0:
		nodes[x - 1][y].elim(a, 1)
	if a[1] == 1 and x + 1 < CANVAS_SIZE: 
		nodes[x + 1][y].elim(a, 0)
	if a[2] == 1 and y + 1 < CANVAS_SIZE:
		nodes[x][y + 1].elim(a, 2)
	if a[3] == 1 and y - 1 >= 0:
		nodes[x][y - 1].elim(a, 3)
	
#func add_random_tiles():
#	for i in range(1, CANVAS_SIZE):
#		for j in CANVAS_SIZE:
#			var flip = randi() % 8
#			if flip == 1:
#				newTile(i, j)
				
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
