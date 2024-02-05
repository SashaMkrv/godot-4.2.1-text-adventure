class_name GameCoordinator
extends Node

@onready var playerMover: PlayerMover = $PlayerMover
@export var currentRoom: Room
@export var gameMap: RoomConnections

signal game_updated(description: String)

# TODO should this always return a state update? does the update have any reason to be a signal???
func executeCommand(action: PlayerAction) -> void:
    if action is NoneAction:
        var problem := action as NoneAction
        textUpdate("Thats a [NONE], flavoured with [%s]." % problem.issue)
        return
    elif action is GoAction:
        var motion := action as GoAction
        movePlayer(motion)
        return
    elif action is LookAction:
        var looking := action as LookAction
        textUpdate("We will [LOOK] at all the various pleasure of [%s]." % looking.specifier)
        return
    elif action is EatAction:
        var eating := action as EatAction
        textUpdate("You [EAT] the mighty snack that is the [%s]." % eating.specifier)
        return
    elif action is HelpAction:
        textUpdate("Interact with the game by entering text commands.

With the exception of a small set of shortcuts (e.g. [N] = [GO NORTH]), commands must begin with a valid verb and be followed by a valid target. Prepositions and articles will be ignored by the parser, but the first macth it finds will be used as the target. So, please, do not \"[EAT] the youth's [GUM]\". You will [EAT YOUTH] instead.")
        return


func movePlayer(motion: GoAction) -> void:
    if playerMover == null:
        textUpdate("[GOING] to [%s]" % motion.specifier)
        return
    # TODO... query constructor? can we do named parameters in gdscript???
    var room := playerMover.getNextRoomFor(currentRoom, motion, gameMap)
    if room == currentRoom:
        textUpdate("Could not move [%s]." % motion.specifier)
        return
    else:
        # TODO this certainly doesn't feel good mixed in here.
        currentRoom = room
        stateUpdate(GameStateView\
        .new()\
        .setHeader(room.name)\
        .setDescription(room.description))
        return

func stateUpdate(gameStateView: GameStateView) -> void:
    game_updated.emit(gameStateView)

func textUpdate(description: String) -> void:
    var view := GameStateView\
    .new()\
    .setHeader(currentRoom.name)\
    .setDescription(description)
    game_updated.emit(view)