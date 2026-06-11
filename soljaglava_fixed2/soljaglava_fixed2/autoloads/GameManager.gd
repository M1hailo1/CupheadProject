extends Node

const SAVE_PATH = "user://highscores.cfg"
var highscores: Array = []
var lives = 3
var score = 0
var enemies_killed = 0
var time_elapsed = 0.0
var controls_shown = false
var current_level = 1
var boss_bonus = 0
var levels = {
	1: "res://scenes/world/level_1.tscn",
	2: "res://scenes/world/level_2.tscn",
	3: "res://scenes/world/level_3.tscn"
}

func _ready():
	load_highscores()

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
		SceneTransition.fade_to(levels[current_level])

func calculate_score():
	var lives_lost = 3 - lives
	var lives_penalty = lives_lost * 400
	score = (enemies_killed * 150) - (int(time_elapsed) * 2) - lives_penalty + boss_bonus
	if score < 0:
		score = 0

func you_win():
	calculate_score()
	add_highscore(score)
	var screen = preload("res://scenes/ui/win_screen.tscn").instantiate()
	get_tree().get_root().add_child(screen)
	
func reset_game():
	lives = 3
	score = 0
	enemies_killed = 0
	time_elapsed = 0.0
	current_level = 1
	boss_bonus = 0
	
func add_highscore(new_score: int):
	highscores.append(new_score)
	highscores.sort()
	highscores.reverse()
	if highscores.size() > 10:
		highscores.resize(10)
	save_highscores()

func save_highscores():
	var config = ConfigFile.new()
	for i in highscores.size():
		config.set_value("scores", str(i), highscores[i])
	config.save(SAVE_PATH)

func load_highscores():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	highscores.clear()
	var i = 0
	while config.has_section_key("scores", str(i)):
		highscores.append(config.get_value("scores", str(i)))
		i += 1
