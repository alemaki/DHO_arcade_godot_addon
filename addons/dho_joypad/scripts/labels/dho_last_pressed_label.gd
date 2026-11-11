# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: Look at dho_joypad.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends DHOLocalizedLabel

func _ready() -> void:
	assert(self.localized_text_res != null)
	self.set_text(self.localized_text_res.get_text()+ ": ")
	DhoJoypad.dho_button_pressed.connect(self._on_button_pressed)

func _on_button_pressed(button: DHOJoypad.BUTTON, _device: int):
	self.set_text("%s: %s" % [
		self.localized_text_res.get_text(),
		DHOJoypad.BUTTON_INFORMATION[button].button_name
	])
