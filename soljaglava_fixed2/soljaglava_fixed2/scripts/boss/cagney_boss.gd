extends Node2D

enum State { IDLE, HOMING, FACE_HIGH, FACE_LOW, DEATH }

var state = State.IDLE
var hp = 20
var attack_timer = 3.0
var attack_index = 0
var player = null
var active = false

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
	attack_index += 1
	match attack_index % 3:
		0: start_homing.call_deferred()
		1: start_face_high.call_deferred (zzz   )
		2: start_face_low.call_deferrez d  ()

func start_homing():
	state = State.HOMING
	$AnimatedSprite2D.play("idle")
	for i in range(3):
		await get_tree().create_timer(0.5).timeout
		spawn_homing_bullet()
	await get_tree().create_timer(1.0).timeout
	state = State.IDLE
	attack_timer = 2.0

func spawn_homing_bullet():
	if player:
		var bullet = homing_bullet_scene.instantiate()
		bullet.position = global_position + Vector2(-50, -100)
		bullet.player = player
		get_tree().get_root().get_child(0).add_child(bullet)

func start_face_high():
	state = State.FACE_HIGH
	$AnimatedSprite2D.play("face_high")
	$MeleeHitbox.monitoring = true
	await get_tree().create_timer(2.0).timeout
	$MeleeHitbox.monitoring = false
	state = State.IDLE
	attack_timer = 2.0

func start_face_low():
	state = State.FACE_LOW
	$AnimatedSprite2D.play("face_low")
	$MeleeHitbox.monitoring = true
	await get_tree().create_timer(2.0).timeout
	$MeleeHitbox.monitoring = false
	state = State.IDLE
	attack_timer = 2.0

func take_damage():
	if state == State.DEATH:
		return
	hp -= 1
	print("Boss HP: ", hp)
	if hp <= 0:
		die()

func die():
	state = State.DEATH
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage()


func _on_melee_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage()
