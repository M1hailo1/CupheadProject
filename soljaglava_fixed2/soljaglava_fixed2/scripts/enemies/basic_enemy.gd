extends CharacterBody2D


const SPEED = 80.0
const GRAVITY = 980.0
var direction = 1
var hp = 3


func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY*delta
	velocity.x = SPEED * direction

	if is_on_wall():
		direction*=-1
	move_and_slide()
	
	if position.x >500:
		direction = -1
	if position.x <100:
		direction = 1
	
func take_damage():
	hp-=1
	print("Enemy HP: ", hp)
	if hp<=0:
		queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":	
		body.take_damage()
