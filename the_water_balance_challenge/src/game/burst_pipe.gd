extends StaticBody2D

var pipe_burst: bool = false
var pipe_can_function: bool = false
var mouse_in_area: bool = false
var fixing_pipe: bool = false
const MIN_TIMER_VALUE: float = 40
const MAX_TIMER_VALUE: float = 100
const LOSS_VALUE: int = 1

@onready var pipe_burst_timer: Timer = $PipeBurstTimer
@onready var point_loss_timer: Timer = $PointLossTimer
@onready var fix_progress_bar: ProgressBar = $FixProgressBar
@onready var explode_fire: AnimatedSprite2D = $ExplodeFire
@onready var notice_label: Label = $NoticeLabel
@export var pipe_group: Global.all_storage_containers_list

func _ready() -> void:
	randomize()
	Global.game_ended_signal.connect(_on_game_ended)
	Global.game_objective_sent_signal.connect(_on_game_objective_sent)

func _on_game_ended(value: bool) -> void:
	if value:
		pipe_burst_timer.stop()
		point_loss_timer.stop()
		pipe_burst = false
		pipe_can_function = false
		mouse_in_area = false
		fixing_pipe = false
		notice_label.hide()
		fix_progress_bar.hide()
		set_process(false)
		set_process_unhandled_input(false)
	else:
		pipe_can_function = true

func _on_game_objective_sent() -> void:
	prepare_to_burst_pipe()

func _unhandled_input(event: InputEvent) -> void:
	if pipe_can_function and pipe_burst:
		if event is InputEventMouseButton:
			Global.set_focused_item(self)

func prepare_to_burst_pipe():
	pipe_burst_timer.wait_time = randf_range(MIN_TIMER_VALUE, MAX_TIMER_VALUE)
	pipe_burst_timer.start()

func fix_pipe() -> void:
	fix_progress_bar.show()
	fix_progress_bar.value = 0
	notice_label.hide()
	set_process(true)

func _process(delta: float) -> void:
	if fix_progress_bar.value < fix_progress_bar.max_value:
		fix_progress_bar.value += 100 * delta
		if fix_progress_bar.value == fix_progress_bar.max_value:
			fix_progress_bar.hide()
			pipe_burst = false
			point_loss_timer.stop()
			explode_fire.play("extinguish")
			prepare_to_burst_pipe()
			set_process(false)

func _on_point_loss_timer_timeout() -> void:
	Global.update_community_happiness(-LOSS_VALUE)
	if pipe_burst:
		point_loss_timer.start()


func _on_pipe_burst_timer_timeout() -> void:
	pipe_burst = true
	point_loss_timer.start()
	explode_fire.play("starting")
	notice_label.show()
	if pipe_group == Global.all_storage_containers_list.CONTAINER_1:
		Global.note_burst_pipe(1)
	elif pipe_group == Global.all_storage_containers_list.CONTAINER_2:
		Global.note_burst_pipe(2)
	elif pipe_group == Global.all_storage_containers_list.CONTAINER_3:
		Global.note_burst_pipe(3)


func _on_mouse_entered() -> void:
	if pipe_can_function and pipe_burst:
		mouse_in_area = true


func _on_mouse_exited() -> void:
	if pipe_can_function:
		mouse_in_area = false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if Global.focused_item == self:
		fix_pipe()


func _on_explode_fire_animation_finished() -> void:
	if explode_fire.animation == "starting":
		explode_fire.play("burning")
