class_name PlayerMoverDefault
extends PlayerMover

# return current room if moving does not work, else return room associated with direction in command
func getNextRoomFor(room: Room, command: GoAction, map: RoomConnections) -> Room:
	var direction := command.specifier
	return map.getNextRoomFrom(room, direction, null)
