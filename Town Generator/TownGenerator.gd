extends Node2D

var vpoint_range = Vector2(0, 400)

var vpoint_amount = 10
var vpoints : PoolVector2Array = []

func generate_voronoi():
	for i in range(0, vpoint_amount):
		vpoints.append(Vector2(rand_range(vpoint_range.x, vpoint_range.y), rand_range(vpoint_range.x, vpoint_range.y)))
	update()

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_voronoi()

func _draw():
	for i in vpoints:
		draw_circle(i, 10, Color.black)
