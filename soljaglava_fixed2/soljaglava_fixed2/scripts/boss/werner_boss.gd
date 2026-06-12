extends CharacterBody2D

const GRAVITY = 980.0
const MOVE_SPEED = 120.0
const DASH_SPEED = 400.0

var hp = 200
var player = null
var state = "idle"
var attack_timer = 3.0
var boss_fight_started = false
var facing = -1
var hit_sound = preload("res://assets/audio/ribhavagrawal-hit-by-a-wood-230542.mp3")
var bullet_scene = preload("res://scenes/projectiles/werner_bullet.tscn")
var attack_count = 0

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	$AnimatedSprite2D.play("idle")

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
		"dash":
			velocity.x = DASH_SPEED * facing
	
	move_and_slide()

func choose_attack():
	if player == null:
		return
	facing = -1 if player.global_position.x < global_position.x else 1
	$AnimatedSprite2D.flip_h = facing == 1
	
	attack_count += 1
	if attack_count % 2 == 0:
		start_dash()
	else:
		start_throw()

func start_dash():
	state = "dash"
	$AnimatedSprite2D.play("dash")

func start_throw():
	state = "throw"
	await get_tree().create_timer(1.0).timeout
	if state == "throw":
		spawn_bullet()
		state = "idle"
		$AnimatedSprite2D.play("idle")
		attack_timer = 3.0

func spawn_bullet():
	if bullet_scene == null:
		return
	for i in 6:
		var target = player.global_position if player else global_position + Vector2(facing * 300, 0)
		var bullet = bullet_scene.instantiate()
		bullet.direction = facing
		bullet.target_x = target.x + randf_range(-100, 100)
		bullet.global_position = global_position + Vector2(facing * 40, -20)
		get_parent().add_child(bullet)
		await get_tree().create_timer(0.4).timeout

func _on_animated_sprite_2d_animation_finished():
	match state:
		"dash":
			state = "idle"
			velocity.x = 0
			$AnimatedSprite2D.play("idle")
			attack_timer = 2.0
		"death":
			GameManager.next_level()

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
	velocity.x = 0
	$AnimatedSprite2D.play("death")
	GameManager.boss_bonus = 1500

func play_sound(stream, volume_db = 0.0):
	var player_node = AudioStreamPlayer.new()
	add_child(player_node)
	player_node.stream = stream
	player_node.volume_db = volume_db
	player_node.play()
	await player_node.finished
	player_node.queue_free()

func _on_hitbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		take_damage()
	elif area.get_parent().has_method("take_damage") == false:
		take_damage()
