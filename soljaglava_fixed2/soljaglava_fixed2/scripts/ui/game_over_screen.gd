extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			get_tree().paused = false
			GameManager.lives = 3
			GameManager.current_level = 1
			queue_free()
			get_tree().change_scene_to_file("res://scenes/world/level_1.tscn")

func _ready():
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
