extends Area2D

const SPEED = 450.0
var direction = 1
 
func _ready():
	$AnimatedSprite2D.modulate = Color(1, 0.3, 0.3)
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("main")
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:
	position.x += SPEED * direction * delta
	$AnimatedSprite2D.flip_h = direction < 0

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("Bullet hit: ", body.name)
	if body.has_method("take_damage"):
		body.take_damage()
		queue_free()
