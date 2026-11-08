# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

@tool
extends Node
# You know... As in DevHubOne
class_name DHOJoypad
# The documentation below is for any godot version from 4.x <= 4.8.
# They might be compatible for future versions or might not be. ¯\_(ツ)_/¯

# To learn how best to use the DevHubOne joypad, please read the designated documentation.
# The code part of this class might be or might not be relevant for you. Depends on how deep of an
# implementation you want to create with the joypad.
""" -------------------------------------------------------------------------------------------- """
""" SECTION: BUTTONS """
""" -------------------------------------------------------------------------------------------- """

# NOTE: Documentation for this section ends here.

signal dho_button_pressed(button: DHOJoypad.BUTTON, device: int)
signal dho_button_released(button: DHOJoypad.BUTTON, device: int)

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

const BUTTON_INFORMATION: Dictionary[BUTTON, DHOButtonInformation] = {
	DHOJoypad.BUTTON.A: preload("res://addons/dho_joypad/resources/buttons/dho_button_a.tres"),
	DHOJoypad.BUTTON.B: preload("res://addons/dho_joypad/resources/buttons/dho_button_b.tres"),
	DHOJoypad.BUTTON.C: preload("res://addons/dho_joypad/resources/buttons/dho_button_c.tres"),
	DHOJoypad.BUTTON.D: preload("res://addons/dho_joypad/resources/buttons/dho_button_d.tres"),
	DHOJoypad.BUTTON.E: preload("res://addons/dho_joypad/resources/buttons/dho_button_e.tres"),
	DHOJoypad.BUTTON.F: preload("res://addons/dho_joypad/resources/buttons/dho_button_f.tres"),
	DHOJoypad.BUTTON.PLAY: preload("res://addons/dho_joypad/resources/buttons/dho_button_play.tres"),
	DHOJoypad.BUTTON.EXIT: preload("res://addons/dho_joypad/resources/buttons/dho_button_exit.tres"),
}

# TODO: generate programatically
const EVENT_TRIGGER_BUTTONS: Dictionary[JoyButton, BUTTON] = {
	JOY_BUTTON_Y:				DHOJoypad.BUTTON.A,
	JOY_BUTTON_B:				DHOJoypad.BUTTON.B,
	JOY_BUTTON_A:				DHOJoypad.BUTTON.C,
	JOY_BUTTON_X:				DHOJoypad.BUTTON.D,
	JOY_BUTTON_LEFT_SHOULDER:	DHOJoypad.BUTTON.E,
	JOY_BUTTON_RIGHT_SHOULDER:	DHOJoypad.BUTTON.F,
	JOY_BUTTON_START:			DHOJoypad.BUTTON.PLAY,
	JOY_BUTTON_BACK:			DHOJoypad.BUTTON.EXIT,
}

class ButtonContext extends RefCounted:
	# If currently pressed
	var is_pressed: bool = false
	# Engine time in which the press started in ms
	var press_started: float = 0.

# Will be generated at _ready
var button_contexts: Dictionary[BUTTON, ButtonContext] = {}


""" -------------------------------------------------------------------------------------------- """
""" SECTION: JOYSTICK """
""" -------------------------------------------------------------------------------------------- """
# NOTE: The devhubone joystick is captured by the default godot action input mappings:
# ui_left, ui_right, ui_up, ui_down. I am sure those are descriptive enough.
#
# New projects in Godot have them ON by default. You can see the godot built-in actions
# by going into: Project -> Project Settings -> Input Map -> Show Built-In-Actions.
# Feel free to define yours if you want to. The instructions are below.
# WARNING: DELETING the default input mappings for the joystick actions will obviously result in you
# not being able to use them. You will have to define your input map for the joystick or return the
# defaults. I recommend using the defaults since they are better integrated in the engine and even
# have interactions with the UI.
# 
# You can capture the joystick events by defining your own action names 
# (for example 'process_[direction]') and setting the input capture to:
# 'process_left' : Joypad Axis 0 - (Left stick Left, Joystick 0 Left)
# 'process_right': Joypad Axis 0 + (Left stick Right, Joystick 0 Right)
# 'process_up'   : Joypad Axis 1 - (Left stick Up, Joystick 0 Up)
# 'process_down' : Joypad Axis 1 + (Left stick Down, Joystick 0 Down)
# 
# Then just capture the mappings:
# var axis_X: float = Input.get_axis("process_left", "process_right")
# var axis_Y: float = Input.get_axis("process_up", "process_down")
# Or ("ui_left, ui_right") and ("ui_up, ui_down") if you have defaults on.
#
# Feel free to get the direct input with:
# var input_left: float = Input.get_action_strength("ui_left") # for example
#
# WARNING: DO NOT USE Input.get_vector like this:
# var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
# As of currently (06.11.2026), joypad inputs will result with some error along the axis
# that is not pressed when calling the Input.get_vector with combination of keyboard input.
# Issue to resolve: https://github.com/godotengine/godot/issues/90515#issuecomment-2616602880
#
# NOTE: Documentation for this section ends here.

var left_joystick_X_axis: float = 0.
var left_joystick_Y_axis: float = 0.
# NOTE: The function below does not return normalised input.
# I am using only raw input here so the devhubone_test_scene will work regardless of input mappings.
func get_input_vector(device: int) -> Vector2:
	return Vector2(self.left_joystick_X_axis, self.left_joystick_Y_axis)

func get_normalized_input_vector(device: int) -> Vector2:
	return get_input_vector(device).normalized()

""" -------------------------------------------------------------------------------------------- """
""" SECTION: NODE FUNCTIONS """
""" -------------------------------------------------------------------------------------------- """

func _init():
	for button in BUTTON.values():
		self.button_contexts[button] = ButtonContext.new()

func _process(_delta: float):
	pass

""" -------------------------------------------------------------------------------------------- """
""" SECTION: INPUT HANDLING """
""" -------------------------------------------------------------------------------------------- """
# NOTE: The devhubone joystick can also be captured by using the general joypad input events.
# Take a look at _input() to see how the input events can be handled.
#
# You can use this node in your scenes to capture input only for joypad.
#
# NOTE: Documentation for this section ends here.

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.is_pressed() && EVENT_TRIGGER_BUTTONS.has(event.get_button_index()):
			self._button_pressed(EVENT_TRIGGER_BUTTONS[event.get_button_index()], event.device)
		elif event.is_released() && EVENT_TRIGGER_BUTTONS.has(event.get_button_index()):
			self._button_released(EVENT_TRIGGER_BUTTONS[event.get_button_index()], event.device)
	
	if event is InputEventJoypadMotion:
		if event.axis == 0:
			self.left_joystick_X_axis = event.axis_value
		elif event.axis == 1:
			self.left_joystick_Y_axis = event.axis_value

func is_button_pressed(button: BUTTON) -> bool:
	return button_contexts[button].is_pressed

# Returns 0 if button is not held
func get_button_hold_duration_msec(button: BUTTON) -> float:
	if not button_contexts[button].is_pressed:
		return 0.
	return Time.get_ticks_msec() - button_contexts[button].press_started

func get_button_hold_duration_sec(button: BUTTON) -> float:
	if not button_contexts[button].is_pressed:
		return 0.
	return (Time.get_ticks_msec() - button_contexts[button].press_started) / 1000.

func get_button_last_held_time_msec(button: BUTTON) -> float:
	return (Time.get_ticks_msec() - button_contexts[button].press_started)
	
func get_button_last_held_time_sec(button: BUTTON) -> float:
	return (Time.get_ticks_msec() - button_contexts[button].press_started) / 1000.

func _button_pressed(button: BUTTON, device: int) -> void:
	# Signal for this button should fire only once when it's pressed.
	self.dho_button_pressed.emit(button)
	button_contexts[button].press_started = Time.get_ticks_msec()
	button_contexts[button].is_pressed = true

func _button_released(button: BUTTON, device: int) -> void:
	# Signal for this button should fire only once when it's released.
	self.dho_button_released.emit(button)
	button_contexts[button].is_pressed = false
