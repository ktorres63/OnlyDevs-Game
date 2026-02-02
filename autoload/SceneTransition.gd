extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

signal transition_finished

func _ready() -> void:
	color_rect.color = Color(0, 0, 0, 0)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func fade_out(duration: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, duration)
	await tween.finished

func fade_in(duration: float = 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, duration)
	await tween.finished

func change_scene_with_fade(scene_path: String, fade_duration: float = 0.5) -> void:
	await fade_out(fade_duration)
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	await fade_in(fade_duration)
	emit_signal("transition_finished")
