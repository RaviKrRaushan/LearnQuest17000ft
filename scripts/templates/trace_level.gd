extends Control

@onready var title_label: Label = %TitleLabel
@onready var info_label: Label = %InfoLabel
@onready var back_button: Button = %BackButton
@onready var finish_button: Button = %FinishButton

func _ready() -> void:
	var data := GameState.level_data
	title_label.text = "Level %d: %s" % [GameState.current_level, data.get("title", "")]
	info_label.text = "Tracing yahan aayegi (%d numbers)" % data.get("items", []).size()
	back_button.pressed.connect(GameState.go_home)
	finish_button.pressed.connect(GameState.complete_level)
