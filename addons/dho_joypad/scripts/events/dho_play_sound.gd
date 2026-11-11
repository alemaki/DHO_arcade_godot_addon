# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

extends DHOEvent
class_name DHOPlaySound

@export var player: AudioStreamPlayer = null

func execute() -> void:
	if !player:
		print("AudioStreamPlayer NOT SET IN DHOPlaySound event.")
		return
	player.set_playing(not player.is_playing())
