class_name PlayerMover
extends Node
# how i want interfaces.


func getNextRoomFor(room: Room, _conditions: GameConditions, _command: GoAction) -> Room:
    return room