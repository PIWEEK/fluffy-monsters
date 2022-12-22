extends Node

class_name Player

var player_name: String
var avatar: Texture

func copy() -> Player:
	var result = Player.new()
	result.player_name = player_name
	result.avatar = avatar
	return result
