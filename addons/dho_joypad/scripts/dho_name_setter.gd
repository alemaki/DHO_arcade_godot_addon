extends HBoxContainer

# TODO: there's gotta be a better solution for this.
const LETTER_COUNT = PlayerScoreData.NAME_SIZE
const CHARACTER_CYCLE: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
var current_letter = 0
var character_indexes: Array[int] = []
var letter_labels: Array[Label] = []

@export var left_action = "ui_left"
@export var right_action = "ui_right"
@export var up_action = "ui_up"
@export var down_action = "ui_down"
@export var save_action = "ui_select"

func _ready() -> void:
	character_indexes.resize(LETTER_COUNT)
	character_indexes.fill(0)
	letter_labels.resize(LETTER_COUNT)
	for i in LETTER_COUNT:
		letter_labels[i] = Label.new()
		self.add_child(letter_labels[i])
	self.update_labels()

func update_labels() -> void:
	for i in LETTER_COUNT:
		letter_labels[i].set_text(CHARACTER_CYCLE[character_indexes[i]])
	for letter_label in self.letter_labels:
		letter_label.modulate = Color.WHITE
	letter_labels[current_letter].modulate = Color.GREEN

func get_result_name() -> String:
	var name: String = ""
	for i in LETTER_COUNT:
		name += CHARACTER_CYCLE[character_indexes[i]]
	return name

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(left_action):
		current_letter -= 1
		if current_letter < 0:
			current_letter = LETTER_COUNT - 1
	if Input.is_action_just_pressed(right_action):
		current_letter += 1
		current_letter %= LETTER_COUNT
	if Input.is_action_just_pressed(up_action):
		character_indexes[current_letter] -= 1
		if character_indexes[current_letter] < 0:
			character_indexes[current_letter] = CHARACTER_CYCLE.length() - 1
	if Input.is_action_just_pressed(down_action):
		character_indexes[current_letter] += 1
		character_indexes[current_letter] %= CHARACTER_CYCLE.length()
	self.update_labels()
