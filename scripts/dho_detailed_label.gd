"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

# NOTE: See dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Label
class_name DetailedLabel

@export var fixed_text: String = ""
@export var no_details_text: String = ""
@export var details_text: String = ""
@export var is_showing_details: bool = false

func show_details() -> void:
	self.is_showing_details = not self.is_showing_details
	self.update_text()

func update_text() -> void:
	var display_text := fixed_text
	if self.is_showing_details:
		display_text += details_text
	else:
		display_text += no_details_text
	self.set_text(display_text)

func _ready() -> void:
	self.update_text()
