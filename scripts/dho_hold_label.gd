"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

# NOTE: See dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Label

# Measured in seconds
@export var max_hold_duration: float =  3
@export var button_capture: DHOInput.BUTTON = DHOInput.BUTTON.A
@export var name_of_event: String = "START"
@export var hold_event: DHOEvent = null
@export var input_node: DHOInput = null

func update_text() -> void:
	var display_text := "Hold %s = %-7s (%.1fs / %.1fs)" % [
		DHOInput.BUTTON_NAMES[self.button_capture],
		self.name_of_event,
		min(input_node.get_button_hold_duration_sec(self.button_capture), self.max_hold_duration),
		self.max_hold_duration
		]
	self.set_text(display_text)

func _ready() -> void:
	assert(input_node != null)
	self.update_text()

func _process(_delta: float) -> void:
	self.update_text()
	if self.input_node.get_button_hold_duration_sec(self.button_capture) >= self.max_hold_duration:
		if !hold_event:
			print(self.get_name() + ": No hold event configured")
		else:
			hold_event.execute()
