# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

## You are not required to do localization in your game but this might help
extends Resource
class_name DHOLocalizedText

@export var format: String = ""
@export var text_keys: Array[String] = []

func get_text() -> String:
	var result_arr: Array[String] = []
	for text_key in self.text_keys:
		var text: String = TranslationServer.translate(text_key)
		if text == text_key:
			push_warning("DHOLocalizedText: Missing translation for key: %s, locale: %s)" % [
				text_key,
				TranslationServer.get_locale()
			])
		result_arr.push_back(text)
	var placeholder_count: int = self.format.replace("%%", "").count("%")
	if placeholder_count != result_arr.size():
		push_warning("DHOLocalizedText: format '%s' has %d placeholders but %d keys" % [
			self.format,
			placeholder_count,
			result_arr.size()
		])
		return self.format
	return self.format % result_arr
