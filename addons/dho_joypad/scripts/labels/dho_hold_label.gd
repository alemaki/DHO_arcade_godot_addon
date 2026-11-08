# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See dho_joypad.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Label

@export var name_of_event: String = "START"
@export var hold_trigger_node: DHOHoldTrigger = null

func update_text() -> void:
	var display_text := "Hold %s = %-7s (%.1fs / %.1fs)" % [
		DHOJoypad.BUTTON_INFORMATION[self.hold_trigger_node.button_capture].button_name,
		self.name_of_event,
		min(DhoJoypad.get_button_hold_duration_sec(self.hold_trigger_node.button_capture),
			self.hold_trigger_node.max_hold_duration),
		self.hold_trigger_node.max_hold_duration
		]
	self.set_text(display_text)

func _ready() -> void:
	assert(hold_trigger_node != null)
	self.update_text()

func _process(_delta: float) -> void:
	self.update_text()
