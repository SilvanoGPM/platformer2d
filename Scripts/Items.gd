extends Area2D

const ANIMATION_COLLECTED_NAME: String = 'collected'

func _ready() -> void:
	var _body_entered = connect('body_entered', self, '_on_body_entered')
	var _animation_end = $animation.connect('animation_finished', self, '_on_animation_finished')
	
func _on_body_entered(_body: Node) -> void:
	if not $animation.assigned_animation == ANIMATION_COLLECTED_NAME:
		$animation.play(ANIMATION_COLLECTED_NAME)

func _on_animation_finished(animation_name: String) -> void:
	if animation_name == ANIMATION_COLLECTED_NAME:
		queue_free()
