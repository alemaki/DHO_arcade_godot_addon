"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

# NOTE: See dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends DetailedLabel

@export var button_capture: DHOInput.BUTTON = DHOInput.BUTTON.A
@export var input_node: DHOInput = null

const ON_TEXT  := "[ON ]"
const OFF_TEXT := "[OFF]"

func show_details() -> void:
	self.is_showing_details = not self.is_showing_details
	self.update_text()

func update_text(is_on: bool = false) -> void:
	var display_text := "%s" % [(ON_TEXT if is_on else OFF_TEXT)]
	display_text += " %s" % [DHOInput.BUTTON_NAMES[self.button_capture]]
	if self.is_showing_details:
		display_text += "  (%s)" % [DHOInput.BUTTON_EVENT_NAMES[self.button_capture]]
	self.set_text(display_text)

func _ready() -> void:
	assert(input_node != null)
	self.update_text(false)
	input_node.dho_button_pressed.connect(self._on_button_pressed)
	input_node.dho_button_released.connect(self._on_button_released)

# I can also check in process but that is better i think
func _on_button_pressed(button: DHOInput.BUTTON) -> void:
	if button == self.button_capture:
		self.update_text(true)

func _on_button_released(button: DHOInput.BUTTON) -> void:
	if button == self.button_capture:
		self.update_text(false)
