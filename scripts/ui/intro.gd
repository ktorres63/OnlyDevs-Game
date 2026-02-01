extends Control

const DIALOGUE = preload("res://assets/dialogs/intro.dialogue")

@onready var panel_image: TextureRect = $TextureRect

var images := {
	"panel_1": preload("res://assets/sprites/story/img1.jpg"),
	"panel_2": preload("res://assets/sprites/story/img2.jpg"),
	"panel_3": preload("res://assets/sprites/story/img3.jpg"),
	"panel_4": preload("res://assets/sprites/story/img4.jpg"),
	"panel_5": preload("res://assets/sprites/story/img5.jpg"),
}

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.got_dialogue.connect(_on_got_dialogue)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)  

	DialogueManager.show_dialogue_balloon(DIALOGUE)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")


func _on_dialogue_started(resource):
	panel_image.texture = images["panel_1"]


func _on_got_dialogue(line: DialogueLine) -> void:
	print("Tags: ", line.tags)
	print("Tag image value: '", line.get_tag_value("image"), "'")
	var key := line.get_tag_value("image")
	if key != "" and images.has(key):
		panel_image.texture = images[key]
