# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends Label
class_name DHODetailedLabel

@export var fixed_text_res: DHOLocalizedText = null
@export var details_text_res: DHOLocalizedText = null
@export var no_details_text_res: DHOLocalizedText = null
@export var is_showing_details: bool = false

func _ready() -> void:
	assert(self.fixed_text_res != null)
	assert(self.no_details_text_res != null)
	assert(self.details_text_res != null)
	self.add_to_group(DHOShowDetails.GROUP_NAME)
	self.update_text()

func show_details() -> void:
	self.is_showing_details = not self.is_showing_details
	self.update_text()

func update_text() -> void:
	var display_text := self.fixed_text_res.get_text()
	if self.is_showing_details:
		display_text += self.details_text_res.get_text()
	else:
		display_text += self.no_details_text_res.get_text()
	self.set_text(display_text)
