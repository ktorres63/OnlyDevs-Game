extends Control

const JUEGO = "res://scenes/introduction/Intro.tscn"

@onready var panel_creditos = $PanelCreditos
@onready var menu_botones = $CenterContainer/VBoxContainer
@onready var fade_rect: ColorRect = $FadeRect

func _ready() -> void:
	# Asegurar que el fade rect esté transparente al iniciar
	if fade_rect:
		fade_rect.color = Color(0, 0, 0, 0)

func _on_button_2_button_down():
	_fade_to_scene(JUEGO)

func _fade_to_scene(scene_path: String) -> void:
	if fade_rect:
		var tween = create_tween()
		tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 0.8)
		await tween.finished
	get_tree().change_scene_to_file(scene_path)

func _on_btn_creditos_pressed():
	menu_botones.visible = false
	panel_creditos.visible = true

func _on_btn_cerrar_creditos_pressed():
	panel_creditos.visible = false
	menu_botones.visible = true

func _on_btn_salir_pressed():
	get_tree().quit()
