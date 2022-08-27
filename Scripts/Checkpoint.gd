extends Area2D

var checked: bool = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group('player') and not checked:
		checked = true

		body._hit_checkpoint()

		$animation.play('saving')
		yield($animation, 'animation_finished')
		$animation.play('checked')
		
		$collision.queue_free()
		
