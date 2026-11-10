# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends VBoxContainer
class_name DHOScoreboard

const BEST_SCORE_COUNT = 10
var score_holder: ScoreDataHolder = null

@export var start_action = "ui_accept"
@export var start_scene = "res://addons/dho_joypad/scenes/dho_joypad_test.tscn"

func _ready() -> void:
	score_holder = ScoreDataHolder.load_scores()
	var index: int = 1
	for score_data in self.score_holder.get_scores(BEST_SCORE_COUNT):
		var label: Label = Label.new()
		label.text = "#%d   %s   %06d" % [index, score_data.name, score_data.score]
		index += 1
		self.add_child(label)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(self.start_action):
		DHOSceneManager.change_scene_new_context(self, start_scene)
