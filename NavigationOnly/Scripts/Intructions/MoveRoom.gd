extends Instruction
class_name MoveRoom

var newRoomIdentifier: String

func _init(newRoom: String):
	newRoomIdentifier = newRoom

func executeChange(gameState: GameState) -> void:
	gameState.currentRoom = newRoomIdentifier
