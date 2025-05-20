extends Node3D

func _on_grabbed():
		get_tree().change_scene_to_file("res://Vr_final/vr_bb.tscn")
