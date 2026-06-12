extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0

var shoot_timer = 0.0
const SHOOT_COOLDOWN = 0.25

const MAX_HP = 3
var hp = 50
var invincible = false
var invincible_timer = 0.0
const INVINCIBLE_TIME = 1.5

var facing = 1

var shoot_sound = preload("res://assets/audio/universfield-gunshot-352466.mp3")
var jump_sound = preload("res://assets/audio/Jump sound.mp3")
var hit_sound = preload("res://assets/audio/ribhavagrawal-hit-by-a-wood-230542.mp3")

var bullet_scene = preload("res://scenes/projectiles/player_bullet.tscn")

func _ready():
	await get_tree().process_frame
	update_hud()
	
func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		play_sound(jump_sound,-5.0)
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if is_on_floor():
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * delta * 10)
	
	if direction > 0:
		facing = 1
	elif direction < 0:
		facing = -1
	
	if invincible:
		invincible_timer -= delta
		if invincible_timer <= 0:
			invincible = false
		$AnimatedSprite2D.modulate.a = 0.0 if fmod(invincible_timer, 0.2) < 0.1 else 1.0
	else:
		$AnimatedSprite2D.modulate.a = 1.0
	
	for area in $Hurtbox.get_overlapping_areas():
		if area.name == "BossTrigger":
			continue
		if area.name == "MeleeHitboxHigh":
			continue
		if area.name == "MeleeHitboxLow":
			continue
		take_damage()
		break
	
	if Input.is_action_pressed("shoot"):
		shoot_timer -= delta
		if shoot_timer <= 0:
			shoot()
			shoot_timer = SHOOT_COOLDOWN
	else:
		shoot_timer = SHOOT_COOLDOWN
	
	move_and_slide()
	velocity.y = clamp(velocity.y, -abs(JUMP_VELOCITY), abs(JUMP_VELOCITY) * 2)
	update_animation()
	update_hud()
	
func update_hud():
	var hp_label = get_tree().get_root().find_child("HPLabel", true, false)
	var lives_label = get_tree().get_root().find_child("LivesLabel", true, false)
	var level_label = get_tree().get_root().find_child("LevelLabel", true, false)
	var timer_label = get_tree().get_root().find_child("TimerLabel", true, false)
	var score_label = get_tree().get_root().find_child("ScoreLabel", true, false)
	
	if hp_label:
		var hearts = ""
		for i in MAX_HP:
			hearts += "❤" if i < hp else "♡"
		hp_label.text = hearts
		
	if lives_label:
		var stars = ""
		for i in 3:
			stars += "💛" if i < GameManager.lives else "🖤"
		lives_label.text = stars
	
	if level_label: level_label.text = "Level: " + str(GameManager.current_level)
	if timer_label:
		var minutes = int(GameManager.time_elapsed) / 60
		var seconds = int(GameManager.time_elapsed) % 60
		timer_label.text = "Time: %d:%02d" % [minutes, seconds]
	if score_label:
		GameManager.calculate_score()
		score_label.text = "Score: " + str(GameManager.score)

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.direction = 1 if facing > 0 else -1
	var spawn_offset = $BulletSpawnPoint.position
	spawn_offset.x = abs(spawn_offset.x) * facing
	bullet.position = global_position + spawn_offset
	get_parent().add_child(bullet)
	play_sound(shoot_sound,-17.0)
	
func take_damage():
	if invincible:
		return
	hp-=1
	invincible=true
	invincible_timer=INVINCIBLE_TIME
	print("HP: ", hp)
	play_sound(hit_sound,-5.0)
	if hp<=0:
		die()
	update_hud()


func die():
	GameManager.lose_life()
	if GameManager.lives <= 0:
		return
	hp = MAX_HP
	invincible = true
	invincible_timer = 2.0
	get_tree().change_scene_to_file.call_deferred(GameManager.levels[GameManager.current_level])

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "BossTrigger":
		return
	if area.name == "MeleeHitboxHigh":
		return
	if area.name == "MeleeHitboxLow":
		return
	take_damage()
	
func update_animation() -> void:
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif Input.is_action_pressed("shoot"):
		if $AnimatedSprite2D.animation != "run_shoot":
			$AnimatedSprite2D.play("run_shoot")
	elif abs(velocity.x) > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	if facing == 1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

func play_sound(stream, volume_db = 0.0):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.volume_db = volume_db
	player.play()
	await player.finished
	player.queue_free()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if get_tree().paused:
				return
			var pause = preload("res://scenes/ui/pause_menu.tscn").instantiate()
			get_tree().current_scene.add_child(pause)
