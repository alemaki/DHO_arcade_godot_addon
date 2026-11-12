# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends DHOLocalizedLabel

@export var name_of_event_res: DHOLocalizedText = null
@export var hold_trigger_node: DHOHoldTrigger = null

func update_text() -> void:
	var button_info := DHOJoypad.BUTTON_INFORMATION[self.hold_trigger_node.button_capture]
	var display_text := "%s %s = %-7s (%.1fs / %.1fs)" % [
		self.localized_text_res.get_text(),
		button_info.button_name,
		self.name_of_event_res.get_text(),
		min(DhoJoypad.get_button_hold_duration_sec(self.hold_trigger_node.button_capture),
				self.hold_trigger_node.max_hold_duration),
		self.hold_trigger_node.max_hold_duration
		]
	self.set_text(display_text)

func _ready() -> void:
	super._ready()
	assert(self.name_of_event_res != null)
	if self.hold_trigger_node == null:
		self.hold_trigger_node = $DHOHoldTrigger
	assert(self.hold_trigger_node != null)
	self.update_text()

func _process(_delta: float) -> void:
	self.update_text()
