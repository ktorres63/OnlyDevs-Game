extends Node

const MAX_TURNOS: int = 24
const OBJETIVO_DINERO: int = 500
const MAX_SOSPECHA: int = 100

@onready var mask_selector = $"../HBoxContainer/MarginContainer2/VBoxContainer/MascaraPanel"
@onready var notificacion = $"../Notificacion"

var EVENTOS = [
	{
		"id": "frecuencias_radio",
		"texto": "Desciframos frecuencias de radio cifradas.",
		"opciones": ["Entregar al Imperio", "Entregar a la Resistencia"],
		"peso": 3
	},
	{
		"id": "movimientos_tropas",
		"texto": "Reportes sobre movimientos de tropas en la frontera.",
		"opciones": ["Vender al Imperio", "Vender a la Resistencia"],
		"peso": 4
	},
	{
		"id": "arma_experimental",
		"texto": "Datos sobre un arma experimental a medio desarrollar.",
		"opciones": ["Vender planos", "Entregar planos"],
		"peso": 2
	},
	{
		"id": "infiltrado",
		"texto": "Un infiltrado ofrece nombres de agentes encubiertos.",
		"opciones": ["Aceptar trato", "Rechazar"],
		"peso": 2
	},
	{
		"id": "saboteo",
		"texto": "Plan de sabotaje contra una fábrica estratégica.",
		"opciones": ["Vender información", "Advertir al objetivo"],
		"peso": 2
	},
	{
		"id": "base_secreta",
		"texto": "Localización de una base secreta de alto mando.",
		"opciones": ["Subastar información", "Destruir datos"],
		"peso": 1
	},
	{
		"id": "traicion_general",
		"texto": "Un general planea traicionar a su propia facción.",
		"opciones": ["Vender traición", "Alertar facción"],
		"peso": 1
	},
	{
		"id": "arma_definitiva",
		"texto": "Planos incompletos de un arma capaz de cambiar la guerra.",
		"opciones": ["Vender al mejor postor", "Entregar y borrar copia"],
		"peso": 1
	}
]


var answered_phone
var probabilidad = 0.5
var current_mask

signal evento_cambiado(evento)
signal stats_actualizados(dinero, turno, sospecha_imperio, sospecha_resistencia)
signal call_phone(team_to_call)
signal missed_call(team)
signal dinero_suficiente()  # Señal para mostrar botón Huir

# TODO: reducir consumo de memoria de esta función
func obtener_evento_aleatorio():
	var pool = []

	for evento in EVENTOS:
		for i in range(evento.peso):
			pool.append(evento)

	return pool.pick_random()


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
	
	# Verificar si alcanzó el objetivo de dinero
	if GameState.dinero >= OBJETIVO_DINERO:
		emit_signal("dinero_suficiente")

func answer_phone(phone):
	answered_phone = phone
	
func new_turn():
	var team_to_call: String
	var if_contesto:bool = false 
	
	if (GameState.turno > MAX_TURNOS):
		checkFinal()
		return
		
	print("comienzo turno")
	await get_tree().create_timer(randf_range(5, 7)).timeout

	# llegada de información
	var evento = obtener_evento_aleatorio()
	emit_signal("evento_cambiado", evento)
	notificacion.mostrar("llegada_informacion")
	
	await get_tree().create_timer(randf_range(7, 10)).timeout
	
	#Realizar llamada
	if probabilidad < 0.3 or probabilidad > 0.7:
		probabilidad = 0.5
		
	if randf_range(0, 1) > probabilidad:
		team_to_call = "Imperio"
		probabilidad += 0.2
	else:
		team_to_call = "Resistencia"
		probabilidad -= 0.2
		
	#cantidad de ring ring's xd
	for i in range(3):
		print("llamando ", team_to_call, " ", i)
		emit_signal("call_phone", {"team_to_call": team_to_call})
		await get_tree().create_timer(1).timeout
		if answered_phone == team_to_call:
			print("[-] contestado ",answered_phone, "con mascara: ", mask_selector.mask_label.text)
			answered_phone = ""
			if_contesto = true
			break
	
	# Limpiar estado del teléfono
	answered_phone = ""

	# Mecánica de llamada perdida - solo si NO contestó
	if !if_contesto:
		print("  - no contestaste pa, te cae multa")
		notificacion.mostrar("llamada_perdida")
		emit_signal("missed_call", team_to_call)
	# Nota: El siguiente turno se inicia desde Main.gd 
	# (missed_call -> new_turn) o (procesar_accion_telefono -> new_turn)

		
func checkFinal():
	# Si llegó al turno máximo sin escapar, pierde (atrapado en la guerra)
	print("DERROTA - Atrapado en la guerra")
	# Usar call_deferred para evitar errores durante await
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over/GameOver.tscn")

func check_sospecha():
	# Verificar si alguna sospecha llegó a 100
	if GameState.sospecha_Imperio >= MAX_SOSPECHA:
		print("GAME OVER - El Imperio te descubrió")
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over/GameOver.tscn")
		return true
	elif GameState.sospecha_Resistencia >= MAX_SOSPECHA:
		print("GAME OVER - La Resistencia te descubrió")
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over/GameOver.tscn")
		return true
	return false

func escapar():
	# Victoria: el jugador decidió huir con suficiente dinero
	if GameState.dinero >= OBJETIVO_DINERO:
		print("VICTORIA - Escapaste con el dinero")
		get_tree().call_deferred("change_scene_to_file", "res://scenes/victory/Victory.tscn")
	return

func procesar_accion_telefono(accion, bando):
	# Obtener la máscara actual
	var mascara_activa = mask_selector.mask_label.text
	
	if accion == "Vender":
		GameState.dinero += 50
		print("Información vendida al " + bando + ". Dinero actual: " + str(GameState.dinero))
		
		if bando == "Imperio":
			GameState.sospecha_Imperio += 10
		else:
			GameState.sospecha_Resistencia += 10
		
	elif accion == "Entregar":
		print("Información entregada al " + bando)
		
		# Si usas la máscara correcta, reduces MÁS sospecha del bando
		var reduccion_base = 5
		var reduccion_mascara = 10  # Bonus por usar máscara correcta
		
		if bando == "Imperio":
			if mascara_activa == "Imperio":
				GameState.sospecha_Imperio -= (reduccion_base + reduccion_mascara)
			else:
				GameState.sospecha_Imperio -= reduccion_base
			GameState.sospecha_Resistencia += 5
		else:
			if mascara_activa == "Resistencia":
				GameState.sospecha_Resistencia -= (reduccion_base + reduccion_mascara)
			else:
				GameState.sospecha_Resistencia -= reduccion_base
			GameState.sospecha_Imperio += 5
	
	# Asegurar que la sospecha no baje de 0
	GameState.sospecha_Imperio = max(0, GameState.sospecha_Imperio)
	GameState.sospecha_Resistencia = max(0, GameState.sospecha_Resistencia)
	
	emit_stats()
	
	# Verificar si alguna sospecha llegó a 100
	if check_sospecha():
		return
	
	GameState.turno += 1
	new_turn()
