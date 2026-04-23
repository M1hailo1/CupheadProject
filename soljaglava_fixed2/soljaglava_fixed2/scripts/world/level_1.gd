extends Node2D

func _on_boss_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var camera = body.get_node("Camera2D")
		camera.limit_left = 2300
		camera.limit_right = 3380
