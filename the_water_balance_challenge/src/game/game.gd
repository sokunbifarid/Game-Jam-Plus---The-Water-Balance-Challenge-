extends Node

var objective_id: int = 0
var game_ended: bool = false
var game_started: bool = false

const COMMUNITY_HAPPINESS_LOSS_VALUE: int = 5
const DELAY_BEFORE_STARTING_GAME_LOOP: int = 5
const DELAY_BEFORE_NEXT_GAME_LOOP: int = 120
const STARTING_COMMUNITY_HAPPINESS: int = 72
const STORAGE_1_REQUIRED_VALUE_LIST: Array = [30,40,10,20,30,40,10,20,30,40,10,20,30,40,10,20]
const STORAGE_2_REQUIRED_VALUE_LIST: Array = [50,10,25,25,50,10,25,25,50,10,25,25,50,10,25,25]
const STORAGE_3_REQUIRED_VALUE_LIST: Array = [20,50,65,55,20,50,65,55,20,50,65,55,20,50,65,55]

@onready var game_progress_timer: Timer = $GameProgressTimer
@onready var tutorial: Control = $InGameUI/Tutorial
@onready var notice_label: Label = $InGameUI/GameNotice/NoticeLabel
@onready var notice_animation_player: AnimationPlayer = $InGameUI/GameNotice/NoticeAnimationPlayer
@onready var community_happiness_loss_timer: Timer = $CommunityHappinessLossTimer

func _ready() -> void:
	randomize()
	tutorial.show()
	Global.set_game_ended(false)
	Global.game_ended_signal.connect(_on_game_ended)
	Global.pipe_burst_signal.connect(_on_pipe_burst)
	Global.update_community_happiness(STARTING_COMMUNITY_HAPPINESS)

func _on_game_ended(value: bool) -> void:
	game_ended = true
	game_started = false
	if value:
		game_progress_timer.stop()
		set_process(false)
	else:
		set_process(true)

func _on_pipe_burst(_value: int) -> void:
	set_notice_for_damages()

func _on_tutorial_close_texture_button_pressed() -> void:
	game_ended = false
	game_progress_timer.wait_time = DELAY_BEFORE_STARTING_GAME_LOOP
	game_progress_timer.start()
	tutorial.hide()

func _process(_delta: float) -> void:
	if game_started:
		if community_happiness_loss_timer.time_left == 0:
			if int(Global.storage_tank_1_value) != int(Global.storage_tank_1_required_value) or int(Global.storage_tank_2_value) != int(Global.storage_tank_2_required_value) or int(Global.storage_tank_3_value) != int(Global.storage_tank_3_required_value):
				community_happiness_loss_timer.start()

func begin_game_loop() -> void:
	objective_id = randi_range(0, STORAGE_1_REQUIRED_VALUE_LIST.size() - 1)
	Global.storage_tank_1_required_value = STORAGE_1_REQUIRED_VALUE_LIST[objective_id]
	Global.storage_tank_2_required_value = STORAGE_2_REQUIRED_VALUE_LIST[objective_id]
	Global.storage_tank_3_required_value = STORAGE_3_REQUIRED_VALUE_LIST[objective_id]
	set_notice_for_water_volume()
	Global.send_out_game_objective_sent()
	game_progress_timer.wait_time = DELAY_BEFORE_NEXT_GAME_LOOP
	game_progress_timer.start()
	game_started = true

func set_notice_for_water_volume() -> void:
	notice_label.text = "PROVIDE NEEDED \nPERCENTAGE OF WATER!"
	notice_animation_player.play("scale")

func set_notice_for_damages() -> void:
	notice_label.text = "FIX BROKEN PIPES!"
	notice_animation_player.play("scale")


func _on_game_progress_timer_timeout() -> void:
	if game_progress_timer.wait_time == DELAY_BEFORE_STARTING_GAME_LOOP:
		begin_game_loop()
	elif game_progress_timer.wait_time == DELAY_BEFORE_NEXT_GAME_LOOP:
		begin_game_loop()

func _on_community_happiness_loss_timer_timeout() -> void:
	if int(Global.storage_tank_1_value) != int(Global.storage_tank_1_required_value) or int(Global.storage_tank_2_value) != int(Global.storage_tank_2_required_value) or int(Global.storage_tank_3_value) != int(Global.storage_tank_3_required_value):
		Global.update_community_happiness(-COMMUNITY_HAPPINESS_LOSS_VALUE)
	else:
		Global.update_community_happiness(COMMUNITY_HAPPINESS_LOSS_VALUE)
