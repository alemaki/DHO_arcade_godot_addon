"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

# NOTE: See dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.
@tool
extends Label

# Measured in seconds
@export var max_hold_duration: float =  3 # TODO: Change to 3 seconds later
@export var button_capture: DHOInput.BUTTON = DHOInput.BUTTON.A
@export var name_of_event: String = "START"
@export var hold_event: DHOEvent = null

var current_hold_duration: float = 0
var is_currently_pressed = false

func update_text() -> void:
	var display_text := "Hold %s = %-7s (%.1fs / %.1fs)" % [
		DHOInput.BUTTON_NAMES[self.button_capture],
		self.name_of_event,
		self.current_hold_duration,
		self.max_hold_duration
		]
	self.set_text(display_text)

func _ready() -> void:
	self.update_text()

func _process(delta: float) -> void:
	if self.is_currently_pressed:
		self.current_hold_duration += delta
		self.update_text()
	if self.current_hold_duration >= self.max_hold_duration:
		if !hold_event:
			print(self.get_name() + ": No hold event configured")
		else:
			hold_event.execute()
		self.current_hold_duration = 0

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.is_pressed()\
			&& event.get_button_index() == DHOInput.BUTTON_EVENT_TRIGGERS[self.button_capture]:
			self.is_currently_pressed = true
		elif event.is_released()\
			&& event.get_button_index() == DHOInput.BUTTON_EVENT_TRIGGERS[self.button_capture]:
			self.is_currently_pressed = false
			self.current_hold_duration = 0
			self.update_text()
