# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See dho_joypad.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends DHOEvent
class_name DHOWinLoseEvent

@export var win_lose_scene: String = "res://addons/dho_joypad/scenes/dho_win_lose.tscn"
@export var dho_scene: DHOScene = self.get_tree().current_scene
@export var is_win: bool = false

func execute() -> void:
	assert(self.dho_scene != null)
	dho_scene.dho_context.is_win = self.is_win
	DHOSceneManager.change_scene(self, win_lose_scene, dho_scene.dho_context)
