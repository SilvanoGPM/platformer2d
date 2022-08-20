extends Area2D

func _on_body_entered(_body: Node) -> void:
	var _reload = get_tree().reload_current_scene()
