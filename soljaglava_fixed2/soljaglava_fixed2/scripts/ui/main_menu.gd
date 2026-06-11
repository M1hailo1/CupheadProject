extends Control

func _on_play_button_pressed():
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/world/level_1.tscn")

func _on_leaderboard_button_pressed():
	var scores = GameManager.highscores
	if scores.is_empty():
		$LeaderboardPanel/LeaderboardLabel.text = "Nema još rezultata"
	else:
		var text = "TOP 10\n──────────\n"
		for i in scores.size():
			text += "%d.  %d\n" % [i + 1, scores[i]]
		$LeaderboardPanel/LeaderboardLabel.text = text
	$LeaderboardPanel.visible = true

func _on_quit_button_pressed():
	get_tree().quit()


func _on_close_button_pressed() -> void:
	$LeaderboardPanel.visible = false
