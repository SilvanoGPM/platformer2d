extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO 
var hitted = false

export (int) var gravity = 1200
export (int) var speed = 64
export (int) var health = 1
export (int) var move_direction = -1
export (int) var bounce_force = 350

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	velocity.x = speed * move_direction if not hitted else 0

	velocity = move_and_slide(velocity)
	
	_set_animation()
	
func _set_animation() -> void:
	var animation = 'run'
	
	if $raycast_wall.is_colliding():
		animation = 'idle'
	
	if hitted:
		animation = 'hit'

	$animation.play(animation)

func _on_animation_finished(animation_name: String):
	if animation_name == 'idle':
		move_direction *= -1
		
		$texture.flip_h = not $texture.flip_h
		$raycast_wall.scale.x = -move_direction
		$animation.play('run')
	elif animation_name == 'hit':
		hitted = false
		
		if health <= 0:
			$hitbox/coliision.set_deferred('disabled', true)
			queue_free()

func _on_hitbox_body_entered(body: Node):
	hitted = true
	health -= 1
	body.velocity.y = 0
	body.velocity.y -= bounce_force
