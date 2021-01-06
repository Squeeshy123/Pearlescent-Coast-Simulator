extends Node2D

onready var camera = get_tree().get_nodes_in_group("Camera")[0]

onready var other_towns = get_tree().get_nodes_in_group("gland_t")

var mouse_in : bool = false

var data = {
	"name" : "hello",
	"food" : 100,
	"wood" : 100,
	"stone": 100,
	"steel": 100,
	"fuel" : 100,
	"usage": 10,
	"people":400,
	"efficiency":10
	}

var stats = [data.food, data.wood, data.stone, data.steel, data.fuel, data.people, data.efficiency]

# Called when the node enters the scene tree for the first time.
func _ready():
	data.efficiency = data.people * 0.01
	data.usage = data.people * data.efficiency / 1000
	
	print(data.usage)

func _process(delta):
	$Sprite.scale = Vector2(1.1 - camera.Zoom_amount, 1.1 - camera.Zoom_amount) * 5
	$Area2D.scale = Vector2(1.1 - camera.Zoom_amount, 1.1 - camera.Zoom_amount) * 2
	
	if mouse_in:
		pass

func change_turn():
	for i in range(0, stats.size()-1):
		stats[i] -= data.usage
	update_info()

func update_info():
	$Info.update_data(stats)

func _input(event):
	if Input.is_action_just_pressed("Click"):
			#Put Click Logic
		pass


func _on_Area2D_mouse_entered():
	mouse_in = true
	$Info.visible = true
	
	update_info()
	


func _on_Area2D_mouse_exited():
	mouse_in = false
	$Info.visible = false
	
	update_info()
