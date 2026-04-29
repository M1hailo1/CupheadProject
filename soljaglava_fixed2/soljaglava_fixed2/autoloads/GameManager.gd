extends Node

var lives = 3
var controls_shown = false
var current_level = 1
var levels = {
	1: "res://scenes/world/level_1.tscn",
	2: "res://scenes/world/level_2.tscn"
}

func lose_life():
	lives -= 1
	if lives <= 0:
		game_over()

func game_over():
	lives = 3
	current_level = 1
	var screen = preload("res://scenes/ui/game_over_screen.tscn").instantiate()
	get_tree().get_root().add_child(screen)

func next_level():
	current_level += 1
	if current_level > levels.size():
		you_win()
	else:
		get_tree().change_scene_to_file(levels[current_level])

func you_win():
	pass # make scene later
