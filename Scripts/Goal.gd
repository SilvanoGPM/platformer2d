extends Area2D



func _on_body_entered(body: Node) -> void:
	if body.is_in_group('player'):
		$animation.play('pressed')
		$confetti.emitting = true
		$collision.queue_free()
