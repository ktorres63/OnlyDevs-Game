extends Control

@onready var minute_hand = $Hand_Long
@onready var hour_hand = $Hand_Short
@onready var sfx_tick = $SfxTick

@export var seconds_per_hour := 5.0
var time : float= 0.0
var tick_accum : float = 0.0


func _process(delta: float) -> void:
	time+= delta/ seconds_per_hour
	tick_accum += delta
	if tick_accum >= 0.25:
		sfx_tick.play()
		tick_accum = 0.0
	
	var minutes = fmod(time * 60.0, 60.0)
	minute_hand.rotation_degrees= minutes * 6.0
	
	hour_hand.rotation_degrees = fmod(time * 30.0, 360.0)
