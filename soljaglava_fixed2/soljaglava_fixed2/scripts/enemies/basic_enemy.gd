extends CharacterBody2D

const SPEED = 80.0
const CHARGE_SPEED = 150.0
const GRAVITY = 980.0
const WALK_RANGE = 150.0
const DETECT_RANGE = 300.0
var direction = 1
var hp = 3
var start_x = 0.0
var charging = false
var player = null

func _ready():
	start_x = position.x
	player = get_tree().get_root().find_child("Player", true, false)

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta

	if player and abs(player.global_position.x - global_position.x) < DETECT_RANGE:
		charging = true
		direction = sign(player.global_position.x - global_position.x)
		velocity.x = CHARGE_SPEED * direction
	else:
		charging = false
		velocity.x = SPEED * direction
		if position.x > start_x + WALK_RANGE:
			direction = -1
		if position.x < start_x - WALK_RANGE:
			direction = 1

	move_and_slide()

	$AnimatedSprite2D.play("run")
	$AnimatedSprite2D.flip_h = direction > 0

func take_damage():
	hp -= 1
	flash()
	if hp <= 0:
		queue_free()
		
func flash():
	$AnimatedSprite2D.modulate = Color(0.813, 0.408, 0.0, 1.0)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage()
