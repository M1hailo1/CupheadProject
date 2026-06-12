extends Area2D

const GRAVITY = 600.0
var direction = 1
var target_x = 0.0
var velocity = Vector2.ZERO

func _ready():
	$AnimatedSprite2D.play("main")
	var dx = target_x - global_position.x
	var time = 0.8
	velocity.x = dx / time
	velocity.y = -400.0

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage()
		queue_free()
