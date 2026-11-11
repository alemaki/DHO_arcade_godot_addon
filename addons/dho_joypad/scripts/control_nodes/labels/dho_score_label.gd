# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

## You can use this score label in your games. See how in the score_saver or win_lose scene.
extends DHOLocalizedLabel
class_name DHOScoreLabel

@export var dho_scene: DHOScene = null

func _ready() -> void:
	super._ready()
	if self.dho_scene == null:
		self.dho_scene = DHOScene._walk_parents_to_find_dho_scene(self)
	assert(dho_scene != null)
	self.set_text("%s: %06d" % [
		self.localized_text_res.get_text(),
		dho_scene.dho_context.score
		])
