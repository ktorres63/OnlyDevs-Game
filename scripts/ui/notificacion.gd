extends Control

const msg_llegada_informacion = "Haz recibido nueva información, revisa tu folder"
const msg_llamada_perdida =     "No contestaste la llamada, incrementan las sospechas"
const msg_error_mascara =       "No usaste la mascara correcta"
const duracion:int = 3

@onready var text_label = $HBoxContainer/Label

func mostrar(tipo):
	match tipo:
		"llegada_informacion":
			text_label.text = msg_llegada_informacion
		"llamada_perdida":
			text_label.text = msg_llamada_perdida	
		"error_mascara":
			text_label.text = msg_error_mascara
	
	visible = true
	await get_tree().create_timer(duracion).timeout
	visible = false
