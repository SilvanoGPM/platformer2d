extends Control

export (int) var minutes = 0
export (int) var seconds = 0

func _process(_delta: float) -> void:
	if minutes > 0 and seconds <= 0:
		minutes -= 1
		seconds = 60		

	var seconds_separator = get_separator(seconds >= 10, " : ", " : 0")
	var minutes_separator = get_separator(minutes >= 10, "", "0")
	
	$seconds.set_text(seconds_separator + str(seconds))
	$minutes.set_text(minutes_separator + str(minutes))

	if seconds <= 0:
		$timer.stop()
		

		yield(get_tree().create_timer(1), 'timeout')
			
		var _reload = get_tree().reload_current_scene()
			
func get_separator(condition: bool, x: String, y: String):
	return x if condition else y

func _on_timer_timeout():
	seconds -= 1
