extends Node


var lives = 3
var score = 0

func lose_life() -> void:
	lives-=1;
	if lives<=0:
		gameOver()
		
func gameOver() -> void:
	print("Game Over!")

func restart() -> void:
	var lives = 3
	var score = 0
