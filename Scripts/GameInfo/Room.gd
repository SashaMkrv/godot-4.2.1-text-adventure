class_name Room
extends Resource

@export var uniqueKey: String
@export var name: String
@export var description: String
# TODO figure out how to propogate exit info to room descriptions
# could make a separate exits command, but that drives me up the wall...
@export var exits: Array[Resource]
@export var items: Array[Resource]
@export var interactables: Array[Resource]

func itemIsPresent(_itemName: StringName) -> bool:
    #TODO update to actually check the presence of an item
    return true

func interactableIsPresent(_objectName: StringName) -> bool:
    #TODO actually check for things
    return true