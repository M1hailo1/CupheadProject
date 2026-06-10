extends Control

func _on_play_button_pressed():
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/world/level_1.tscn")

func _on_leaderboard_button_pressed():
	pass

func _on_quit_button_pressed():
	get_tree().quit()
