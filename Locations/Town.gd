extends Node2D

onready var camera = get_tree().get_nodes_in_group("Camera")[0]

onready var other_towns = get_tree().get_nodes_in_group("gland_t")

var mouse_in : bool = false
const convo = preload("res://AI/Convoy.tscn")

var spawned_convoy = false

export var data = {
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

var resource_diff = 15

var stats = [data.food, data.wood, data.stone, data.steel, data.fuel, data.people, data.efficiency]

var def_convoy_cooldown = 5
var convoy_cooldown = def_convoy_cooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	data.efficiency = data.people * 0.01
	data.usage = data.people * data.efficiency / 1000

func _process(delta):
	$Sprite.scale = Vector2(1.1 - camera.Zoom_amount, 1.1 - camera.Zoom_amount) * 5
	$Area2D.scale = Vector2(1.1 - camera.Zoom_amount, 1.1 - camera.Zoom_amount) * 2
	
	if mouse_in:
		pass

func change_turn():
	for i in range(0, stats.size()-1):
		stats[i] -= data.usage
	for i in other_towns:
		if i.data.steel > data.steel - resource_diff and !spawned_convoy:
			send_convoy(i, ["steel"], resource_diff)
			spawned_convoy = true
	update_info()


func send_convoy(target_town : Node2D, resource : PoolStringArray, amount : int):
	var convoi = convo.instance()
	get_parent().add_child(convoi)
	convoi.position = position
	convoi.target = target_town
	convoi.resources = resource
	convoi.resource_amount = amount

func give_resources(res : PoolStringArray, res_amount : float):
	for i in res:
		data[str(i)] += res_amount
		print(i)
		update_info()

func update_info():
	$Info.update_data(data)

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
