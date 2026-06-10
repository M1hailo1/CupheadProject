extends CanvasLayer

func _ready():
	get_tree().paused = true

func _on_resume_button_pressed():
	get_tree().paused = false
	queue_free()

func _on_menu_button_pressed():
	get_tree().paused = false
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
