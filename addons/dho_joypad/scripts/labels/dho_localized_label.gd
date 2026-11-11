# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends Label
class_name DHOLocalizedLabel

@export var localized_text: DHOLocalizedText = null

func _ready() -> void:
	assert(localized_text != null)
	self.set_text(localized_text.get_text())
