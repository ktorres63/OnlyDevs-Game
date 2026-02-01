extends Control

signal mask_changed(new_mask)
# Called when the node enters the scene tree for the first time.

enum Mask {
	IMPERIO,
	RESISTENCIA
}
@onready var mask_image = $HBoxContainer/Panel/VBoxContainer/TextureRect
@onready var mask_label = $HBoxContainer/Panel/VBoxContainer/Label
@onready var change_button = $HBoxContainer/TextureButton

var current_mask: Mask = Mask.IMPERIO

func _ready() -> void:
	update_ui()
	change_button.pressed.connect(_on_change_pressed)

func _on_change_pressed () -> void:
	if current_mask == Mask.IMPERIO:
		current_mask = Mask.RESISTENCIA
	else:
		current_mask = Mask.IMPERIO
	update_ui()
	emit_signal("mask_changed", current_mask)
	
func update_ui():
	match current_mask:
		Mask.IMPERIO:
			mask_label.text = "Imperio"
			mask_image.texture = preload("res://assets/sprites/ui/Redmask.png")
		Mask.RESISTENCIA:
			mask_label.text = "Resistencia"
			mask_image.texture = preload("res://assets/sprites/ui/BlueMask.png")
