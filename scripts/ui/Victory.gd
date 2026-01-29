extends Control

@onready var message_label = $VBoxContainer/MessageLabel
@onready var stats_label = $VBoxContainer/StatsLabel

func _ready() -> void:
	update_stats()

func update_stats():
	stats_label.text = "Dinero final: $" + str(GameState.dinero) + "\n"
	stats_label.text += "Turnos: " + str(GameState.turno - 1) + "/24"
	
	# Mensaje personalizado según el desempeño
	if GameState.turno <= 15:
		message_label.text = "¡Victoria perfecta! Completaste el objetivo rápidamente"
	elif GameState.sospecha_Imperio < 50 and GameState.sospecha_Resistencia < 50:
		message_label.text = "¡Victoria sigilosa! Nadie sospechó de ti"
	else:
		message_label.text = "¡Lograste el objetivo de dinero!"

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")

func _on_menu_button_pressed():
	# Por ahora regresa al Main, puedes cambiar esto si creas un menú principal
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
