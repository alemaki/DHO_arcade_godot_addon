# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends DHOLocalizedLabel

@export var dho_scene: DHOScene = null

func _ready() -> void:
	super._ready()
	if self.dho_scene == null:
		self.dho_scene = DHOScene._walk_parents_to_find_dho_scene(self)
	assert(dho_scene != null)
	DhoJoypad.dho_button_pressed.connect(self._on_button_pressed)
	self.update_text()

func update_text():
	self.set_text("%s: %06d" % [
		self.localized_text_res.get_text(),
		self.dho_scene.dho_context.score
	])

func _on_button_pressed(button: DHOJoypad.BUTTON, device):
	if button == DHOJoypad.BUTTON.A:
		self.dho_scene.dho_context.score += 10
		self.update_text()
	
