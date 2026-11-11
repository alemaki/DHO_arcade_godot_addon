# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends DHOLocalizedLabel
class_name ScoreLabel

@export var dho_scene: DHOScene = null

func _ready() -> void:
	super._ready()
	if self.dho_scene == null:
		self.dho_scene = DHOScene._walk_parents_to_find_dho_scene(self)
	assert(dho_scene != null)
	self.set_text("%s: %06d" % [
		self.localized_text_res.get_text(),
		dho_scene.dho_context.player_info.score
		])
