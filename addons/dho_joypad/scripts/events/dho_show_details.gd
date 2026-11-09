# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See dho_joypad.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends DHOEvent
class_name DHOShowDetails

# Yeah this is ugly. Too lazy to do it the right way...
static func get_all_button_detectors(root: Node) -> Array[DHODetailedLabel]:
	var button_detectors: Array[DHODetailedLabel] = []
	if root is DHODetailedLabel:
		button_detectors.push_back(root)
	for child in root.get_children():
		button_detectors += get_all_button_detectors(child)
	return button_detectors

func execute() -> void:
	var root := self.get_tree().get_root()
	var press_buttons: Array[DHODetailedLabel] = get_all_button_detectors(root)
	for button in press_buttons:
		button.show_details()
