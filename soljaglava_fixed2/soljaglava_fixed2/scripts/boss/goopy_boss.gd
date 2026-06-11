extends CharacterBody2D

const GRAVITY = 980.0
const JUMP_FORCE = -600.0
const PUNCH_SPEED = 300.0

var hp = 80
var player = null
var state = "idle"
var attack_timer = 3.0
var boss_fight_started = false
var facing = -1

var hit_sound = preload("res://assets/audio/universfield-falling-game-character-352287.mp3")

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
	velocity.x = PUNCH_SPEED * facing
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
		pass

func landed():
	if state == "jump":
		state = "idle"
		velocity.x = 0
		$AnimatedSprite2D.play("idle")
		attack_timer = 2.0
		screen_shake()

func take_damage(amount = 1):
	if not boss_fight_started:
		return
	if state == "death":
		return
	hp -= 1
	if hp <= 0:
		die()
		return
	play_sound(hit_sound, -12.0)
	flash()

func flash():
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

func die():
	state = "death"
	$AnimatedSprite2D.play("death")
	GameManager.boss_bonus = 1000
	await get_tree().create_timer(3.0).timeout
	GameManager.next_level()

func _on_hitbox_area_entered(area):
	if area.get_parent().name == "PlayerBullet" or area.is_in_group("player_bullet"):
		take_damage(10)

func play_sound(stream, volume_db = 0.0):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.volume_db = volume_db
	player.play()
	await player.finished
	player.queue_free()
	
func screen_shake():
	var camera = get_tree().get_root().find_child("Camera2D", true, false)
	if camera == null:
		return
	var original = camera.offset
	var tween = create_tween()
	for i in 8:
		tween.tween_property(camera, "offset", original + Vector2(randf_range(-12, 12), randf_range(-12, 12)), 0.05)
	tween.tween_property(camera, "offset", original, 0.05)
