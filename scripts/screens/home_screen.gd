extends Control

@onready var grade1_button: Button = %Grade1Button

func _ready() -> void:
	grade1_button.pressed.connect(_on_grade1_pressed)

func _on_grade1_pressed() -> void:
	GameState.start_grade(1)
