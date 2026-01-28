extends Control

@onready var money_label = $HBoxContainer/VBoxContainer3/MoneyLabel
@onready var turn_label = $HBoxContainer/VBoxContainer2/TurnLabel
@onready var event_text = $HBoxContainer/VBoxContainer2/EventPanel/EventText
@onready var phone_red = $HBoxContainer/VBoxContainer/PhoneRed
@onready var phone_blue = $HBoxContainer/VBoxContainer3/PhoneBlue
@onready var game_manager = $GameManager
@onready var suspicion_bar_red = $HBoxContainer/VBoxContainer/SuspicionBarRed
@onready var suspicion_bar_blue = $HBoxContainer/VBoxContainer3/SuspicionBarBlue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.evento_cambiado.connect(mostrar_evento)
	game_manager.start_game()
	actualizar_hud()


func mostrar_evento(evento) -> void:
	event_text.text = evento.texto
	actualizar_hud()
	
func actualizar_hud():
	money_label.text = "💰Dinero: $" + str(GameState.dinero)
	turn_label.text = "Turno: " + str(GameState.turno)

func _on_phone_red_pressed():
	game_manager.elegir_opcion("Imperio")
	
func _on_phone_blue_pressed():
	game_manager.elegir_opcion("Resistencia")
