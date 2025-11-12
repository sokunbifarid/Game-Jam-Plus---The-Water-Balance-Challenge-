extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var v_slider: VSlider = $TextureProgressBar/VSlider
@onready var storage_percent_label: Label = $StorageDataVBoxContainer/StoragePercentagePanel/StoragePercentLabel
@onready var storage_name_label: Label = $StorageDataVBoxContainer/StorageNamePanel/StorageNameLabel
@export var current_storage_type: Global.all_storage_containers_list

func _ready() -> void:
	if current_storage_type == Global.all_storage_containers_list.CONTAINER_1:
		storage_name_label.text = Global.storage_1_name
	elif current_storage_type == Global.all_storage_containers_list.CONTAINER_2:
		storage_name_label.text = Global.storage_2_name
	elif current_storage_type == Global.all_storage_containers_list.CONTAINER_3:
		storage_name_label.text = Global.storage_3_name

func _process(_delta: float) -> void:
	storage_percent_label.text = str(int(v_slider.value)) + "%"
	texture_progress_bar.value = v_slider.value
	if current_storage_type != Global.current_active_storage_container:
		if current_storage_type == Global.all_storage_containers_list.CONTAINER_1:
			v_slider.value = Global.storage_tank_1_value
		elif current_storage_type == Global.all_storage_containers_list.CONTAINER_2:
			v_slider.value = Global.storage_tank_2_value
		elif current_storage_type == Global.all_storage_containers_list.CONTAINER_3:
			v_slider.value = Global.storage_tank_3_value
	else:
		if current_storage_type == Global.all_storage_containers_list.CONTAINER_1:
			Global.storage_tank_1_value = int(v_slider.value)
		elif current_storage_type == Global.all_storage_containers_list.CONTAINER_2:
			Global.storage_tank_2_value = int(v_slider.value)
		elif current_storage_type == Global.all_storage_containers_list.CONTAINER_3:
			Global.storage_tank_3_value = int(v_slider.value)
		Global.limit_storage_values_to_max()

func _on_visibility_changed() -> void:
	if visible:
		set_process(true)
		if current_storage_type == Global.current_active_storage_container:
			v_slider.editable = true
			self.modulate = Color(1,1,1)
		else:
			v_slider.editable = false
			self.modulate = Color(0.5,0.5,0.5)
	else:
		set_process(false)
