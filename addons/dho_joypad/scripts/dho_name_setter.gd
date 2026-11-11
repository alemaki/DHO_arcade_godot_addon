# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends HBoxContainer

const LETTER_COUNT = DHOPlayerScoreData.NAME_SIZE
# TODO: there's gotta be a better solution for this.
const CHARACTER_CYCLE: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
var current_letter = 0
var character_indexes: Array[int] = []
var letter_labels: Array[Label] = []

@export var dho_scene: DHOScene = null

@export var bad_name_label: Label = null

@export var left_action = "ui_left"
@export var right_action = "ui_right"
@export var up_action = "ui_up"
@export var down_action = "ui_down"
@export var save_action = "ui_accept"
@export var exit_action = "ui_back"

@export_file("*.tscn") var accept_scene_to_change_to = "res://addons/dho_joypad/scenes/dho_win_lose.tscn"
@export_file("*.tscn") var back_scene_to_change_to = "res://addons/dho_joypad/scenes/dho_win_lose.tscn"

func _ready() -> void:
	if self.dho_scene == null:
		self.dho_scene = DHOScene._walk_parents_to_find_dho_scene(self)
	assert(dho_scene != null)
	assert(bad_name_label != null)
	bad_name_label.set_visible(false)
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
	var result_name: String = ""
	for i in LETTER_COUNT:
		result_name += CHARACTER_CYCLE[character_indexes[i]]
	return result_name

func try_to_save_score(player_score_data: DHOPlayerScoreData) -> bool:
	var score_data: DHOScoreDataHolder = DHOScoreDataHolder.load_scores()
	if score_data == null:
		return false
	var saved: bool = score_data.add_score(player_score_data)
	if not saved:
		return false
	return score_data.save_scores()

func try_save() -> bool:
	var player_score_data: DHOPlayerScoreData = DHOPlayerScoreData.new()
	player_score_data.name = self.get_result_name()
	player_score_data.score = self.dho_scene.dho_context.score
	self.dho_scene.dho_context.is_score_saved = self.try_to_save_score(player_score_data)
	var result := await DHOSceneManager.change_scene(
		self,
		accept_scene_to_change_to,
		self.dho_scene.dho_context
	)
	if result != OK:
		return false
	return true

func show_bad_name_label():
	self.bad_name_label.set_visible(true)

func hide_bad_name_label():
	self.bad_name_label.set_visible(false)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(self.left_action):
		self.current_letter -= 1
		if self.current_letter < 0:
			self.current_letter = LETTER_COUNT - 1
	if Input.is_action_just_pressed(right_action):
		self.current_letter += 1
		self.current_letter %= LETTER_COUNT
	if Input.is_action_just_pressed(self.up_action):
		self.character_indexes[current_letter] -= 1
		if self.character_indexes[current_letter] < 0:
			self.character_indexes[current_letter] = CHARACTER_CYCLE.length() - 1
	if Input.is_action_just_pressed(self.down_action):
		self.character_indexes[self.current_letter] += 1
		self.character_indexes[self.current_letter] %= CHARACTER_CYCLE.length()
	if Input.is_action_just_pressed(self.save_action):
		if not DHOPlayerScoreData.is_name_valid(self.get_result_name()):
			self.show_bad_name_label()
			self.get_tree().create_timer(2).timeout.connect(self.hide_bad_name_label)
		elif not await self.try_save():
			push_warning("Something went horribly wrong.")
	if Input.is_action_just_pressed(self.exit_action):
		DHOSceneManager.change_scene(self, back_scene_to_change_to, self.dho_scene.dho_context)
	self.update_labels()
