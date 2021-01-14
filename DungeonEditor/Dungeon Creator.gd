extends Node2D

const up_rules = [[0,0], [-1, 4], [7, 5], [13, 2], [12, 27], [10, 3], [7, 5], [6, 30], [8, 28], [9,29]]
const down_rules = [[0,0], [-1, 8], [10,9], [7,6], [4, 28], [5, 30], [3, 29], [2, 27], [13, 12]]
const left_rules = [[0,0], [-1, 10], [4, 3], [7, 13], [5, 2], [8, 9], [6, 12], [28, 29]]
const right_rules = [[0,0], [-1, 7], [4, 5], [10, 13], [9, 12], [8, 6], [29, 27], [3, 2], [28, 30]]

var grid_size = Vector2(1000,1000)
var grid_scale = 64
var grid_color = Color(1,1,1,0.1)

enum direction {UP, DOWN, LEFT, RIGHT}

var cells : PoolVector2Array = []

var data = {
'dat': cells
}

func save():
	# open file
	var file = File.new()
	file.open("user://dungeon01.json", File.WRITE)
	file.store_line(JSON.print(data))

func load_file():
	var file = File.new()
	file.open("user://dungeon01.json", File.READ)
	data = JSON.parse(file.get_line())


func get_tile_in_dir(loc,dir):
	match dir:
		direction.UP:
			return $TileMap.get_cell(loc.x, loc.y - 1)
		direction.DOWN:
			return $TileMap.get_cell(loc.x, loc.y + 1)
		direction.LEFT:
			return $TileMap.get_cell(loc.x - 1, loc.y)
		direction.RIGHT:
			return $TileMap.get_cell(loc.x + 1, loc.y)


func place_cell(position):
	var tile_position = position / 64
	$TileMap.set_cellv(tile_position, 1)
	
	var left_tile = get_tile_in_dir(tile_position, direction.LEFT)
	var right_tile = get_tile_in_dir(tile_position, direction.RIGHT)
	var down_tile = get_tile_in_dir(tile_position, direction.DOWN)
	var up_tile = get_tile_in_dir(tile_position, direction.UP)
	
	var up_index = 0
	var down_index = 0
	var left_index = 0
	var right_index = 0
	
	for i in direction.values():
		match direction.values()[i]:
			direction.UP:
				for rule in up_rules:
					if rule[0] == up_tile:
						up_index = rule[1]
						print(up_index)
				if up_index != 0:
					$TileMap.set_cellv(Vector2(tile_position.x, tile_position.y - 1), up_index)
			direction.DOWN:
				for rule in down_rules:
					if rule[0] == down_tile:
						down_index = rule[1]
				if down_index != 0:
					$TileMap.set_cellv(Vector2(tile_position.x, tile_position.y + 1), down_index)
				
			direction.LEFT:
				for rule in left_rules:
						if rule[0] == left_tile:
							left_index = rule[1]
				if left_index != 0:
					$TileMap.set_cellv(Vector2(tile_position.x - 1, tile_position.y), left_index)
			direction.RIGHT:
				for rule in right_rules:
						if rule[0] == right_tile:
							right_index = rule[1]
				if right_index != 0:
					$TileMap.set_cellv(Vector2(tile_position.x + 1, tile_position.y), right_index)
	
	cells.append(position)


func _draw():
	for x in range(0, grid_size.x):
		draw_line(Vector2(x-grid_size.x/2, grid_size.y/2) * grid_scale, Vector2(x-grid_size.x/2, -(grid_size.y/2)) * grid_scale, grid_color)
	for y in range(0, grid_size.y):
		draw_line(Vector2(grid_size.x/2, y-grid_size.y/2) * grid_scale, Vector2(-(grid_size.x/2), y-grid_size.y/2) * grid_scale, grid_color)

func _process(_delta):
	var relative_mouse_postition = get_global_mouse_position() - position
	
	$Sprite.position = Vector2(stepify(relative_mouse_postition.x, 64), stepify(relative_mouse_postition.y, 64))
	


func _input(event):
	if Input.is_action_just_pressed("Click"):
		place_cell($Sprite.position)
