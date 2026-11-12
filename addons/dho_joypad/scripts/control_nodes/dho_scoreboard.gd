# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends VBoxContainer
class_name DHOScoreboard

const BEST_SCORE_COUNT = 10
var player_data_holder: DHOPlayerDataHolder = null

@export var start_action = "ui_accept"
@export_file("*.tscn") var start_scene = "res://addons/dho_joypad/scenes/dho_joypad_test.tscn"

func _ready() -> void:
	self.player_data_holder = DHOPlayerDataHolder.load_player_data()
	assert(self.player_data_holder != null)
	var index: int = 1
	for player_data in self.player_data_holder.get_player_data(BEST_SCORE_COUNT):
		var label: Label = Label.new()
		label.text = "#%02d   %s   %06d" % [index, player_data.name, player_data.score]
		index += 1
		self.add_child(label)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(self.start_action):
		DHOSceneManager.change_scene_new_context(self, start_scene)
