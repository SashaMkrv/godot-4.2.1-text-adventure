class_name PlayerMover
extends Node
# how i want interfaces.

func getNextRoomFor(room: Room, _command: GoAction, _map: RoomConnections) -> Room:
    return room