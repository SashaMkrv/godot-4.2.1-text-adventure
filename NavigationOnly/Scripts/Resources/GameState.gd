extends Resource
class_name GameState

signal current_room_changed

## special state
@export
var currentRoom: String:
	set(value):
		# you know what, if someone is looping over their single room, I won't stop them.
		#if currentRoom == value:
			#return
		currentRoom = value
		# TODO make sure you unconnect this anytime gamestate is changed.
		current_room_changed.emit()


### Should be STRING KEYED
#@export
#var userStateItems: Dictionary
