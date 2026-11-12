# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends HBoxContainer

const LETTER_COUNT = DHOPlayerData.NAME_SIZE
# There's gotta be a better solution for this.
const CHARACTER_CYCLE: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
var current_letter := 0
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

@export_file("*.tscn") var accept_scene_to_change_to = "res://addons/dho_arcade_godot_addon/scenes/dho_win_lose.tscn"
@export_file("*.tscn") var back_scene_to_change_to = "res://addons/dho_arcade_godot_addon/scenes/dho_win_lose.tscn"

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
	
	# No need to save a score that is not a new highscore!
	if not DHOPlayerDataHolder.is_new_highscore(dho_scene.dho_context.score):
		self.set_process(false)
		# Call deferred since scene is still loading in _ready
		self.call_deferred("go_next_scene", accept_scene_to_change_to)

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

func try_save_player_data(player_data: DHOPlayerData) -> bool:
	var player_data_holder: DHOPlayerDataHolder = DHOPlayerDataHolder.load_player_data()
	if player_data_holder == null:
		return false
	var saved: bool = player_data_holder.add_player_data(player_data)
	if not saved:
		return false
	return player_data_holder.save_player_data()

func create_and_save_player_data() -> void:
	var player_data: DHOPlayerData = DHOPlayerData.new()
	player_data.name = self.get_result_name()
	player_data.score = self.dho_scene.dho_context.score
	self.dho_scene.dho_context.is_score_saved = self.try_save_player_data(player_data)

func go_next_scene(scene_path: String) -> Error:
	var result := await DHOSceneManager.change_scene(
			self,
			scene_path,
			self.dho_scene.dho_context
	)
	return result

func show_bad_name_label() -> void:
	self.bad_name_label.set_visible(true)

func hide_bad_name_label() -> void:
	self.bad_name_label.set_visible(false)

func handle_input_label_change() -> void:
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

func handle_input_scene_change() -> void:
	if Input.is_action_just_pressed(self.save_action):
		if not DHOPlayerData.is_name_valid(self.get_result_name()):
			self.show_bad_name_label()
			self.get_tree().create_timer(2).timeout.connect(self.hide_bad_name_label)
		else:
			self.create_and_save_player_data()
			if await go_next_scene(self.accept_scene_to_change_to) != OK:
				push_warning("ScoreSaver: Something went horribly wrong.")
				self.get_tree().quit() # not okay if player can save scores multiple times.
	if Input.is_action_just_pressed(self.exit_action):
		if await go_next_scene(self.back_scene_to_change_to) != OK:
			push_warning("ScoreSaver: Something went horribly wrong.")

func _process(_delta: float) -> void:
	self.handle_input_label_change()
	self.handle_input_scene_change()
	self.update_labels()
