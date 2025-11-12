extends Control

var red_style_box: StyleBoxFlat = StyleBoxFlat.new()
var yellow_style_box: StyleBoxFlat = StyleBoxFlat.new()
var green_style_box: StyleBoxFlat = StyleBoxFlat.new()
var current_community_happiness_progress_bar_stylebox_in_use: StyleBoxFlat

@onready var storage_1_name_label: Label = $Panel/VBoxContainer/VBoxContainer/StorageInfoSorterHBoxContainer/Storage1HolderVBoxContainer/Storage1NameLabel
@onready var storage_1_required_label: Label = $Panel/VBoxContainer/VBoxContainer/StorageInfoSorterHBoxContainer/Storage1HolderVBoxContainer/Storage1DataVBoxContainer/Storage1RequiredLabel
@onready var storage_1_provided_label: Label = $Panel/VBoxContainer/VBoxContainer/StorageInfoSorterHBoxContainer/Storage1HolderVBoxContainer/Storage1DataVBoxContainer/Storage1ProvidedLabel
@onready var storage_2_name_label: Label = $Panel/VBoxContainer/VBoxContainer/StorageInfoSorterHBoxContainer/Storage2HolderVBoxContainer/Storage2NameLabel
@onready var storage_2_required_label: Label = $Panel/VBoxContainer/VBoxContainer/StorageInfoSorterHBoxContainer/Storage2HolderVBoxContainer/Storage2DataVBoxContainer/Storage2RequiredLabel
@onready var storage_2_provided_label: Label = $Panel/VBoxContainer/VBoxContainer/StorageInfoSorterHBoxContainer/Storage2HolderVBoxContainer/Storage2DataVBoxContainer/Storage2ProvidedLabel
@onready var storage_3_name_label: Label = $Panel/VBoxContainer/VBoxContainer/StorageInfoSorterHBoxContainer/Storage3HolderVBoxContainer/Storage3NameLabel
@onready var storage_3_required_label: Label = $Panel/VBoxContainer/VBoxContainer/StorageInfoSorterHBoxContainer/Storage3HolderVBoxContainer/Storage3DataVBoxContainer/Storage3RequiredLabel
@onready var storage_3_provided_label: Label = $Panel/VBoxContainer/VBoxContainer/StorageInfoSorterHBoxContainer/Storage3HolderVBoxContainer/Storage3DataVBoxContainer/Storage3ProvidedLabel
@onready var community_happiness_progress_bar: ProgressBar = $Panel/VBoxContainer/VBoxContainer/CommunityHappinessVBoxContainer/CommunityHappinessProgressBar


func _ready() -> void:
	Global.game_ended_signal.connect(_on_game_ended)
	storage_1_name_label.text = Global.storage_1_name
	storage_2_name_label.text = Global.storage_2_name
	storage_3_name_label.text = Global.storage_3_name
	set_storage_ui_data()
	red_style_box.bg_color = Color.RED
	yellow_style_box.bg_color = Color.ORANGE
	green_style_box.bg_color = Color.GREEN

func _on_game_ended(value: bool) -> void:
	if value:
		set_process(false)
	else:
		set_process(true)


func _process(_delta: float) -> void:
	set_community_happiness_progress_value()
	set_storage_ui_data()

func set_storage_ui_data() -> void:
	storage_1_provided_label.text = "Provided: " + str(int(Global.storage_tank_1_value)) + "%"
	storage_2_provided_label.text = "Provided: " + str(int(Global.storage_tank_2_value)) + "%"
	storage_3_provided_label.text = "Provided: " + str(int(Global.storage_tank_3_value)) + "%"
	storage_1_required_label.text = "Required: " + str(int(Global.storage_tank_1_required_value)) + "%"
	storage_2_required_label.text = "Required: " + str(int(Global.storage_tank_2_required_value)) + "%"
	storage_3_required_label.text = "Required: " + str(int(Global.storage_tank_3_required_value)) + "%"
	if int(Global.storage_tank_1_value) != int(Global.storage_tank_1_required_value):
		storage_1_provided_label.self_modulate = Color.RED
	else:
		storage_1_provided_label.self_modulate = Color.GREEN
	if int(Global.storage_tank_2_value) != int(Global.storage_tank_2_required_value):
		storage_2_provided_label.self_modulate = Color.RED
	else:
		storage_2_provided_label.self_modulate = Color.GREEN
	if int(Global.storage_tank_3_value) != int(Global.storage_tank_3_required_value):
		storage_3_provided_label.self_modulate = Color.RED
	else:
		storage_3_provided_label.self_modulate = Color.GREEN


func set_community_happiness_progress_value() -> void:
	community_happiness_progress_bar.value = Global.community_happiness_value
	if Global.community_happiness_value <= 30:
		if current_community_happiness_progress_bar_stylebox_in_use != red_style_box:
			current_community_happiness_progress_bar_stylebox_in_use = red_style_box
			community_happiness_progress_bar.add_theme_stylebox_override("fill", red_style_box)
	elif Global.community_happiness_value > 30 and Global.community_happiness_value < 70:
		if current_community_happiness_progress_bar_stylebox_in_use != yellow_style_box:
			current_community_happiness_progress_bar_stylebox_in_use = yellow_style_box
			community_happiness_progress_bar.add_theme_stylebox_override("fill", yellow_style_box)
	else:
		if current_community_happiness_progress_bar_stylebox_in_use != green_style_box:
			current_community_happiness_progress_bar_stylebox_in_use = green_style_box
			community_happiness_progress_bar.add_theme_stylebox_override("fill", green_style_box)
