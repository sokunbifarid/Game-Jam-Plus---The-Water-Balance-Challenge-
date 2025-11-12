extends Control

func _ready() -> void:
	Global.resource_management_active_signal.connect(_on_resource_management_active)
	self.hide()

func _on_resource_management_active(value: bool, _id: int) -> void:
	if value:
		self.show()

func _on_close_texture_button_pressed() -> void:
	self.hide()
	Global.set_resource_management_active(false)
