extends PanelContainer

signal opcion_seleccionada(tipo_accion, bando_objetivo)

var bando_actual = ""

func setup_y_mostrar(bando, posicion_global):
	bando_actual = bando
	global_position = posicion_global
	show()

func _on_btn_vender_pressed():
	emit_signal("opcion_seleccionada", "Vender", bando_actual)
	queue_free() 

func _on_btn_entregar_pressed():
	emit_signal("opcion_seleccionada", "Entregar", bando_actual)
	queue_free()
