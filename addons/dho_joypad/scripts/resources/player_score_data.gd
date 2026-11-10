# Copyright (c) 2026 Alexander Makedonski
# SPDX-License-Identifier: MIT

extends Resource			
class_name PlayerScoreData

# Currently the size of the name is fixed to 3 symbols (digits and letters)
const NAME_SIZE: int = 3
# Currently fixed to six digits
const MAX_SCORE: int = 999999

@export var score: int = 0:
	set(value):
		score = clampi(value, 0, MAX_SCORE)
	get():
		return score
@export var name: String = "AAA":
	set(value):
		if not self.is_name_valid(value):
			push_warning("player name: %s not set, because invlalid" % value)
			return
		name = value
	get():
		return name

static func is_name_allowed(name_str: String) -> bool:
	return not DHOBadWords.contains(name_str)

## Use this to verify resource
func is_data_valid() -> bool:
	if self.score < 0 || self.score > MAX_SCORE:
		return false
	return is_name_valid(self.name)

static func is_name_digits_and_letters(name_str: String) -> bool:
	var regex = RegEx.create_from_string("[0-9a-zA-Z]+")
	var result = regex.search(name_str)
	return result != null and result.get_string() == name_str

## Us this to verify name before setting.
static func is_name_valid(name_str: String) -> bool:
	if name_str.length() != NAME_SIZE:
		return false
	return is_name_digits_and_letters(name_str) and is_name_allowed(name_str)

static func _bigger_score(score_data1: PlayerScoreData, score_data2: PlayerScoreData) -> bool:
	return score_data1.score > score_data2.score

func to_dict() -> Dictionary[String, Variant]:
	return {
		"score": score,
		"name": name,
	}

static func from_dict(dict: Dictionary) -> PlayerScoreData:
	var score_value: Variant = dict.get("score")
	var name_value: Variant = dict.get("name")
	if not (score_value is float or score_value is int) or not (name_value is String):
		return null
	if not is_name_valid(name_value):
		return null
	var result := PlayerScoreData.new()
	result.score = int(score_value)
	result.name = name_value
	return result
