extends Node2D

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
	var tile_position = $TileMap.world_to_map(position - $TileMap.position)
	print(tile_position)
	$TileMap.set_cellv(tile_position, 1)
	
	for i in direction:
		var tile = 2
		if get_tile_in_dir(tile_position, i) != $TileMap.INVALID_CELL:
			match i:
				direction.UP:
					#$TileMap.set_cell(tile_position.x, )
					pass

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
		spawn_cell(get_global_mouse_position())
