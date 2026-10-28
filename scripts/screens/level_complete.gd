extends Control

func _ready() -> void:
	%NextButton.visible = GameState.has_next_level()
	%NextButton.pressed.connect(_on_next_pressed)
	%HomeButton.pressed.connect(_on_home_pressed)

func _on_next_pressed() -> void:
	print("Next button dab gaya!")
	GameState.next_level()

func _on_home_pressed() -> void:
	print("Home button dab gaya!")
	GameState.go_home()
