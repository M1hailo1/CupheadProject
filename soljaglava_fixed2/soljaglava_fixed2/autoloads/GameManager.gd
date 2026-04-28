extends Node


var lives = 3
var score = 0
var controls_shown = false

func lose_life() -> void:
	lives-=1;
	if lives<=0:
		gameOver()
		
func gameOver() -> void:
	print("Game Over!")

func restart() -> void:
	var lives = 3
	var score = 0
