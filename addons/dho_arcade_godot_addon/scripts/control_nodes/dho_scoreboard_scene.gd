# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game.

extends DHOScene

@export var start_action = "ui_accept"
## Set this to your game's start scene. It can be a [DHOScene] type, but not required.
@export_file("*.tscn") var start_scene = "res://addons/dho_arcade_godot_addon/scenes/dho_joypad_test.tscn"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(self.start_action):
		await DHOSceneManager.change_scene_to_path(self, start_scene)
