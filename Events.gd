extends Node

signal game_start()
signal player_ready(player)

signal draw_start()
signal draw_end(player)

signal play_start()
signal play_end(player, data)

signal resolve_turn_start(data)
signal resolve_turn_end(player)

signal next_turn_start()
signal next_turn_end(player)

signal finish_game_start(data)
signal finish_game_end(player)

signal close_game()
