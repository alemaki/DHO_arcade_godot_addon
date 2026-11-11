# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends Label
class_name DHOLocalizedLabel

@export var localized_text_res: DHOLocalizedText = null

func _ready() -> void:
	assert(localized_text_res != null)
	self.set_text(localized_text_res.get_text())
