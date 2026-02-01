extends Control

@onready var money_label = $Control/MoneyLabel
@onready var turn_label = $HBoxContainer/VBoxContainer2/VBoxContainer/TurnLabel
@onready var event_text = $HBoxContainer/VBoxContainer2/VBoxContainer/EventPanel/EventText
@onready var phone_red = $HBoxContainer/MarginContainer2/VBoxContainer/VBoxContainer/PhoneRed
@onready var phone_blue = $HBoxContainer/MarginContainer/VBoxContainer3/VBoxContainer/PhoneBlue
@onready var game_manager = $GameManager
@onready var suspicion_bar_red = $HBoxContainer/MarginContainer2/VBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SuspicionBarRed
@onready var suspicion_bar_blue = $HBoxContainer/MarginContainer/VBoxContainer3/VBoxContainer/HBoxContainer/HBoxContainer/SuspicionBarBlue
@onready var sfx_ring = $SfxRing
@onready var sfx_hangup = $SfxHangup
@onready var sfx_click = $SfxClick
@onready var sfx_paper_info = $SfxPaperInfo
@onready var sfx_paper_sell = $SfxPaperSell
@onready var sfx_static = $SfxStatic
@onready var folder = $TextureRect2	

const PANEL_DECISION_SCENE = preload("res://scenes/main/panel_contestar.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.evento_cambiado.connect(mostrar_evento)
	game_manager.stats_actualizados.connect(_on_stats_actualizados)
	game_manager.call_phone.connect(call_phone)
	game_manager.missed_call.connect(missed_call)
	game_manager.start_game()
	phone_blue.disabled = true
	phone_red.disabled = true
	

func mostrar_evento(evento) -> void:
	GameState.informacion_recibida.append(evento)
	actualizar_estado_folder()
	#esta linea está quedando obsoleta 
	event_text.text = evento.texto
	

func _on_stats_actualizados(dinero, turno, sospecha_imperio, sospecha_resistencia):
	money_label.text = str(dinero)
	turn_label.text = "Turno: " + str(turno)
	
	suspicion_bar_red.value = sospecha_imperio
	suspicion_bar_blue.value = sospecha_resistencia

func _on_phone_red_pressed():
	sfx_click.play()
	sfx_ring.stop()
	sfx_paper_sell.play()
	if not sfx_static.playing:
		sfx_static.play()
	game_manager.answer_phone("red")
	mostrar_panel_decision("Imperio", phone_red)
	phone_red.texture_normal = load("res://assets/sprites/ui/phone_red_call.png")
	
func _on_phone_blue_pressed():
	sfx_click.play()
	sfx_ring.stop()
	sfx_paper_sell.play()
	if not sfx_static.playing:
		sfx_static.play()
	game_manager.answer_phone("blue")
	mostrar_panel_decision("Resistencia", phone_blue)
	phone_blue.texture_normal = load("res://assets/sprites/ui/phone_blue_call.png")

func mostrar_panel_decision(bando: String, boton_telefono: Control):
	var panel = PANEL_DECISION_SCENE.instantiate()
	add_child(panel)
	panel.setup_y_mostrar(bando, boton_telefono.global_position)
	panel.opcion_seleccionada.connect(_on_decision_tomada)
	
func _on_decision_tomada(accion: String, bando: String):
	print("El jugador decidió: ", accion, " para el bando: ", bando)
	game_manager.procesar_accion_telefono(accion, bando)
	actualizar_estado_telefono(bando)
	
func missed_call(bando):
	if bando == "red":
		GameState.sospecha_Imperio += 30
	else:
		GameState.sospecha_Resistencia += 30
	actualizar_estado_telefono(bando)
	game_manager.emit_stats()
	GameState.turno += 1
	game_manager.new_turn()
	 
func actualizar_estado_telefono(bando: String):
	if bando == "Imperio" || bando == "red" : 
		phone_red.texture_normal = load("res://assets/sprites/ui/phoneRed.png")
		phone_red.disabled = true
	elif bando == "Resistencia" || bando == "blue":
		phone_blue.texture_normal = load("res://assets/sprites/ui/phoneBlue.png")
		phone_blue.disabled = true

func actualizar_estado_folder():
	if (GameState.informacion_recibida.is_empty()):
		folder.texture = load("res://assets/sprites/ui/empty_folder.png")	
	else:
		folder.texture = load("res://assets/sprites/ui/folder.png")

func call_phone(evento):
	var phone
	if evento.team_to_call == "blue":
		phone = phone_blue
		phone_blue.disabled = false
	else:
		phone = phone_red
		phone_red.disabled = false

	sfx_ring.stop()
	sfx_ring.play()

	UIAnimations.shake(phone)	
		
