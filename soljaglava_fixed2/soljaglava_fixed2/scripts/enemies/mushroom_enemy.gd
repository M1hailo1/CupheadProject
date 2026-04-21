extends CharacterBody2D

const GRAVITY = 980.0
var hp = 3
var shoot_timer = 3.0
const SHOOT_COOLDOWN = 3.0
var player = null
var bullet_scene = preload("res://scenes/projectiles/player_bullet.tscn")

func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()
	
	shoot_timer -= delta
	if shoot_timer <= 0:
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
		bullet.position = global_position
		get_parent().add_child(bullet)
		await get_tree().create_timer(1.0).timeout
		$AnimatedSprite2D.play("idle")

func take_damage():
	hp -= 1
	if hp <= 0:
		queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage()
