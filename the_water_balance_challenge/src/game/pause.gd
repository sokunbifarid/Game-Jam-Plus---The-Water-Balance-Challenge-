extends Control

@onready var options_control: Control = $OptionsControl
@onready var help_control: Control = $HelpControl
@onready var pause_buttons_v_box_container: VBoxContainer = $PauseButtonsVBoxContainer
@onready var button_pressed_audio_stream_player: AudioStreamPlayer = $Audio/ButtonPressedAudioStreamPlayer
@onready var panel_opened_audio_stream_player: AudioStreamPlayer = $Audio/PanelOpenedAudioStreamPlayer

signal pause_closed

func _ready() -> void:
	self.hide()

func _on_resume_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	get_tree().paused = false
	pause_closed.emit()
	self.hide()

func _on_options_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	options_control.show()
	pause_buttons_v_box_container.hide()

func _on_help_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	help_control.show()
	pause_buttons_v_box_container.hide()

func _on_close_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	get_tree().quit()

func _on_visibility_changed() -> void:
	if self.visible:
		if pause_buttons_v_box_container:
			pause_buttons_v_box_container.show()
		if options_control:
			options_control.hide()
		if help_control:
			help_control.hide()
		if panel_opened_audio_stream_player:
			panel_opened_audio_stream_player.play()


func _on_options_control_options_closed() -> void:
	pause_buttons_v_box_container.show()


func _on_help_control_help_closed() -> void:
	pause_buttons_v_box_container.show()
