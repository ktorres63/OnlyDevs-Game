extends HBoxContainer

var PanelContestarScene = preload("res://scenes/main/panel_contestar.tscn")

@onready var phone_red = $VBoxContainer/PhoneRed
@onready var phone_blue = $VBoxContainer3/PhoneBlue

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_phone_red_clicked():
	mostrar_panelVE_rojo()
	
func _on_phone_blue_clicked():
	mostrar_panelVE_blue():
