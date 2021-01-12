extends Node2D

const up_rules = [[10, 4], [-1,4],[0,0]]
const down_rules = [[7, 8], [-1,8], [0,0]]
const left_rules = [[10, 10], [-1,10], [0,0]]
const right_rules = [[7, 13], [-1,13], [0,0]]

var grid_size = Vector2(1000,1000)
var grid_scale = 64
var grid_color = Color(1,1,1,0.1)

enum direction {UP, DOWN, LEFT, RIGHT}




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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



func spawn_cell(position):
	var tile_position = position / 64
	print(tile_position)
	$TileMap.set_cellv(tile_position, 1)
	
	for i in direction.values():
		print("yuh")
		match direction.values()[i]:
			direction.UP:
				print("up")
				var up_tile = get_tile_in_dir(tile_position, direction.UP)
				if up_tile != 1:
					$TileMap.set_cellv(Vector2(tile_position.x, tile_position.y - 1), 4)
			direction.DOWN:
				print("down")
				var down_tile = get_tile_in_dir(tile_position, direction.DOWN)
				if down_tile != 1:
					if down_tile != 10:
						if down_tile != 7:
							$TileMap.set_cellv(Vector2(tile_position.x, tile_position.y + 1), 8)
						else:
							$TileMap.set_cellv(Vector2(tile_position.x, tile_position.y + 1), 6)
					else:
						$TileMap.set_cellv(Vector2(tile_position.x, tile_position.y + 1), 9)
			direction.LEFT:
				print("left")
				var left_tile = get_tile_in_dir(tile_position, direction.LEFT)
				if left_tile != 1:
					if left_tile != 4:
						if left_tile != 5:
							$TileMap.set_cellv(Vector2(tile_position.x - 1, tile_position.y), 10)
						else:
							$TileMap.set_cellv(Vector2(tile_position.x - 1, tile_position.y), 2)
					else:
						$TileMap.set_cellv(Vector2(tile_position.x - 1, tile_position.y), 3)
			direction.RIGHT:
				print("right")
				var right_tile = get_tile_in_dir(tile_position, direction.RIGHT)
				
				if right_tile != 1:
					if right_tile != 4:
						if right_tile != 8:
							if right_tile != 7:
								$TileMap.set_cellv(Vector2(tile_position.x + 1, tile_position.y), 7)
							else:
								$TileMap.set_cellv(Vector2(tile_position.x + 1, tile_position.y), 7)
						else:
							$TileMap.set_cellv(Vector2(tile_position.x + 1, tile_position.y), 6)
					else:
						$TileMap.set_cellv(Vector2(tile_position.x + 1, tile_position.y), 5)

func place_cell(position):
	var tile_position = position / 64
	$TileMap.set_cellv(tile_position, 1)
	
	var left_tile = get_tile_in_dir(tile_position, direction.LEFT)
	var right_tile = get_tile_in_dir(tile_position, direction.RIGHT)
	var down_tile = get_tile_in_dir(tile_position, direction.DOWN)
	var up_tile = get_tile_in_dir(tile_position, direction.UP)
	
	
	
	for i in direction.values():
		match direction.values()[i]:
			direction.UP:
				var broken = false
				for x in up_rules:
					print(x)
					if up_tile == x[0] and !broken:
						$TileMap.set_cellv(Vector2(tile_position.x, tile_position.y - 1), x[1])
			direction.DOWN:
				for x in down_rules:
					if down_tile == x[0]:
						tile_index = x[1]
						$TileMap.set_cellv(Vector2(tile_position.x, tile_position.y + 1), x[1])
			direction.LEFT:
				var tile_index = 10
				for x in left_rules:
					if left_tile == x[0]:
						tile_index = x[1]
				$TileMap.set_cellv(Vector2(tile_position.x - 1, tile_position.y), tile_index)
				print(tile_index)
			direction.RIGHT:
				var tile_index = 7
				for x in right_rules:
					if right_tile == x[0]:
						tile_index = x[1]
				print(tile_index)
				$TileMap.set_cellv(Vector2(tile_position.x + 1, tile_position.y), tile_index)

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
