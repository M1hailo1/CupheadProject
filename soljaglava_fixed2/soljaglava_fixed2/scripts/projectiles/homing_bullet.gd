extends Area2D

var player = null
const SPEED = 120.0
var velocity = Vector2.ZERO
var homing = true

func _ready():
	$AnimatedSprite2D.play("fly")
	await get_tree().create_timer(7.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if player and homing:
		var to_player = player.global_position - global_position
		if velocity != Vector2.ZERO and velocity.dot(to_player) < 0:
			homing = false
		else:
			velocity = to_player.normalized() * SPEED
	
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		queue_free()
