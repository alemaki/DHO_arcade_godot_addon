# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

@tool
extends Node

# You know... As in DevHubOne
## An autoloaded 
class_name DHOJoypad
# To learn how best to use the DevHubOne joypad, please read the README located at the root of the addon.
# The code part of this class might be or might not be relevant for you. Depends on how deep of an
# implementation you want to create with the joypad.
#
# WARNING: This node is autoloaded by the plugin. Disabling the autoload of this node (or disabling
# the plugin) will BREAK the joypad test scene provided by this plugin.
# You can see the autoloads in Project settings -> Globals.

""" -------------------------------------------------------------------------------------------- """
""" SECTION: DEVICE CONTEXTS """
""" -------------------------------------------------------------------------------------------- """

const MAX_DEVICES_HANDLED_SETTING_PATH := "DHO/arcade/max_devices_handled"
const MAX_DEVICES_HANDLED_DEFAULT_VALUE := 2

## Context for the joypad measurements.
class _DHOJoypadContext extends RefCounted:
	var device: int = 0
	## Will be generated at _init
	var button_contexts: Dictionary[BUTTON, ButtonContext] = {}
	var left_joystick_X_axis: float = 0.
	var left_joystick_Y_axis: float = 0.
	
	func _init() -> void:
		for button in BUTTON.values():
			self.button_contexts[button] = ButtonContext.new()

var _device_contexts: Dictionary[int, _DHOJoypadContext] = {}

static func get_max_devices_handled() -> int:
	return ProjectSettings.get_setting(
			MAX_DEVICES_HANDLED_SETTING_PATH,
			MAX_DEVICES_HANDLED_DEFAULT_VALUE,
		)

func is_device_valid(device: int) -> bool:
	if device >= get_max_devices_handled():
		return false
	return true

""" -------------------------------------------------------------------------------------------- """
""" SECTION: BUTTONS """
""" -------------------------------------------------------------------------------------------- """
# TODO: create interaction between "ui_back" and control nodes?
# "ui_cancel" is mapped to esc. not proper for this purpose

## Attach to this to listen for button input events.
signal dho_button_pressed(button: DHOJoypad.BUTTON, device: int)
## Attach to this to listen for button input events.
signal dho_button_released(button: DHOJoypad.BUTTON, device: int)

## All current DHOJoypad buttons
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

## All relevant information for the button enums above
const BUTTON_INFORMATION: Dictionary[BUTTON, DHOButtonInformation] = {
	DHOJoypad.BUTTON.A: preload("res://addons/dho_arcade_addon/resources/buttons/dho_button_a.tres"),
	DHOJoypad.BUTTON.B: preload("res://addons/dho_arcade_addon/resources/buttons/dho_button_b.tres"),
	DHOJoypad.BUTTON.C: preload("res://addons/dho_arcade_addon/resources/buttons/dho_button_c.tres"),
	DHOJoypad.BUTTON.D: preload("res://addons/dho_arcade_addon/resources/buttons/dho_button_d.tres"),
	DHOJoypad.BUTTON.E: preload("res://addons/dho_arcade_addon/resources/buttons/dho_button_e.tres"),
	DHOJoypad.BUTTON.F: preload("res://addons/dho_arcade_addon/resources/buttons/dho_button_f.tres"),
	DHOJoypad.BUTTON.PLAY: preload("res://addons/dho_arcade_addon/resources/buttons/dho_button_play.tres"),
	DHOJoypad.BUTTON.EXIT: preload("res://addons/dho_arcade_addon/resources/buttons/dho_button_exit.tres"),
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
	## If currently pressed
	var is_pressed: bool = false
	## Engine time in which the press started in ms
	var press_started: float = 0.
	## in ms
	var last_held_duration: float = 0.

## Param device = -1 for any device.
func is_button_pressed(button: BUTTON, device: int = -1) -> bool:
	assert(self.is_device_valid(device))
	if device < 0:
		for device_context in self._device_contexts.values():
			if  device_context.button_contexts[button].is_pressed:
				return true
	else:
		return self._device_contexts[device].button_contexts[button].is_pressed
	return false

## Returns 0 if button is not held. Defaults to device 0 if param device = -1.
func get_button_hold_duration_msec(button: BUTTON, device: int = -1) -> float:
	assert(self.is_device_valid(device))
	if device < 0:
		device = 0
	if not self._device_contexts[device].button_contexts[button].is_pressed:
		return 0.
	return Time.get_ticks_msec()\
		 - self._device_contexts[device].button_contexts[button].press_started

## Returns 0 if button is not held. Defaults to device 0 if param device = -1.
func get_button_hold_duration_sec(button: BUTTON, device: int = -1) -> float:
	return self.get_button_hold_duration_msec(button, device) / 1000.0

## Returns last held time for the button. (current not included)
## Defaults to device 0 if param device = -1.
func get_button_last_held_time_msec(button: BUTTON, device: int = -1) -> float:
	assert(self.is_device_valid(device))
	if device < 0:
		device = 0
	return self._device_contexts[device].button_contexts[button].last_held_duration

## Returns last held time for the button. (current not included)
## Defaults to device 0 if param device = -1.
func get_button_last_held_time_sec(button: BUTTON, device: int = -1) -> float:
	return self.get_button_last_held_time_msec(button, device) / 1000.0

## Handle for event.
func _button_pressed(button: BUTTON, device: int) -> void:
	# Signal for this button should fire only once when it's pressed.
	var button_context: ButtonContext = self._device_contexts[device].button_contexts[button]
	button_context.press_started = Time.get_ticks_msec()
	button_context.is_pressed = true
	self.dho_button_pressed.emit(button, device)

## Handle for event.
func _button_released(button: BUTTON, device: int) -> void:
	# Signal for this button should fire only once when it's released.
	var button_context: ButtonContext = self._device_contexts[device].button_contexts[button]
	button_context.is_pressed = false
	button_context.last_held_duration = Time.get_ticks_msec() - button_context.press_started
	self.dho_button_released.emit(button, device)

""" -------------------------------------------------------------------------------------------- """
""" SECTION: JOYSTICK """
""" -------------------------------------------------------------------------------------------- """

## Emits normalized input
signal dho_joystick_changed(vector: Vector2, device: int)

# This currently is only used in plugin registration for actions
const AXIS_INFORMATION: Array[DHOJoystickAxisInformation] = [
	preload("res://addons/dho_arcade_addon/resources/axes/X_left.tres"),
	preload("res://addons/dho_arcade_addon/resources/axes/X_right.tres"),
	preload("res://addons/dho_arcade_addon/resources/axes/Y_up.tres"),
	preload("res://addons/dho_arcade_addon/resources/axes/Y_down.tres"),
]

var _last_movement_device_change: int = -1

# This function defaults to device 0 in device = -1, because not sure how I am supposed to handle
# multiple device inputs for axes.
## NOTE: The function below does not return normalised input.
## I am using only raw input here so the devhubone_test_scene will work regardless of input actions.
## If device = -1 will default to device that last changed movement.
func get_input_vector(device: int = -1) -> Vector2:
	assert(self.is_device_valid(device))
	if device == -1:
		if _last_movement_device_change == -1:
			device = 0
		else:
			device = _last_movement_device_change
	return Vector2(
			self._device_contexts[device].left_joystick_X_axis, 
			self._device_contexts[device].left_joystick_Y_axis
	)

## If device = -1 it will default to 0.
func get_normalized_input_vector(device: int = -1) -> Vector2:
	return get_input_vector(device).normalized()

func _axis_x_changed(axis_value: float, device: int) -> void:
	self._device_contexts[device].left_joystick_X_axis = axis_value
	self._last_movement_device_change = device
	self.dho_joystick_changed.emit(self.get_normalized_input_vector(device), device)


func _axis_y_changed(axis_value: float, device: int) -> void:
	self._device_contexts[device].left_joystick_Y_axis = axis_value
	self._last_movement_device_change = device
	self.dho_joystick_changed.emit(self.get_normalized_input_vector(device), device)

""" -------------------------------------------------------------------------------------------- """
""" SECTION: NODE FUNCTIONS """
""" -------------------------------------------------------------------------------------------- """

func _init() -> void:
	for device in get_max_devices_handled():
		var device_context := _DHOJoypadContext.new()
		device_context.device = device
		self._device_contexts[device] = device_context

""" -------------------------------------------------------------------------------------------- """
""" SECTION: INPUT HANDLING """
""" -------------------------------------------------------------------------------------------- """

@export_range(0.0, 1, 0.001)
var axis_deadzone: float = 0.5 # default in godot

func _input(event: InputEvent) -> void:
	if not self.is_device_valid(event.device):
		return
	if event is InputEventJoypadButton:
		if event.is_pressed() && EVENT_TRIGGER_BUTTONS.has(event.get_button_index()):
			self._button_pressed(EVENT_TRIGGER_BUTTONS[event.get_button_index()], event.device)
		elif event.is_released() && EVENT_TRIGGER_BUTTONS.has(event.get_button_index()):
			self._button_released(EVENT_TRIGGER_BUTTONS[event.get_button_index()], event.device)
	
	if event is InputEventJoypadMotion:
		if absf(event.axis_value) < self.axis_deadzone:
			event.axis_value = 0
		if event.axis == 0:
			self._axis_x_changed(event.axis_value, event.device)
		elif event.axis == 1:
			self._axis_y_changed(event.axis_value, event.device)
