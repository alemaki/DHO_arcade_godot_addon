# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

## You are not required to do localization in your game but this might help
extends Resource
class_name DHOLocalizedText

@export var format: String = ""
@export var text_keys: Array[String] = []

func get_text() -> String:
	# TODO: do i need to set language somewhere or godot knows?
	#var preferred_language = OS.get_locale_language()
	#print("Language: ", preferred_language)
	# TranslationServer.set_locale("bg")
	var result_arr: Array[String] = []
	for text_key in self.text_keys:
		result_arr.push_back(TranslationServer.translate(text_key)) # TODO: warning if no translation?
	return self.format % result_arr
