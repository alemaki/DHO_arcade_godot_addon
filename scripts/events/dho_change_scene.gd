"""
Copyright (c) 2026 Alexander Makedonski
SPDX-License-Identifier: MIT
"""

# NOTE: See dho_input.gd for more information.
# This scripts' purpose is for the devhubone test scene. It is not intended to be used in your game.
# Make of that what you will.
extends DHOEvent
class_name DHOChangeScene

@export var scene: PackedScene = null

func execute() -> void:
	if !scene:
		print("SCENE NOT SET IN DHOChangeScene event.")
		return
	# TODO: load scene
