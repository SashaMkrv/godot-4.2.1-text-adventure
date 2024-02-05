class_name PlayerMoverDefault
extends PlayerMover

# return current room if moving does not work, else return room associated with direction in command
func getNextRoomFor(room: Room, _conditions: GameConditions, command: GoAction) -> Room:
	var direction := command.specifier
	var nextRoom := room.checkDirectionForExit(direction)
	return room if nextRoom == null else nextRoom
