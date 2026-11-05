"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

@tool
extends Label

# NOTE: Look at dho_input.gd for more information.

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var direction := DHOInput.get_input_vector()
	self.set_text("X=%3.2f, Y=%3.2f" % [direction.x, direction.y])
