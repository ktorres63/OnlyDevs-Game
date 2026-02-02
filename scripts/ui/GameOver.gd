extends Control

@onready var reason_label = $VBoxContainer/ReasonLabel
@onready var stats_label = $VBoxContainer/StatsLabel

func _ready() -> void:
	update_stats()

func update_stats():
	stats_label.text = "Dinero final: $" + str(GameState.dinero) + "\n"
	stats_label.text += "Turnos jugados: " + str(GameState.turno - 1) + "/24"
	
	# Determinar razón del Game Over
	if GameState.sospecha_Imperio >= 100:
		reason_label.text = "¡El Imperio descubrió tu identidad!"
	elif GameState.sospecha_Resistencia >= 100:
		reason_label.text = "¡La Resistencia descubrió tu identidad!"
	elif GameState.turno > 24:
		reason_label.text = "¡Quedaste atrapado en la guerra!"
	else:
		reason_label.text = "No lograste escapar a tiempo"

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_inicio/menu_inicio.tscn")
