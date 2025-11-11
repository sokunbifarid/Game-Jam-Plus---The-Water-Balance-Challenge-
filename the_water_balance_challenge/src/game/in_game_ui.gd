extends Control

@onready var pause_control: Control = $PauseControl
@onready var button_pressed_audio_stream_player: AudioStreamPlayer = $Audio/ButtonPressedAudioStreamPlayer
@onready var pause_texture_button: TextureButton = $PauseTextureButton
@onready var level_completed_control: Control = $LevelCompletedControl
@onready var level_failed_control: Control = $LevelFailedControl
@onready var black_screen_cover: Control = $"../BlackScreenCover"

func _ready() -> void:
	black_screen_cover.prepare_to_zoom_in()

func _on_pause_texture_button_pressed() -> void:
	pause_control.show()
	button_pressed_audio_stream_player.play()
	pause_texture_button.hide()
	get_tree().paused = true

func _on_pause_control_pause_closed() -> void:
	pause_texture_button.show()

func level_completed():
	pause_texture_button.hide()
	level_completed_control.show()

func level_failed():
	pause_texture_button.hide()
	level_failed_control.show()
