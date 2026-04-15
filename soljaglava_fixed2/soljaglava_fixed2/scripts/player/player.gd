extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0

const MAX_HP = 3
var hp = 3
var invincible = false
var invincible_timer = 0.0
const INVINCIBLE_TIME = 1.5

var facing = 1
var bullet_scene = preload("res://scenes/projectiles/player_bullet.tscn")

func _ready():
	get_tree().get_root().find_child("HPLabel", true, false).text = "HP: " + str(hp)

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	
	if direction > 0:
		facing = 1
	elif direction < 0:
		facing = -1

	if invincible:
		invincible_timer-=delta
		if invincible_timer<=0:
			invincible=false
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		

	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.direction = 1 if facing > 0 else -1
	bullet.position = global_position
	get_parent().add_child(bullet)
	
func take_damage():
	if invincible:
		return
	hp-=1
	invincible=true
	invincible_timer=INVINCIBLE_TIME
	print("HP: ", hp)
	if hp<=0:
		die()
	get_tree().get_root().find_child("HPLabel", true, false).text = "HP: " + str(hp)

func die():
	print("YOU DIED")
	GameManager.lose_life()
	get_tree().reload_current_scene()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	take_damage()
