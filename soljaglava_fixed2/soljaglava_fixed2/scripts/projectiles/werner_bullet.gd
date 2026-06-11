extends Area2D

const SPEED = 300.0
var direction = 1

func _ready():
	$AnimatedSprite2D.play("main")

func _physics_process(delta):
	position.x += SPEED * direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage()
		queue_free()
