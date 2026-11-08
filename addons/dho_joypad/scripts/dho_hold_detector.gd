# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: Look at dho_joypad.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Node
class_name DHOHoldTrigger

# Measured in seconds
@export var max_hold_duration = 3
@export var button_capture: DHOJoypad.BUTTON = DHOJoypad.BUTTON.A
@export var trigger_event: DHOEvent = null

# Shouldn't fire multiple times.
var fired = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if not self.fired\
		and DhoJoypad.get_button_hold_duration_sec(self.button_capture) >= self.max_hold_duration:
		self.fired = true
		if trigger_event != null:
			trigger_event.execute()
	elif self.fired\
		and DhoJoypad.get_button_hold_duration_sec(self.button_capture) < self.max_hold_duration:
		self.fired = false
