# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends DHOLocalizedLabel

func _ready() -> void:
	super._ready()
	self.set_text(self.localized_text_res.get_text() + ": ")

func _process(_delta: float) -> void:
	var first: bool = true
	var result_text: String = self.localized_text_res.get_text() + ": "
	for button in DHOJoypad.BUTTON.values():
		if DhoJoypad.is_button_pressed(button):
			if first:
				result_text += DHOJoypad.BUTTON_INFORMATION[button].button_name
				first = false
			else:
				result_text += ", " + DHOJoypad.BUTTON_INFORMATION[button].button_name
	self.set_text(result_text)
