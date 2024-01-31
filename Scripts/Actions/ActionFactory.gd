class_name ActionFactory
extends RefCounted

var verb: StringName
var specifier: StringName

func setVerb(_verb: StringName) -> ActionFactory:
    verb = _verb
    return self

func setSpecifier(_specifier: StringName) -> ActionFactory:
    specifier = _specifier
    return self


func constructAction() -> PlayerAction:
    if verb == null:
        print_debug("You forgot the verb, friend")
        return NoneAction.new(&"INVALID")
    # TODO check if the specifier even handles the verb
    # and while we're at it maybe just move the whole parsing shebang into here.
    # a little "set text" or something as a catchall.
    match verb:
        &"GO":
            return GoAction.new(specifier)
        &"EAT":
            return EatAction.new(specifier)
        &"LOOK":
            return LookAction.new(&"AROUND" if specifier == null else specifier)
        &"USE":
            return UseAction.new(specifier)
        &"TALK":
            return TalkAction.new(specifier)
        &"GRAB":
            return GrabAction.new(specifier)
        _:
            return NoneAction.new(&"BAD VERB")