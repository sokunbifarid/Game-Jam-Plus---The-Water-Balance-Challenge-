extends StaticBody2D

@onready var storage_tank_name_label: Label = $StorageTankNamePanel/VBoxContainer/StorageTankNameLabel
@onready var storage_tank_value_label: Label = $StorageTankNamePanel/VBoxContainer/StorageTankValueLabel
@export var storage_container_type: Global.all_storage_containers_list
var mouse_in_area: bool = false
var can_detect_mouse: bool = true

func _ready() -> void:
	Global.game_ended_signal.connect(_on_game_ended)
	if storage_container_type == Global.all_storage_containers_list.CONTAINER_1:
		storage_tank_name_label.text = Global.storage_1_name
	elif storage_container_type == Global.all_storage_containers_list.CONTAINER_2:
		storage_tank_name_label.text = Global.storage_2_name
	elif storage_container_type == Global.all_storage_containers_list.CONTAINER_3:
		storage_tank_name_label.text = Global.storage_3_name

func _process(_delta: float) -> void:
	if storage_container_type == Global.all_storage_containers_list.CONTAINER_1:
		storage_tank_value_label.text = str(Global.storage_tank_1_value) + "%"
	elif storage_container_type == Global.all_storage_containers_list.CONTAINER_2:
		storage_tank_value_label.text = str(Global.storage_tank_2_value) + "%"
	elif storage_container_type == Global.all_storage_containers_list.CONTAINER_3:
		storage_tank_value_label.text = str(Global.storage_tank_3_value) + "%"

func _on_game_ended(value: bool) -> void:
	if value == true:
		can_detect_mouse = false
		mouse_in_area = false
		set_process(false)
		set_process_input(false)
	else:
		can_detect_mouse = true
		set_process(true)
		set_process_input(true)

func _on_mouse_entered() -> void:
	if can_detect_mouse:
		mouse_in_area = true

func _on_mouse_exited() -> void:
	if can_detect_mouse:
		mouse_in_area = false

func set_container_based_on_type() -> void:
	if storage_container_type == Global.all_storage_containers_list.CONTAINER_1:
		Global.set_active_storage_container_to_container_1()
	elif storage_container_type == Global.all_storage_containers_list.CONTAINER_2:
		Global.set_active_storage_container_to_container_2()
	elif storage_container_type == Global.all_storage_containers_list.CONTAINER_3:
		Global.set_active_storage_container_to_container_3()
	else:
		Global.set_active_storage_container_to_none()

func _input(event: InputEvent) -> void:
	if can_detect_mouse and mouse_in_area:
		if event is InputEventMouseButton:
			set_container_based_on_type()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_detect_mouse and not Global.player_using_resource_management:
		if Global.current_active_storage_container == storage_container_type:
			Global.set_resource_management_active(true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and Global.player_using_resource_management:
		Global.set_resource_management_active(false)
