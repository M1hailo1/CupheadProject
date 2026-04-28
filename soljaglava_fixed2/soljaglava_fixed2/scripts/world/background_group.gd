extends Node2D

func _process(delta: float) -> void:
	var camera = get_tree().get_root().find_child("Camera2D", true, false)
	if camera:
		var cam_x = camera.global_position.x
		for bg in get_children():
			#bg.get_node("Sky").position.x = cam_x * 0.3
			bg.get_node("Forest").position.x = cam_x * 1.0
