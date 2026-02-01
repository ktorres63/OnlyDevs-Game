extends Control

# Cambiar a "res://scenes/introduction/Intro.tscn" cuando la intro funcione
const JUEGO = "res://scenes/main/Main.tscn"

@onready var panel_creditos = $PanelCreditos
@onready var menu_botones = $CenterContainer/VBoxContainer

func _on_button_2_button_down():
	get_tree().change_scene_to_file(JUEGO)

func _on_btn_creditos_pressed():
	menu_botones.visible = false
	panel_creditos.visible = true

func _on_btn_cerrar_creditos_pressed():
	panel_creditos.visible = false
	menu_botones.visible = true

func _on_btn_salir_pressed():
	get_tree().quit()
