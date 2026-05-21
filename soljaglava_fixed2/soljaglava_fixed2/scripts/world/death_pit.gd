extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
	elif body.has_method("death_animation"):
		body.death_animation()

func _ready():
	$AnimatedSprite2D.play("spike")
	$AnimatedSprite2D2.play("spike")
