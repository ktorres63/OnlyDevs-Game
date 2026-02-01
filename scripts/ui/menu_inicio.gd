extends Control

const JUEGO = "res://scenes/introduction/Intro.tscn"

@onready var panel_creditos = $PanelCreditos
@onready var menu_botones = $CenterContainer/VBoxContainer

func _on_button_2_button_down():
	SceneTransition.change_scene_with_fade(JUEGO, 0.8)

func _on_btn_creditos_pressed():
	menu_botones.visible = false
	panel_creditos.visible = true

func _on_btn_cerrar_creditos_pressed():
	panel_creditos.visible = false
	menu_botones.visible = true

func _on_btn_salir_pressed():
	get_tree().quit()
