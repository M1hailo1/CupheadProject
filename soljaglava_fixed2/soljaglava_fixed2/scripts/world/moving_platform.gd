extends AnimatableBody2D

@export var move_direction = Vector2(1, 0)
@export var move_distance = 200.0
@export var move_speed = 100.0

var start_position = Vector2.ZERO
var direction_sign = 1
var traveled = 0.0

func _ready():
	start_position = global_position

func _physics_process(delta: float) -> void:
	var movement = move_direction * move_speed * direction_sign * delta
	position += movement
	traveled += movement.length()
	
	if traveled >= move_distance:
		traveled = 0.0
		direction_sign *= -1
