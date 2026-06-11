extends CanvasLayer

func _ready():
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var minutes = int(GameManager.time_elapsed) / 60
	var seconds = int(GameManager.time_elapsed) % 60
	
	$TimeLabel.text = "Time: %d:%02d" % [minutes, seconds]
	$KillsLabel.text = "Enemies Killed: " + str(GameManager.enemies_killed)
	$ScoreLabel.text = "Score: " + str(GameManager.score)
	
	var scores = GameManager.highscores
	if scores.is_empty():
		$LeaderboardLabel.text = "Nema još rezultata"
	else:
		var text = "TOP 10\n──────────\n"
		for i in scores.size():
			text += "%d.  %d\n" % [i + 1, scores[i]]
		$LeaderboardLabel.text = text

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			get_tree().paused = false
			GameManager.lives = 3
			GameManager.score = 0
			GameManager.enemies_killed = 0
			GameManager.time_elapsed = 0.0
			GameManager.current_level = 1
			queue_free()
			get_tree().change_scene_to_file("res://scenes/world/level_1.tscn")
