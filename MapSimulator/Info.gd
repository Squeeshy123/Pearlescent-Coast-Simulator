extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_data(data : Array, names):
	var final : String
	for i in range(0, data.size()-1):
		final += str(names.keys()[i]).to_lower() + ": " + str(data[i]) + "\n"
	$ColorRect/Label.text = final
