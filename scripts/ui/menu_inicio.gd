extends Control

const JUEGO = "res://scenes/main/Main.tscn"

func _on_button_2_button_down():
	get_tree().change_scene_to_file(JUEGO)
