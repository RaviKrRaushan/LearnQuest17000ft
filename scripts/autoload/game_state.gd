extends Node

const SAVE_PATH := "user://progress.json"
const HOME_SCENE := "res://scenes/screens/home_screen.tscn"
const COMPLETE_SCENE := "res://scenes/screens/level_complete.tscn"

const TEMPLATE_SCENES := {
	"trace": "res://scenes/templates/trace/trace_level.tscn",
}

var current_grade: int = 1
var current_level: int = 1
var level_data: Dictionary = {}
var highest_unlocked: Dictionary = {}

func _ready() -> void:
	_load_progress()

func start_grade(grade: int) -> void:
	current_grade = grade
	start_level(1)

func start_level(level: int) -> void:
	var data := _read_level_file(current_grade, level)
	if data.is_empty():
		push_error("Level data nahi mila: grade %d level %d" % [current_grade, level])
		return
	var template: String = data.get("template", "")
	if not TEMPLATE_SCENES.has(template):
		push_error("Unknown template: " + template)
		return
	current_level = level
	level_data = data
	get_tree().change_scene_to_file(TEMPLATE_SCENES[template])

func complete_level() -> void:
	if has_next_level():
		var key := str(current_grade)
		highest_unlocked[key] = maxi(highest_unlocked.get(key, 1), current_level + 1)
		_save_progress()
	get_tree().change_scene_to_file(COMPLETE_SCENE)

func has_next_level() -> bool:
	return FileAccess.file_exists(_level_path(current_grade, current_level + 1))

func next_level() -> void:
	start_level(current_level + 1)

func go_home() -> void:
	get_tree().change_scene_to_file(HOME_SCENE)

func _level_path(grade: int, level: int) -> String:
	return "res://data/grade_%d/level_%02d.json" % [grade, level]

func _read_level_file(grade: int, level: int) -> Dictionary:
	var path := _level_path(grade, level)
	if not FileAccess.file_exists(path):
		return {}
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed if parsed is Dictionary else {}

func _save_progress() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(highest_unlocked))

func _load_progress() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if parsed is Dictionary:
		highest_unlocked = parsed
