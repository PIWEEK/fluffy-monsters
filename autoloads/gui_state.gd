extends Node

const CARD_WIDTH = 200
const CARD_HEIGHT = 241

var dragging = false
var dragging_card = null
var dragging_location = null

var cards_hand = []
var cards_location = [[], [], []]
var cards_location_enemy = [[], [], []]
