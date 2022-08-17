extends Area2D

export var points = 1

func _ready() -> void:
	var _body_entered = connect('body_entered', self, '_on_body_entered')
	var _animation_end = $animation.connect('animation_finished', self, '_on_animation_finished')
	
func _on_body_entered(_body: Node) -> void:
	GameManager.fruits += points
	
	if not $animation.assigned_animation == 'collected':
		$animation.play('collected')

func _on_animation_finished(animation_name: String) -> void:
	if animation_name == 'collected':
		queue_free()
