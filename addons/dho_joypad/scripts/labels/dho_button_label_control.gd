# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See dho_joypad.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends DHODetailedLabel # TODO: This doesn't make sense to be detailed label, make a better solution!!!!

@export var button_capture: DHOJoypad.BUTTON = DHOJoypad.BUTTON.A

@onready var TEXT_WIDTH	:= maxi(
	tr("TEST_SCENE_TEXT_ON").length(),
	tr("TEST_SCENE_TEXT_OFF").length()
	)
@onready var ON_TEXT	:= "[%s]" % [tr("TEST_SCENE_TEXT_ON").rpad(TEXT_WIDTH)]
@onready var OFF_TEXT	:= "[%s]" % [tr("TEST_SCENE_TEXT_OFF").rpad(TEXT_WIDTH)]

func show_details() -> void:
	self.is_showing_details = not self.is_showing_details
	self.update_text()

func update_text(is_on: bool = false) -> void:
	var display_text := "%s" % [(ON_TEXT if is_on else OFF_TEXT)]
	display_text += " %s" % [DHOJoypad.BUTTON_INFORMATION[self.button_capture].button_name]
	if self.is_showing_details:
		display_text += " (%s)" % [DHOJoypad.BUTTON_INFORMATION[self.button_capture].event_name]
	self.set_text(display_text)

func _ready() -> void:
	# Won't assert missing resources
	self.update_text(false)
	DhoJoypad.dho_button_pressed.connect(self._on_button_pressed)
	DhoJoypad.dho_button_released.connect(self._on_button_released)

# I can also check in process but that is better i think
func _on_button_pressed(button: DHOJoypad.BUTTON, _device: int) -> void:
	if button == self.button_capture:
		self.update_text(true)

func _on_button_released(button: DHOJoypad.BUTTON, _device: int) -> void:
	if button == self.button_capture:
		self.update_text(false)
