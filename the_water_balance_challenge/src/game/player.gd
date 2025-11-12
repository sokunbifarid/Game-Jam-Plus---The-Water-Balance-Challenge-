extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var can_control_character: bool = true
const SPEED: float = 10000

func _ready() -> void:
	Global.game_ended_signal.connect(_on_game_ended)
	Global.resource_management_active_signal.connect(_on_resource_management_active)

func _on_game_ended(value: bool):
	if value:
		can_control_character = false
		set_physics_process(false)
		set_process_input(false)
	else:
		can_control_character = true
		set_physics_process(true)
		set_process_input(true)
	animated_sprite_2d.play("idle")

func _on_resource_management_active(value: bool, _id: int) -> void:
	if value:
		can_control_character = false
	else:
		can_control_character = true
	animated_sprite_2d.play("idle")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		set_next_target_position(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	if can_control_character:
		var direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = direction * SPEED * delta
		if velocity.x > 0:
			if animated_sprite_2d.flip_h != true:
				animated_sprite_2d.flip_h = true
		else:
			if animated_sprite_2d.flip_h != false:
				animated_sprite_2d.flip_h = false
		move_and_slide()

func set_next_target_position(pos: Vector2) -> void:
	if can_control_character:
		navigation_agent_2d.target_position = pos
		set_physics_process(true)
		animated_sprite_2d.play("walk")

func _on_navigation_agent_2d_navigation_finished() -> void:
	animated_sprite_2d.play("idle")
	set_physics_process(false)
