extends Node2D

onready var tilemap : TileMap = get_node("TileMap")
onready var camera : Camera2D = get_node("Camera2D")
var speed = 300

enum direction {up = 0, down = 1, left = 3, right = 4}

var xmargin = 15
var ymargin = 5

var walls : PoolVector3Array = []
var tile_size = 32

export var hull_curve : Curve

func _ready():
	pass

func clear_grid():
	for i in tilemap.get_used_cells():
		tilemap.set_cellv(i, -1)
	
onready var xsize = int($Control/XSize.text)
onready var ysize = int($Control/YSize.text)

func generate_ship():
	clear_grid()
	xsize = int($Control/XSize.text)
	ysize = int($Control/YSize.text)
	var hull_height = int($Control/Hull_Height.text)
	for x in range(xsize):
		for y in range(ysize):
			tilemap.set_cell(xmargin + x, ymargin + y,0)
	for y in range(hull_height):
		for x in range(xsize):
			
			var hull_interp = hull_curve.interpolate(float(x+1)/float(xsize+1))
			var y_intercept = (float(y)/float(hull_height))
			
			if y_intercept < hull_interp:
				tilemap.set_cell((xmargin) + x, ymargin - y, 0)


func generate_walls():
	walls.resize(0)
	var last = []
	for i in range(int(xsize/2)):
		var rand = int(rand_range(2,6))
		last.append(rand)
		draw_wall(Vector2(i*tile_size + ((xmargin)*tile_size), (ymargin + ysize - rand) * tile_size), direction.up)
	for i in range(last.size()):
		draw_wall(Vector2((xsize / 2 + i) * tile_size + ((xmargin)*tile_size), (ymargin + ysize - last[-i - 1]) * tile_size), direction.up)
	update()
	
func _physics_process(delta):
	if Input.is_action_pressed("Down"):
		camera.position.y += 1 * speed * delta
	if Input.is_action_pressed("Up"):
		camera.position.y -= 1 * speed * delta
	if Input.is_action_pressed("Left"):
		camera.position.x -= 1 * speed * delta
	if Input.is_action_pressed("Right"):
		camera.position.x += 1 * speed * delta


func _input(event):
	if Input.is_action_just_pressed("Change_turn"):
		tilemap.set_cellv(tilemap.world_to_map(get_global_mouse_position() * 2), 0)
#		print(str(get_global_mouse_position() / 32))
	if Input.is_action_just_pressed("Click"):
		var mouse_step = Vector2(stepify(get_global_mouse_position().x, tile_size), stepify(get_global_mouse_position().y, tile_size))
		draw_wall(mouse_step, direction.up)
		update()

func _on_Generate_button_down():
	generate_ship()
	generate_walls()

func _on_RandomizeDimensions_button_down():
	randomize()
	var randx = int(rand_range(5,10))
	if randx % 2 != 0:
		randx += 1
	$Control/XSize.text = str(int(randx))
	$Control/YSize.text = str(int(rand_range(5,20)))
	$Control/Hull_Height.text = str(int(rand_range(2,6)))

func draw_wall(loc : Vector2, dir):
	walls.append(Vector3(loc.x, loc.y, dir))
	

func _draw():
	for wall_ind in range(walls.size()-1):
		var wall = walls[wall_ind]
		var top_left = Vector2(wall.x - tile_size/2, wall.y - tile_size/2) + Vector2(tile_size/2, tile_size/2)
		var top_right = Vector2(wall.x + tile_size/2, wall.y - tile_size/2) + Vector2(tile_size/2, tile_size/2)
		var bottom_left = Vector2(wall.x - tile_size/2, wall.y + tile_size/2) + Vector2(tile_size/2, tile_size/2)
		var bottom_right = Vector2(wall.x + tile_size/2, wall.y + tile_size/2) + Vector2(tile_size/2, tile_size/2)
#		draw_circle(top_left, 1, Color.aqua)
#		draw_circle(top_right, 1, Color.aqua)
#		draw_circle(bottom_left, 1, Color.aqua)
#		draw_circle(bottom_right, 1, Color.aqua)
		match int(wall.z):
			direction.up:
				draw_line(top_left, top_right, Color.black, 3)
			direction.down:
				draw_line(bottom_left, bottom_right, Color.black,3)
			direction.left:
				draw_line(top_left, bottom_left, Color.black, 3)
			direction.right:
				draw_line(top_right, bottom_right, Color.black, 3)
