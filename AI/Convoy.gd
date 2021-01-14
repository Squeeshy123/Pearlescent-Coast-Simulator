extends Node2D


var target : Node2D
var speed : float = 20
var resources : PoolStringArray
var resource_amount : float = 10


func change_turn():
	position += position.direction_to(target.position) * speed
	if position.distance_to(target.position) < 30:
		target.give_resources(resources, resource_amount)
		queue_free()
