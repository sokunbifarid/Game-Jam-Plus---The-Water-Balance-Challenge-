extends Control

@onready var button_pressed_audio_stream_player: AudioStreamPlayer = $Audio/ButtonPressedAudioStreamPlayer
@onready var panel_opened_audio_stream_player: AudioStreamPlayer = $Audio/PanelOpenedAudioStreamPlayer

signal help_closed

func _ready() -> void:
	self.hide()

func _on_visibility_changed() -> void:
	if self.visible and panel_opened_audio_stream_player:
		panel_opened_audio_stream_player.play()


func _on_close_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	self.hide()
	help_closed.emit()
