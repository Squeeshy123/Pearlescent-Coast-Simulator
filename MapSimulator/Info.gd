extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_data(data : Array):
	var final : String
	for i in data:
		final += str(i) + "\n"
	$ColorRect/Label.text = final