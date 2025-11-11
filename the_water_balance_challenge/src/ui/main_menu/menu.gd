extends Control

@onready var button_pressed_audio_stream_player: AudioStreamPlayer = $Audio/ButtonPressedAudioStreamPlayer
@onready var panel_opened_audio_stream_player: AudioStreamPlayer = $Audio/PanelOpenedAudioStreamPlayer


signal play_button_pressed
signal options_button_pressed
signal help_button_pressed


func _on_play_texture_button_pressed() -> void:
	self.hide()
	play_button_pressed.emit()
	button_pressed_audio_stream_player.play()


func _on_options_texture_button_pressed() -> void:
	self.hide()
	options_button_pressed.emit()
	button_pressed_audio_stream_player.play()


func _on_help_texture_button_pressed() -> void:
	self.hide()
	help_button_pressed.emit()
	button_pressed_audio_stream_player.play()


func _on_close_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	get_tree().quit()


func _on_visibility_changed() -> void:
	if self.visible and panel_opened_audio_stream_player:
		panel_opened_audio_stream_player.play()
