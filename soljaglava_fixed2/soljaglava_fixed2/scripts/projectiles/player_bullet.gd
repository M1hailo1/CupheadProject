extends Area2D

const SPEED = 600.0
var direction = 1

func _ready():
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:
	position.x += SPEED * direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	print("Bullet hit: ", area.name)
	if area.name == "Hitbox":
		area.get_parent().take_damage()
		queue_free()
