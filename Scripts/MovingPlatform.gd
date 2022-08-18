extends Node2D

const WAIT_DURATION: float = 1.0

var follow = Vector2.ZERO

onready var platform: KinematicBody2D = $platform
onready var tween: Tween = $tween

export (float) var speed = 3.0
export (int) var distance = 192
export (bool) var horizontal = true

func _ready() -> void:
	_start_tween()

func _start_tween() -> void:
	var move_direction = (Vector2.RIGHT if horizontal else Vector2.UP) * distance
	var duration = move_direction.length() / float(speed * 16)
	
	var _interpolate = tween.interpolate_property(
		self, 
		'follow',
		Vector2.ZERO,
		move_direction,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		WAIT_DURATION
	)
	
	var _interpolate2 = tween.interpolate_property(
		self,
		'follow',
		move_direction,		
		Vector2.ZERO,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		duration + WAIT_DURATION * 2
	)
	
	var _start = tween.start()

func _physics_process(_delta: float):
	platform.position = platform.position.linear_interpolate(follow, 0.05)
