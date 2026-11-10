# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends Label
class_name score_label

@export var display_text: String = "Score: "
@onready @export var dho_scene: DHOScene = self.get_tree().current_scene

func _ready() -> void:
	assert(dho_scene != null)
	self.set_text("%s %06d" % [
		display_text,
		dho_scene.dho_context.player_info.score
		])
