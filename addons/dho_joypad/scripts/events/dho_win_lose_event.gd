# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

## You can use this node to switch to different [DHOScene]. Normally when the game ends
## you should switch to the save_score.tscn. You can do whatever you want, tho. Set is_win before
## switching to know if the player won or lost. Other info will be handled.
## NOTE: This node requires a current [DHOScene]. If not set it will search for it.
extends DHOEvent
class_name DHOWinLoseEvent

@export_file("*.tscn") var win_lose_scene: String = "res://addons/dho_joypad/scenes/dho_save_score.tscn"
@export var dho_scene: DHOScene = null
@export var is_win: bool = false

func execute() -> void:
	if self.dho_scene == null:
		self.dho_scene = DHOScene._walk_parents_to_find_dho_scene(self)
	assert(self.dho_scene != null)
	dho_scene.dho_context.is_win = self.is_win
	DHOSceneManager.change_scene(self, win_lose_scene, dho_scene.dho_context)
