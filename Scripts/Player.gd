extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var is_grounded: bool = true

onready var raycasts: Node2D = $raycasts

export (int) var move_speed = 480
export (int) var jump_force = -720
export (int) var gravity = 1200

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	_get_input()

	velocity = move_and_slide(velocity)

func _get_input() -> void:
	velocity.x = 0
	
	var move_direction = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))

	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)

	if move_direction != 0:
		$texture.scale.x = move_direction

	is_grounded = _check_is_grouded()

	_set_animation()

func _input(event: InputEvent) -> void:
	_check_jump(event)

func _check_jump(event: InputEvent) -> void:
	if event.is_action_pressed('jump') and is_grounded:
		velocity.y = jump_force / 2

func _check_is_grouded() -> bool:
	for raycast in raycasts.get_children():
		if (raycast as RayCast2D).is_colliding():
			return true

	return false

func _set_animation() -> void:
	var animation = 'idle'
	
	if not is_grounded:
		animation = 'jump'
	elif velocity.x != 0:
		animation = 'run'
	
	if $animation.assigned_animation != animation:
		$animation.play(animation)

