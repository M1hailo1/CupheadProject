extends Node2D

enum State { IDLE, HOMING, FACE_HIGH, FACE_LOW, DEATH }

var state = State.IDLE
var hp = 50
var attack_timer = 3.0
var attack_index = 0
var player = null
var active = false
var attacking = false

var homing_bullet_scene = preload("res://scenes/projectiles/homing_bullet.tscn")

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	if not active:
		if player and abs(player.global_position.x - global_position.x) < 1000:
			active = true
			$AnimatedSprite2D.play("idle")
		return
		
	if state == State.IDLE:
		attack_timer -= delta
		if attack_timer <= 0:
			next_attack()

func next_attack():
	if attacking:
		return
	attacking = true
	attack_index += 1
	match attack_index % 3:
		0: start_homing()
		1: start_face_high()
		2: start_face_low()

func start_homing():
	state = State.HOMING
	$AnimatedSprite2D.play("idle")
	for i in range(3):
		await get_tree().create_timer(0.5).timeout
		spawn_homing_bullet()
	await get_tree().create_timer(1.0).timeout
	state = State.IDLE
	attack_timer = 2.0
	attacking = false

func spawn_homing_bullet():
	if player:
		var bullet = homing_bullet_scene.instantiate()
		bullet.position = global_position + Vector2(-50, -100)
		bullet.player = player
		get_tree().get_root().get_child(0).add_child(bullet)

func start_face_high():
	state = State.FACE_HIGH
	$AnimatedSprite2D.play("face_high")
	$MeleeHitboxHigh.monitoring = true
	await get_tree().create_timer(0.7).timeout
	if $MeleeHitboxHigh.overlaps_body(player):
		player.take_damage()
	await get_tree().create_timer(0.7).timeout
	$MeleeHitboxHigh.monitoring = false
	state = State.IDLE
	attack_timer = 2.0
	attacking = false

func start_face_low():
	state = State.FACE_LOW
	$AnimatedSprite2D.play("face_low")
	$MeleeHitboxLow.monitoring = true
	await get_tree().create_timer(0.7).timeout
	if $MeleeHitboxLow.overlaps_body(player):
		player.take_damage()
	await get_tree().create_timer(0.7).timeout
	$MeleeHitboxLow.monitoring = false
	state = State.IDLE
	attack_timer = 2.0
	attacking = false

func take_damage():
	if state == State.DEATH:
		return
	hp -= 1
	print("Boss HP: ", hp)
	flash()
	if hp <= 0:
		die()

func flash():
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

func die():
	state = State.DEATH
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = $AnimatedSprite2D.sprite_frames.get_frame_count("death") - 1

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage()
