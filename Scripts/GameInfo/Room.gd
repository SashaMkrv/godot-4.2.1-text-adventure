class_name Room
extends Resource

@export var uniqueKey: String
@export var name: String
@export var description: String
@export var exits: Dictionary # TODO Make this not an untyped dictionary :(
@export var items: Array[Resource]
@export var interactables: Array[Resource]

# You stand in the middle of a gas station store. There are many, slightly aged, [TASTY TREATS] to enjoy, and a dull-eyed [YOUTH] stood behind the cash register to pester.    The [AUTOMATIC DOOR] to the [SOUTH] no longer works. You may exit through the [BROKEN WINDOW] to the [EAST].

# TODO pull this logic out and into something that does these checks based on passed room data


func checkDirectionForExit(direction: StringName) -> Room:
    # This impl doesn't allow for busted doors. Do I actually need a portal repr?
    # also how can i avoid a null return here boohoo. an error Room???
    if exits.has(direction):
        return exits[direction] as Room
    return null

func itemIsPresent(_itemName: StringName) -> bool:
    #TODO update to actually check the presence of an item
    return true

func interactableIsPresent(_objectName: StringName) -> bool:
    #TODO actually check for things
    return true