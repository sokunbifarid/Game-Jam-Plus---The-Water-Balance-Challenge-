extends Control

@onready var available_percentage_label: Label = $ContainerHolderPanel/ContainerVBoxContainer/AvailablePercentageLabel

func _ready() -> void:
	Global.resource_management_active_signal.connect(_on_resource_management_active)
	self.hide()
	set_process(false)


func _on_resource_management_active(value: bool, _id: int) -> void:
	if value:
		self.show()
	else:
		if visible:
			self.hide()

func _process(_delta: float) -> void:
	available_percentage_label.text = "Available Percentage: " + str(Global.get_available_percentage())

func _on_close_texture_button_pressed() -> void:
	self.hide()
	Global.set_resource_management_active(false)


func _on_visibility_changed() -> void:
	if visible:
		set_process(true)
	else:
		set_process(false)
