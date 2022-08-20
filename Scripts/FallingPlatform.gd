extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var gravity: int = 720
var is_triggered: bool = false

onready var animation: AnimationPlayer = $animation
onready var timer: Timer = $timer

onready var reset_position: Vector2  = global_position

export (float) var reset_timer = 3.0

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	position += velocity * delta
	
func collide_with(_collision: KinematicCollision2D, _collider: KinematicBody2D) -> void:
	if not is_triggered:
		is_triggered = true
		animation.play('shake')
		velocity = Vector2.ZERO

func _on_animation_finished(animation_name: String) -> void:
	if animation_name == 'shake':
		set_physics_process(true)
		timer.start(reset_timer)

func _on_timer_timeout() -> void:
	set_physics_process(false)

	yield(get_tree(), 'physics_frame')
	
	var temp = collision_layer
	
	collision_layer = 0
	global_position = reset_position
	
	yield(get_tree(), 'physics_frame')
	
	collision_layer = temp
	
	animation.play('on')
	is_triggered = false
