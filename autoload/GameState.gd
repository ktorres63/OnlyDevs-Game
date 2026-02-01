extends Node

enum Mascara {IMPERIO, RESISTENCIA}

var turno: int = 1
var dinero: int = 0
var informacion_recibida: Array[Dictionary]

var sospecha_Imperio: int = 0
var sospecha_Resistencia: int = 0

var mascara_actual: Mascara = Mascara.IMPERIO
