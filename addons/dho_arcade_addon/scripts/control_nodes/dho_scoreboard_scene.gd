# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game.

extends DHOScene

@export var start_action = "ui_accept"
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(self.start_action):
		await DHOSceneManager.change_scene_to_path(
				self.get_tree(),
				DHOSceneManager.get_game_start_scene_path(),
			)
