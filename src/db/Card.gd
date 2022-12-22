extends Node

class_name Card

@export var card_name: String
@export var cost: int
@export var power: int
@export var image: Texture
@export_multiline var text: String

@export var on_begin_turn: OnBeginTurn
@export var on_self_reveal: OnSelfReveal
@export var on_card_play: OnCardPlay
@export var on_destroy: OnDestroy
@export var on_discard: OnDiscard
