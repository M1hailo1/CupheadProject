extends Node

var lives = 3
var score = 0
var enemies_killed = 0
var time_elapsed = 0.0
var controls_shown = false
var current_level = 1
var levels = {
	1: "res://scenes/world/level_1.tscn",
	2: "res://scenes/world/level_2.tscn",
	3: "res://scenes/world/level_3.tscn"
}

func lose_life():
	lives -= 1
	if lives <= 0:
		game_over()

func game_over():
	lives = 3
	score = 0
	enemies_killed = 0
	time_elapsed = 0.0
	current_level = 1
	var screen = preload("res://scenes/ui/game_over_screen.tscn").instantiate()
	get_tree().get_root().add_child(screen)

func next_level():
	current_level += 1
	if current_level > levels.size():
		you_win()
	else:
		get_tree().change_scene_to_file(levels[current_level])

func calculate_score():
	var lives_lost = 3 - lives
	var lives_penalty = lives_lost * 500
	score = (enemies_killed * 100) - (int(time_elapsed) * 5) - lives_penalty
	if score < 0:
		score = 0

func you_win():
	calculate_score()
	var screen = preload("res://scenes/ui/win_screen.tscn").instantiate()
	get_tree().get_root().add_child(screen)
