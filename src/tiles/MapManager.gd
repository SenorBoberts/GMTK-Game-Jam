extends Node2D

var tile = preload("res://src/tiles/tile.tscn")
# Global size of the canvas
const CANVAS_SIZE = 9

var nodes: Array; 

func _ready():
	# get empty grid of nulls
	generate_empty_grid()
	# add random grounds
	var curTile = tile.instantiate()
	curTile.position = Vector2(0 * 80, 0 * 80)
	add_child(curTile)
	nodes[0][0] = curTile
	add_random_tiles()
	# print progress
	pretty_print_grid()
	
func generate_empty_grid():
	for i in CANVAS_SIZE:
		nodes.append([])
		for j in CANVAS_SIZE:
			nodes[i].append(null)
	
func add_random_tiles():
	for i in range(1, CANVAS_SIZE):
		for j in CANVAS_SIZE:
			var flip = randi() % 8
			if flip == 1:
				newTile(i, j)
				
func newTile(x, y):
	var curTile = tile.instantiate()
	curTile.position = Vector2(x * 80, y * 80)
	add_child(curTile)
	nodes[x][y] = curTile
	
	
func pretty_print_grid():
	for i in CANVAS_SIZE:
		var str = ""
		for j in CANVAS_SIZE:
			str += str(nodes[i][j]) + " "
		print(str) 
