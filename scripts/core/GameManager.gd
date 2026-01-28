extends Node

#@onready var suspicion_bar_red = $HBoxContainer/VBoxContainer/SuspicionBarRed
#@onready var suspicion_bar_blue = $HBoxContainer/VBoxContainer3/SuspicionBarBlue
#
#var suspicionRed := 0
#var suspicionBlue := 0
#
#
#func add_suspicionBlue(amount: int):
#	suspicionBlue = clamp(suspicionBlue + amount, 0,100)
#	suspicion_bar_blue.value = suspicionBlue
#
#func add_suspicionRed(amount: int):
#	suspicionRed = clamp(suspicionRed + amount, 0,100)
#	suspicion_bar_red.value = suspicionRed
	
const MAX_TURNOS: int = 24
const OBJETIVO_DINERO: int = 1000
const MAX_SOSPECHA: int = 100

signal evento_cambiado(evento)
signal stats_actualizados(dinero, turno, sospecha_imperio, sospecha_resistencia)

func start_game():
	GameState.turno = 1
	GameState.dinero = 0
	GameState.sospecha_Imperio = 0
	GameState.sospecha_Resistencia = 0
	GameState.mascara_actual = GameState.Mascara.IMPERIO
	emit_stats()
	new_turn()


func emit_stats():
	emit_signal(
		"stats_actualizados",
		 GameState.dinero,
		 GameState.turno,
		 GameState.sospecha_Imperio,
		 GameState.sospecha_Resistencia
		)
func new_turn():
	if(GameState.turno > MAX_TURNOS):
		checkFinal()
		return
		
	emit_signal("evento_cambiado", {
		"texto": "Interceptamos Informacion de un posible ataque.",
		"opciones": ["Imperio", "Resistencia"]
	})

func elegir_opcion(opcion):
	if opcion == "Imperio":
		GameState.dinero += 200
		GameState.sospecha_Imperio += 15
		GameState.sospecha_Resistencia += 5
	else:
		GameState.dinero += 100
		GameState.sospecha_Resistencia += 15
		GameState.sospecha_Imperio += 5
		
	GameState.sospecha_Imperio = clamp(GameState.sospecha_Imperio, 0, MAX_SOSPECHA)
	GameState.sospecha_Resistencia = clamp(GameState.sospecha_Resistencia, 0, MAX_SOSPECHA)
	
	GameState.turno +=1
	emit_stats()
	new_turn()
		

func checkFinal():
	if GameState.dinero >= OBJETIVO_DINERO:
		print("VICTORIA")
	else:
		print("DERROTA")
		
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
