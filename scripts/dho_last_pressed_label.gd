"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

# NOTE: Look at dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Label

@export var input_node: DHOInput = null
@export var display_text: String = "Last pressed button: "

func _ready() -> void:
	assert(input_node != null)
	self.set_text(self.display_text)
	input_node.dho_button_pressed.connect(self._on_button_pressed)

func _on_button_pressed(button: DHOInput.BUTTON):
	self.set_text("%s: %s" % [self.display_text, DHOInput.BUTTON_NAMES[button]])
