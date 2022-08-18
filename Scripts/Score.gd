extends Label

func _process(_delta: float) -> void:
	var zeros = "000"
	
	if GameManager.fruits >= 10:
		zeros = "00"
	elif GameManager.fruits >= 100:
		zeros = "0"
	elif GameManager.fruits >= 1000:
		zeros = ""
	
	text = zeros + String(GameManager.fruits)
