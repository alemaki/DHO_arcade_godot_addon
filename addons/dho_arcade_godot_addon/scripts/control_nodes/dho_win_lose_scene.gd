# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends DHOScene
class_name DHOWinLoseScene

@export var play_again_action = "ui_accept"
@export var menu_action = "ui_back"
## Set this to your game's start scene. It can be a [DHOScene] type, but not required.
@export_file("*.tscn") var play_again_scene = "res://addons/dho_arcade_godot_addon/scenes/dho_joypad_test.tscn"
## Leave this as the default.
@export_file("*.tscn") var menu_scene = "res://addons/dho_arcade_godot_addon/scenes/dho_scoreboard.tscn"

@export var score_saved_label: Label = null

@export var win_lose_label: Label = null
@export var win_text_ref: DHOLocalizedText = null
@export var lose_text_ref: DHOLocalizedText = null

func _ready() -> void:
	assert(self.win_text_ref != null)
	assert(self.lose_text_ref != null)
	assert(self.score_saved_label != null)
	assert(self.win_lose_label != null)
	super._ready()
	if self.dho_context.is_score_saved:
		self.score_saved_label.set_visible(true)
	else:
		self.score_saved_label.set_visible(false)
	
	if self.dho_context.is_win:
		self.win_lose_label.set_text(win_text_ref.get_text())
	else:
		self.win_lose_label.set_text(lose_text_ref.get_text())


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(self.play_again_action):
		await DHOSceneManager.change_scene_to_path(self, self.play_again_scene)
	if Input.is_action_just_pressed(self.menu_action):
		await DHOSceneManager.change_scene_new_context(self, self.menu_scene)
