# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: Look at dho_joypad.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.

extends Label

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var direction := DhoJoypad.get_input_vector(0) # 0 is the default device, I think...
	self.set_text("X=%3.2f, Y=%3.2f" % [direction.x, direction.y])
