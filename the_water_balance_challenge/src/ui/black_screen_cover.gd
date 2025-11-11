extends Control

@onready var black_circle_texture_rect: TextureRect = $BlackCircleTextureRect

var the_tween: Tween
var is_zooming_out: bool = false
const DURATION: float = 0.25

signal zoom_out_completed

func _ready() -> void:
	black_circle_texture_rect.hide()

func zoom_out():
	black_circle_texture_rect.scale = Vector2.ZERO
	black_circle_texture_rect.show()
	is_zooming_out = true
	if the_tween:
		the_tween.kill()
	the_tween = get_tree().create_tween()
	the_tween.tween_property(black_circle_texture_rect, "scale", Vector2(1,1), DURATION)
	if not the_tween.is_connected("finished", the_tween_finished):
		the_tween.connect("finished", the_tween_finished)

func prepare_to_zoom_in():
	black_circle_texture_rect.scale = Vector2(1,1)
	black_circle_texture_rect.show()
	await get_tree().create_timer(1.5).timeout
	zoom_in()

func zoom_in():
	is_zooming_out = false
	if the_tween:
		the_tween.kill()
	the_tween = get_tree().create_tween()
	the_tween.tween_property(black_circle_texture_rect, "scale", Vector2(0,0), DURATION)

func the_tween_finished():
	if not is_zooming_out:
		black_circle_texture_rect.hide()
	else:
		await get_tree().create_timer(1.5).timeout
		zoom_out_completed.emit()
