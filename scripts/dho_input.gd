"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

@tool
extends Node
# You know... As in DevHubOne
class_name DHOInput
# The documentation below is for any godot version from 4.x <= 4.8.
# They might be compatible for future versions or might not be.
""" -------------------------------------------------------------------------------------------- """
""" SECTION: BUTTONS """
""" -------------------------------------------------------------------------------------------- """

enum BUTTON {
	A,
	B,
	C,
	D,
	E,
	F,
	PLAY,
	EXIT
}

const BUTTON_NAMES: Dictionary = {
	DHOInput.BUTTON.A :		"A",
	DHOInput.BUTTON.B :		"B",
	DHOInput.BUTTON.C :		"C",
	DHOInput.BUTTON.D :		"D",
	DHOInput.BUTTON.E :		"E",
	DHOInput.BUTTON.F :		"F",
	DHOInput.BUTTON.PLAY :	"Play (Left)",
	DHOInput.BUTTON.EXIT :	"ChangeGame (Right)",
}


const GODOT_BUTTON_MAPPING: Dictionary = {
	DHOInput.BUTTON.A :		"ui_select",
	DHOInput.BUTTON.B :		"", # no default godot mapping.
	DHOInput.BUTTON.C :		"", # no default godot mapping.
	DHOInput.BUTTON.D :		"ui_colorpicker_delete_preset",
	DHOInput.BUTTON.E :		"", # no default godot mapping.
	DHOInput.BUTTON.F :		"", # no default godot mapping.
	DHOInput.BUTTON.PLAY :	"", # no default godot mapping.
	DHOInput.BUTTON.EXIT :	"", # no default godot mapping.
}

const BUTTON_EVENT_TRIGGERS: Dictionary = {
	DHOInput.BUTTON.A:		JOY_BUTTON_Y, 				# Joypad Button 3 (Top Action, Sony Triangle, Xbox Y, Nintendo X) - All devices
	DHOInput.BUTTON.B:		JOY_BUTTON_B, 				# Joypad Button 1 (Right Action, Sony Circle, Xbox B, Nintendo A) - All devices
	DHOInput.BUTTON.C:		JOY_BUTTON_A, 				# Joypad Button 0 (Bottom Action, Sony Cross, Xbox A, Nintendo B) - All devices
	DHOInput.BUTTON.D:		JOY_BUTTON_X, 				# Joypad Button 2 (Left Action, Sony Square, Xbox X, Nintendo Y) - All devices
	DHOInput.BUTTON.E:		JOY_BUTTON_LEFT_SHOULDER, 	# Joypad Button 9 (Left Shoulder, Sony L1, Xbox LB)
	DHOInput.BUTTON.F:		JOY_BUTTON_RIGHT_SHOULDER, 	# Joypad Button 10 (Right Shoulder, Sony R1, Xbox RB)
	DHOInput.BUTTON.PLAY: 	JOY_BUTTON_START, 			# Joypad Button 6 (Start, Xbox Menu, Nintendo +)
	DHOInput.BUTTON.EXIT: 	JOY_BUTTON_BACK 			# Joypad Button 4 (Back, Sony Select, Xbox Back, Nintendo -)
}

const BUTTON_EVENT_NAMES: Dictionary = {
	DHOInput.BUTTON.A:		"Joypad Button 3 (Top Action, Sony Triangle, Xbox Y, Nintendo X)-All devices",
	DHOInput.BUTTON.B:		"Joypad Button 1 (Right Action, Sony Circle, Xbox B, Nintendo A)-All devices",
	DHOInput.BUTTON.C:		"Joypad Button 0 (Bottom Action, Sony Cross, Xbox A, Nintendo B)-All devices",
	DHOInput.BUTTON.D:		"Joypad Button 2 (Left Action, Sony Square, Xbox X, Nintendo Y)-All devices",
	DHOInput.BUTTON.E:		"Joypad Button 9 (Left Shoulder, Sony L1, Xbox LB)",
	DHOInput.BUTTON.F:		"Joypad Button 10 (Right Shoulder, Sony R1, Xbox RB)",
	DHOInput.BUTTON.PLAY: 	"Joypad Button 6 (Start, Xbox Menu, Nintendo +)",
	DHOInput.BUTTON.EXIT: 	"Joypad Button 4 (Back, Sony Select, Xbox Back, Nintendo -)",
}

""" -------------------------------------------------------------------------------------------- """
""" SECTION: JOYPAD """
""" -------------------------------------------------------------------------------------------- """
# We are using the default movement names (ui_left, ui_right, etc.) here.
#
# WARNING: IF you have DELETED the input mapping for the events mentioned above,
# this test script WILL NOT WORK!!!!
#
# New projects in Godot have them ON by default. You can see the godot built-in actions
# by going into: Project -> Project Settings -> Input Map -> Show Built-In-Actions.
# Feel free to define yours if you want to. The instructions are below.
#
# The devhubone joystick is captured by the default actions ui_left, ui_right, ui_up, ui_down.
# I am sure those are descriptive enough.
#
# You can capture the joystick events by defining your own action names 
# (for example 'process_[direction]') and setting the input capture to: 
# 'process_left' : Joypad Axis 0 - (Left stick Left, Joystick 0 Left)
# 'process_right': Joypad Axis 0 + (Left stick Right, Joystick 0 Right)
# 'process_up'   : Joypad Axis 1 - (Left stick Up, Joystick 0 Up)
# 'process_Down' : Joypad Axis 1 + (Left stick Down, Joystick 0 Down)
#
# NOTE: The function below does not return normalised input.
static func get_input_vector() -> Vector2:
	var axis_X: float = Input.get_axis("ui_left", "ui_right")
	var axis_Y: float = Input.get_axis("ui_up", "ui_down")
	
	# WARNING: DO NOT USE Input.get_vector like this:
	# var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# As of currently (04.11.2026), joypad inputs will result with some error along the axis
	# that is not pressed when calling the Input.get_vector.
	# Issue to resolve: https://github.com/godotengine/godot/issues/90515#issuecomment-2616602880
	#
	# Feel free to get the direct input with:
	# var input_left: float = Input.get_action_strength("ui_left")
	
	return Vector2(axis_X, axis_Y)
