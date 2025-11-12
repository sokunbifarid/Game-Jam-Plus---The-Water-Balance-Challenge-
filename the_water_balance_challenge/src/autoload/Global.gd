extends Node

var audio_state: bool = true
var sfx_state: bool = true
var game_ended: bool = true
var player_using_resource_management: bool = false

var storage_tank_1_value: int = 0
var storage_tank_2_value: int = 0
var storage_tank_3_value: int = 0
const TOTAL_MAX_STORAGE_VALUE: int = 100

var storage_1_name: String = "FARM"
var storage_2_name: String = "CITY"
var storage_3_name: String = "BARN"

enum all_storage_containers_list{NONE, CONTAINER_1, CONTAINER_2, CONTAINER_3}
var current_active_storage_container: all_storage_containers_list = all_storage_containers_list.NONE


signal game_ended_signal
signal resource_management_active_signal

func save_settings():
	pass

func load_settings():
	pass

func set_game_ended(value: bool) -> void:
	game_ended = value
	game_ended_signal.emit(value)
	if value == true:
		set_active_storage_container_to_none()

func set_resource_management_active(value: bool) -> void:
	if value:
		print("got")
		player_using_resource_management = true
		if current_active_storage_container == all_storage_containers_list.CONTAINER_1:
			resource_management_active_signal.emit(value, 1)
		elif current_active_storage_container == all_storage_containers_list.CONTAINER_2:
			resource_management_active_signal.emit(value, 2)
		elif current_active_storage_container == all_storage_containers_list.CONTAINER_3:
			resource_management_active_signal.emit(value, 3)
		elif current_active_storage_container == all_storage_containers_list.NONE:
			resource_management_active_signal.emit(value, 0)
	else:
		print("gotten")
		player_using_resource_management = false
		resource_management_active_signal.emit(value, 0)

func set_active_storage_container_to_none() -> void:
	print("dull")
	current_active_storage_container = all_storage_containers_list.NONE

func set_active_storage_container_to_container_1() -> void:
	print("heres sds asd")
	current_active_storage_container = all_storage_containers_list.CONTAINER_1

func set_active_storage_container_to_container_2() -> void:
	current_active_storage_container = all_storage_containers_list.CONTAINER_2

func set_active_storage_container_to_container_3() -> void:
	current_active_storage_container = all_storage_containers_list.CONTAINER_3

func limit_storage_values_to_max() -> void:
	var difference: int = TOTAL_MAX_STORAGE_VALUE - (storage_tank_1_value + storage_tank_2_value + storage_tank_3_value)
	if difference < 0:
		if current_active_storage_container == all_storage_containers_list.CONTAINER_1:
			var remainder: int = storage_tank_2_value + difference
			storage_tank_2_value += difference
			if remainder < 0:
				storage_tank_3_value += remainder
		elif current_active_storage_container == all_storage_containers_list.CONTAINER_2:
			var remainder: int = storage_tank_1_value + difference
			storage_tank_1_value += difference
			if remainder < 0:
				storage_tank_3_value += remainder
		elif current_active_storage_container == all_storage_containers_list.CONTAINER_3:
			var remainder: int = storage_tank_1_value + difference
			storage_tank_1_value += difference
			if remainder < 0:
				storage_tank_2_value += difference

	storage_tank_1_value = clampi(storage_tank_1_value, 0, TOTAL_MAX_STORAGE_VALUE)
	storage_tank_2_value = clampi(storage_tank_2_value, 0, TOTAL_MAX_STORAGE_VALUE)
	storage_tank_3_value = clampi(storage_tank_3_value, 0, TOTAL_MAX_STORAGE_VALUE)
