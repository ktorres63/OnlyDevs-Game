extends Control

const JUEGO = "res://scenes/introduction/Intro.tscn"

func _on_button_2_button_down():
	get_tree().change_scene_to_file(JUEGO)
