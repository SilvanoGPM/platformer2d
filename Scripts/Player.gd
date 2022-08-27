extends KinematicBody2D

signal change_life(health)

const UP = Vector2.UP

var velocity: Vector2 = Vector2.ZERO
var is_grounded: bool = true
var hurted: bool = false
var knockback_direction: int = 0

onready var raycasts: Node2D = $raycasts

export (int) var move_speed = 480
export (int) var jump_force = -720
export (int) var gravity = 1200
export (int) var max_health = 3
export (int) var health = 3
export (int) var knockback = 1200

func _ready() -> void:
	var node: Control = get_parent().get_node('hud/container/health_holder')
	
	var _connect = connect('change_life', node, '_on_change_life')
	emit_signal('change_life', max_health)

#	position.x = GameManager.checkpoint_position
	position.y -= 50

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = 0
	
	if not hurted:
		_get_input()

	velocity = move_and_slide(velocity, UP)

	is_grounded = _check_is_grouded()

	_set_animation()

	for platforms in get_slide_count():
		var collision = get_slide_collision(platforms)
		
		if collision.collider.has_method('collide_with'):
			collision.collider.collide_with(collision, self)

func _get_input() -> void:
	velocity.x = 0
	
	var move_direction = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))

	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)

	if move_direction != 0:
		$texture.scale.x = move_direction
		$step_particles.scale.x = move_direction		
		knockback_direction = move_direction

func _input(event: InputEvent) -> void:
	if not hurted:
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
	var animation: String = 'idle'
	
	if not is_grounded:
		animation = 'jump'
	elif velocity.x != 0:
		animation = 'run'
		$step_particles.emitting = true
	
	if velocity.y > 0 and not is_grounded:
		animation = 'fall' 
	
	if hurted:
		animation = 'hit'
	
	if $animation.assigned_animation != animation:
		$animation.play(animation)

func _on_hurtbox_body_entered(_body: Node) -> void:
	if not hurted:
		health -= 1
		hurted = true
		
		emit_signal('change_life', health)
		
		_knockback()
				
		$hurtbox/collision.set_deferred('disabled', true)

		yield(get_tree().create_timer(0.5), 'timeout')
		
		$hurtbox/collision.set_deferred('disabled', false)
		
		hurted = false

		if health <= 0:
			queue_free()
			var _reload = get_tree().reload_current_scene()

func _knockback() -> void:
	if $raycasts/right.is_colliding():
		velocity.x = -knockback_direction * knockback
	
	if $raycasts/left.is_colliding():
		velocity.x = knockback_direction * knockback
	
	velocity = move_and_slide(velocity)

func _hit_checkpoint() -> void:
	GameManager.checkpoint_position = position.x
