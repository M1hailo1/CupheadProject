extends Area2D

var player = null
const SPEED = 120.0
var velocity = Vector2.ZERO
var homing_timer = 2.0

func _ready():
	$AnimatedSprite2D.play("fly")
	await get_tree().create_timer(7.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if player and homing_timer > 0:
		homing_timer -= delta
		var target_velocity = (player.global_position - global_position).normalized() * SPEED
		velocity = velocity.lerp(target_velocity, 0.05)
	
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		queue_free()
