extends Node

enum Mascara {IMPERIO, RESISTENCIA}

var turno: int = 1
var dinero: int = 0

var sospecha_Imperio: int = 0
var sospecha_Resistencia: int = 0

var mascara_actual: Mascara = Mascara.IMPERIO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
