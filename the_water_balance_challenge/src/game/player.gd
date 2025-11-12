extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var navigation_agent_completed_task: bool = true
var can_control_character: bool = true
const SPEED: float = 10000

func _ready() -> void:
	Global.game_ended_signal.connect(_on_game_ended)
	Global.resource_management_active_signal.connect(_on_resource_management_active)

func _on_game_ended(value: bool):
	if value:
		can_control_character = false
		set_physics_process(false)
	else:
		can_control_character = true
		set_physics_process(true)
	animated_sprite_2d.play("idle")

func _on_resource_management_active(value: bool, _id: int) -> void:
	if value:
		can_control_character = true
	else:
		can_control_character = false
	animated_sprite_2d.play("idle")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		set_next_target_position(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	if can_control_character:
		if not navigation_agent_completed_task:
			var direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
			velocity = direction * SPEED * delta
			if velocity.length() > 0 or velocity.length() < 0:
				if velocity.x > 0:
					animated_sprite_2d.flip_h = true
				else:
					animated_sprite_2d.flip_h = false
			move_and_slide()

func set_next_target_position(pos: Vector2) -> void:
	if can_control_character:
		navigation_agent_completed_task = false
		navigation_agent_2d.target_position = pos
		animated_sprite_2d.play("walk")

func _on_navigation_agent_2d_navigation_finished() -> void:
	navigation_agent_completed_task = true
	animated_sprite_2d.play("idle")
