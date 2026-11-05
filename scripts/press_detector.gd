"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

# NOTE: See dho_input.gd for more information.

@tool
extends Label

@export var button_capture: DHOInput.BUTTON = DHOInput.BUTTON.A

const ON_TEXT  := "[ON ]"
const OFF_TEXT := "[OFF]"

func update_text(is_on: bool = false) -> void:
	var display_text := "%s" % [(ON_TEXT if is_on else OFF_TEXT)]
	display_text += " %s" % [DHOInput.BUTTON_NAMES[self.button_capture]]
	display_text += "  (%s)" % [DHOInput.BUTTON_EVENT_NAMES[self.button_capture]]
	self.set_text(display_text)

func _ready() -> void:
	self.update_text(false)

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.is_pressed()\
			&& event.get_button_index() == DHOInput.BUTTON_EVENT_TRIGGERS[self.button_capture]:
			self.update_text(true)
		elif event.is_released()\
			&& event.get_button_index() == DHOInput.BUTTON_EVENT_TRIGGERS[self.button_capture]:
			self.update_text(false)
