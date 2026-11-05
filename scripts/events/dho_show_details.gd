"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

# NOTE: See dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.
extends DHOEvent
class_name DHOShowDetails

# Yeah this is ugly. Too lazy to do it the right way...
static func get_all_button_detectors(root: Node) -> Array[DHOButtonDetector]:
	var button_detectors: Array[DHOButtonDetector] = []
	if root is DHOButtonDetector:
		button_detectors.push_back(root)
	for child in root.get_children():
		button_detectors += get_all_button_detectors(child)
	return button_detectors

func execute() -> void:
	var root := self.get_tree().get_root()
	var press_buttons: Array[DHOButtonDetector] = get_all_button_detectors(root)
	for button in press_buttons:
		button.show_details()
