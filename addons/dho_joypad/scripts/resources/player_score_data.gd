# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends Resource
class_name PlayerScoreData

# Currently the size of the name is fixed to 3 symbols (digits and letters)
const NAME_SIZE: int = 3
# Currently fixed to six digits
const MAX_SCORE: int = 999999
const BAD_WORDS_FILE_PATH: String = "res://addons/dho_joypad/resources/bad_words.txt"
@export var score: int = 0
@export var name: String = ""

## Use this to verify resource
func is_data_valid() -> bool:
	if self.score < 0 || self.score > MAX_SCORE:
		return false
	return is_name_valid(self.name)

static func is_name_digits_and_letters(name_str: String) -> bool:
	var regex = RegEx.create_from_string("[0-9a-zA-Z]+")
	var result = regex.search(name_str)
	return result != null and result.get_string() == name_str

static func is_name_allowed(name_str: String) -> bool:
	var f = FileAccess.open(BAD_WORDS_FILE_PATH, FileAccess.READ)
	assert(f != null)
	while not f.eof_reached():
		var word = f.get_line()
		if name_str.to_lower() == word.to_lower():
			return false
	f.close()
	return true

## Us this to verify name before setting.
static func is_name_valid(name_str: String) -> bool:
	if name_str.length() != NAME_SIZE:
		return false
	return is_name_digits_and_letters(name_str) and is_name_allowed(name_str)

static func _smaller_score(score_data1: PlayerScoreData, score_data2: PlayerScoreData) -> bool:
	return score_data1.score < score_data2.score
