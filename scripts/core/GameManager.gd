extends Node

const MAX_TURNOS: int = 24
const OBJETIVO_DINERO: int = 1000
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
		team_to_call = "blue"
		probabilidad += 0.2
	else:
		team_to_call = "red"
		probabilidad -= 0.2
		
	#cantidad de ring ring's xd
	for i in range(3):
		print("lamando ", team_to_call, " ", i)
		emit_signal("call_phone", {"team_to_call": team_to_call})
		await get_tree().create_timer(1).timeout
		if answered_phone == team_to_call:
			print("[-] contestado ",answered_phone, "con mascara: ", mask_selector.mask_label.text)    
			#ahora usamos la variable para verificar que se contestó
			answered_phone = ""
			if_contesto = true
			break
	
	#mecanica de llamada perdida
	#if if_contesto:
		# tiempo que dura llamada
	#	await get_tree().create_timer(3).timeout
		
	# TODO: elección de mandar información
	answered_phone = ""

	if !if_contesto:
		print("  - no contestaste pa, te cae multa")
		notificacion.mostrar("llamada_perdida")
		emit_signal("missed_call",team_to_call)
	
	await get_tree().create_timer(3).timeout
	
		
func checkFinal():
	if GameState.dinero >= OBJETIVO_DINERO:
		print("VICTORIA")
	else:
		print("DERROTA")

func procesar_accion_telefono(accion, bando):
	if accion == "Vender":
		GameState.dinero += 10
		print("Información vendida al " + bando + ". Dinero actual: " + str(GameState.dinero))
		
		if bando == "Imperio":
			GameState.sospecha_Imperio += 10
		else:
			GameState.sospecha_Resistencia += 10
		
	elif accion == "Entregar":
		print("Información entregada al " + bando)
		
		if bando == "Imperio":
			GameState.sospecha_Imperio -= 5
			GameState.sospecha_Resistencia += 5
		else:
			GameState.sospecha_Resistencia -= 5
			GameState.sospecha_Imperio += 5
	
	emit_stats()
	GameState.turno += 1
	new_turn()
