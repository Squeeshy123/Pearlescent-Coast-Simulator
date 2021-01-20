extends Node2D

onready var camera = get_tree().get_nodes_in_group("Camera")[0]

onready var other_towns = get_tree().get_nodes_in_group("gland_t")

var mouse_in : bool = false
const convo = preload("res://AI/Convoy.tscn")

var spawned_convoy = false

var current_convoys : Array
var max_convoys = 4

var mutex = Mutex.new()

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

enum stat_res {NAME=0, FOOD=1, WOOD=2, STONE=3, STEEL=4, FUEL=5, PEOPLE=6, EFFICIENCEY=7, USAGE=8}
var stats = [data.name, data.food, data.wood, data.stone, data.steel, data.fuel, data.people, data.efficiency, data.usage]

var def_convoy_cooldown = 5
var convoy_cooldown = def_convoy_cooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = [data.name, data.food, data.wood, data.stone, data.steel, data.fuel, data.people, data.efficiency, data.usage]
	stats[stat_res.EFFICIENCEY] = data.people * 0.01
	stats[stat_res.USAGE] = stats[stat_res.PEOPLE] * data.efficiency / 1000

func _process(delta):
	$Sprite.scale = Vector2(1.1 - camera.Zoom_amount, 1.1 - camera.Zoom_amount) * 5
	$Area2D.scale = Vector2(1.1 - camera.Zoom_amount, 1.1 - camera.Zoom_amount) * 2
	
	if mouse_in:
		pass

func change_turn():
	for i in range(1, stats.size()-1):
		stats[i] -= stats[stat_res.USAGE]
	
	if spawned_convoy:
		convoy_cooldown -= 1
		if convoy_cooldown <= 0:
			spawned_convoy = false
			convoy_cooldown = def_convoy_cooldown
	
	for i in range(1, stat_res.size()-1):
		var checker_thread = Thread.new()
		checker_thread.start(self, "check_other_town_stat", stat_res.values()[i])
		checker_thread.wait_to_finish()
	
	var convoy_check_thread = Thread.new()
	
	convoy_check_thread.start(self, "check_for_convoys", "hello")
	
	convoy_check_thread.wait_to_finish()
	
	update_info()
	

func check_other_town_stat():
	var resources_to_send = []
	for i in other_towns:
		for j in range(1, stat_res.size()-1):
			if i.stats[j] < stats[j] - resource_diff:
				mutex.lock()
				resources_to_send.append(stat_res.keys()[j])
				mutex.unlock()
		
		send_convoy(i, resources_to_send, resource_diff)
	
	
	

func check_for_convoys(_arg):
	for i in range(0, current_convoys.size()-1):
		if max_convoys:
			if current_convoys[min(i, max_convoys)] == null:
				mutex.lock()
				current_convoys.remove(i)
				mutex.unlock()
			

func send_convoy(target_town : Node2D, resource : PoolIntArray, amount : int):
	if !(current_convoys.size() >= max_convoys) and !spawned_convoy:
		var convoi = convo.instance()
		get_parent().add_child(convoi)
		convoi.position = position
		convoi.target = target_town
		convoi.resources = resource
		convoi.resource_amount = amount
		
		mutex.lock()
		current_convoys.append(convoi)
		mutex.unlock()
		

func give_resources(res : PoolIntArray, res_amount : float):
	for i in res:
		stats[i] += res_amount
		update_info()

func update_info():
	$Info.update_data(stats, stat_res)

func _input(event):
	if Input.is_action_just_pressed("Click"):
			if mouse_in:
				stats[stat_res.STEEL] -= 5
		


func _on_Area2D_mouse_entered():
	mouse_in = true
	$Info.visible = true
	
	update_info()
	


func _on_Area2D_mouse_exited():
	mouse_in = false
	$Info.visible = false
	
	update_info()
