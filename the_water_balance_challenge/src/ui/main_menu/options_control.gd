extends Control

@onready var music_on: TextureRect = $OptionsPanelTextureRect/AudioVBoxContainer/MusicHBoxContainer/MusicTextureButton/MusicOn
@onready var music_off: TextureRect = $OptionsPanelTextureRect/AudioVBoxContainer/MusicHBoxContainer/MusicTextureButton/MusicOff
@onready var sfx_on: TextureRect = $OptionsPanelTextureRect/AudioVBoxContainer/SfxHBoxContainer/SfxTextureButton/SfxOn
@onready var sfx_off: TextureRect = $OptionsPanelTextureRect/AudioVBoxContainer/SfxHBoxContainer/SfxTextureButton/SfxOff
@onready var button_pressed_audio_stream_player: AudioStreamPlayer = $Audio/ButtonPressedAudioStreamPlayer
@onready var panel_opened_audio_stream_player: AudioStreamPlayer = $Audio/PanelOpenedAudioStreamPlayer


var audio_state: bool = true
var sfx_state: bool = true

signal options_closed

func _ready() -> void:
	self.hide()
	Global.load_settings()
	audio_state = Global.audio_state
	sfx_state = Global.sfx_state
	match_button_texture()

func match_button_texture():
	if audio_state:
		music_on.show()
		music_off.hide()
	else:
		music_off.show()
		music_on.hide()
	if sfx_state:
		sfx_on.show()
		sfx_off.hide()
	else:
		sfx_off.show()
		sfx_on.hide()
	AudioServer.set_bus_mute(1, not audio_state)
	AudioServer.set_bus_mute(2, not sfx_state)

func _on_music_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	if audio_state:
		audio_state = false
		Global.audio_state = false
	else:
		audio_state = true
		Global.audio_state = true
	match_button_texture()


func _on_sfx_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	if sfx_state:
		sfx_state = false
		Global.sfx_state = false
	else:
		sfx_state = true
		Global.sfx_state = true
	match_button_texture()


func _on_close_texture_button_pressed() -> void:
	button_pressed_audio_stream_player.play()
	Global.save_settings()
	self.hide()
	options_closed.emit()


func _on_visibility_changed() -> void:
	if self.visible and panel_opened_audio_stream_player:
		panel_opened_audio_stream_player.play()
