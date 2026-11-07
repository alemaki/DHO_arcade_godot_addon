## Copyright (c) 2026 Alexander Makedonski
## SPDX-License-Identifier: MIT

# NOTE: Look at dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Label

@export var input_node: DHOJoypad = null
@export var display_text: String = "Currently pressed buttons: "

func _ready() -> void:
	assert(input_node != null)
	self.set_text(self.display_text)

func _process(_delta: float) -> void:
	var first: bool = true
	var result_text: String = self.display_text
	for button in DHOJoypad.BUTTON.values():
		if input_node.is_button_pressed(button):
			if first:
				result_text += DHOJoypad.BUTTON_NAMES[button]
				first = false
			else:
				result_text += ", " + DHOJoypad.BUTTON_NAMES[button]
	self.set_text(result_text)
