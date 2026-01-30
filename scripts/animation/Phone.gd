extends Node
class_name UIAnimations

static func shake(
	node: Node,
	strength := 5.0,
	duration := 0.4
):
	var tween := node.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	var original_pos = node.position
	
	for i in range(10):
		tween.tween_property(
			node,
			"position",
			original_pos + Vector2(
				randf_range(-strength, strength),
				randf_range(-strength, strength)
			),
			duration / 10
		)

	tween.tween_property(node, "position", original_pos, duration / 10)
