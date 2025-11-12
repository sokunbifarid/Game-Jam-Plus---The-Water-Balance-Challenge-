extends Control

@onready var menu: Control = $Menu
@onready var options_control: Control = $OptionsControl
@onready var black_screen_cover: Control = $BlackScreenCover
@onready var help_control: Control = $HelpControl
const GAME = preload("uid://t2xv0frrgbdq")

var getting_ready_to_play_game: bool = false

func _ready() -> void:
	black_screen_cover.prepare_to_zoom_in()

func _on_options_control_options_closed() -> void:
	menu.show()

func _on_menu_options_button_pressed() -> void:
	options_control.show()

func _on_menu_play_button_pressed() -> void:
	if not getting_ready_to_play_game:
		getting_ready_to_play_game = true
		black_screen_cover.zoom_out()
		Global.set_game_ended(true)

func _on_black_screen_cover_zoom_out_completed() -> void:
	get_tree().change_scene_to_packed(GAME)


func _on_help_control_help_closed() -> void:
	menu.show()


func _on_menu_help_button_pressed() -> void:
	help_control.show()
