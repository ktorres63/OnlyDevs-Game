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
	else:
		reason_label.text = "No lograste el objetivo de dinero a tiempo"

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")

func _on_menu_button_pressed():
	# Por ahora regresa al Main, puedes cambiar esto si creas un menú principal
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
