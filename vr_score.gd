extends Area3D

func _on_body_entered(body: Area3D) -> void:
	if $"../BasketBall":
		
		await get_tree().create_timer(0.1).timeout
pass
