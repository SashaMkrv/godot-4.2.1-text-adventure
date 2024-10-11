extends Resource
class_name EditorGame

## Game in an editable state.

@export
var startingRoomIdentifier: String = ""
@export
var mapName: String = "Map"
# My kingdom for a typed dictionary.
@export
var gridSize: Vector2i = Vector2i(30, 30)
@export
var placedItems: Dictionary = {}


static func NewEmptyGame() -> EditorGame:
	return EditorGame.new()
