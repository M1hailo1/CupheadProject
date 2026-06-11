extends CanvasLayer

func _ready():
	$ColorRect.modulate.a = 0.0
	process_mode = Node.PROCESS_MODE_ALWAYS
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func fade_to(path: String):
	await fade_out()
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	await get_tree().process_frame
	await fade_in()

func fade_out():
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 0.5)
	await tween.finished

func fade_in():
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.0, 0.5)
	await tween.finished
