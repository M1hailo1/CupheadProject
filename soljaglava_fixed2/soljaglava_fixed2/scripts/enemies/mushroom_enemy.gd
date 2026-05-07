extends CharacterBody2D

const GRAVITY = 980.0
var hp = 3
var shoot_timer = 3.0
const SHOOT_COOLDOWN = 3.0
var player = null
var dying = false
var invincible = false

var bullet_scene = preload("res://scenes/projectiles/enemy_bullet.tscn")
var hit_sound = preload("res://assets/audio/universfield-falling-game-character-352287.mp3")

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()
	
	shoot_timer -= delta
	if shoot_timer <= 0:
		if player and abs(player.global_position.x - global_position.x) < 400:
			attack()
		shoot_timer = SHOOT_COOLDOWN
		
	if player:
		$AnimatedSprite2D.flip_h = player.global_position.x >	 global_position.x

func attack():
	$AnimatedSprite2D.play("attack")
	if player:
		var dir = sign(player.global_position.x - global_position.x)
		var bullet = bullet_scene.instantiate()
		bullet.direction = dir
		print("Spawn position: ", $BulletSpawnPoint.global_position)
		print("Mushroom position: ", global_position)
		var spawn = $BulletSpawnPoint.position
		spawn.x = abs(spawn.x) * dir
		bullet.position = global_position + spawn
		get_tree().get_root().get_child(0).add_child(bullet)
		await get_tree().create_timer(1.0).timeout
		$AnimatedSprite2D.play("idle")

func take_damage():
	if dying or invincible:
		return
	invincible = true
	hp -= 1
	flash()
	play_sound(hit_sound,-12.0)
	if hp <= 0:
		GameManager.enemies_killed += 1
		dying = true
		death_animation()
		
func flash():
	$AnimatedSprite2D.modulate = Color(0.813, 0.408, 0.0, 1.0)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	invincible = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage()

func death_animation():
	$CollisionShape2D.disabled = true
	$Hitbox/CollisionShape2D.disabled = true
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 100, 0.3)
	tween.tween_property(self, "position:y", position.y + 500, 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished
	queue_free()

func play_sound(stream, volume_db = 0.0):
	var player = AudioStreamPlayer.new()
	get_tree().get_root().add_child(player)
	player.stream = stream
	player.volume_db = volume_db
	player.play()
	await get_tree().create_timer(1.0).timeout
	player.queue_free()
