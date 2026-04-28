extends CanvasLayer

func _ready():
	if GameManager.controls_shown:
		queue_free()
		return
	GameManager.controls_shown = true
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		get_tree().paused = false
		queue_free()
