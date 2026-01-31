extends Node

const MAX_TURNOS: int = 24
const OBJETIVO_DINERO: int = 1000
const MAX_SOSPECHA: int = 100

var answered_phone
var probabilidad = 0.5

signal evento_cambiado(evento)
signal stats_actualizados(dinero, turno, sospecha_imperio, sospecha_resistencia)
signal call_phone(team_to_call)

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
	if(GameState.turno > MAX_TURNOS):
		checkFinal()
		return
	print("comienzo turno")
	# TODO: llegada de información
	
	
	await get_tree().create_timer(randf_range(5,10)).timeout
	#Realizar llamada
	var team_to_call
	if probabilidad < 0.3 or probabilidad > 0.7:
		probabilidad = 0.5
	if randf_range(0,1) > probabilidad:
		team_to_call = "blue" 
		probabilidad-=0.2
	else:
		team_to_call = "red"
		probabilidad+=0.2
	
	for i in range(20):
		print("lamando ", team_to_call," ", i)
		emit_signal("call_phone",{"team_to_call":team_to_call})	
		await get_tree().create_timer(1).timeout
		if answered_phone == team_to_call:
			print("[-] contestado ",answered_phone)
			answered_phone = ""
			break
	# tiempo que dura llamada
	await get_tree().create_timer(3).timeout
	# TODO: elección de mandar información
	
	emit_signal("evento_cambiado", {
		"texto": "Interceptamos Informacion de un posible ataque.",
		"opciones": ["Imperio", "Resistencia"]
	})

func elegir_opcion(opcion):
	print("no me borres, ayuda")
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
