extends Control
const DIALOGUE  = preload("res://assets/dialogs/intro.dialogue")
var images := [""]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.show_dialogue_balloon(DIALOGUE,"start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
