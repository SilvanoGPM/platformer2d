extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO

export var move_speed = 480
export var jump_force = -720
export var gravity = 1200

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	var move_direction = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))

	if Input.is_action_pressed('jump'):
		velocity.y = jump_force / 2

	velocity.x = move_speed * move_direction

	velocity = move_and_slide(velocity)
