extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(19.0).timeout
	get_tree().quit()
	pass 
