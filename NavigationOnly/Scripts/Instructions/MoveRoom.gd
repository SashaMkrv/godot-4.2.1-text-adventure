extends Instruction
class_name MoveRoom

var newRoomIdentifier: String

func _init(newRoom: String) -> void:
	newRoomIdentifier = newRoom

func executeChange(gameState: GameState) -> Result:
	gameState.currentRoom = newRoomIdentifier
	return Result.new(false, "Room change should be handled by player and game state. (doesn't feel right, now)")
