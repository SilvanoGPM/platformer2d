extends KinematicBody2D

const ANIMATION_IDLE_NAME: String = 'idle'

var velocity: Vector2 = Vector2.ZERO 

export (int) var speed = 64
export (int) var health = 1
export (int) var move_direction = -1

func _physics_process(delta: float) -> void:
	velocity.x = speed * move_direction
	
	velocity = move_and_slide(velocity)
	
	if $raycast_wall.is_colliding():
		$animation.play(ANIMATION_IDLE_NAME)

func _on_animation_finished(animation_name: String):
	if animation_name == ANIMATION_IDLE_NAME:
		move_direction *= -1
		
		$texture.flip_h = not $texture.flip_h
		$raycast_wall.scale.x = -move_direction
		$animation.play('run')

