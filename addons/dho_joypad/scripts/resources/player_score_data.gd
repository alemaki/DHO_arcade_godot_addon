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
	if self.name.length() != NAME_SIZE:
		return false
	if self.score < 0 || self.score > MAX_SCORE:
		return false
	return is_name_valid()

func is_name_valid() -> bool:
	var f = FileAccess.open(BAD_WORDS_FILE_PATH, FileAccess.READ)
	while not f.eof_reached():
		var word = f.get_line()
		if name == word:
			return false
	f.close()
	return true

static func _smaller_score(score_data1: PlayerScoreData, score_data2: PlayerScoreData) -> bool:
	return score_data1.score < score_data2.score
