## Copyright (c) 2026 Alexander Makedonski
## SPDX-License-Identifier: MIT

# NOTE: Look at dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Label

@export var display_text: String = "Last pressed button: "

func _ready() -> void:
	self.set_text(self.display_text)
	DhoJoypad.dho_button_pressed.connect(self._on_button_pressed)

func _on_button_pressed(button: DHOJoypad.BUTTON):
	self.set_text("%s: %s" % [self.display_text, DHOJoypad.BUTTON_NAMES[button]])
