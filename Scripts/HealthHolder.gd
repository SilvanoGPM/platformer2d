extends Control

var life_size = 32

func _on_change_life(player_health: int) -> void:
	$icon.rect_size.x = player_health * life_size
