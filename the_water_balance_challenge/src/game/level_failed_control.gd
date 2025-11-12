extends Control

@onready var button_pressed_audio_stream_player: AudioStreamPlayer = $Audio/ButtonPressedAudioStreamPlayer
@onready var panel_opened_audio_stream_player: AudioStreamPlayer = $Audio/PanelOpenedAudioStreamPlayer

const MAIN_MENU = preload("uid://ben015ddg3i15")

func _ready() -> void:
	self.hide()
	Global.level_lost_signal.connect(_on_level_lost)

func _on_level_lost() -> void:
	self.show()

func _on_visibility_changed() -> void:
	if visible:
		if panel_opened_audio_stream_player:
			panel_opened_audio_stream_player.play()


func _on_menu_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	get_tree().change_scene_to_packed(MAIN_MENU)

func _on_close_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	get_tree().quit()
