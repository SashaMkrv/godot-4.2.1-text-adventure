class_name GameCoordinator
extends Node

signal game_updated(description: String)


func executeCommand(action: PlayerAction) -> void:
    if action is NoneAction:
        var problem := action as NoneAction
        textUpdate("Thats a [NONE], flavoured with [%s]." % problem.issue)
    if action is GoAction:
        var motion := action as GoAction
        textUpdate("Cool. We're going [%s]." % motion.specifier)
    if action is LookAction:
        var looking := action as LookAction
        textUpdate("We will [LOOK] at all the various pleasure of [%s]." % looking.specifier)


func textUpdate(description: String) -> void:
    var view := GameStateView.new()
    view.description = description
    game_updated.emit(view)