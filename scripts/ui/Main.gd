extends Control

@onready var money_label = $RightPanel/MoneyLabel
@onready var turn_label = $CenterPanel/TurnLabel
@onready var event_text = $CenterPanel/EventPanel/EventText
@onready var phone_red = $LeftPanel/PhoneRed
@onready var phone_blue = $RightPanel/PhoneBlue
@onready var game_manager = $GameManager
@onready var suspicion_bar_red = $LeftPanel/HBoxContainer/VBoxContainer/SuspicionBarRed
@onready var suspicion_bar_blue = $RightPanel/HBoxContainer/VBoxContainer/SuspicionBarBlue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.evento_cambiado.connect(mostrar_evento)
	game_manager.stats_actualizados.connect(_on_stats_actualizados)
	game_manager.call_phone.connect(call_phone)
	game_manager.end_call.connect(reset_sprite)
	game_manager.start_game()
	phone_blue.disabled = true
	phone_red.disabled = true
	

func mostrar_evento(evento) -> void:
	event_text.text = evento.texto
	

func _on_stats_actualizados(dinero, turno, sospecha_imperio, sospecha_resistencia):
	money_label.text = "💰Dinero: $" + str(dinero)
	turn_label.text = "Turno: " + str(turno)
	
	suspicion_bar_red.value = sospecha_imperio
	suspicion_bar_blue.value = sospecha_resistencia

func _on_phone_red_pressed():
	game_manager.answer_phone("red")
	game_manager.elegir_opcion("Imperio")
	phone_red.texture_normal = load("res://assets/sprites/ui/mask_blue.png")
	phone_red.disabled = true	
	# TODO: cambiar por url al sprite de telefono descolgado

func reset_sprite(team):
	if team == "blue":
		phone_blue.texture_normal = load("res://assets/sprites/ui/phoneBlue.png")
	else:
		phone_red.texture_normal = load("res://assets/sprites/ui/phoneRed.png")

func _on_phone_blue_pressed():
	game_manager.answer_phone("blue")
	game_manager.elegir_opcion("Resistencia")
	phone_blue.texture_normal = load("res://assets/sprites/ui/mask_blue.png")
	phone_blue.disabled = true
	
func call_phone(evento):
	var phone
	if evento.team_to_call == "blue":
		phone = phone_blue
		phone_blue.disabled = false
	else:
		phone = phone_red
		phone_red.disabled = false

	UIAnimations.shake(phone)	
		
		
	
