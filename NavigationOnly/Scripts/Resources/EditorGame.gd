extends Resource
class_name EditorGame

## Game in an editable state.

@export
var startingRoomIdentifier: String = ""
@export
var mapName: String = ""
@export
var mapDescription: String = ""
# My kingdom for a typed dictionary.
#@export
#var gridSize: Vector2i = Vector2i(30, 30)
@export
var placedItems: PlacedItems = PlacedItems.Empty()

const STARTING_ROOM_KEY = "startingRoom"
const MAP_NAME_KEY = "mapName"
const MAP_DESCRIPTION_KEY = "mapDescription"

const PLACED_ITEMS_KEY = "placedItems"


static func NewEmptyGame() -> EditorGame:
	return EditorGame.new()

static func _to_dict(game: EditorGame) -> Dictionary:
	return {
		STARTING_ROOM_KEY: game.startingRoomIdentifier,
		MAP_NAME_KEY: game.mapName,
		MAP_DESCRIPTION_KEY: game.mapDescription,
		PLACED_ITEMS_KEY: PlacedItems._to_dict(game.placedItems)
	}

static func _from_dict(dictionary: Dictionary) -> EditorGame:
	var newGame = EditorGame.NewEmptyGame()
	newGame.startingRoomIdentifier = dictionary[STARTING_ROOM_KEY]
	newGame.mapName = dictionary[MAP_NAME_KEY]
	newGame.mapDescription = dictionary[MAP_DESCRIPTION_KEY]
	var placedItems = PlacedItems._from_string_keyed_dict(dictionary[PLACED_ITEMS_KEY])
	newGame.placedItems = placedItems
	return newGame
	
