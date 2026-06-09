extends CharacterBody2D

const GRAVITY = 980.0
const JUMP_FORCE = -600.0
const PUNCH_SPEED = 300.0

var hp = 60
var max_hp = 60
var player = null
var state = "idle"
var attack_timer = 3.0
var boss_fight_started = false
var facing = -1

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)

func _physics_process(delta):
	if not boss_fight_started:
		return
		
	velocity.y += GRAVITY * delta
	
	match state:
		"idle":
			velocity.x = 0
			attack_timer -= delta
			if attack_timer <= 0:
				choose_attack()
		"punch":
			velocity.x = PUNCH_SPEED * facing
		"jump":
			pass
	
	move_and_slide()
	if is_on_floor() and state == "jump":
		landed()

func choose_attack():
	if player == null:
		return
	facing = -1 if player.global_position.x < global_position.x else 1
	$AnimatedSprite2D.flip_h = facing == 1
	
	if randi() % 2 == 0:
		start_jump()
	else:
		start_punch()

func start_jump():
	state = "jump"
	velocity.y = JUMP_FORCE
	$AnimatedSprite2D.play("jump")

func start_punch():
	state = "punch"
	$AnimatedSprite2D.play("punch")

func _on_animated_sprite_2d_animation_finished():
	if state == "punch":
		state = "idle"
		velocity.x = 0
		$AnimatedSprite2D.play("idle")
		attack_timer = 2.5
	elif state == "death":
		queue_free()

func landed():
	if state == "jump":
		state = "idle"
		$AnimatedSprite2D.play("idle")
		attack_timer = 2.0

func take_damage(amount = 10):
	hp -= amount
	if hp <= 0:
		die()

func die():
	state = "death"
	$AnimatedSprite2D.play("death")
	GameManager.boss_bonus = 500

func _on_hitbox_area_entered(area):
	if area.get_parent().name == "PlayerBullet" or area.is_in_group("player_bullet"):
		take_damage(10)
