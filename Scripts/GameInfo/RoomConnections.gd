class_name RoomConnections
extends Resource

@export var connections: Array[RoomConnection] = []

# return connected room if a connection is found. otherwise, return the provided room.
# TODO figure out what to do if you DO connect, just to the same room. a little circle path.
# but on the plus side you can add descriptions to the connections later.
# though then returning the connection itself would probably make more sense....
# It might make more sense to just key a dictionary on room direction combinations...
# though then you wouldn't be able to fetch all the connections for a room
# or at least not with the dictionary.
# maybe you could?
# whatever, it's not a problem for now.

# TODO pull this logic out and into something that does these checks based on passed room data
func getNextRoomFrom(room: Room, direction: StringName, _conditions: GameConditions) -> Room:
	for connection in connections:
		if connection.fromRoom == room and connection.direction == direction:
			return connection.toRoom
	
	return room
