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
	game_manager.stats_actualizados.connect(_on_stats_actualizados)
	game_manager.start_game()

func mostrar_evento(evento) -> void:
	event_text.text = evento.texto
	

func _on_stats_actualizados(dinero, turno, sospecha_imperio, sospecha_resistencia):
	money_label.text = "Dinero: $" + str(dinero)
	turn_label.text = "Turno: " + str(turno)
	
	suspicion_bar_red.value = sospecha_imperio
	suspicion_bar_blue.value = sospecha_resistencia

func _on_phone_red_pressed():
	game_manager.elegir_opcion("Imperio")
	
func _on_phone_blue_pressed():
	game_manager.elegir_opcion("Resistencia")
