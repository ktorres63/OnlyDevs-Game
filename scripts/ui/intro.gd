extends Control

# Sistema de intro tipo novela visual (sin DialogueManager)

# Imágenes de la historia
var images := [
	preload("res://assets/sprites/story/img1.jpg"),
	preload("res://assets/sprites/story/img2.jpg"),
	preload("res://assets/sprites/story/img3.jpg"),
	preload("res://assets/sprites/story/img4.jpg"),
	preload("res://assets/sprites/story/img5.jpg"),
]

# Textos de la historia (basados en el lore de Valcora)
var dialogues := [
	"La capital aún funciona... los tranvías circulan, los mercados abren algunas horas.\nPero fuera de las avenidas principales, el país se ha fragmentado.",
	"El Nuevo Orden tomó el control hace seis meses. Prometieron estabilidad.\nA cambio, exigieron obediencia absoluta. Toques de queda. Censura total.",
	"En respuesta surgió La Llama Libre. No es un movimiento unificado...\nSon células rebeldes, contrabandistas, desertores. Operan desde las sombras.",
	"Yo trabajaba en la Central de Comunicaciones. Escuchaba teléfonos que no debían existir.\nLeía documentos que nadie admite haber escrito.",
	"El final de la guerra se acerca. Necesito juntar suficiente dinero para escapar.\nSolo quien logre irse a tiempo sobrevivirá lo que viene."
]

var current_index := 0
var is_typing := false
var full_text := ""
var char_index := 0.0
const CHARS_PER_SECOND := 30.0

var is_transitioning := false

@onready var panel_image: TextureRect = $TextureRect
@onready var text_label: RichTextLabel = $RichTextLabel
@onready var sfx_intro: AudioStreamPlayer = $SfxIntro
@onready var skip_hint: Label = $SkipHint
@onready var fade_rect: ColorRect = $FadeRect

func _ready() -> void:
	text_label.visible = true
	text_label.text = ""
	show_current_slide()
	sfx_intro.play()
	# Fade in al iniciar
	if fade_rect:
		fade_rect.color = Color(0, 0, 0, 1)
		var tween = create_tween()
		tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 0.5)

func _process(delta: float) -> void:
	if is_typing:
		char_index += CHARS_PER_SECOND * delta
		if char_index >= full_text.length():
			char_index = full_text.length()
			is_typing = false
		text_label.text = full_text.substr(0, int(char_index))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			# Mostrar todo el texto inmediatamente
			is_typing = false
			char_index = full_text.length()
			text_label.text = full_text
		else:
			# Avanzar al siguiente slide
			next_slide()
	
	# Skip completo con Escape
	if event.is_action_pressed("ui_cancel"):
		skip_intro()

func show_current_slide() -> void:
	if current_index < images.size():
		panel_image.texture = images[current_index]
	if current_index < dialogues.size():
		full_text = dialogues[current_index]
		char_index = 0.0
		is_typing = true
		text_label.text = ""

func next_slide() -> void:
	current_index += 1
	if current_index >= dialogues.size():
		skip_intro()
	else:
		show_current_slide()

func skip_intro() -> void:
	if is_transitioning:
		return
	is_transitioning = true
	sfx_intro.stop()
	# Fade out antes de cambiar escena
	if fade_rect:
		var tween = create_tween()
		tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 0.8)
		await tween.finished
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
