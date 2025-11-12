extends Node

var audio_state: bool = true
var sfx_state: bool = true
var game_ended: bool = true

signal game_ended_signal
signal resource_management_active_signal

func save_settings():
	pass

func load_settings():
	pass

func set_game_ended(value: bool) -> void:
	game_ended = value
	game_ended_signal.emit(value)

func set_resource_management_active(value: bool) -> void:
	resource_management_active_signal.emit(value)
