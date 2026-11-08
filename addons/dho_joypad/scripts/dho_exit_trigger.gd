# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends Node
class_name DHOExitTrigger

# Measured in seconds
@export var second_press_trigger_time_window: float = 1.
var pressed_once: bool = false
# Children will be removed so they will not be processed in the scene and only added on exit button.
var hidden_children: Array[Node] = []

func hide_children() -> void:
	self.hidden_children = self.get_children()
	for child in self.get_children():
		self.remove_child(child)

func show_children() -> void:
	for child in self.hidden_children:
		self.add_child(child)

func _ready() -> void:
	self.hide_children()
	DhoJoypad.dho_button_pressed.connect(self._on_button_pressed)


func _on_button_pressed(button: DHOJoypad.BUTTON) -> void:
	if button == DHOJoypad.BUTTON.EXIT:
		if not pressed_once:
			self.pressed_once = true
			self.get_tree()\
				.create_timer(second_press_trigger_time_window)\
				.timeout\
				.connect(self._on_first_press_timeout)
			self.show_children()
		else:
			self.get_tree().quit()

func _on_first_press_timeout() -> void:
	self.hide_children()
	self.pressed_once = false


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for child in self.hidden_children:
			child.queue_free()
