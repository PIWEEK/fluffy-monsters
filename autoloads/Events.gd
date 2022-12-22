extends Node

signal game_start()

signal player_join_start(player: Player, deck_id: String)
signal player_join_end(player_name: String, player: int)

signal begin_game_start()
signal begin_game_end(player: int)

signal begin_turn_start()
signal begin_turn_end(player: int)

signal draw_start()
signal draw_end(player: int)

signal play_start()
signal play_end(player: int, actions: Array[PlayerAction])

signal resolve_turn_start()
signal resolve_turn_end(player: int)

signal finish_turn_start()
signal finish_turn_end(player: int)

signal finish_game_start()
signal finish_game_end(player: int)

signal game_end()
