# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

# NOTE: See the README.md for more information.
# This scripts' purpose is to be a part of the DevHubOne's plugin scenes.
# It is not intended to be used in your game. 
# Make of that what you will.

## This class stores localized keys and writes them in the given format. You can make use of it,
## however I would recommend against it in a game jam setting, because you won't need localization.
extends Resource
class_name DHOLocalizedText

@export var format: String = ""
@export var text_keys: Array[String] = []

func get_text() -> String:
	var result_arr: Array[String] = []
	for text_key in self.text_keys:
		var text: String = TranslationServer.translate(text_key)
		if text == text_key:
			DHOWarner.warn_once("DHOLocalizedText: Missing translation for key: %s, locale: %s)" % [
				text_key,
				TranslationServer.get_locale()
			])
		result_arr.push_back(text)
	var placeholder_count: int = self.format.replace("%%", "").count("%")
	if placeholder_count != result_arr.size():
		DHOWarner.warn_once("DHOLocalizedText: format '%s' has %d placeholders but %d keys" % [
			self.format,
			placeholder_count,
			result_arr.size()
		])
		return self.format
	return self.format % result_arr
